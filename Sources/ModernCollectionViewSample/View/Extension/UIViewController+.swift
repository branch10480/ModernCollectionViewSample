import UIKit

public extension UIViewController {
    static func instantiateVC() -> Self {
        let nib = UINib(nibName: String(describing: Self.self), bundle: Bundle.module)
        return nib.instantiate(withOwner: nil).first as! Self
    }
}
