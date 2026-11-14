import AppKit

// Standalone trusted API v2 plugin. No implementation is linked into Asky.
@MainActor
enum ColorPicker {
    static func emit(_ frame: [String: Any]) {
        guard let data = try? JSONSerialization.data(withJSONObject: frame, options: [.sortedKeys]) else { exit(1) }
        FileHandle.standardOutput.write(data + Data([10]))
    }

    static func finish(_ value: Any) -> Never {
        emit(["type": "result", "value": value])
        exit(0)
    }

    static func fail(_ message: String) -> Never {
        emit(["type": "result", "error": message])
        exit(1)
    }

    static func save(_ state: [String: Any], id: Int) {
        emit(["type": "rpc", "id": id, "method": "state", "value": state])
        guard let reply = readFrame(), reply["id"] as? Int == id, reply["value"] as? Bool == true else {
            fail("无法保存取色状态")
        }
    }

    static func readFrame() -> [String: Any]? {
        guard let line = readLine(), let data = line.data(using: .utf8) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
    }

    static func hex(_ color: NSColor) -> String? {
        guard let rgb = color.usingColorSpace(.sRGB) else { return nil }
        let components = [rgb.redComponent, rgb.greenComponent, rgb.blueComponent]
        guard components.allSatisfy({ $0.isFinite }) else { return nil }
        let bytes = components.map { Int((min(1, max(0, $0)) * 255).rounded()) }
        return String(format: "#%02X%02X%02X", bytes[0], bytes[1], bytes[2])
    }

    static func run() {
        guard let frame = readFrame(), frame["tool"] as? String == "pick",
              let requestID = frame["requestID"] as? String else { fail("无效的取色请求") }
        let state = frame["state"] as? [String: Any] ?? [:]
        if frame["readback"] as? Bool == true {
            guard state["requestID"] as? String == requestID else { finish(NSNull()) }
            if state["cancelled"] as? Bool == true { finish(["items": []]) }
            guard let text = state["hex"] as? String,
                  state["changeCount"] as? Int == NSPasteboard.general.changeCount,
                  NSPasteboard.general.string(forType: .string) == text else { finish(NSNull()) }
            finish(["text": text])
        }
        // Never replay an operation whose result is unknown.
        guard state["requestID"] as? String != requestID else { fail("取色请求已执行，请核实结果") }
        save(["requestID": requestID, "attempting": true], id: 1)
        NSApplication.shared.setActivationPolicy(.accessory)
        NSColorSampler().show { color in
            MainActor.assumeIsolated {
                guard let color else {
                    save(["requestID": requestID, "cancelled": true], id: 2)
                    finish(["items": []])
                }
                guard let text = hex(color) else { fail("无法转换所选颜色") }
                NSPasteboard.general.clearContents()
                guard NSPasteboard.general.setString(text, forType: .string) else { fail("无法复制所选颜色，请重试。") }
                save(["requestID": requestID, "hex": text, "changeCount": NSPasteboard.general.changeCount], id: 2)
                finish(["text": text])
            }
        }
        NSApp.run()
    }
}

#if !COLOR_PICKER_TESTS
@main
enum PluginMain {
    @MainActor static func main() { ColorPicker.run() }
}
#endif
