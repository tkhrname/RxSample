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
