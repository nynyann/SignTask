import SwiftUI
import UIKit

// MARK: - Model

enum MessageStatus: Equatable { case pending, understood, askedAgain }

struct TaskMessage: Identifiable, Equatable {
    let id = UUID()
    var sender: String
    var time: Date
    var isUrgent: Bool
    /// Bản ngắn, theo trật tự ngữ pháp ngôn ngữ ký hiệu
    var shortText: String
    /// Bản gốc, đúng lời người nói
    var originalText: String
    var imageName: String?
    var audioURL: URL?
    var status: MessageStatus = .pending

    var timeString: String {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f.string(from: time)
    }
}

enum MockData {
    static func at(_ h: Int, _ m: Int) -> Date {
        Calendar.current.date(bySettingHour: h, minute: m, second: 0, of: Date()) ?? Date()
    }

    static let messages: [TaskMessage] = [
        TaskMessage(sender: "Quản lý", time: at(12, 41), isUrgent: true,
                    shortText: "2 LY CÀ PHÊ ĐEN, BÀN 3, GẤP.",
                    originalText: "Trân ơi, bàn 3 gọi hai ly cà phê đen, làm gấp dùm chị nhe.",
                    imageName: "coffee"),
        TaskMessage(sender: "Quản lý", time: at(12, 30), isUrgent: true,
                    shortText: "1 LY CÀ PHÊ SỮA, BÀN 5, GẤP.",
                    originalText: "Bàn 5 gọi thêm 1 ly cà phê sữa, làm nhanh giúp chị nha.",
                    imageName: "coffee", status: .understood),
    ]
}

// MARK: - App state + điều hướng bằng phím âm lượng

@MainActor
final class AppState: ObservableObject {
    enum Screen: Equatable { case list, incoming(UUID), detail(UUID), compose }

    @Published var screen: Screen
    @Published var messages: [TaskMessage] = MockData.messages
    @Published var selectedIndex = 0
    @Published var toast: String?

    init() {
        // Mở app là thấy thẻ tin mới (giống màn 1 trong thiết kế)
        screen = .incoming(MockData.messages[0].id)
    }

    var pending: [TaskMessage] { messages.filter { $0.status != .understood } }
    var understood: [TaskMessage] { messages.filter { $0.status == .understood } }
    var listOrder: [TaskMessage] { pending + understood }

    func message(_ id: UUID) -> TaskMessage? { messages.first { $0.id == id } }

    /// Mọi thao tác phím +/− đều đi qua đây, tùy màn hình mà làm việc khác nhau.
    func handle(_ button: VolumeButton) {
        switch screen {
        case .list:
            let items = listOrder
            guard !items.isEmpty else { return }
            Haptics.tap()
            if button == .up {
                screen = .detail(items[min(selectedIndex, items.count - 1)].id)   // + Mở tin
            } else {
                selectedIndex = (selectedIndex + 1) % items.count                 // − Cuộn xuống
            }

        case .incoming(let id):
            Haptics.tap()
            if button == .up { screen = .detail(id) }                            // + Mở tin
            else { showToast("Đã để sau"); screen = .list }                       // − Để sau

        case .detail(let id):
            Haptics.tap()
            if button == .up {                                                   // + Đã rõ
                setStatus(id, .understood)
                showToast("Đã gửi: Đã rõ")
            } else {                                                             // − Hỏi lại
                setStatus(id, .askedAgain)
                showToast("Đã gửi yêu cầu hỏi lại")
            }
            screen = .list

        case .compose:
            break
        }
    }

    /// Nhận tin mới (từ màn Nhắn tin) → rung + hiện thẻ tin
    func receive(_ msg: TaskMessage) {
        messages.insert(msg, at: 0)
        selectedIndex = 0
        Haptics.alert()
        screen = .incoming(msg.id)
    }

    func showHelp() {
        switch screen {
        case .list: showToast("Phím +: mở tin · Phím −: xuống tin sau")
        case .detail: showToast("Phím +: đã rõ · Phím −: hỏi lại")
        default: showToast("Phím +: mở tin · Phím −: để sau")
        }
    }

    func showToast(_ text: String) {
        toast = text
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            if toast == text { toast = nil }
        }
    }

    private func setStatus(_ id: UUID, _ status: MessageStatus) {
        guard let i = messages.firstIndex(where: { $0.id == id }) else { return }
        messages[i].status = status
    }
}

// MARK: - Rung (quan trọng vì người dùng ký hiệu không nghe tiếng báo)

enum Haptics {
    static func tap() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
    static func alert() {
        let g = UINotificationFeedbackGenerator()
        g.notificationOccurred(.warning)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { g.notificationOccurred(.warning) }
    }
}
