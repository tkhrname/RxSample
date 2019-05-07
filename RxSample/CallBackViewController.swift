//
//  CallBackViewController.swift
//  RxSample
//
//  Created by 渡邊丈洋 on 2019/05/07.
//  Copyright © 2019 渡邊丈洋. All rights reserved.
//

import UIKit

class CallBackViewController: UIViewController {

    @IBOutlet weak var countLabel: UILabel!
    
    private var viewModel: CounterViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CounterViewModel()
        
    }
    
    @IBAction func countUp(_ sender: Any) {
        viewModel.incrementCount(callBack: { [weak self] count in
            self?.updateCountLabel(count)
        })
    }
    
    @IBAction func countDown(_ sender: Any) {
        viewModel.decrementCount(callBack: { [weak self] count in
            self?.updateCountLabel(count)
        })
    }
    
    @IBAction func countReset(_ sender: Any) {
        viewModel.resetCount(callBack: { [weak self] count in
            self?.updateCountLabel(count)
        })
    }
    
    private func updateCountLabel(_ count: Int) {
        countLabel.text = String(count)
    }

}


class CounterViewModel {
    private(set) var count = 0
    
    func incrementCount(callBack: (Int) -> ()) {
        count += 1
        callBack(count)
    }
    
    func decrementCount(callBack: (Int) -> ()) {
        count -= 1
        callBack(count)
    }
    
    func resetCount(callBack: (Int) -> ()) {
        count = 0
        callBack(count)
    }
    
}
