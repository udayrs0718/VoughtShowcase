import UIKit

final class MotherMilkCarouselItem: CarouselItem {
    private var viewController: UIViewController?

    /// Get controller
    /// - Returns: View controller
    func getController() -> UIViewController {
        if viewController == nil {
            viewController = ImageViewController(imageName: "mm")
        }
        return viewController!
    }
}
