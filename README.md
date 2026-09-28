# SignTask

Prototype iOS (SwiftUI): nhận chỉ dẫn công việc dạng thẻ, điều khiển bằng phím âm lượng.
Phím + / − làm việc khác nhau tùy màn hình (mở tin, để sau, đã rõ, hỏi lại).

## Chạy thử không cần Mac hay iPhone (trên trình duyệt/giống prototype rồi không cần dùng nữa)

Dùng được trên **Windows, Chromebook, máy tính bất kỳ**: không cài gì, chỉ cần trình duyệt.

Cách hoạt động: mỗi lần có code mới đẩy lên GitHub, máy Mac của GitHub tự build app và để sẵn một file tải về.
Bạn đưa file đó lên **Appetize.io** aka trang web chạy iPhone ảo ngay trong trình duyệt.

### Bước 1: Tải file app từ GitHub (cần đăng nhập GitHub)
1. Mở https://github.com/nynyann/SignTask/actions
2. Bấm vào dòng **Build** trên cùng có dấu ✅ xanh.
   (Nếu chưa có dòng nào xanh: bấm **Build** ở cột trái → **Run workflow** → **Run workflow**, đợi khoảng 2 phút.)
3. Kéo xuống cuối trang, mục **Artifacts**, bấm **SignTask-appetize.zip** để tải về.
   **Không giải nén**: file này upload thẳng lên Appetize.

### Bước 2: Đưa lên Appetize
1. Vào https://appetize.io → **Sign up**, tạo tài khoản miễn phí (có thể đăng nhập bằng Google).
2. Trong trang quản lý, bấm **Upload** (hoặc **Upload app** / **New app**).
3. Chọn file `SignTask-appetize.zip` ở bước 1. Nếu được hỏi nền tảng, chọn **iOS**.
4. Tải lên xong, bấm vào app vừa tạo → **Open** / **Play**.

### Bước 3: Bấm thử
1. Chọn máy **iPhone 16** (hoặc mới hơn) và **iOS 26** nếu có, để thấy hiệu ứng kính giống Figma.
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
- Báo **"No .app folder found"**: bạn đang upload nhầm file (đã giải nén rồi nén lại, hoặc file từ bản build cũ). Tải lại **SignTask-appetize.zip** ở bước 1 và upload nguyên file.
- Báo **"All slots for this account are currently in use"** / **Account-based queue**: gói miễn phí chỉ chạy 1 máy ảo một lúc. Đóng các tab Appetize khác (kể cả trang xem trước sau khi upload), đợi 2–5 phút rồi tải lại trang.
- File trong **Artifacts** tự xóa sau 30 ngày → bấm **Run workflow** (bước 1.2) để build lại.
- Có code mới thì phải tải file mới và upload lại (trong Appetize có thể bấm **Update** trên app cũ để giữ nguyên link).
- Muốn thử phím âm lượng và giọng nói thật thì phải cài lên iPhone (cần Mac, xem phần dưới).

## Chạy trên iPad bằng Swift Playgrounds (không cần Mac, miễn phí)

Chạy thật trên iPad, có phím âm lượng, rung và micro. Không cần Mac, không cần cáp, không cần tài khoản Apple Developer.
Chỉ chạy được trên **iPad**, Swift Playgrounds không có trên iPhone.

**Cần có:** iPad chạy **iPadOS 17 trở lên** (iPadOS 26 để thấy hiệu ứng kính giống Figma) và tài khoản GitHub có quyền xem repo này.

### Bước 1: Cài Swift Playgrounds
Trên iPad mở **App Store**, tìm **Swift Playgrounds** (của Apple, miễn phí) và cài.

### Bước 2: Tải gói app về iPad
1. Trên iPad mở **Safari**, vào https://github.com/nynyann/SignTask/actions và đăng nhập GitHub.
2. Bấm vào dòng **Build** trên cùng có dấu ✅ xanh.
3. Kéo xuống mục **Artifacts**, bấm **SignTask-iPad.zip** rồi chọn **Tải về**.
   Không thấy mục Artifacts: bấm biểu tượng **Aa** (hoặc **⋯**) trên thanh địa chỉ, chọn **Yêu cầu trang web cho máy tính**, tải lại trang.

Cách khác: tải file trên máy tính rồi gửi sang iPad bằng AirDrop, iCloud Drive, Google Drive hoặc Zalo.

### Bước 3: Mở bằng Swift Playgrounds
1. Mở app **Tệp** (Files), vào **Tải về** (Downloads).
2. Chạm vào **SignTask-iPad.zip**. iPad tự giải nén ra thư mục **SignTask** (biểu tượng Swift Playgrounds).
3. Chạm vào **SignTask** để mở trong Swift Playgrounds.
   Nếu nó mở ra như thư mục thường: mở app Swift Playgrounds, bấm **Vị trí / Locations** ở góc, tìm đến **Tải về** và chọn **SignTask**.
4. Lần đầu Swift Playgrounds có thể hỏi có tin cậy/cho phép chạy code này không: chọn **Cho phép / Trust**.

### Bước 4: Chạy app
1. Đợi vài giây cho Swift Playgrounds đọc xong code (vòng xoay ở trên cùng biến mất).
2. Bấm nút **▶︎ Chạy** (Run) ở góc trên. App hiện ở khung bên phải.
3. Bấm biểu tượng **toàn màn hình** ở khung đó để app chiếm cả màn hình.
4. Lần đầu vào màn **Nhắn tin**, iPad hỏi quyền micro và nhận dạng giọng nói: chọn **Cho phép**.

Dùng phím âm lượng của iPad (cạnh trên hoặc cạnh bên) giống bảng phím ở phần trên, hoặc bấm tab **+ / −** trên màn hình.

### Lưu ý khi chạy trên iPad
- Giao diện thiết kế cho iPhone nên trên iPad sẽ nằm gọn một bên, không giãn ra hết màn hình.
- App chạy bên trong Swift Playgrounds nên phím âm lượng có thể thỉnh thoảng làm hiện thanh âm lượng của hệ thống. Nếu phím không phản hồi, bấm tab **+ / −** trên màn hình.
- Có code mới thì tải lại **SignTask-iPad.zip** (bước 2), xóa bản cũ trong app Tệp rồi làm lại bước 3.
- File trong Artifacts tự xóa sau 90 ngày. Hết hạn thì vào **Actions → Build → Run workflow** để tạo lại.
- Muốn tự tạo gói trên máy có bash: `bash scripts/make-ipad-playground.sh` (ra file `SignTask-iPad.zip`).

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
| `Playground/Package.swift`, `scripts/make-ipad-playground.sh` | Đóng gói app cho Swift Playgrounds trên iPad |

Cách tạo project bằng tay trong Xcode (không dùng XcodeGen) và bảng phím: xem [HUONG_DAN.md](HUONG_DAN.md).

## Kiểm tra bộ rút gọn câu (không cần iPhone)

```bash
swiftc SignTask/SignGrammarShortener.swift Tests/main.swift -o /tmp/t && /tmp/t
```

GitHub Actions (`.github/workflows/build.yml`) tự chạy bài kiểm tra này và build app cho Simulator mỗi lần push.
