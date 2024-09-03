import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Initialize the carousel view
        initCarouselView()
    }

    private func initCarouselView() {
        // Create a carousel item provider
        let carouselItemProvider = CarouselItemDataSourceProvider()
        
        // Create carouselViewController with items
        let carouselViewController = CarouselViewController(items: carouselItemProvider.items())
        
        // Set carouselViewController's view frame to match the containerView
        carouselViewController.view.frame = containerView.bounds
        
        // Add carousel view controller in container view
        add(asChildViewController: carouselViewController, containerView: containerView)
    }
}
