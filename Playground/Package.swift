// swift-tools-version: 5.9

// Gói app cho Swift Playgrounds trên iPad.
// Không sửa trực tiếp trong SignTask.swiftpm: file này và code trong SignTask/
// được script scripts/make-ipad-playground.sh chép vào khi build.

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "SignTask",
    platforms: [
        .iOS("17.0")
    ],
    products: [
        .iOSApplication(
            name: "SignTask",
            targets: ["AppModule"],
            bundleIdentifier: "com.sunny.signtask",
            teamIdentifier: "",
            displayVersion: "1.0",
            bundleVersion: "1",
            accentColor: .presetColor(.red),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait
            ],
            capabilities: [
                .microphone(purposeString: "Ghi âm chỉ dẫn công việc"),
                .speechRecognition(purposeString: "Chuyển giọng nói thành văn bản")
            ]
        )
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: "."
        )
    ]
)
