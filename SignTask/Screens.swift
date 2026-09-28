import SwiftUI

// Số đo theo frame iPhone 390×844 trong Figma.
// Khoảng cách "top" tính từ mép dưới thanh trạng thái (safe area ≈ 59pt).

// MARK: - Màn 1: Thẻ tin mới  (Figma frame "1")

struct IncomingCardView: View {
    @EnvironmentObject var state: AppState
    let message: TaskMessage

    var body: some View {
        ZStack {
            IncomingBackground()

            HStack(alignment: .top, spacing: 0) {
                VolumeHint(upLabel: "Mở tin", downLabel: "Để sau", onDark: true,
                           onUp: { state.handle(.up) }, onDown: { state.handle(.down) })
                    .padding(.top, 55)          // tab ở y=214, thẻ ở y=159
                card
                Spacer(minLength: 0)
            }
            .padding(.top, 100)
            .frame(maxHeight: .infinity, alignment: .top)

            VStack {
                Spacer()
                Text("Dùng phím âm lượng để tương tác")
                    .font(.system(size: 15))
                    .foregroundStyle(Color(hex: 0xF3F3F3))
                    .padding(.bottom, 20)
            }
        }
    }

    private var card: some View {
        VStack(alignment: .leading, spacing: 0) {
            Thumb(name: message.imageName, size: 244, radius: 22)
            if message.isUrgent {
                Text("Gấp")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 101, height: 49)
                    .glass(tint: Theme.red.opacity(0.85), cornerRadius: 24.5)
                    .padding(.top, 51)
            }
            Text(message.shortText)
                .font(.system(size: 32, weight: .semibold))
                .tracking(-0.43)
                .lineSpacing(3)
                .foregroundStyle(.black)
                .minimumScaleFactor(0.6)
                .frame(width: 259, alignment: .leading)
                .padding(.top, 20)
            Spacer(minLength: 0)
            HStack {
                Spacer()
                Text(message.timeString)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white)
            }
        }
        .padding(.leading, 21)
        .padding(.trailing, 12)
        .padding(.top, 20)
        .padding(.bottom, 14)
        .frame(width: 286, height: 479, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 27, style: .continuous)
                .fill(LinearGradient(stops: [
                    .init(color: Color(hex: 0xB17690, opacity: 0.55), location: 0),
                    .init(color: Color(hex: 0xE5CBFF, opacity: 0.45), location: 0.45),
                    .init(color: Color(hex: 0xF26580, opacity: 0.7), location: 0.7),
                    .init(color: Color(hex: 0xFF0000, opacity: 0.75), location: 1),
                ], startPoint: .top, endPoint: .bottom))
                .overlay(RoundedRectangle(cornerRadius: 27, style: .continuous)
                    .stroke(.white.opacity(0.18), lineWidth: 1))
                .shadow(color: .black.opacity(0.5), radius: 45)
        )
    }
}

/// Nền tối + quầng đỏ/hồng + viền đỏ phát sáng nhấp nháy
struct IncomingBackground: View {
    @State private var pulse = false

    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(hex: 0x202020), location: 0),
                .init(color: Color(hex: 0x2C2C2C), location: 0.37),
                .init(color: Color(hex: 0x3F434B), location: 0.56),
                .init(color: Color(hex: 0x515B69), location: 0.75),
                .init(color: Color(hex: 0x292D34), location: 0.875),
                .init(color: .black, location: 1),
            ], center: UnitPoint(x: 0.65, y: 0.02), startRadius: 0, endRadius: 880)

            // Hình thoi hồng chạy dọc giữa màn
            RoundedRectangle(cornerRadius: 30)
                .fill(LinearGradient(colors: [Color(hex: 0xFF2D6F), Color(hex: 0xC2185B)],
                                     startPoint: .top, endPoint: .bottom))
                .frame(width: 260, height: 260)
                .rotationEffect(.degrees(45))
                .scaleEffect(x: 0.7, y: 2.4)
                .opacity(0.45)
                .blur(radius: 28)
                .offset(y: 60)
                .blendMode(.plusLighter)

            // Quầng hồng góc dưới phải
            Ellipse()
                .fill(Color(hex: 0xFF3DA8))
                .frame(width: 220, height: 180)
                .blur(radius: 50)
                .opacity(0.55)
                .offset(x: 110, y: 170)
                .blendMode(.plusLighter)

            // Vệt đỏ sáng dưới tai thỏ
            VStack {
                Capsule()
                    .fill(Color(hex: 0xFF3A3A))
                    .frame(width: 163, height: 60)
                    .blur(radius: 18)
                    .offset(y: -30)
                Spacer()
            }

            // Viền đỏ phát sáng quanh màn hình (nhấp nháy = chuông báo bằng hình)
            RoundedRectangle(cornerRadius: 50)
                .stroke(Color.red, lineWidth: pulse ? 22 : 10)
                .blur(radius: 16)
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) { pulse = true }
        }
    }
}

