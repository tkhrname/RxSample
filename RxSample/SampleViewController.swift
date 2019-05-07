import UIKit
import RxSwift
import RxCocoa

class SampleViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private var viewModel: SampleViewModel!
    
    @IBOutlet weak var nameTextField: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var showUserNameButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = SampleViewModel()
        
        self.viewModel.helloWorldObservable
            .subscribe(
                // デフォルトのイベントを流す。イベント内に値を格納でき、何度でも呼び出せる。
                onNext: { [weak self] value in
                  print("value = \(value)")
            })
            // disposeBagを引数として渡すと
            .disposed(by: disposeBag) // 購読を破棄
        
        self.viewModel.updateItem()
    }
    
    private func initializedBind() {
        // bindを利用
        self.nameTextField.rx.text
            .bind(to: self.nameLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        // subscribeを利用
        self.nameTextField.rx.text.subscribe(onNext: { text in
            self.nameLabel.text = text
        }).disposed(by: self.disposeBag)
    }
    
    // Operatorサンプル1
    private func mapSample1() {
        self.nameTextField.rx.text
            .map { text -> String in
                return "\(text!.count)"
            }
            .bind(to: self.nameLabel.rx.text)
            .disposed(by: self.disposeBag)
    }
    
    // Operatorサンプル2
    private func mapSample2() {
        struct User{
            var name: String
        }
        let user = User(name: "takehiro")
        self.showUserNameButton
            .rx // Reactive化
            .tap // ControlEvent
            .map{ _ in
                return user.name
            } // Disposable 購読
            .bind(to: self.nameLabel.rx.text)
            .disposed(by: self.disposeBag)
    }
    
    // Operatorサンプル3 filter
    // 整数が流れるObservableから偶数のイベントのみに絞り混んでeventObservableに流す
    private func fileterSample() {
        let subject = PublishSubject<Int>()
        subject
            .filter{ $0 % 2 == 0 }
            .bind(to: subject.asObserver())
            .disposed(by: self.disposeBag)
    }
    
    // 複数のAPIにリクエストして同時に反映したい場合に使用することがある
    private func zipSample() {
        let api1Observable = PublishSubject<Int>().asObserver()
        let api2Observable = PublishSubject<Int>().asObserver()
        Observable.zip(api1Observable, api2Observable)
            .subscribe(onNext: { (api1, api2) in
                //
            })
            .disposed(by: self.disposeBag)
    }
    
}

class SampleViewModel {
    
    /*
     Observable: 「観測可能」なものを表現し、イベントを検知するためのクラス
     ストリームとも表現される
     イベントの発生元を作成
     */
    var helloWorldObservable: Observable<String> {
        return helloWorldSubject.asObserver()
    }
    
    var helloWorldDriver: Driver<String> {
        return helloWorldSubject.asDriver(onErrorJustReturn: "Error")
    }
    
    // 「Subject」イベントの検知に加えて、イベントの発生もできるクラス
    private let helloWorldSubject = PublishSubject<String>()
    
    func updateItem() {
        helloWorldSubject.onNext("Hello World!")
        helloWorldSubject.onNext("Hello World!!")
        helloWorldSubject.onNext("Hello World!!!")
        helloWorldSubject.onCompleted()
    }
    
}
