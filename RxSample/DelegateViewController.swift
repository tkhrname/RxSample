//
//  DelegateViewController.swift
//  RxSample
//
//  Created by 渡邊丈洋 on 2019/05/07.
//  Copyright © 2019 渡邊丈洋. All rights reserved.
//

import UIKit

class DelegateViewController: UIViewController {
    
    @IBOutlet weak var countLabel: UILabel!
    
    private let presenter = CounterPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attachView(self)
    }
    
    @IBAction func countUp(_ sender: Any) {
        presenter.incrementCount()
    }
    
    @IBAction func countDown(_ sender: Any) {
        presenter.decrementCount()
    }
    
    @IBAction func countReset(_ sender: Any) {
        presenter.resetCount()
    }

}

extension DelegateViewController: CounterDelegate {
    func updateCount(count: Int) {
        countLabel.text = String(count)
    }
}

protocol CounterDelegate {
    func updateCount(count: Int)
}

class CounterPresenter {
    private var count = 0 {
        didSet {
            delegate?.updateCount(count: count)
        }
    }
    
    private var delegate: CounterDelegate?
    
    func attachView(_ delegate: CounterDelegate) {
        self.delegate = delegate
    }
    
    func detachView() {
        self.delegate = nil
    }
    
    func incrementCount() {
        count += 1
    }
    
    func decrementCount() {
        count -= 1
    }
    
    func resetCount() {
        count = 0
    }
}
