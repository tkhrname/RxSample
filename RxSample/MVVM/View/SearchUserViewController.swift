import UIKit

/*
 View
 1. ユーザー入力をViewModelに伝搬する(処理を依頼)
 2. 自身の状態とViewModelの状態をデータバインディングする(ViewModelのデータと自分をバインドする)
 3. ViewModelから返されるイベントを元に描画処理を実行する
 */
class SearchUserViewController: UIViewController {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    
    private lazy var viewModel = SearchUserViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // ユーザー入力をViewModelに伝搬する
}

// 自分(ViewController)でやらないといけない処理は自身で実装する
