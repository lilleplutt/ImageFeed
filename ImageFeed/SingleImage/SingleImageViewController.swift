import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    //MARK: - Properties
    var image: UIImage? {
        didSet {
            guard isViewLoaded, let image else { return }
            imageView.image = image
            imageView.frame.size = image.size
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    var imageURL: String?
    
    //MARK: - Outlets
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.01
        scrollView.maximumZoomScale = 1.25
        
        if let imageURL {
            loadImage(from: imageURL)
        } else if let image {
            imageView.image = image
            imageView.frame.size = image.size
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let image {
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    //MARK: - Private methods
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        UIBlockingProgressHUD.show()
        
        imageView.kf.setImage(with: url) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self else { return }
            switch result {
            case .success(let value):
                self.image = value.image
            case .failure:
                self.showAlert()
            }
        }
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        view.layoutIfNeeded()
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        
        scrollView.setZoomScale(scale, animated: false)
        scrollView.minimumZoomScale = scale
        scrollView.layoutIfNeeded()
        centerImage()
    }
    
    private func centerImage() {
        let visibleRectSize = scrollView.bounds.size
        let newContentSize = scrollView.contentSize
        let x = max(0, (visibleRectSize.width - newContentSize.width) / 2)
        let y = max(0, (visibleRectSize.height - newContentSize.height) / 2)
        scrollView.contentInset = UIEdgeInsets(top: y, left: x, bottom: y, right: x)
    }
    
    //MARK: - Actions
    @IBAction private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        guard let image else { return }
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
}

//MARK: - Extentions
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }
}
