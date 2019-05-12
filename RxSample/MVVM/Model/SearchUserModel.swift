import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}

protocol SearchUserModelInput {
    func fetchUser(query: String, completion: @escaping (Result<[User]>) -> ())
}

final class SearchUserModel: SearchUserModelInput {
    
    func fetchUser(query: String, completion: @escaping (Result<[User]>) -> ()) {
        // APIなどリクエスト処理
    }
    
}
