import Foundation
import UIKit

/**
 ここではViewとViewModelのデータバインディングにNotificationCenterを利用
 シンプルな実装だが、ViewとViewModelを十分に疎結合を実現できることがわかる
 */

/*
 Model
 */
enum MResult<T> {
    case success(T)
    case failure(Error)
}

enum MModelError: Error {
    case invalidId
    case invalidPassword
    case invalidIdAndPassword
    
    var errorText: String {
        switch self {
        case .invalidIdAndPassword:
            return ""
        case .invalidId:
            return ""
        case .invalidPassword:
            return ""
        }
    }
}

protocol MModelProtocol {
    func validate(idText: String?, passwordText: String?) -> MResult<Void>
}

/**
 Modelはプレゼンテーションロジック以外のドメインロジックを担当する
 文字列のバリデーション = ドメインロジック
 */
final class MModel: MModelProtocol {
    func validate(idText: String?, passwordText: String?) -> MResult<Void> {
        switch (idText, passwordText) {
        case (.none, .none):
            return .failure(MModelError.invalidIdAndPassword)
        case (.none, .some):
            return .failure(MModelError.invalidId)
        case (.some, .none):
            return .failure(MModelError.invalidPassword)
        case (.some, .some):
            return .success(())
        }
    }
}

/*
 View
 1. ユーザー入力をViewModelに伝搬する
 2. 自身の状態とViewModelの状態をデータバインディングする
 3. ViewModelから返されるイベントを元に描画処理を実行する
 */
final class MvvmViewController: UIViewController {
    
    @IBOutlet private weak var idTextField: UITextField!
    @IBOutlet private weak var pwTextField: UITextField!
    @IBOutlet private weak var validationLabel: UILabel!
    
    private let notificationCenter = NotificationCenter()
    private lazy var viewModel = MvvmViewModel(notificationCenter: notificationCenter)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1. ユーザー入力を監視
        idTextField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        pwTextField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        // 2. ViewModelからの通知をここで監視する
        notificationCenter.addObserver(self, selector: #selector(updateValidationText), name: viewModel.changeText, object: nil)
        notificationCenter.addObserver(self, selector: #selector(updateValidationColor), name: viewModel.changeColor, object: nil)
    }
    
    @objc func textFieldEditingChanged(sender: UITextField) {
        // 1. ユーザー入力をViewModelに伝える
        viewModel.idPwChanged(id: idTextField.text, pw: pwTextField.text)
    }
    
    // 3. Viewが画面を更新できるようにする
    @objc func updateValidationText(notification: Notification) {
        // 送られてくる型情報が失われている
        guard let text = notification.object as? String else { return }
        validationLabel.text = text
    }
    // 3. Viewが画面を更新できるようにする
    @objc func updateValidationColor(notification: Notification) {
        guard let color = notification.object as? UIColor else { return }
        validationLabel.textColor = color
    }
}

/*
 ViewModel
 1. Viewに表示するためのデータを保持する
 2. Viewからイベントを受け取り、Modelの処理を呼び出す
 3. Viewからイベントを受け取り、加工して値を更新する
 */
final class MvvmViewModel {
    
    let changeText = Notification.Name("changeText")
    let changeColor = Notification.Name("changeColor")
    
    private let notificationCenter: NotificationCenter
    private let model: MModelProtocol
    
    init(notificationCenter: NotificationCenter, model: MModelProtocol = MModel()) {
        self.notificationCenter = notificationCenter
        self.model = model
    }
    
    // Notificationを使うことで実際のViewがなくてもViewModelとそのロジックが独立して存在できる
    // -> ViewModelがテストしやすい状態にある
    func idPwChanged(id: String?, pw: String?) {
        // 2. Viewからイベントを受け取り、Modelの処理を呼び出す
        let result = model.validate(idText: id, passwordText: pw)
        switch result {
        case .success:
            // 3. 加工して値を更新する
            notificationCenter.post(name: changeText, object: "OK")
            notificationCenter.post(name: changeColor, object: UIColor.green)
        case .failure(let error as MModelError):
            // 3. 加工して値を更新する
            notificationCenter.post(name: changeText, object: error.errorText)
            notificationCenter.post(name: changeColor, object: UIColor.red)
        case _:
            fatalError("Unexpected pattern.")
        }
    }
}


