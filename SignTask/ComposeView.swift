import SwiftUI

// MARK: - Màn Nhắn tin (dành cho người nghe): nói → ra 2 bản văn bản → gửi

struct ComposeView: View {
    @EnvironmentObject var state: AppState
    @StateObject private var rec = SpeechRecorder()
    @State private var shortText = ""
    @State private var isUrgent = true
    @State private var permissionDenied = false
    private let shortener = SignGrammarShortener()

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Button {
                rec.stop()
                state.screen = .list
            } label: {
                Label("Quay lại", systemImage: "chevron.left")
            }

            Text("Nhắn tin bằng giọng nói").font(.title2.bold())

            VStack(alignment: .leading, spacing: 6) {
                Text("Văn bản gốc").font(.caption).foregroundStyle(.secondary)
                Text(rec.transcript.isEmpty ? "Ấn micro và nói chỉ dẫn…" : rec.transcript)
                    .foregroundStyle(rec.transcript.isEmpty ? .secondary : .primary)
                    .frame(maxWidth: .infinity, minHeight: 80, alignment: .topLeading)
            }
            .padding(14)
            .background(RoundedRectangle(cornerRadius: 16).fill(Theme.cardBG))

            VStack(alignment: .leading, spacing: 6) {
                Text("Văn bản ngắn (theo ngữ pháp ký hiệu) — sửa được")
                    .font(.caption).foregroundStyle(.secondary)
                TextField("", text: $shortText, axis: .vertical)
                    .font(.title3.weight(.heavy))
            }
            .padding(14)
            .background(RoundedRectangle(cornerRadius: 16).fill(Theme.cardBG))

            Toggle("Đánh dấu Gấp", isOn: $isUrgent).tint(Theme.urgent)

            Spacer()

            HStack(spacing: 24) {
                Button {
                    Task {
                        if rec.isRecording {
                            rec.stop()
                        } else if await rec.requestPermissions() {
                            try? rec.start()
                        } else {
                            permissionDenied = true
                        }
                    }
                } label: {
                    Image(systemName: rec.isRecording ? "stop.fill" : "mic.fill")
                        .font(.title)
                        .foregroundStyle(.white)
                        .frame(width: 72, height: 72)
                        .background(Circle().fill(rec.isRecording ? Theme.urgent : Theme.accent))
                }

                Button("Gửi", action: send)
                    .buttonStyle(PillStyle(fill: Theme.dark, text: .white))
                    .disabled(rec.transcript.isEmpty || rec.isRecording)
                    .opacity(rec.transcript.isEmpty || rec.isRecording ? 0.4 : 1)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(20)
        .onChange(of: rec.transcript) { _, t in shortText = shortener.shorten(t) }
        .alert("Cần quyền micro và nhận dạng giọng nói", isPresented: $permissionDenied) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Vào Cài đặt → SignTask để bật lại.")
        }
    }

    private func send() {
        let msg = TaskMessage(sender: "Quản lý", time: Date(), isUrgent: isUrgent,
                              shortText: shortText.isEmpty ? rec.transcript : shortText,
                              originalText: rec.transcript,
                              imageName: nil,
                              audioURL: rec.recordingURL)
        // Prototype 1 máy: tin gửi đi hiện luôn ở máy này như tin đến.
        state.receive(msg)
    }
}
