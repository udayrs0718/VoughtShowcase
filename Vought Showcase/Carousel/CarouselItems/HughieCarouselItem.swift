import UIKit

final class HughieCarouselItem: CarouselItem {
    private var viewController: UIViewController?

    /// Get controller
    /// - Returns: View controller
    func getController() -> UIViewController {
        // If viewController is nil, create and assign it
        if viewController == nil {
            viewController = ImageViewController(imageName: "hughei")
        }
        return viewController!
    }
}
