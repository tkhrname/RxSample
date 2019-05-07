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

//
class CounterRxViewModel: CounterViewModelType {
    var outputs: CounterViewModelOutput?
    
    private let countRelay = BehaviorRelay<Int>(value: 0)
    private let initialCount = 0
    private let disposeBag = DisposeBag()
    
    init() {
        self.outputs = self
        resetCount()
    }
    
    func setup(input: CounterViewModelInput) {
        input.countUpButton
            .subscribe(onNext: { [weak self] in
                self?.incrementCount()
            })
            .disposed(by: disposeBag)
        
        input.countDownButton
            .subscribe(onNext: { [weak self] in
                self?.decrementCount()
            })
            .disposed(by: disposeBag)
        
        input.countResetButton
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
            countUpButton: countUpButton.rx.tap.asObservable(),
            countDownButton: countDownButton.rx.tap.asObservable(),
            countResetButton: countResetButton.rx.tap.asObservable()
        )
        
        viewModel.setup(input: input)
        
        viewModel.outputs?.conterText
//            .drive(onNext: {value in})
            .drive(countLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
}
