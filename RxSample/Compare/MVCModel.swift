import Foundation

enum MVCResult<T> {
    case success(T)
    case failure(Error)
}

enum MVCError: Error {
    case invalidMail
    case invalidPw
    case invalidMailAndPw
}

protocol MVCModelProtocol {
    func validate(mail: String?, pw: String?) -> MVCResult<Void>
}

final class MVCModel: MVCModelProtocol {
    func validate(mail: String?, pw: String?) -> MVCResult<Void> {
        switch (mail, pw) {
        case (.none, .none):
            return .failure(MVCError.invalidMailAndPw)
        case (.none, .some):
            return .failure(MVCError.invalidMail)
        case (.some, .none):
            return .failure(MVCError.invalidPw)
        case (.some, .some):
            return MVCResult.success(())
        }
    }
}