// MARK: - Màn 2: Chi tiết tin  (Figma frame "9" và "10")

struct MessageDetailView: View {
    @EnvironmentObject var state: AppState
    let message: TaskMessage
    @State private var showOriginal = false
    @StateObject private var player = AudioPlayback()

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            VStack(alignment: .leading, spacing: 24) {
                VolumeHint(upLabel: "Đã rõ", downLabel: "Hỏi lại",
                           onUp: { state.handle(.up) }, onDown: { state.handle(.down) })
                HelpButton { state.showHelp() }
            }
            .padding(.top, 55)

            card
            Spacer(minLength: 0)
        }
        .padding(.top, 100)
        .frame(maxHeight: .infinity, alignment: .top)
    }

    private var card: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 10) {
                Thumb(name: message.imageName, size: 62, radius: 12)
                VStack(alignment: .leading, spacing: 1) {
                    Text(message.sender)
                        .font(.system(size: 15, weight: .medium))
                        .tracking(-0.23)
                        .foregroundStyle(Theme.title)
                    Text(message.timeString)
                        .font(.system(size: 13))
                        .foregroundStyle(Theme.secondary)
                }
                Spacer()
                if message.isUrgent {
                    Text("Gấp")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Theme.redLabel)
                }
            }

            Picker("", selection: $showOriginal) {
                Text("Văn bản ngắn").tag(false)
                Text("Văn bản gốc").tag(true)
            }
            .pickerStyle(.segmented)
            .padding(.top, 26)

            Text(showOriginal ? message.originalText : message.shortText)
                .font(.system(size: 32, weight: .semibold))
                .tracking(-0.43)
                .lineSpacing(3)
                .multilineTextAlignment(.center)
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity, minHeight: 82)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 41)

            Waveform(isPlaying: player.isPlaying)
                .contentShape(Rectangle())
                .onTapGesture { player.toggle(url: message.audioURL) }
                .padding(.top, 44)

            Text(message.audioURL == nil
                 ? "Tin mẫu chưa có bản ghi âm gốc"
                 : "Ấn vào ảnh để phát lại bản ghi âm gốc")
                .font(.system(size: 13))
                .foregroundStyle(.black)
                .padding(.top, 44)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 12)
        .frame(width: 286)
        .frame(minHeight: 479, alignment: .top)
        .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(Theme.cardBG))
    }
}

/// Sóng âm — chiều cao 17 vạch lấy đúng từ Figma "Frame 4" (190×108)
struct Waveform: View {
    var isPlaying: Bool
    private let heights: [CGFloat] = [90, 52, 31, 91, 90, 52, 62, 28, 108, 34, 52, 74, 90, 56, 74, 46, 74]
    @State private var phase = false

    var body: some View {
        HStack(alignment: .center, spacing: 7.36) {
            ForEach(heights.indices, id: \.self) { i in
                let h = (isPlaying && phase) ? heights[(i + 5) % heights.count] : heights[i]
                Capsule()
                    .fill(Color(hex: 0x2A2A2A))
                    .frame(width: 4.5, height: h)
            }
        }
        .frame(width: 190, height: 108)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.35).repeatForever()) { phase.toggle() }
        }
    }
}

