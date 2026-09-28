import Foundation
import AVFoundation
import Speech

// MARK: - Ghi âm + chuyển giọng nói tiếng Việt thành chữ

@MainActor
final class SpeechRecorder: ObservableObject {
    @Published var transcript = ""
    @Published var isRecording = false

    private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "vi-VN"))
    private let engine = AVAudioEngine()
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private(set) var recordingURL: URL?

    func requestPermissions() async -> Bool {
        let speechOK = await withCheckedContinuation { cont in
            SFSpeechRecognizer.requestAuthorization { cont.resume(returning: $0 == .authorized) }
        }
        let micOK = await AVAudioApplication.requestRecordPermission()
        return speechOK && micOK
    }

    func start() throws {
        transcript = ""
        VolumeButtonManager.shared.isEnabled = false

        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, mode: .measurement, options: [.defaultToSpeaker, .duckOthers])
        try session.setActive(true, options: .notifyOthersOnDeactivation)

        let req = SFSpeechAudioBufferRecognitionRequest()
        req.shouldReportPartialResults = true
        request = req

        // Lưu bản ghi âm gốc để phát lại ở màn chi tiết
        let input = engine.inputNode
        let format = input.outputFormat(forBus: 0)
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("rec-\(UUID().uuidString).caf")
        let file = try AVAudioFile(forWriting: url, settings: format.settings)
        recordingURL = url

        Self.installTap(on: input, format: format, request: req, file: file)
        engine.prepare()
        try engine.start()
        isRecording = true

        task = recognizer?.recognitionTask(with: req) { [weak self] result, error in
            let text = result?.bestTranscription.formattedString
            let done = (result?.isFinal ?? false) || error != nil
            Task { @MainActor in
                guard let self else { return }
                if let text { self.transcript = text }
                if done && self.isRecording { self.stop() }
            }
        }
    }

    func stop() {
        guard isRecording else { return }
        engine.stop()
        engine.inputNode.removeTap(onBus: 0)
        request?.endAudio()
        task?.finish()
        isRecording = false
        VolumeButtonManager.shared.isEnabled = true
        VolumeButtonManager.shared.restoreSession()
    }

    /// Tách ra hàm nonisolated vì khối tap chạy trên luồng âm thanh, không phải main thread.
    nonisolated private static func installTap(on input: AVAudioInputNode,
                                               format: AVAudioFormat,
                                               request: SFSpeechAudioBufferRecognitionRequest,
                                               file: AVAudioFile) {
        input.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
            request.append(buffer)
            try? file.write(from: buffer)
        }
    }
}

// MARK: - Phát lại bản ghi âm gốc

@MainActor
final class AudioPlayback: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published var isPlaying = false
    private var player: AVAudioPlayer?

    func toggle(url: URL?) {
        guard let url else { return }
        if isPlaying {
            player?.stop()
            isPlaying = false
            return
        }
        player = try? AVAudioPlayer(contentsOf: url)
        player?.delegate = self
        player?.play()
        isPlaying = player?.isPlaying ?? false
    }

    nonisolated func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        Task { @MainActor in self.isPlaying = false }
    }
}
