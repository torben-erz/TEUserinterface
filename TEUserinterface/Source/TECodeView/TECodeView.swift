//
//  TECodeView.swift
//
//  Created by Torben Erz on 01.06.18.
//  Copyright © 2018 Torben Erz. All rights reserved.
//

import Foundation
import UIKit

public class TECodeView: UIStackView {
    
    public enum CodeType {
        case numbers
        case numbersAndLetters
    }
    
    fileprivate enum State: Equatable {
        case inserting(Int)
        case loading
        case finished
        case disabled
    }
    
    public weak var delegate: TECodeViewDelegate?
    public var codeType: CodeType = .numbers
    public var digitViewInit: (() -> TECodeDigitView)!
    public var numberOfDigits: Int = 6
    public var groupingSize: Int = 3
    public var itemSpacing: Int = 2
    public var isEnabled: Bool {
        get { return self.digitState != .disabled }
        set {
            if newValue == isEnabled { return }
            
            if !newValue {
                self.previousDigitState = self.digitState
                self.digitState = .disabled
            } else if let previousState = self.previousDigitState {
                self.digitState = previousState
            }
        }
    }
    
    private var previousDigitState: State?
    private var didLayoutSubviews = false
    
    fileprivate var digitViews = [TECodeDigitView]()
    fileprivate var digitState: State = .inserting(0) {
        didSet {
            if case .inserting(0) = self.digitState {
                self.clearCode()
            }
        }
    }
    
    public init(numberOfDigits: Int = 6, codeType: CodeType = .numbers, groupingSize: Int = 3, itemSpacing: Int = 2) {
        super.init(frame: .zero)
        
        // Die Werte übernhemen
        self.numberOfDigits = numberOfDigits
        self.codeType = codeType
        self.groupingSize = groupingSize
        self.itemSpacing = itemSpacing
        
        // Initialisierung
        self.initialize()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        // Initialisierung
        self.initialize()
    }
    
    required public init(coder: NSCoder) {
        super.init(coder: coder)
        
        // Initialisierung
        self.initialize()
    }
    
    private func initialize() {
        
        // Die StackView konfigurieren
        self.axis = .horizontal
        self.distribution = .fill
        self.translatesAutoresizingMaskIntoConstraints = false
        
        // GestureRecognizer hinzufügen
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress))
        longPress.minimumPressDuration = 0.25
        self.addGestureRecognizer(longPress)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if !self.didLayoutSubviews {
            self.didLayoutSubviews = true
            self.configureDigitViews()
        }
    }
    
    @objc func didTap() {
        guard !self.isFirstResponder else {
            return
        }
        self.becomeFirstResponder()
    }
    
    @objc func didLongPress(gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else {
            return
        }
        
        if !self.isFirstResponder  {
            self.becomeFirstResponder()
        }
        
        UIMenuController.shared.setTargetRect(self.bounds, in: self)
        UIMenuController.shared.setMenuVisible(true, animated: true)
    }
    
    private func configureDigitViews() {
        assert(self.digitViewInit != nil, "Must provide a single digit view initializer")
        
        self.spacing = CGFloat(self.itemSpacing)
        
        self.arrangedSubviews.forEach { view in
            self.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        self.digitViews = []
        
        for _ in 0..<self.numberOfDigits {
            let digitView = self.digitViewInit()
            digitView.view.translatesAutoresizingMaskIntoConstraints = false
            self.addArrangedSubview(digitView.view)
            self.digitViews.append(digitView)
        }
        
        if self.groupingSize > 0 {
            for idx in stride(from: self.groupingSize, to: self.numberOfDigits, by: self.groupingSize).reversed() {
                let separator = TECodeSeparatorView()
                separator.text = "-"
                separator.textColor = UIColor.white
                separator.font = UIFont.systemFont(ofSize: 30)
                self.insertArrangedSubview(separator, at: idx)
            }
        }
    }
    
    fileprivate var text: String {
        return self.digitViews.reduce("", { text, digitView in
            return text + (digitView.digit ?? "")
        })
    }
    
    public func resetDigits() {
        self.digitState = .inserting(0)
    }
    
    func clearCode() {
        for digitView in self.digitViews {
            digitView.digit = nil
        }
    }
    
    fileprivate var canReceiveText: Bool {
        return [.loading, .disabled].contains(self.digitState) == false
    }
    
    func submitDigits() {
        self.digitState = .loading
        
        self.delegate?.codeView(self, didSubmitCode: text, isValidCallback: { [weak self] (isValid) in
            guard !isValid, let loSelf = self else {
                return
            }
            
            if loSelf.digitState == .loading {
                loSelf.digitState = .finished
            } else {
                loSelf.previousDigitState = .finished
            }
            
            for digitView in loSelf.digitViews {
                digitView.state = .failedVerification
            }
            
            loSelf.animateFailure()
        })
    }
    
    private func animateFailure() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = NSValue(cgPoint: CGPoint(x: center.x - 5, y: center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: center.x + 5, y: center.y))
        animation.duration = 0.07
        animation.repeatCount = 2
        animation.autoreverses = true
        self.layer.add(animation, forKey: "position")
    }
}

