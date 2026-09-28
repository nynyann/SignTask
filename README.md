# SignTask

Prototype iOS (SwiftUI): nhận chỉ dẫn công việc dạng thẻ, điều khiển bằng phím âm lượng.
Phím + / − làm việc khác nhau tùy màn hình (mở tin, để sau, đã rõ, hỏi lại).

## Chạy thử không cần Mac hay iPhone (trên trình duyệt)

Dùng được trên **Windows, Chromebook, máy tính bất kỳ** — không cài gì, chỉ cần trình duyệt.

Cách hoạt động: mỗi lần có code mới đẩy lên GitHub, máy Mac của GitHub tự build app và để sẵn một file tải về.
Bạn đưa file đó lên **Appetize.io** — trang web chạy iPhone ảo ngay trong trình duyệt.

### Bước 1 — Tải file app từ GitHub (cần đăng nhập GitHub)
1. Mở https://github.com/nynyann/SignTask/actions
2. Bấm vào dòng **Build** trên cùng có dấu ✅ xanh.
   (Nếu chưa có dòng nào xanh: bấm **Build** ở cột trái → **Run workflow** → **Run workflow**, đợi khoảng 2 phút.)
3. Kéo xuống cuối trang, mục **Artifacts**, bấm **SignTask-appetize** để tải về.
4. Giải nén **SignTask-appetize.zip** (Windows: chuột phải → **Extract All**).
   Bên trong có file **`SignTask-simulator.zip`** — đây là file cần dùng, **không giải nén tiếp**.

### Bước 2 — Đưa lên Appetize
1. Vào https://appetize.io → **Sign up**, tạo tài khoản miễn phí (có thể đăng nhập bằng Google).
2. Trong trang quản lý, bấm **Upload** (hoặc **Upload app** / **New app**).
3. Chọn file `SignTask-simulator.zip` ở bước 1. Nếu được hỏi nền tảng, chọn **iOS**.
4. Tải lên xong, bấm vào app vừa tạo → **Open** / **Play**.

### Bước 3 — Bấm thử
1. Chọn máy **iPhone 16** (hoặc mới hơn) và **iOS 26** nếu có — để thấy hiệu ứng kính giống Figma.
2. Bấm **Tap to play**. Đợi vài giây, app mở ra **màn thẻ đỏ**.
3. Điện thoại ảo không có phím âm lượng thật, nên **bấm chuột vào tab + / − ở mép trái màn hình**:

| Màn hình | Bấm + | Bấm − |
|---|---|---|
| Thẻ tin mới (đỏ) | Mở tin | Để sau |
| Chi tiết tin | Đã rõ | Hỏi lại |
| Danh sách ca | Mở tin đang chọn | Xuống tin sau |

Thử theo thứ tự: thẻ đỏ → **+** (mở tin) → đổi **Văn bản ngắn / Văn bản gốc** → **+** (Đã rõ) → về danh sách ca → bấm **?** để xem gợi ý phím.

### Giới hạn của bản thử trên web
- Không có phím âm lượng thật, không rung. Micro thường không dùng được, nên màn **Nhắn tin** bằng giọng nói có thể không chạy.
- Gói miễn phí của Appetize giới hạn số phút chạy mỗi tháng.
- File trong **Artifacts** tự xóa sau 30 ngày → bấm **Run workflow** (bước 1.2) để build lại.
- Có code mới thì phải tải file mới và upload lại (trong Appetize có thể bấm **Update** trên app cũ để giữ nguyên link).
- Muốn thử phím âm lượng và giọng nói thật thì phải cài lên iPhone (cần Mac — xem phần dưới).

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
