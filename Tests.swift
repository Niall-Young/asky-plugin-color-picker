import AppKit

@main @MainActor
enum ColorPickerTests {
    static func main() {
        precondition(ColorPicker.hex(.black) == "#000000")
        precondition(ColorPicker.hex(.white) == "#FFFFFF")
        precondition(ColorPicker.hex(NSColor(srgbRed: 1, green: 147.0 / 255, blue: 23.0 / 255, alpha: 1)) == "#FF9317")
        precondition(ColorPicker.hex(NSColor(srgbRed: 0.5, green: 0, blue: 1, alpha: 0.2)) == "#8000FF")
        let p3 = NSColor(displayP3Red: 0.6, green: 0.4, blue: 0.2, alpha: 1)
        precondition(ColorPicker.hex(p3) == ColorPicker.hex(p3.usingColorSpace(.sRGB)!))
        precondition(ColorPicker.hex(p3) != "#996633")
        print("Color picker sRGB conversion passed")
    }
}
