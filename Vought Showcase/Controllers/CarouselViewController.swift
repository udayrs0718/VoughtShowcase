import Foundation
import UIKit

final class CarouselViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var containerView: UIView!
    
    // MARK: - Properties
    private var progressBar: SegmentedProgressBar!
    private var pageViewController: UIPageViewController?
    private var items: [CarouselItem] = []
    private var currentItemIndex: Int = 0

    // MARK: - Initializer
    public init(items: [CarouselItem]) {
        self.items = items
        super.init(nibName: "CarouselViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationStyle = .fullScreen
        if items.isEmpty {
            fatalError("The items array cannot be empty")
        }
        initPageViewController()
        initProgressBar()
        setupTapGestures()
        setupSwipeDownGesture() // Added swipe down gesture
    }
    
    // MARK: - Setup Methods
    private func initPageViewController() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController?.dataSource = nil // Disabling swipe gestures
        pageViewController?.delegate = self
        
        // Check if items count is valid before setting the view controller
        guard !items.isEmpty else {
            fatalError("Cannot initialize PageViewController. Items array is empty.")
        }
        pageViewController?.setViewControllers([getController(at: currentItemIndex)], direction: .forward, animated: true)
        
        guard let theController = pageViewController else { return }
        add(asChildViewController: theController, containerView: containerView)
    }

    private func initProgressBar() {
        // Ensure items count is valid for progress bar
        guard items.count > 0 else {
            fatalError("Cannot initialize ProgressBar. Items array is empty.")
        }
        progressBar = SegmentedProgressBar(numberOfSegments: items.count)
        progressBar.frame = CGRect(x: 0, y: 50, width: view.frame.width, height: 5)
        progressBar.delegate = self
        view.addSubview(progressBar)
        progressBar.startAnimation()
    }

    private func setupTapGestures() {
        let leftTap = UITapGestureRecognizer(target: self, action: #selector(handleLeftTap))
        let rightTap = UITapGestureRecognizer(target: self, action: #selector(handleRightTap))

        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width / 2, height: view.frame.height))
        let rightView = UIView(frame: CGRect(x: view.frame.width / 2, y: 0, width: view.frame.width / 2, height: view.frame.height))

        leftView.addGestureRecognizer(leftTap)
        rightView.addGestureRecognizer(rightTap)

        view.addSubview(leftView)
        view.addSubview(rightView)
    }

    // MARK: - Navigation Handlers
    @objc private func handleLeftTap() {
        showPreviousItem()
    }

    @objc private func handleRightTap() {
        showNextItem()
    }

    private func showNextItem() {
        guard !items.isEmpty else {
            print("Cannot show next item. Items array is empty.")
            return
        }
        let nextIndex = (currentItemIndex + 1) % items.count
        let direction: UIPageViewController.NavigationDirection = .forward
        let controller = getController(at: nextIndex)
        pageViewController?.setViewControllers([controller], direction: direction, animated: true, completion: nil)
        currentItemIndex = nextIndex
        progressBar.skip()
    }

    private func showPreviousItem() {
        guard !items.isEmpty else {
            print("Cannot show previous item. Items array is empty.")
            return
        }
        let previousIndex = currentItemIndex == 0 ? items.count - 1 : currentItemIndex - 1
        let direction: UIPageViewController.NavigationDirection = .reverse
        let controller = getController(at: previousIndex)
        pageViewController?.setViewControllers([controller], direction: direction, animated: true, completion: nil)
        currentItemIndex = previousIndex
        progressBar.rewind()
    }

    // MARK: - Swipe Down Gesture
    private func setupSwipeDownGesture() {
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown))
        swipeDownGesture.direction = .down
        view.addGestureRecognizer(swipeDownGesture)
    }
    
    @objc private func handleSwipeDown() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Utility Method
    private func getController(at index: Int) -> UIViewController {
        guard index >= 0 && index < items.count else {
            fatalError("Index \(index) out of range")
        }
        return items[index].getController()
    }
}

// MARK: - UIPageViewControllerDelegate methods
extension CarouselViewController: UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let visibleViewController = pageViewController.viewControllers?.first,
           let index = items.firstIndex(where: { $0.getController() == visibleViewController }) {
            currentItemIndex = index
            progressBar.skipToIndex(index)
        } else {
            print("Error: Visible view controller not found in items")
        }
    }
}

// MARK: - SegmentedProgressBarDelegate methods
extension CarouselViewController: SegmentedProgressBarDelegate {
    func segmentedProgressBarChangedIndex(index: Int) {
        guard index >= 0 && index < items.count else {
            print("Index \(index) out of range in segmentedProgressBarChangedIndex")
            return
        }
        
        let direction: UIPageViewController.NavigationDirection = index > currentItemIndex ? .forward : .reverse
        let controller = getController(at: index)
        pageViewController?.setViewControllers([controller], direction: direction, animated: true, completion: nil)
        currentItemIndex = index
    }
    
    func segmentedProgressBarFinished() {
        guard !items.isEmpty else {
            print("Cannot finish segmented progress bar. Items array is empty.")
            return
        }
        let nextIndex = (currentItemIndex + 1) % items.count
        if nextIndex == 0 {
            // Dismiss when all items have been shown
            dismiss(animated: true, completion: nil)
        } else {
            let direction: UIPageViewController.NavigationDirection = .forward
            let controller = getController(at: nextIndex)
            pageViewController?.setViewControllers([controller], direction: direction, animated: true, completion: nil)
            currentItemIndex = nextIndex
        }
    }
}
