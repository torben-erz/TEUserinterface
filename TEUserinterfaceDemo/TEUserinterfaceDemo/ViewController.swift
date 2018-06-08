//
//  ViewController.swift
//  TEUserinterfaceDemo
//
//  Created by Torben Erz on 01.06.18.
//  Copyright © 2018 Torben Erz. All rights reserved.
//

import UIKit
import TEUserinterface

class ViewController: UIViewController {
    
    @IBOutlet weak var codeView: TECodeView! {
        didSet {
            self.codeView.delegate = self
            self.codeView.numberOfDigits = 6
            self.codeView.groupingSize = 3
            self.codeView.itemSpacing = 7
            self.codeView.digitViewInit = CodeDigitSquareView.init
        }
    }
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
}

extension ViewController: TECodeViewDelegate {
    
    func codeView(_ codeView: TECodeView, didInsertCode code: String) { }
    
    func codeView(_ codeView: TECodeView, didSubmitCode code: String, isValidCallback: @escaping (Bool) -> Void) {
        
        // Den Code an den Server übermitteln
        self.codeView.alpha = 0.5
        self.activityIndicatorView.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.codeView.alpha = 1
            self.activityIndicatorView.stopAnimating()
            isValidCallback(false)
        }
    }
}
