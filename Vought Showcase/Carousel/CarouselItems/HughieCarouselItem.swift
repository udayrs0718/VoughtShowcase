import UIKit

final class HughieCarouselItem: CarouselItem {
    private var viewController: UIViewController?

    /// Get controller
    /// - Returns: View controller
    func getController() -> UIViewController {
        if viewController == nil {
            viewController = ImageViewController(imageName: "hughei")
        }
        return viewController!
    }
}
