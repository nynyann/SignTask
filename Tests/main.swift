// Kiểm tra bộ rút gọn câu (chạy được không cần iPhone):
//   swiftc SignTask/SignGrammarShortener.swift Tests/main.swift -o /tmp/t && /tmp/t
let s = SignGrammarShortener()
let cases: [(String, String)] = [
    ("Trân ơi, bàn 3 gọi hai ly cà phê đen, làm gấp dùm chị nhe.", "2 LY CÀ PHÊ ĐEN, BÀN 3, GẤP."),
    ("Em ơi làm giúp anh 2 ly cà phê đen cho bàn 3 nhé, gấp lắm", "2 LY CÀ PHÊ ĐEN, BÀN 3, GẤP."),
    ("Bàn 5 gọi thêm 1 ly cà phê sữa, làm nhanh giúp chị nha.", "1 LY CÀ PHÊ SỮA, BÀN 5, GẤP."),
    ("Không được mở cửa kho", "MỞ CỬA KHO, KHÔNG."),
]
var failed = 0
for (input, expected) in cases {
    let got = s.shorten(input)
    let ok = got == expected
    if !ok { failed += 1 }
    print(ok ? "✅" : "❌", input, "→", got, ok ? "" : "(mong đợi: \(expected))")
}
if failed > 0 { fatalError("\(failed) trường hợp sai") }
