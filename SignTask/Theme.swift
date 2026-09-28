import SwiftUI

// Màu và số đo lấy trực tiếp từ file Figma "button".
enum Theme {
    static let blue      = Color(hex: 0x0088FF)   // accents/blue — tab +/−, nút ?
    static let red       = Color(hex: 0xFF383C)   // accents/red — "Gấp", chip chờ xác nhận
    static let redLabel  = Color(hex: 0xFF3A3A)   // chữ "Gấp" ở màn chi tiết
    static let green     = Color(hex: 0x34C759)   // chip "Đã rõ"
    static let orange    = Color(hex: 0xFF9500)   // chip "Đã hỏi lại" (không có trong Figma)
    static let label     = Color(hex: 0x171717)   // chữ dưới tab +/−
    static let title     = Color(hex: 0x1A1A1A)   // tên người gửi
    static let secondary = Color(hex: 0x727272)   // giờ ở màn chi tiết
    static let time      = Color(hex: 0x323232)   // giờ ở danh sách
    static let cardBG    = Color(hex: 0xF9F9F9)   // nền thẻ trắng xám
    static let dark      = Color(hex: 0x1C1C1E)   // nút "Lịch sử"

    // giữ tên cũ cho các file khác
    static let accent  = blue
    static let urgent  = red
    static let success = green
    static let warning = orange
    static let pink    = Color(hex: 0xEB98BF)
}

extension Color {
    init(hex: UInt32, opacity: Double = 1) {
        self.init(.sRGB,
                  red: Double((hex >> 16) & 0xFF) / 255,
                  green: Double((hex >> 8) & 0xFF) / 255,
                  blue: Double(hex & 0xFF) / 255,
                  opacity: opacity)
    }
}

// MARK: - Liquid Glass (thiết kế dùng component iOS 26)

extension View {
    /// iOS 26 trở lên: hiệu ứng Liquid Glass thật. Máy cũ hơn: nền màu phẳng.
    @ViewBuilder
    func glass(tint: Color? = nil, cornerRadius: CGFloat) -> some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        #if compiler(>=6.2)   // Xcode 26 trở lên mới có glassEffect
        if #available(iOS 26.0, *) {
            if let tint {
                self.glassEffect(.regular.tint(tint).interactive(), in: shape)
            } else {
                self.glassEffect(.regular.interactive(), in: shape)
            }
        } else {
            flatGlass(tint: tint, shape: shape)
        }
        #else
        flatGlass(tint: tint, shape: shape)
        #endif
    }

    private func flatGlass(tint: Color?, shape: RoundedRectangle) -> some View {
        self.background(
            shape.fill(tint ?? Color(hex: 0xEDEDED))
                .shadow(color: .black.opacity(0.18), radius: 6, y: 3)
        )
    }
}

// MARK: - Cột tab +/− bám mép trái (đúng vị trí phím âm lượng trên iPhone)
// Figma: thanh 10×80 bo 30, cách nhau 6pt; nút tròn 26; chữ 17 Medium; cột rộng 83.

struct VolumeHint: View {
    let upLabel: String
    let downLabel: String
    var onDark = false
    var onUp: () -> Void
    var onDown: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            tab(symbol: "+", label: upLabel, action: onUp)
            tab(symbol: "−", label: downLabel, action: onDown)
        }
    }

    private func tab(symbol: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 0) {
                UnevenRoundedRectangle(bottomTrailingRadius: 10, topTrailingRadius: 10, style: .continuous)
                    .fill(onDark ? Theme.red : Theme.blue)
                    .frame(width: 10, height: 80)
                    .shadow(color: onDark ? Theme.red.opacity(0.8) : .clear, radius: 10)
                VStack(spacing: 10) {
                    Text(symbol)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(onDark ? .black : .white)
                        .frame(width: 26, height: 26)
                        .glass(tint: onDark ? Color.white.opacity(0.55) : Theme.blue, cornerRadius: 13)
                    Text(label)
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(onDark ? .white : Theme.label)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(width: 73)
            }
            .frame(height: 80)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

/// Nút "?" — Figma: tròn 48, Liquid Glass tint xanh
struct HelpButton: View {
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Text("?")
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
                .glass(tint: Theme.blue, cornerRadius: 24)
        }
        .buttonStyle(.plain)
        .padding(.leading, 20)
    }
}

/// Ảnh ly cà phê (asset "coffee" export từ Figma). Chưa có ảnh thì hiện icon tạm.
struct Thumb: View {
    let name: String?
    var size: CGFloat
    var radius: CGFloat

    var body: some View {
        Group {
            if let name, UIImage(named: name) != nil {
                Image(name).resizable().scaledToFill()
            } else {
                ZStack {
                    Theme.red.opacity(0.15)
                    Image(systemName: "cup.and.saucer.fill")
                        .font(.system(size: size * 0.35))
                        .foregroundStyle(Theme.red)
                }
            }
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
    }
}

/// Chip trạng thái — Figma: cao 22, bo 25, chữ 12 Medium
struct StatusChip: View {
    let status: MessageStatus
    var body: some View {
        switch status {
        case .pending:    chip("Chờ xác nhận", Theme.red, bg: 0.2)
        case .understood: chip("Đã rõ", Theme.green, bg: 0.08)
        case .askedAgain: chip("Đã hỏi lại", Theme.orange, bg: 0.12)
        }
    }
    private func chip(_ t: String, _ c: Color, bg: Double) -> some View {
        Text(t)
            .font(.system(size: 12, weight: .medium))
            .foregroundStyle(c)
            .padding(.horizontal, 10)
            .frame(height: 22)
            .background(Capsule().fill(c.opacity(bg)))
    }
}

/// Avatar góc phải màn danh sách — Figma "Gradient 6": nền trắng, viền phát sáng hồng/xanh
struct GlowAvatar: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 15, style: .continuous)
            .fill(Color.white
                .shadow(.inner(color: Color(hex: 0xA6CBF8), radius: 6))
                .shadow(.inner(color: Color(hex: 0x5FEFF4), radius: 12))
                .shadow(.inner(color: Color(hex: 0xFF93FF), radius: 10))
                .shadow(.inner(color: Color(hex: 0xFFE9FF), radius: 16)))
            .frame(width: 49, height: 49)
    }
}

struct PillStyle: ButtonStyle {
    var fill: Color
    var text: Color
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .medium))
            .foregroundStyle(text)
            .frame(width: 125, height: 63)
            .background(Capsule().fill(fill))
            .shadow(color: .black.opacity(0.18), radius: 6, y: 3)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct ToastView: View {
    let text: String
    var body: some View {
        VStack {
            Text(text)
                .font(.headline)
                .foregroundStyle(.white)
                .padding(.horizontal, 20).padding(.vertical, 12)
                .background(Capsule().fill(.black.opacity(0.85)))
                .padding(.top, 8)
            Spacer()
        }
        .transition(.move(edge: .top).combined(with: .opacity))
    }
}
