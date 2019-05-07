//
//  ViewController.swift
//  RxSample
//
//  Created by 渡邊丈洋 on 2019/05/07.
//  Copyright © 2019 渡邊丈洋. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var countLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func countUp(_ sender: Any) {
    }
    
    @IBAction func countDown(_ sender: Any) {
    }
    
    @IBAction func countReset(_ sender: Any) {
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
        count -= 1
        callBack(count)
    }
    
}
