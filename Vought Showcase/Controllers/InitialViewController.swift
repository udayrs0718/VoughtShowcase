import UIKit

final class InitialViewController: UIViewController {
    
    // MARK: - Properties
    private let openCarouselButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("The Boys Take Over", for: .normal)
        
        // Customizing the button appearance
        button.backgroundColor = UIColor.black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        button.addTarget(self, action: #selector(openCarouselTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupButton()
    }
    
    // MARK: - Setup Methods
    private func setupButton() {
        view.addSubview(openCarouselButton)
        NSLayoutConstraint.activate([
            openCarouselButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            openCarouselButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            openCarouselButton.widthAnchor.constraint(equalToConstant: 200),
            openCarouselButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Actions
    @objc private func openCarouselTapped() {
        let carouselItems = itemDataSourceProvider.items()  // Use the data source provider to get items
        let carouselVC = CarouselViewController(items: carouselItems)
        carouselVC.modalPresentationStyle = .overCurrentContext
        carouselVC.modalTransitionStyle = .coverVertical
        present(carouselVC, animated: true, completion: nil)
    }
    
    // MARK: - Properties
    private let itemDataSourceProvider: CarouselItemDataSourceProviderType = CarouselItemDataSourceProvider()
}
