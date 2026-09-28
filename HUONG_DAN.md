# SignTask: prototype điều khiển bằng phím âm lượng (iOS)

## Cần có
- Máy Mac cài **Xcode 26** (tải miễn phí trên App Store), cần bản này để có hiệu ứng Liquid Glass giống Figma
- iPhone chạy **iOS 17 trở lên** + dây cáp (iOS 26 thì nút có hiệu ứng kính; máy cũ hơn nút màu phẳng)
- Một Apple ID (tài khoản miễn phí là đủ, không cần trả 99$)

> Phím âm lượng **chỉ chạy trên iPhone thật**. Trên Simulator, bấm vào các tab +/− ở mép trái màn hình để thử.
> Không có Mac hay iPhone? Xem phần "Chạy thử không cần Mac hay iPhone" trong README.md.

## Bước 1: Tạo project
1. Mở Xcode → **Create New Project** → iOS → **App** → Next.
2. Product Name: `SignTask` · Interface: **SwiftUI** · Language: **Swift** → Next → chọn nơi lưu.
3. Ở cột trái, **xóa** 2 file Xcode tự tạo: `ContentView.swift` và `SignTaskApp.swift` (chọn Move to Trash).
4. Kéo cả 7 file `.swift` trong thư mục này vào cột trái Xcode, tick **Copy items if needed** → Finish.

## Bước 2: Lấy ảnh ly cà phê từ Figma (việc duy nhất phải tự làm trong Figma)
1. Mở file Figma "button", frame **"1"** (màn nền đỏ), bấm chọn layer **`image 6`** (ảnh ly cà phê to).
2. Panel phải → mục **Export** → bấm **+** → chọn **PNG**, **3x** → **Export image 6**.
3. Trong Xcode mở `Assets.xcassets`, kéo file PNG vào, **đổi tên thành `coffee`**.
   (Chưa có ảnh thì app hiện icon ly tạm, vẫn chạy được.)

## Bước 3: Màu, font, kích thước
Đã lấy sẵn từ Figma và điền vào `Theme.swift` + `Screens.swift` (xanh `#0088FF`, đỏ `#FF383C`,
xanh lá `#34C759`, chữ SF Pro 32 Semibold cho câu lệnh, 17 Medium cho tab +/−...). Không cần làm gì.
Nếu sau này đổi màu trong Figma, sửa mã hex tương ứng trong `Theme.swift`.

## Bước 4: Xin quyền micro (cho màn Nhắn tin)
Chọn project `SignTask` → tab **Info** → dấu **+** → thêm 2 dòng:
- `Privacy - Microphone Usage Description` = `Ghi âm chỉ dẫn công việc`
- `Privacy - Speech Recognition Usage Description` = `Chuyển giọng nói thành văn bản`

## Bước 5: Chạy lên iPhone
1. Tab **Signing & Capabilities** → Team → **Add an Account…** → đăng nhập Apple ID → chọn team "(Personal Team)".
2. Nếu báo trùng Bundle Identifier, đổi thành `com.tenban.signtask`.
3. Cắm iPhone, bấm **Trust** trên điện thoại.
4. Trên iPhone: **Cài đặt → Quyền riêng tư & Bảo mật → Chế độ nhà phát triển → Bật**, máy sẽ khởi động lại.
5. Trên thanh trên cùng Xcode chọn iPhone của bạn → bấm ▶︎ (Cmd + R).
6. Lần đầu nếu báo "Untrusted Developer": iPhone → **Cài đặt → Cài đặt chung → Quản lý VPN & thiết bị** → chọn Apple ID của bạn → **Tin cậy**.

## Cách dùng
| Màn hình | Phím + | Phím − |
|---|---|---|
| Thẻ tin mới (đỏ) | Mở tin | Để sau |
| Chi tiết tin | Đã rõ | Hỏi lại |
| Danh sách ca | Mở tin đang chọn | Cuộn xuống tin sau |

Nút **Nhắn tin**: nói tiếng Việt → app tạo bản gốc + bản ngắn → **Gửi** → tin hiện lại như tin đến (prototype chạy trên 1 máy).

## Lưu ý
- Nhận dạng tiếng Việt của Apple cần **có mạng**.
- Bấm phím âm lượng không làm đổi âm lượng thật (app luôn đưa về 50%). Khi thoát app, phím hoạt động bình thường.
- Chứng chỉ Apple ID miễn phí hết hạn sau **7 ngày**, chỉ cần cắm máy bấm ▶︎ lại.
- Muốn 2 máy gửi tin cho nhau thật: cần thêm backend (ví dụ Firebase). Muốn bản ngắn chuẩn hơn: thay `SignGrammarShortener` bằng API AI và nhờ người dùng ngôn ngữ ký hiệu kiểm tra.

## Các file
- `SignTaskApp.swift`: điểm khởi động, chuyển màn hình
- `VolumeButtonManager.swift`: bắt phím âm lượng
- `AppState.swift`: dữ liệu, logic phím +/− theo từng màn
- `Screens.swift`: 3 màn hình theo thiết kế
- `ComposeView.swift`: màn nhắn tin bằng giọng nói
- `Speech.swift`: ghi âm, chuyển giọng nói thành chữ, phát lại
- `SignGrammarShortener.swift`: rút gọn câu theo trật tự ngữ pháp ký hiệu
- `Theme.swift`: màu sắc, các thành phần giao diện dùng chung
