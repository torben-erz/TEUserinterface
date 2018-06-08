//
//  CodeDigitSquareView.swift
//  TEUserinterfaceDemo
//
//  Created by Torben Erz on 01.06.18.
//  Copyright © 2018 Torben Erz. All rights reserved.
//

import Foundation
import TEUserinterface

public class CodeDigitSquareView: UILabel, TECodeDigitView {
    
    public var state: TECodeDigitViewState! = .isEmpty {
        didSet {
            if state != oldValue {
                configure(withState: state)
            }
        }
    }
    
    public var digit: String? {
        didSet {
            guard digit != oldValue else { return }
            self.state = digit != nil ? .hasDigits : .isEmpty
            self.text = digit
        }
    }
    
    convenience required public init() {
        self.init(frame: .zero)
        
        self.textAlignment = .center
        self.font = UIFont.systemFont(ofSize: 30)
        self.layer.borderWidth = 2
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.cornerRadius = 10
        self.textColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1)
        self.configure(withState: .isEmpty)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    public func configure(withState state: TECodeDigitViewState) {
        
        switch state {
            
        case .isEmpty:
            layer.borderColor = UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1).cgColor
            
        case .hasDigits:
            layer.borderColor = UIColor(red: 0, green: 161.0/255.0, blue: 230.0/255.0, alpha: 1).cgColor
            
        case .failedVerification:
            layer.borderColor = UIColor(red: 246.0/255.0, green: 95.0/255.0, blue: 124.0/255.0, alpha: 1).cgColor
        }
    }
}

