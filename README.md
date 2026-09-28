# SignTask

Prototype iOS (SwiftUI): nhận chỉ dẫn công việc dạng thẻ, điều khiển bằng phím âm lượng.
Phím + / − làm việc khác nhau tùy màn hình (mở tin, để sau, đã rõ, hỏi lại).

## Chạy trên Mac (khoảng 10 phút)

Cần: Mac có Xcode 26 và Homebrew, iPhone kèm cáp, Apple ID.

```bash
git clone https://github.com/nynyann/SignTask.git
cd SignTask
brew install xcodegen      # chỉ cần làm lần đầu
xcodegen                   # tạo SignTask.xcodeproj
open SignTask.xcodeproj
```

Trong Xcode:
1. Chọn target **SignTask** → tab **Signing & Capabilities** → **Team**: đăng nhập Apple ID, chọn "Personal Team".
   Nếu báo trùng Bundle Identifier thì đổi `com.example.SignTask` thành tên khác, ví dụ `com.tenban.SignTask`.
2. Chạy nhanh trên máy ảo: chọn một iPhone Simulator rồi bấm ▶︎. Simulator không có phím âm lượng thật,
   nên hãy bấm vào tab **+ / −** ở mép trái màn hình.
3. Chạy trên iPhone thật: cắm máy, bấm **Tin cậy**, bật **Cài đặt → Quyền riêng tư & Bảo mật → Chế độ nhà phát triển**
   (máy sẽ khởi động lại). Chọn iPhone trong Xcode rồi bấm ▶︎.
   Nếu báo "Untrusted Developer": **Cài đặt → Cài đặt chung → Quản lý VPN & thiết bị** → chọn Apple ID → **Tin cậy**.

Quyền micro và nhận dạng giọng nói đã khai báo sẵn trong `project.yml`, không cần thêm tay ở tab Info.

### Ảnh cà phê (không bắt buộc)
Export layer `image 6` (frame "1" trong Figma) thành PNG 3x, kéo vào `SignTask/Assets.xcassets`, đặt tên `coffee`.
Chưa có ảnh thì app hiện biểu tượng ly cà phê thay thế.

## Cấu trúc

| File | Nội dung |
|---|---|
| `SignTaskApp.swift` | Điểm vào app, chuyển màn hình |
| `AppState.swift` | Dữ liệu tin, logic phím +/−, rung |
| `Screens.swift` | Màn thẻ tin mới, chi tiết tin, danh sách ca |
| `ComposeView.swift` | Màn nhắn tin bằng giọng nói |
| `SignGrammarShortener.swift` | Rút gọn câu theo trật tự ngữ pháp ký hiệu |
| `Theme.swift` | Màu lấy từ Figma, Liquid Glass, tab +/−, chip, toast |
| `VolumeButtonManager.swift` | Bắt phím âm lượng vật lý |
| `Speech.swift` | Ghi âm, nhận dạng tiếng Việt, phát lại |

Cách tạo project bằng tay trong Xcode (không dùng XcodeGen) và bảng phím: xem [HUONG_DAN.md](HUONG_DAN.md).

## Kiểm tra bộ rút gọn câu (không cần iPhone)

```bash
swiftc SignTask/SignGrammarShortener.swift Tests/main.swift -o /tmp/t && /tmp/t
```

GitHub Actions (`.github/workflows/build.yml`) tự chạy bài kiểm tra này và build app cho Simulator mỗi lần push.
