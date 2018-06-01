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
            self.codeView.groupingSize = 0
            self.codeView.itemSpacing = 7
            self.codeView.digitViewInit = CodeDigitSquareView.init
        }
    }
}

extension ViewController: TECodeViewDelegate {
    
    func codeView(_ codeView: TECodeView, didInsertCode code: String) {
        
    }
    
    func codeView(_ codeView: TECodeView, didSubmitCode code: String, isValidCallback: @escaping (Bool) -> Void) {
        
        //  codeView.alpha = 0.5
        
        // check server for code validity, etc
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            //       codeView.alpha = 1
            
            isValidCallback(false)
        }
    }
}
