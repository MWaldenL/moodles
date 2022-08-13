import Foundation
import AsyncDisplayKit


struct Styles {
    static let textWhite: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font: Fonts.helveticaBold16,
        NSAttributedString.Key.foregroundColor: UIColor.white
    ]
    
    static let textBlue: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font: Fonts.helveticaBold16,
        NSAttributedString.Key.foregroundColor: Color.primary
    ]
    
    static let textBody: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font: Fonts.helvetica16
    ]
    
    static let textError: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font: Fonts.helvetica18,
        NSAttributedString.Key.foregroundColor: Color.error
    ]
    
    static let textPlaceholder: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font: Fonts.helvetica16,
        NSAttributedString.Key.foregroundColor: Color.grey50
    ]
    
    static let textTitle: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font: Fonts.helvetica24
    ]
    
    static let textLabel: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font: Fonts.helvetica18,
        NSAttributedString.Key.foregroundColor: Color.primary
    ]
    
    static let textLabelWhite: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font: Fonts.helvetica18,
        NSAttributedString.Key.foregroundColor: UIColor.white
    ]
    
    static let textMuted: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font: Fonts.helvetica18,
        NSAttributedString.Key.foregroundColor: Color.grey50
    ]
    
    static let textHeader: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font: Fonts.helveticaBold24,
        NSAttributedString.Key.foregroundColor: Color.primary
    ]
    
    static let textHeaderLight: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font: Fonts.helveticaBold24,
        NSAttributedString.Key.foregroundColor: UIColor.white
    ]
    
    struct Color {
        static let dark = UIColor(red: 0.17, green: 0.44, blue: 0.48, alpha: 1.00)
        static let error = UIColor(red: 0.95, green: 0.69, blue: 0.67, alpha: 1.00)
        static let primary = UIColor(red: 0.28, green: 0.58, blue: 0.62, alpha: 1.00)
        static let babyBlue = UIColor(red: 0.22, green: 1.00, blue: 0.71, alpha: 1.00)
        
//        static let babyBlue2 = UIColor(red: 0.56, green: 0.65, blue: 0.96, alpha: 1.00)
        static let babyBlue2 = UIColor(red: 0.41, green: 0.86, blue: 0.91, alpha: 1)
        
//        static let babyBlue3 = UIColor(red: 0.80, green: 0.84, blue: 1.00, alpha: 1.00)
        static let babyBlue3 = UIColor(red: 0.41, green: 0.86, blue: 0.91, alpha: 1)
        
//        static let babyBlue4 = UIColor(red: 0.84, green: 0.85, blue: 1.00, alpha: 1.00)
        static let babyBlue4 = UIColor(red: 0.41, green: 0.86, blue: 0.91, alpha: 1)
        
        // static let babyBlue5 = UIColor(red: 0.87, green: 0.96, blue: 1.00, alpha: 0.250)
        static let babyBlue5 = UIColor(red: 0.41, green: 0.86, blue: 0.91, alpha: 0.25)
        
        
//- MARK: Orange
        static let orange = UIColor(red: 0.98, green: 0.62, blue: 0.22, alpha: 1.00)
        static let orange1 = UIColor(red: 1.00, green: 0.91, blue: 0.76, alpha: 1.00)
        
        static let lightGrey = UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1.00)
        static let grey50 = UIColor(red: 0.60, green: 0.60, blue: 0.60, alpha: 1.00)
    }
    
    struct Fonts {
        static let helvetica16 = UIFont(name: "HelveticaNeue", size: 16.0)!
        static let helvetica18 = UIFont(name: "HelveticaNeue", size: 18.0)!
        static let helvetica24 = UIFont(name: "HelveticaNeue", size: 24.0)!
        static let helveticaBold16 = UIFont(name: "HelveticaNeue-Bold", size: 16.0)!
        static let helveticaBold24 = UIFont(name: "HelveticaNeue-Bold", size: 24.0)!
    }
    
    struct Dimens {
        static let _40 = ASDimension(unit: .points, value: 40)
        static let _60 = ASDimension(unit: .points, value: 60)
        static let _80 = ASDimension(unit: .points, value: 80)
    }
}
