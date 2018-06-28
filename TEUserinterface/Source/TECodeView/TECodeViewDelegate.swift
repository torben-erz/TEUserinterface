//
//  TECodeViewDelegate.swift
//
//  Created by Torben Erz on 01.06.18.
//  Copyright © 2018 Torben Erz. All rights reserved.
//

import Foundation
import UIKit

public protocol TECodeViewDelegate: class {
    func codeView(_ codeView: TECodeView, didInsertCode code: String)
    func codeView(_ codeView: TECodeView, didInsertCode code: String, isValidCallback: @escaping (Bool)->Void)
    func codeView(_ codeView: TECodeView, didInsertDigit digit: String)
}
