//
//  NormalViewController.swift
//  RxSample
//
//  Created by 渡邊丈洋 on 2019/04/29.
//  Copyright © 2019 渡邊丈洋. All rights reserved.
//

import UIKit

class NormalViewController: UIViewController {
    
    @IBOutlet private weak var nameField: UITextField!
    @IBOutlet private weak var nameLabel: UILabel!
    
    @IBOutlet private weak var addressField: UITextField!
    @IBOutlet private weak var addressLabel: UILabel!
    
    private let maxNameFieldSize = 10
    private let maxAddressFieldSize = 50

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    private func limitText(_ count: Int) -> String {
        return "あと\(count)文字"
    }
    
}
