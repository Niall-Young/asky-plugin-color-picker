#!/bin/sh
set -eu
cd "$(dirname "$0")"
if [ -z "${DEVELOPER_DIR:-}" ] && [ -d /Applications/Xcode.app/Contents/Developer ]; then
    export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
fi
artifact_dir=.build/tests
mkdir -p "$artifact_dir"
xcrun swiftc -parse-as-library -swift-version 6 -D COLOR_PICKER_TESTS main.swift Tests.swift -o "$artifact_dir/tests"
"$artifact_dir/tests"
