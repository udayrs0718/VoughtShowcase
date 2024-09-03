import UIKit

final class CarouselViewController: UIViewController {
    
    @IBOutlet private weak var containerView: UIView!
    
    private var progressBar: SegmentedProgressBar!
    private var pageViewController: UIPageViewController?
    private var items: [CarouselItem] = []
    private var currentItemIndex: Int = 0

    public init(items: [CarouselItem]) {
        self.items = items
        super.init(nibName: "CarouselViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationStyle = .fullScreen
        if items.isEmpty {
            fatalError("The items array cannot be empty")
        }
        initPageViewController()
        initProgressBar()
        setupTapGestures()
        setupSwipeDownGesture()
    }
    
    private func initPageViewController() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController?.dataSource = self
        pageViewController?.delegate = self
        
        if let initialViewController = getController(at: currentItemIndex) {
            pageViewController?.setViewControllers([initialViewController], direction: .forward, animated: true, completion: { completed in
                if !completed {
                    // Handle failure if needed
                }
            })
        } else {
            fatalError("Cannot initialize PageViewController. Initial view controller is nil.")
        }
        
        if let pageVC = pageViewController {
            add(asChildViewController: pageVC, containerView: containerView)
        }
    }

    private func initProgressBar() {
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

    @objc private func handleLeftTap() {
        showPreviousItem()
    }

    @objc private func handleRightTap() {
        showNextItem()
    }

    private func showNextItem() {
        guard !items.isEmpty else {
            return
        }
        
        let nextIndex = currentItemIndex + 1
        if nextIndex < items.count {
            if let controller = getController(at: nextIndex) {
                pageViewController?.setViewControllers([controller], direction: .forward, animated: true, completion: { completed in
                    if !completed {
                        // Handle failure if needed
                    }
                })
                currentItemIndex = nextIndex
                progressBar.skip()
            }
        } else {
            progressBar.finish()
        }
    }

    private func showPreviousItem() {
        guard !items.isEmpty else {
            return
        }

        let previousIndex: Int
        let direction: UIPageViewController.NavigationDirection

        // Check if we're at the first item
        if currentItemIndex == 0 {
            // If we're at the first item, stay on the first item and reset the progress bar
            previousIndex = 0
            direction = .reverse
            progressBar.rewind() // Reset the progress bar to start again
        } else {
            // Otherwise, move to the previous item as usual
            previousIndex = currentItemIndex - 1
            direction = .reverse
            progressBar.rewind() // Move the progress bar to the previous segment
        }

        if let controller = getController(at: previousIndex) {
            pageViewController?.setViewControllers([controller], direction: direction, animated: true, completion: { completed in
                if !completed {
                    // Handle failure if needed
                }
            })
            currentItemIndex = previousIndex
        }
    }

    private func setupSwipeDownGesture() {
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown))
        swipeDownGesture.direction = .down
        view.addGestureRecognizer(swipeDownGesture)
    }
    
    @objc private func handleSwipeDown() {
        dismiss(animated: true, completion: nil)
    }

    private func getController(at index: Int) -> UIViewController? {
        guard index >= 0 && index < items.count else {
            return nil
        }
        return items[index].getController()
    }
}

extension CarouselViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = items.firstIndex(where: { $0.getController() == viewController }) else {
            return nil
        }
        let previousIndex = index == 0 ? items.count - 1 : index - 1
        return getController(at: previousIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = items.firstIndex(where: { $0.getController() == viewController }) else {
            return nil
        }
        let nextIndex = (index + 1) % items.count
        return getController(at: nextIndex)
    }
}

extension CarouselViewController: UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let visibleViewController = pageViewController.viewControllers?.first,
           let index = items.firstIndex(where: { $0.getController() == visibleViewController }) {
            currentItemIndex = index
            progressBar.skipToIndex(index)
        }
    }
}

extension CarouselViewController: SegmentedProgressBarDelegate {
    func segmentedProgressBarChangedIndex(index: Int) {
        guard index >= 0 && index < items.count else {
            return
        }
        
        let direction: UIPageViewController.NavigationDirection = index > currentItemIndex ? .forward : .reverse
        if let controller = getController(at: index) {
            pageViewController?.setViewControllers([controller], direction: direction, animated: true, completion: nil)
            currentItemIndex = index
        }
    }
    
    func segmentedProgressBarFinished() {
        guard !items.isEmpty else {
            return
        }
        dismiss(animated: true, completion: nil)
    }
}
