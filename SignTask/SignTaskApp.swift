import SwiftUI

@main
struct SignTaskApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .preferredColorScheme(.light)
        }
    }
}

struct RootView: View {
    @StateObject private var state = AppState()

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            switch state.screen {
            case .list:
                ShiftListView()
            case .incoming(let id):
                if let m = state.message(id) { IncomingCardView(message: m) }
            case .detail(let id):
                if let m = state.message(id) { MessageDetailView(message: m) }
            case .compose:
                ComposeView()
            }

            // Bắt buộc có trong màn hình để ẩn thanh âm lượng của iOS
            HiddenVolumeView()
                .frame(width: 1, height: 1)
                .allowsHitTesting(false)

            if let t = state.toast {
                ToastView(text: t)
            }
        }
        .environmentObject(state)
        .animation(.easeInOut(duration: 0.25), value: state.screen)
        .animation(.spring, value: state.toast)
        .onAppear { VolumeButtonManager.shared.start() }
        .onReceive(VolumeButtonManager.shared.pressed) { state.handle($0) }
    }
}
