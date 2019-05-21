import Foundation
import UIKit


protocol SearchEventViewControllerProtocol: AnyObject { // AnyObject
    func updateTableView(events: [String])
    func displayError()
}

class SearchEventViewController: UIViewController {
    let searchBar = UISearchBar(frame: .zero)
    let tableView = UITableView(frame: .zero)
    private(set) var events = [String]()
    
    private var presenter: SearchEventPresenterProtocol!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func inject(presenter: SearchEventPresenterProtocol) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

class FakeSearchEventViewController: SearchEventViewControllerProtocol {
    var updateTableView_arguments = [String]()
    func updateTableView(events: [String]) {
        self.updateTableView_arguments = events
    }
    
    var dispalayError_callCount = 0
    func displayError() {
        dispalayError_callCount += 1
    }
    
}

extension SearchEventViewController: SearchEventViewControllerProtocol {
    func updateTableView(events: [String]) {
        self.events = events
        self.tableView.reloadData()
    }
    
    func displayError() {
        // エラー時の処理
    }
    
}

extension SearchEventViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.didTapSearchButton(text: searchBar.text)
        searchBar.resignFirstResponder()
    }
}

protocol SearchEventPresenterProtocol {
    var didTapSearchButton_arguments: String? { get set }
    func didTapSearchButton(text: String?)
}

class SearchEventPresenter: SearchEventPresenterProtocol {
    
    weak var viewController: SearchEventViewControllerProtocol?
    let model: SearchEventModelProtocol
    
    init(viewController: SearchEventViewControllerProtocol, model: SearchEventModelProtocol) {
        self.viewController = viewController
        self.model = model
    }
    
    var didTapSearchButton_arguments: String?
    
    // 取得したテキストを検索するか判定してModelのsearchを実行
    func didTapSearchButton(text: String?) {
        guard let searchWord = text, searchWord.isEmpty == false else { return }
        self.model.search(word: searchWord) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let events):
                // UIの更新のためメインスレッドで実行
                DispatchQueue.main.async {
                    self.viewController?.updateTableView(events: events)
                }
            case .failure:
                DispatchQueue.main.async {
                    self.viewController?.displayError()
                }
            }
        }
    }
    
}

class FakeSearchEventPresenter: SearchEventPresenterProtocol {
    var didTapSearchButton_arguments: String?
    func didTapSearchButton(text: String?) {
        didTapSearchButton_arguments = text
    }
}

enum SearchEventResult<T> {
    case success(T)
    case failure(Error)
}

protocol SearchEventModelProtocol {
    func search(word: String, callBack: (SearchEventResult<[String]>) -> Void)
}

class SearchEventModel: SearchEventModelProtocol {
    func search(word: String, callBack: (SearchEventResult<[String]>) -> Void) {
        
    }
}


