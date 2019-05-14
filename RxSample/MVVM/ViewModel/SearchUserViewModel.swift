import Foundation

protocol SearchUserViewModelInput {
    var numberOfUsers: Int { get }
    func user(forRow row: Int) -> User?
    func didSelectRow(at indexPath: IndexPath)
    func didTapSearchButton(text: String?)
}

protocol SearchUserViewModelOutput {
    func updateUsers(_ users: [User])
    func transitionToUserDetail(userName: String?)
}

protocol SearchUserViewModelType {
    var output: SearchUserViewModelOutput? { get }
    func setup(input: SearchUserViewModelInput)
}

/*
 ViewModel
 1. Viewに表示するためのデータを保持する
 2. Viewからイベントを受け取り、Modelの処理を呼び出す
 3. Viewからイベントを受け取り、加工して値を更新する
 */
class SearchUserViewModel: SearchUserViewModelType {
    
    var output: SearchUserViewModelOutput?
    
    init() {
        self.output = self
    }
    
    func setup(input: SearchUserViewModelInput) {}
}

extension SearchUserViewModel: SearchUserViewModelOutput {
    func updateUsers(_ users: [User]) {
        
    }
    
    func transitionToUserDetail(userName: String?) {
        
    }
}
