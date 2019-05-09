//
//  RxCounterViewController.swift
//  RxSample
//
//  Created by 渡邊丈洋 on 2019/05/07.
//  Copyright © 2019 渡邊丈洋. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// イベント発生元
struct CounterViewModelInput {
    let countUpButton: Observable<Void>
    let countDownButton: Observable<Void>
    let countResetButton: Observable<Void>
}

//
protocol CounterViewModelOutput {
    var conterText: Driver<String?> { get }
}

// ViewModelで実装させる
// outputはパラメータ
// inputはメソッド
protocol CounterViewModelType {
    var outputs: CounterViewModelOutput? { get }
    func setup(input: CounterViewModelInput)
}

/*
 ViewModel
 1. Viewに表示するためのデータを保持する
 2. Viewからイベントを受け取り、Modelの処理を呼び出す
 3. Viewからイベントを受け取り、加工して値を更新する
 */
class CounterRxViewModel: CounterViewModelType {
    var outputs: CounterViewModelOutput?
    // 1. Viewに表示するためのデータを保持する
    private let countRelay = BehaviorRelay<Int>(value: 0)
    private let initialCount = 0
    private let disposeBag = DisposeBag()
    
    init() {
        self.outputs = self
        resetCount()
    }
    
    func setup(input: CounterViewModelInput) {
        input.countUpButton // 3. Viewからイベントを受け取り、加工して値を更新する
            .subscribe(onNext: { [weak self] in
                self?.incrementCount()
            })
            .disposed(by: disposeBag)
        
        input.countDownButton // 3. Viewからイベントを受け取り、加工して値を更新する
            .subscribe(onNext: { [weak self] in
                self?.decrementCount()
            })
            .disposed(by: disposeBag)
        
        input.countResetButton // 3. Viewからイベントを受け取り、加工して値を更新する
            .subscribe(onNext: { [weak self] in
                self?.resetCount()
            })
            .disposed(by: disposeBag)
    }
    
    private func incrementCount() {
        let count = countRelay.value + 1
        countRelay.accept(count)
    }
    
    private func decrementCount() {
        let count = countRelay.value - 1
        countRelay.accept(count)
    }
    
    private func resetCount() {
        countRelay.accept(initialCount)
    }
}

extension CounterRxViewModel: CounterViewModelOutput {
    var conterText: Driver<String?> {
        return countRelay
            .map { "Rxパターン\($0)" }
            .asDriver(onErrorJustReturn: nil)
    }
}

/*
 View
 1. ユーザー入力をViewModelに伝搬する
 2. 自身の状態とViewModelの状態をデータバインディングする
 3. ViewModelから返されるイベントを元に描画処理を実行する
 */
class RxCounterViewController: UIViewController {
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var countUpButton: UIButton!
    @IBOutlet weak var countDownButton: UIButton!
    @IBOutlet weak var countResetButton: UIButton!
    
    private let disposeBag = DisposeBag()
    private var viewModel: CounterRxViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewModel()
        
    }
    
    private func setupViewModel() {
        viewModel = CounterRxViewModel()
        let input = CounterViewModelInput(
            countUpButton: countUpButton.rx.tap.asObservable(), // 1. ユーザー入力をViewModelに伝搬する
            countDownButton: countDownButton.rx.tap.asObservable(), // 1. ユーザー入力をViewModelに伝搬する
            countResetButton: countResetButton.rx.tap.asObservable() // 1. ユーザー入力をViewModelに伝搬する
        )
        
        viewModel.setup(input: input)
        // 2. 自身の状態とViewModelの状態をデータバインディングする
        viewModel.outputs?.conterText
            .drive(
                // 3. ViewModelから返されるイベントを元に描画処理を実行する
                countLabel.rx.text
            )
//            .drive(onNext: { value in
//                self.countLabel.text = value
//            })
            .disposed(by: disposeBag)
    }
    
}
