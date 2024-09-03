import UIKit

final class FrenchieCarouselItem: CarouselItem {
    private var viewController: UIViewController?

    /// Get controller
    /// - Returns: View controller
    func getController() -> UIViewController {
        // If viewController is nil, create and assign it
        if viewController == nil {
            viewController = ImageViewController(imageName: "frenchie")
        }
        return viewController!
    }
}