extension TECodeView {
    override public func paste(_ sender: Any?) {
        guard let string = UIPasteboard.general.string else {
            return
        }
        
        let code: String
        switch self.codeType {
            
        case .numbers:
            code = string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            
        case .numbersAndLetters:
            code = string.components(separatedBy: CharacterSet.alphanumerics.inverted).joined()
        }
        
        let index = code.index(code.startIndex, offsetBy: min(numberOfDigits, code.count))
        self.insertText(String(code[..<index]))
    }
    
    override public var canBecomeFirstResponder: Bool {
        return self.canReceiveText
    }
    
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return self.canReceiveText && action == #selector(paste(_:))
    }
    
    public var keyboardType: UIKeyboardType {
        get {
            switch self.codeType {
                
            case .numbers:
                return .numberPad
                
            case .numbersAndLetters:
                return .default
            }
        }
        set { }
    }
}

extension TECodeView: UIKeyInput {
    
    public var hasText: Bool {
        return !text.isEmpty
    }
    
    private func isValidText(_ text: String) -> Bool {
        guard !text.isEmpty else {
            return false
        }
        
        let validCharacterSet: CharacterSet
        switch self.codeType {
            
        case .numbers:
            validCharacterSet = .decimalDigits
            
        case .numbersAndLetters:
            validCharacterSet = .alphanumerics
        }
        
        guard let scalar = UnicodeScalar(text), validCharacterSet.contains(scalar) else {
            return false
        }
        return true
    }
    
    public func insertText(_ text: String) {
        guard self.canReceiveText else {
            return
        }
        
        guard text.count == 1 else {
            self.digitState = .inserting(0)
            text.map({ "\($0)" }).forEach(insertText)
            return
        }
        
        guard self.isValidText(text) else {
            return
        }
        
        self.delegate?.codeView(self, didInsertCode: text)
        
        // state machine
        switch self.digitState {
            
        case .inserting(let digitIndex):
            let digitView = self.digitViews[digitIndex]
            digitView.digit = text
            
            if digitIndex + 1 == self.numberOfDigits {
                self.digitState = .finished
                self.submitDigits()
            } else {
                self.digitState = .inserting(digitIndex + 1)
            }
            
        case .finished:
            self.digitState = .inserting(0)
            self.insertText(text)
            
        default: break
        }
    }
    
    public func deleteBackward() {
        guard self.canReceiveText else {
            return
        }
        
        self.delegate?.codeView(self, didInsertCode: "")
        
        switch self.digitState {
            
        case .inserting(let index) where index > 0:
            let digitView = self.digitViews[index - 1]
            digitView.digit = nil
            
            self.digitState = .inserting(index - 1)
            
        case .finished:
            self.digitState = .inserting(0)
            
        default: break
        }
    }
}

extension TECodeViewDelegate {
    func codeView(_ codeView: TECodeView, didInsertCode Code: String) {}
}

fileprivate func ==(lhs: TECodeView.State, rhs: TECodeView.State) -> Bool {
    
    switch (lhs, rhs) {
        
    case (.inserting(let index1), .inserting(let index2)):
        return index1 == index2
        
    case (.finished, .finished),
         (.loading, .loading),
         (.disabled, .disabled):
        return true
        
    default:
        return false
    }
}
