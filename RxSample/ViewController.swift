import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.Subjectを定義
        let helloWorldSubject = PublishSubject<String>()
        
        // 2.Subjectを購読
        helloWorldSubject.subscribe(
            // 3.値が流れてきたらprint()で値を出力するように定義
            onNext: { message in
            print("onNext: \(message)")
        }, onError: { error in
            // エラーイベント
            // 1度だけ呼ばれ、その時点で終了、購読を破棄
            print("onError: \(error)")
        },
           onCompleted: {
            // 完了イベント
            // 1度だけ呼ばれ、その時点で終了、購読を破棄
            print("onCompleted")
        },
           onDisposed: {
            print("onDisposed")
        })
            // 定義したクラスが破棄されたら、購読も自動的に破棄させる
            .disposed(by: disposeBag)
        
        helloWorldSubject.onNext("Hello World!")
        helloWorldSubject.onNext("Hello World!!")
        helloWorldSubject.onNext("Hello World!!!")
        helloWorldSubject.onCompleted()
    }

}

