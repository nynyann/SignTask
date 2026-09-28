import Foundation

/// Rút gọn câu nói thành bản ngắn theo trật tự gần với ngữ pháp ngôn ngữ ký hiệu Việt Nam:
///   [THỜI GIAN], [VIỆC / ĐỒ VẬT], [ĐỊA ĐIỂM], [PHỦ ĐỊNH ở cuối], [GẤP]
/// Ví dụ: "Em ơi làm giúp anh 2 ly cà phê đen cho bàn 3 nhé, gấp lắm"
///      → "2 LY CÀ PHÊ ĐEN, BÀN 3, GẤP."
///
/// Đây là bộ luật đơn giản cho prototype. Bản thật nên nhờ người dùng ngôn ngữ ký hiệu
/// / chuyên gia kiểm tra, hoặc thay bằng một API AI (giữ nguyên tên hàm `shorten`).
struct SignGrammarShortener {

    private let urgentPattern = "gấp|khẩn|ngay lập tức|ngay|nhanh lên|nhanh"
    private let timePattern = "bây giờ|lát nữa|sáng nay|trưa nay|chiều nay|tối nay|ngày mai|[0-9]+ phút nữa|[0-9]+ giờ(?: [0-9]+)?"
    private let placePattern = "(?:(?:cho|ở|tại|ra|vào|lên|xuống) )?(?:bàn|phòng|quầy|tầng|khu|kệ) [\\p{L}\\p{N}]+"
    // "[tên] ơi" (gọi tên) và các từ đệm lịch sự
    private let fillerPattern = "[\\p{L}]+ ơi|ơi|làm ơn|(?:giúp|hộ|dùm|giùm)(?: (?:anh|chị|em|mình|tôi|tui))?|nhé|nha|nhá|nghen|ạ|lắm|nhe"
    private let numberWords = ["một": "1", "hai": "2", "ba": "3", "bốn": "4", "năm": "5",
                               "sáu": "6", "bảy": "7", "tám": "8", "chín": "9", "mười": "10"]
    private let classifiers = "ly|cốc|phần|suất|đĩa|tô|chai|lon|cái|thùng|hộp"

    func shorten(_ text: String) -> String {
        var s = " " + text.lowercased()
            .replacingOccurrences(of: "[.,!?;:…\"“”]", with: " ", options: .regularExpression) + " "
        s = collapse(s)

        // "hai ly" → "2 ly"
        for (word, digit) in numberWords {
            s = s.replacingOccurrences(of: self.word(word) + "(?= (?:\(classifiers)))",
                                       with: digit, options: .regularExpression)
        }

        let isUrgent = extract(urgentPattern, from: &s) != nil
        remove(urgentPattern, from: &s)
        let time = extract(timePattern, from: &s)
        var place = extract(placePattern, from: &s)
        if let p = place {
            place = p.replacingOccurrences(of: "^(cho|ở|tại|ra|vào|lên|xuống) ",
                                           with: "", options: .regularExpression)
        }
        remove(fillerPattern, from: &s)
        s = collapse(s)
        s = s.replacingOccurrences(of: " (với|làm)$", with: "", options: .regularExpression)

        // Phủ định đặt cuối câu: "không được mở cửa kho" → "MỞ CỬA KHO, KHÔNG"
        var negative = false
        if let r = s.range(of: "^(không được|không|đừng|cấm) ", options: .regularExpression) {
            negative = true
            s.removeSubrange(r)
        }
        // Bỏ động từ chung chung đứng trước số lượng: "gọi thêm 2 ly" → "2 ly"
        s = s.replacingOccurrences(of: "^((làm|pha|mang|đem|lấy|bưng|chuẩn bị|dọn|gọi|cần|thêm) )+(?=[0-9])",
                                   with: "", options: .regularExpression)
        s = collapse(s)

        var parts: [String] = []
        if let time { parts.append(time) }
        if !s.isEmpty { parts.append(s) }
        if let place { parts.append(place) }
        if negative { parts.append("không") }
        if isUrgent { parts.append("gấp") }
        guard !parts.isEmpty else { return "" }

        return parts.joined(separator: ", ")
            .uppercased(with: Locale(identifier: "vi_VN")) + "."
    }

    // MARK: helpers

    /// Bọc pattern để chỉ khớp nguyên từ (không cắt giữa chữ có dấu)
    private func word(_ p: String) -> String {
        "(?<![\\p{L}\\p{N}])(?:\(p))(?![\\p{L}\\p{N}])"
    }

    private func extract(_ pattern: String, from s: inout String) -> String? {
        guard let r = s.range(of: word(pattern), options: [.regularExpression, .caseInsensitive]) else { return nil }
        let found = String(s[r])
        s.replaceSubrange(r, with: " ")
        return collapse(found)
    }

    private func remove(_ pattern: String, from s: inout String) {
        s = s.replacingOccurrences(of: word(pattern), with: " ",
                                   options: [.regularExpression, .caseInsensitive])
    }

    private func collapse(_ s: String) -> String {
        s.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
         .trimmingCharacters(in: .whitespaces)
    }
}
