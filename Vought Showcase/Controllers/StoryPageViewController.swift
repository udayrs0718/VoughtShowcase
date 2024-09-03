import UIKit

class StoryPageViewController: UIViewController {
    private var imageView: UIImageView!

    // Initialize with an image
    init(image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        setupImageView(with: image)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black // Ensure background is black to match Instagram style
        setupImageViewConstraints()
    }

    private func setupImageView(with image: UIImage) {
        imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit // Changed to scaleAspectFit to prevent cropping
        imageView.clipsToBounds = true // This ensures that any part of the image that overflows the bounds is clipped
        view.addSubview(imageView)
    }

    private func setupImageViewConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
