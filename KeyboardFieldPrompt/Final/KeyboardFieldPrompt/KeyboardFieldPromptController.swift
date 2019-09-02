//
//  KeyboardFieldPromptController.swift
//  KeyboardFieldPrompt
//
//  Created by Andrew J Wagner on 9/1/19.
//  Copyright © 2019 Drewag. All rights reserved.
//

import UIKit

class KeyboardFieldPromptController: UIViewController {
    // View to hold the text field above the keyboard
    let aboveKeyboardView = UIView()
    let textField = UITextField()

    let keyboadConstraintAdjuster = KeyboardConstraintAdjuster()

    let completion: (String) -> ()
    let configure: (UITextField) -> ()

    init(
        configure: @escaping (UITextField) -> () = { _ in },
        completion: @escaping (String) -> ()
        )
    {
        self.completion = completion
        self.configure = configure

        super.init(nibName: nil, bundle: nil)

        // Configure as overlay
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // -----------------
        // Dismiss on tap
        // -----------------
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapToDismiss))
        self.view.addGestureRecognizer(recognizer)

        // -----------------
        // Configure the views
        // -----------------

        self.view.backgroundColor = UIColor(white: 0, alpha: 0.2)

        self.aboveKeyboardView.backgroundColor = UIColor.white

        self.textField.returnKeyType = .done
        self.textField.delegate = self
        self.configure(self.textField)
        self.aboveKeyboardView.addSubview(self.textField)
        self.view.addSubview(self.aboveKeyboardView)

        // -----------------
        // Constrain textField to inside of aboveKeyboardView
        // -----------------
        var factory = ConstraintFactory()
        self.textField.translatesAutoresizingMaskIntoConstraints = false

        factory.constrain([.centerX, .top, .bottom], ofBoth: self.textField, and: self.aboveKeyboardView)
        factory.constrain(.height, of: self.textField, to: 44)

        // Constrain the sides to the safe area
        factory.add(self.view.safeAreaLayoutGuide.leftAnchor.constraint(
            equalTo: self.textField.leftAnchor,
            constant: -8
        ))

        // This is the complicated part to handle the safe area

        // By default, the aboveKeyboardView should be tall enough to fit the text field
        let fill = factory.constrain(.bottom, ofBoth: self.textField, and: self.aboveKeyboardView)
        // Set its priority to low to make it breakable
        fill.priority = .defaultLow
        // More importantly, space should be left at the bottom greater than or equal to the safe area
        factory.add(self.view.safeAreaLayoutGuide.bottomAnchor.constraint(greaterThanOrEqualTo: self.textField.bottomAnchor))

        // -----------------
        // Constrain the aboveKeyboardView view to the bottom of the view above the keyboard
        // -----------------
        self.aboveKeyboardView.translatesAutoresizingMaskIntoConstraints = false

        factory.constrain([.left, .right], ofBoth: self.view!, and: self.aboveKeyboardView)
        self.keyboadConstraintAdjuster.view = self.view
        self.keyboadConstraintAdjuster.constraint = factory.constrain(.bottom, ofBoth: self.view!, and: self.aboveKeyboardView)

        // -----------------
        // Activate all of the constraints
        // -----------------
        factory.activateAll()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        DispatchQueue.main.async {
            // Become first responder on the next main loop
            // to avoid weird presentation animation
            self.textField.becomeFirstResponder()
            let range = self.textField.textRange(
                from: self.textField.endOfDocument,
                to: self.textField.endOfDocument
            )
            self.textField.selectedTextRange = range
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func tapToDismiss() {
        // Resign first responder first to create smoother dismiss animation
        self.textField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
}

extension KeyboardFieldPromptController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.tapToDismiss()
        self.completion(textField.text ?? "")
        return false
    }
}
