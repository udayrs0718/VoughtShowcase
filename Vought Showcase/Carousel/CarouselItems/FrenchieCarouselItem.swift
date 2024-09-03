import UIKit

final class FrenchieCarouselItem: CarouselItem {
    private var viewController: UIViewController?

    /// Get controller
    /// - Returns: View controller
    func getController() -> UIViewController {
        if viewController == nil {
            viewController = ImageViewController(imageName: "frenchie")
        }
        return viewController!
    }
}
