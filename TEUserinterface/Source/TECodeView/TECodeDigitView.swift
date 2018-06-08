//
//  TECodeDigitView.swift
//
//  Created by Torben Erz on 01.06.18.
//  Copyright © 2018 Torben Erz. All rights reserved.
//

import Foundation
import UIKit

public enum TECodeDigitViewState {
    case isEmpty
    case hasDigits
    case failedVerification
}

public protocol TECodeDigitView: class {
    init()
    var digit: String? { get set }
    var state: TECodeDigitViewState! { get set }
    func configure(withState: TECodeDigitViewState)
    var view: UIView { get }
}

public extension TECodeDigitView where Self: UIView {
    var view: UIView {
        return self
    }
}

class TECodeSeparatorView: UILabel {
    
    init() {
        super.init(frame: .zero)
        self.textAlignment = .center
        self.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
        self.sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
