import Foundation
#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(DeveloperToolsSupport)
import DeveloperToolsSupport
#endif

#if SWIFT_PACKAGE
private let resourceBundle = Foundation.Bundle.module
#else
private class ResourceBundleClass {}
private let resourceBundle = Foundation.Bundle(for: ResourceBundleClass.self)
#endif

// MARK: - Color Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ColorResource {

}

// MARK: - Image Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ImageResource {

    /// The "MoviePoster" asset catalog image resource.
    static let moviePoster = DeveloperToolsSupport.ImageResource(name: "MoviePoster", bundle: resourceBundle)

    /// The "Netflix Long" asset catalog image resource.
    static let netflixLong = DeveloperToolsSupport.ImageResource(name: "Netflix Long", bundle: resourceBundle)

    /// The "kingkong" asset catalog image resource.
    static let kingkong = DeveloperToolsSupport.ImageResource(name: "kingkong", bundle: resourceBundle)

    /// The "legend" asset catalog image resource.
    static let legend = DeveloperToolsSupport.ImageResource(name: "legend", bundle: resourceBundle)

    /// The "netflix" asset catalog image resource.
    static let netflix = DeveloperToolsSupport.ImageResource(name: "netflix", bundle: resourceBundle)

    /// The "truman" asset catalog image resource.
    static let truman = DeveloperToolsSupport.ImageResource(name: "truman", bundle: resourceBundle)

}

// MARK: - Color Symbol Extensions -

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

}
#endif

#if canImport(SwiftUI)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.Color {

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

}
#endif

// MARK: - Image Symbol Extensions -

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    /// The "MoviePoster" asset catalog image.
    static var moviePoster: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .moviePoster)
#else
        .init()
#endif
    }

    /// The "Netflix Long" asset catalog image.
    static var netflixLong: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .netflixLong)
#else
        .init()
#endif
    }

    /// The "kingkong" asset catalog image.
    static var kingkong: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .kingkong)
#else
        .init()
#endif
    }

    /// The "legend" asset catalog image.
    static var legend: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .legend)
#else
        .init()
#endif
    }

    /// The "netflix" asset catalog image.
    static var netflix: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .netflix)
#else
        .init()
#endif
    }

    /// The "truman" asset catalog image.
    static var truman: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .truman)
#else
        .init()
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    /// The "MoviePoster" asset catalog image.
    static var moviePoster: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .moviePoster)
#else
        .init()
#endif
    }

    /// The "Netflix Long" asset catalog image.
    static var netflixLong: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .netflixLong)
#else
        .init()
#endif
    }

    /// The "kingkong" asset catalog image.
    static var kingkong: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .kingkong)
#else
        .init()
#endif
    }

    /// The "legend" asset catalog image.
    static var legend: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .legend)
#else
        .init()
#endif
    }

    /// The "netflix" asset catalog image.
    static var netflix: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .netflix)
#else
        .init()
#endif
    }

    /// The "truman" asset catalog image.
    static var truman: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .truman)
#else
        .init()
#endif
    }

}
#endif

// MARK: - Thinnable Asset Support -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(watchOS, unavailable)
extension DeveloperToolsSupport.ColorResource {

    private init?(thinnableName: String, bundle: Bundle) {
#if canImport(AppKit) && os(macOS)
        if AppKit.NSColor(named: NSColor.Name(thinnableName), bundle: bundle) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIColor(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.Color {

    private init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

    private init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}
#endif

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(watchOS, unavailable)
extension DeveloperToolsSupport.ImageResource {

    private init?(thinnableName: String, bundle: Bundle) {
#if canImport(AppKit) && os(macOS)
        if bundle.image(forResource: NSImage.Name(thinnableName)) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIImage(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ImageResource?) {
#if !targetEnvironment(macCatalyst)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ImageResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

