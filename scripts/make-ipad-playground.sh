#!/bin/bash
# Tạo SignTask.swiftpm (mở được bằng Swift Playgrounds trên iPad) và nén thành SignTask-iPad.zip.
#   bash scripts/make-ipad-playground.sh
set -euo pipefail
cd "$(dirname "$0")/.."

out=build/ipad/SignTask.swiftpm
rm -rf build/ipad
mkdir -p "$out"
cp Playground/Package.swift "$out/"
cp SignTask/*.swift "$out/"
cp -R SignTask/Assets.xcassets "$out/"

cd build/ipad
rm -f ../../SignTask-iPad.zip
if command -v ditto >/dev/null; then
  ditto -c -k --norsrc --keepParent SignTask.swiftpm ../../SignTask-iPad.zip
else
  zip -qr ../../SignTask-iPad.zip SignTask.swiftpm
fi
echo "Đã tạo SignTask-iPad.zip"
