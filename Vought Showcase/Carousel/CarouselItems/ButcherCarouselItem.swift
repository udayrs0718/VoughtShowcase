import UIKit

final class ButcherCarouselItem: CarouselItem {
    private var viewController: UIViewController?

    /// Get controller
    /// - Returns: View controller
    func getController() -> UIViewController {
        if viewController == nil {
            viewController = ImageViewController(imageName: "butcher")
        }
        return viewController!
    }
}
