import Foundation
import RxSwift
import RxCocoa


/*
 Model
 */
// 1. Protocol化して疎結合にしてテスタブルにする
// 2. Observerを返却してViewModelとの建て付けをよくする
protocol RxModelProtocol {
    // Observable: イベントを検知するクラス、観測可能なものを表現
    func validate(idText: String?, passwordText: String?) -> Observable<Void>
}

// 1. Modelに直接依存するのではなくProtocolに依存するようにしてDIできるようにすることで疎結合になりテスタブルになる
final class RxModel: RxModelProtocol {
    // ViewModelが扱うObservableと合成しやすいのでObservableを返す
    func validate(idText: String?, passwordText: String?) -> Observable<Void> {
        switch (idText, passwordText) {
        case (.none, .none):
            return Observable.error(MModelError.invalidIdAndPassword)
        case (.none, .some):
            return Observable.error(MModelError.invalidId)
        case (.some, .none):
            return Observable.error(MModelError.invalidPassword)
        case (let idText?, let passwordText?):
            switch (idText.isEmpty, passwordText.isEmpty) {
            case (true, true):
                return Observable.error(MModelError.invalidIdAndPassword)
            case (false, false):
                return Observable.just(())
            case (true, false):
                return Observable.error(MModelError.invalidId)
            case (false, true):
                return Observable.error(MModelError.invalidPassword)
            }
        }
    }
}

/*
 View
 1. ユーザー入力をViewModelに伝搬する
 2. 自身の状態とViewModelの状態をデータバインディングする
 3. ViewModelから返されるイベントを元に描画処理を実行する
 */
final class RxViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet private weak var idTextField: UITextField!
    @IBOutlet private weak var pwTextField: UITextField!
    @IBOutlet private weak var validationLabel: UILabel!
    
    // 1. 入力フィールドのObaservableをViewModelに渡す
    private lazy var viewModel = RxViewModel(idTextObservable: idTextField.rx.text.asObservable(), pwTextObservable: pwTextField.rx.text.asObservable(), model: RxModel())
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 2. ViewModelのObservable(validationText)と自身(validationLabel.rx.text)をバインドしている
        // ViewModelのObservableはViewModel内のプレゼンテーションロジックによって値が更新される->バインドされたViewも更新される
        viewModel.validationText.bind(to: validationLabel.rx.text).disposed(by: disposeBag)
        viewModel.loadLabelColor.bind(to: loadLabelColor).disposed(by: disposeBag)
    }
    
    // 3. rx拡張のないプロパティを更新したりViewメソッドを実行するためにObservableを独自に定義
    private var loadLabelColor: Binder<UIColor> {
        return Binder(self, binding: { me, color in
            me.validationLabel.textColor = color
        })
    }
}

/*
 ViewModel
 1. Viewに表示するためのデータを保持する
 2. Viewからイベントを受け取り、Modelの処理を呼び出す
 3. Viewからイベントを受け取り、加工して値を更新する
 */
final class RxViewModel {

    let validationText: Observable<String>
    let loadLabelColor: Observable<UIColor>
    
    init(idTextObservable: Observable<String?>, pwTextObservable: Observable<String?>, model: RxModelProtocol) {
        // 2. textFieldの文字列の入力・変更イベントに同期してModelのValidateを呼び出すように関連付けている
        let event = Observable
            // IDとPWそれぞれで変更があった時、共通の処理を呼び出すためにcombineLatestを使う
            .combineLatest(idTextObservable, pwTextObservable) // 複数のObservableの最新値を組み合わせる
            .skip(1) // 指定時間の間はイベントを無視する
            .flatMap { (arg) -> Observable<Event<Void>> in // 通常の高階関数と同じ働き
                let (idText, pwText) = arg
                return model.validate(idText: idText, passwordText: pwText)
                    // onNext,onErrorのイベントをObservable<Event<Void>>として変換し、別々のストリームとして扱えるようにしている
                        .materialize()
            }
        // HotObservableに変換し、一つの入力に対して以降のObservableがそれぞれ独立したストリームとしてデータ更新を行えるようにしている
        .share()
        
        // flatMapに入力されるイベントに応じてViewに出力する情報を加工し、更新している
        self.validationText = event.flatMap { event -> Observable<String> in
            switch event {
            case .next: return .just("OK")
            case let .error(error as MModelError):
                return .just(error.errorText)
            case .error, .completed: return .empty()
            }
        }
        .startWith("IDとPWを入力してください")
        
        self.loadLabelColor = event.flatMap { event -> Observable<UIColor> in
            switch event {
            case .next: return .just(.green)
            case .error: return .just(.red)
            case .completed: return .empty()
            }
        }
    }
}

