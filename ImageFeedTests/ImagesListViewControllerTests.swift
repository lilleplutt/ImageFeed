import XCTest
@testable import ImageFeed

final class ImagesListViewControllerTests: XCTestCase {
    
    func testViewDidLoadCallsPresenter() {
        // given
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let vc = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let presenter = ImagesListPresenterSpy()
        vc.presenter = presenter
        presenter.view = vc
        
        // when
        _ = vc.view
        
        // then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testWillDisplayCallsPresenter() {
        // given
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let vc = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let presenter = ImagesListPresenterSpy()
        vc.presenter = presenter
        presenter.view = vc
        _ = vc.view
        
        // when
        vc.tableView(vc.value(forKey: "tableView") as! UITableView, willDisplay: UITableViewCell(), forRowAt: IndexPath(row: 0, section: 0))
        
        // then
        XCTAssertTrue(presenter.willDisplayCalled)
    }
    
    func testDidSelectRowCallsPresenter() {
        // given
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let vc = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let presenter = ImagesListPresenterSpy()
        vc.presenter = presenter
        presenter.view = vc
        _ = vc.view
        
        // when
        vc.tableView(vc.value(forKey: "tableView") as! UITableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        
        // then
        XCTAssertTrue(presenter.didSelectRowCalled)
    }
}


