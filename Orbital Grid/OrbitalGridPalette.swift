import SwiftUI

// MARK: - Orbital Grid palette + typography
// Theme-independent. Always light. No SF Symbols. No emoji.

enum OrbitalGridPalette {
    // deep indigo
    static let indigo = Color(red: 0x1B/255, green: 0x28/255, blue: 0x45/255)
    // ivory background
    static let ivory = Color(red: 0xEF/255, green: 0xEB/255, blue: 0xE0/255)
    // arctic teal
    static let teal = Color(red: 0x5D/255, green: 0xAE/255, blue: 0xC0/255)
    // warm orange accent
    static let ember = Color(red: 0xE1/255, green: 0x8A/255, blue: 0x4E/255)
    // graphite (body text)
    static let graphite = Color(red: 0x37/255, green: 0x3D/255, blue: 0x45/255)
    // magenta highlight
    static let magenta = Color(red: 0xA8/255, green: 0x5D/255, blue: 0x7A/255)

    // surface tones derived from the core palette
    static let panel = Color(red: 0xF6/255, green: 0xF2/255, blue: 0xE7/255)
    static let panelDeep = Color(red: 0xE5/255, green: 0xDE/255, blue: 0xCC/255)
    static let hairline = Color(red: 0xC8/255, green: 0xBE/255, blue: 0xA8/255)
    static let bgDim = Color(red: 0xD9/255, green: 0xD3/255, blue: 0xC0/255)
    static let success = Color(red: 0x6C/255, green: 0x9A/255, blue: 0x55/255)
    static let warning = Color(red: 0xC9/255, green: 0x77/255, blue: 0x3C/255)
    static let danger  = Color(red: 0xA8/255, green: 0x3F/255, blue: 0x39/255)

    // module category accents
    static let modPower    = Color(red: 0xC7/255, green: 0x9B/255, blue: 0x3F/255)
    static let modLife     = Color(red: 0x5D/255, green: 0xAE/255, blue: 0xC0/255)
    static let modHab      = Color(red: 0xA8/255, green: 0x5D/255, blue: 0x7A/255)
    static let modScience  = Color(red: 0x52/255, green: 0x84/255, blue: 0x9B/255)
    static let modOps      = Color(red: 0x6C/255, green: 0x9A/255, blue: 0x55/255)
    static let modSpecial  = Color(red: 0xE1/255, green: 0x8A/255, blue: 0x4E/255)
}

enum OrbitalGridTypography {
    static func display(_ size: CGFloat) -> Font {
        if let d = UIFont.systemFont(ofSize: size, weight: .bold).fontDescriptor.withDesign(.serif) {
            return Font(UIFont(descriptor: d, size: size))
        }
        return Font.system(size: size, weight: .bold)
    }
    static func title(_ size: CGFloat) -> Font {
        if let d = UIFont.systemFont(ofSize: size, weight: .semibold).fontDescriptor.withDesign(.serif) {
            return Font(UIFont(descriptor: d, size: size))
        }
        return Font.system(size: size, weight: .semibold)
    }
    static func body(_ size: CGFloat) -> Font {
        Font.system(size: size, weight: .regular, design: .default)
    }
    static func mono(_ size: CGFloat) -> Font {
        Font.system(size: size, weight: .medium, design: .monospaced)
    }
    static func chip(_ size: CGFloat) -> Font {
        Font.system(size: size, weight: .semibold, design: .rounded)
    }
}
