//
//  MVCViewController.swift
//  RxSample
//
//  Created by 渡邊丈洋 on 2019/05/09.
//  Copyright © 2019 渡邊丈洋. All rights reserved.
//

import UIKit

class MVCViewController: UIViewController {
    
    @IBOutlet private weak var mailTextField: UITextField!
    @IBOutlet private weak var pwTextField: UITextField!
    @IBOutlet private weak var validationLabel: UILabel!
    
    private let model: MVCModel = MVCModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.mailTextField.tag = 0
        self.pwTextField.tag = 1
    }
    
    func mailPwChanged(mail: String?, pw: String?) {
        let result = model.validate(mail: mail, pw: pw)
        switch result {
        case .success:
            self.validationLabel.text = "OK"
            self.validationLabel.textColor = UIColor.green
        case .failure(let error as MVCError):
            self.validationLabel.text = error.localizedDescription
            self.validationLabel.textColor = UIColor.red
        case _:
            self.validationLabel.text = "unknown"
            self.validationLabel.textColor = UIColor.red
        }
    }

}

extension MVCViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.mailPwChanged(mail: self.mailTextField.text, pw: self.pwTextField.text)
    }
}
