//
//  TECodeViewDelegate.swift
//
//  Created by Torben Erz on 01.06.18.
//  Copyright © 2018 Torben Erz. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol TECodeViewDelegate: class {
    func codeView(_ codeView: TECodeView, didSubmitCode code: String, isValidCallback: @escaping (Bool)->Void)
    func codeView(_ codeView: TECodeView, didInsertCode code: String)
}
