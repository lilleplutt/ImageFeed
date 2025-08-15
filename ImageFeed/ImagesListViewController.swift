import UIKit

class ImagesListViewController: UIViewController {

//MARK: - IBOutlets
    
@IBOutlet private var tableView: UITableView!
    
    
override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = self
    tableView.delegate = self
        
    }
    
}

extension ImagesListViewController: UITableViewDelegate {
    
    
}

extension ImagesListViewController: UITableViewDataSource {
    
    
}

