import UIKit
import RxSwift

class SampleViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private var viewModel: SampleViewModel!

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
    
}

class SampleViewModel {
    
    /*
     Observable: 「観測可能」なものを表現し、イベントを検知するためのクラス
     ストリームとも表現される
     */
    var helloWorldObservable: Observable<String> {
        return helloWorldSubject.asObserver()
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
