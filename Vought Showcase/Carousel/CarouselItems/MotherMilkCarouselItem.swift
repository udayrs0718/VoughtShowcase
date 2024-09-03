import UIKit

final class MotherMilkCarouselItem: CarouselItem {
    private var viewController: UIViewController?

    /// Get controller
    /// - Returns: View controller
    func getController() -> UIViewController {
        // If viewController is nil, create and assign it
        if viewController == nil {
            viewController = ImageViewController(imageName: "mm")
        }
        return viewController!
    }
}
