import SwiftUI
import AVFoundation
import MediaPlayer
import Combine

enum VolumeButton { case up, down }

/// Bắt sự kiện phím âm lượng vật lý trên iPhone.
/// iOS không có API chính thức, nên cách làm là:
/// 1. Theo dõi `AVAudioSession.outputVolume` (thay đổi mỗi khi bấm phím).
/// 2. So với mức gốc 0.5 → biết là phím + hay phím −.
/// 3. Đặt lại âm lượng về 0.5 để lần bấm sau vẫn nhận được (kể cả khi đang ở max/min).
/// 4. Nhét một `MPVolumeView` gần như vô hình vào màn hình để ẩn thanh âm lượng của hệ thống.
/// Chỉ chạy trên iPhone thật, KHÔNG chạy trên Simulator.
final class VolumeButtonManager: NSObject {
    static let shared = VolumeButtonManager()

    /// Phát ra `.up` / `.down` mỗi lần bấm phím.
    let pressed = PassthroughSubject<VolumeButton, Never>()

    /// Tắt khi đang ở màn cần dùng micro / âm lượng bình thường.
    var isEnabled = true {
        didSet { if isEnabled && !oldValue { resetToBaseline() } }
    }

    let volumeView = MPVolumeView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))

    private let session = AVAudioSession.sharedInstance()
    private var observation: NSKeyValueObservation?
    private let baseline: Float = 0.5
    private var lastPress = Date.distantPast
    private var started = false

    func start() {
        guard !started else { return }
        started = true
        activateSession()
        observation = session.observe(\.outputVolume, options: [.new]) { [weak self] _, change in
            guard let value = change.newValue else { return }
            DispatchQueue.main.async { self?.handle(value) }
        }
        NotificationCenter.default.addObserver(
            self, selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification, object: nil)
        // Chờ MPVolumeView gắn vào cửa sổ rồi mới đặt âm lượng gốc
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { self.resetToBaseline() }
    }

    /// Gọi sau khi màn ghi âm dùng xong micro.
    func restoreSession() {
        activateSession()
        resetToBaseline()
    }

    // MARK: - Private

    private func activateSession() {
        try? session.setCategory(.ambient, options: [.mixWithOthers])
        try? session.setActive(true)
    }

    @objc private func appDidBecomeActive() { restoreSession() }

    private func handle(_ value: Float) {
        // Giá trị bằng mức gốc = do chính mình vừa đặt lại → bỏ qua
        guard abs(value - baseline) > 0.01 else { return }
        guard isEnabled else { return }

        let button: VolumeButton = value > baseline ? .up : .down
        resetToBaseline()

        // Chống lặp khi giữ phím
        guard Date().timeIntervalSince(lastPress) > 0.25 else { return }
        lastPress = Date()
        pressed.send(button)
    }

    private func resetToBaseline() {
        guard let slider = volumeView.subviews.compactMap({ $0 as? UISlider }).first else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            slider.value = self.baseline
        }
    }
}

/// Đặt view này ở đâu đó trong màn hình (kích thước 1x1, gần như trong suốt)
/// để iOS không hiện thanh âm lượng mỗi lần bấm.
struct HiddenVolumeView: UIViewRepresentable {
    func makeUIView(context: Context) -> MPVolumeView {
        let view = VolumeButtonManager.shared.volumeView
        view.alpha = 0.01
        view.isUserInteractionEnabled = false
        return view
    }
    func updateUIView(_ uiView: MPVolumeView, context: Context) {}
}
