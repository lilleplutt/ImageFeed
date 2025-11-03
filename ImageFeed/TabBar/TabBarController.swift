import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib() // = viewDidload
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imagesListVC = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
        if let imagesListViewController = imagesListVC as? ImagesListViewController {
            let imagesListPresenter = ImagesListPresenter()
            imagesListViewController.presenter = imagesListPresenter
            imagesListPresenter.view = imagesListViewController
        }
        imagesListVC.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_editorial_active"),
            selectedImage: nil)
        
        let profileViewController = ProfileViewController()
        let profilePresenter = ProfileViewPresenter()
        profileViewController.presenter = profilePresenter
        profilePresenter.view = profileViewController
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil)
        self.viewControllers = [imagesListVC, profileViewController]
    }
}
