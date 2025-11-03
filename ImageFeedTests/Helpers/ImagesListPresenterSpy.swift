import ImageFeed
import Foundation

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    
    var viewDidLoadCalled = false
    var willDisplayCalled = false
    var didSelectRowCalled = false
    var didTapLikeCalled = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func willDisplayRow(at indexPath: IndexPath, totalCount: Int) {
        willDisplayCalled = true
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        didSelectRowCalled = true
    }
    
    func didTapLike(at indexPath: IndexPath) {
        didTapLikeCalled = true
    }
}