// MARK: - Màn 3: Danh sách ca  (Figma frame "dashboard pending" / "dashboard confirmed")

struct ShiftListView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        VStack(spacing: 0) {
            // Tiêu đề ca — Figma y=64
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Ca sáng")
                        .font(.system(size: 22, weight: .bold))
                        .tracking(-0.26)
                    Text("07:00 - 12:00")
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundStyle(.black)
                Spacer()
                GlowAvatar()
            }
            .padding(.leading, 23)
            .padding(.trailing, 16)
            .padding(.top, 5)

            HStack(alignment: .top, spacing: 2) {
                VStack(alignment: .leading, spacing: 24) {
                    VolumeHint(upLabel: "Mở tin", downLabel: "Cuộn\nxuống",
                               onUp: { state.handle(.up) }, onDown: { state.handle(.down) })
                    HelpButton { state.showHelp() }
                }
                .padding(.top, 101)             // tab ở y=214, danh sách ở y=147

                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .trailing, spacing: 0) {
                            section("CẦN XÁC NHẬN (\(state.pending.count))")
                            ForEach(Array(state.pending.enumerated()), id: \.element.id) { i, m in
                                row(m, selected: i == state.selectedIndex).id(m.id)
                                    .padding(.top, i == 0 ? 13 : 12)
                            }
                            section("ĐÃ RÕ HÔM NAY (\(state.understood.count))")
                                .padding(.top, 16)
                            ForEach(Array(state.understood.enumerated()), id: \.element.id) { i, m in
                                row(m, selected: state.pending.count + i == state.selectedIndex).id(m.id)
                                    .padding(.top, i == 0 ? 16 : 12)
                            }
                        }
                        .padding(.trailing, 19)
                        .padding(.top, 34)
                        .padding(.bottom, 40)       // chừa chỗ cho bóng đổ
                    }
                    .onChange(of: state.selectedIndex) { _, new in
                        let items = state.listOrder
                        guard new < items.count else { return }
                        withAnimation { proxy.scrollTo(items[new].id, anchor: .center) }
                    }
                }
            }

            HStack {
                Button { state.showToast("Lịch sử: chưa làm trong prototype") } label: {
                    Text("Lịch sử")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(width: 125, height: 63)
                        .glass(tint: Theme.dark, cornerRadius: 31.5)
                }
                .buttonStyle(.plain)
                Spacer()
                Button { state.screen = .compose } label: {
                    Text("Nhắn tin")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(.black)
                        .frame(width: 125, height: 63)
                        .glass(cornerRadius: 31.5)
                }
                .buttonStyle(.plain)
            }
            .padding(.leading, 41)
            .padding(.trailing, 41)
            .padding(.bottom, 36)
        }
    }

    private func section(_ t: String) -> some View {
        Text(t)
            .font(.system(size: 14, weight: .medium))
            .foregroundStyle(.black)
            .padding(.trailing, 4)
    }

    /// Thẻ tin — Figma: 286×79, bo 20; thẻ đang chọn có bóng đổ (0 0 54 đen 20%)
    private func row(_ m: TaskMessage, selected: Bool) -> some View {
        HStack(alignment: .center, spacing: 9) {
            Thumb(name: m.imageName, size: 50, radius: 8)
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 11) {
                    Text(m.sender)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.black)
                    StatusChip(status: m.status)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 14) {
                    if m.isUrgent {
                        Text("Gấp")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Theme.red)
                    }
                    Text(m.timeString)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Theme.time)
                }
            }
        }
        .padding(.horizontal, 12.5)
        .frame(width: 286, height: 79)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Theme.cardBG)
                .shadow(color: .black.opacity(selected ? 0.2 : 0), radius: 27)
        )
        .animation(.easeInOut(duration: 0.2), value: selected)
    }
}
