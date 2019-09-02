//
//  ViewController.swift
//  KeyboardFieldPrompt
//
//  Created by Andrew J Wagner on 9/1/19.
//  Copyright © 2019 Drewag. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let label = UILabel()

    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let stackView = UIStackView()
        stackView.axis = .vertical

        label.text = "Hello World!"
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0

        let button = UIButton()
        button.setTitle("Edit", for: .normal)
        button.addTarget(self, action: #selector(edit), for: .touchUpInside)
        button.setTitleColor(UIColor.green, for: .normal)

        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(button)

        view.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false

        var factory = ConstraintFactory()
        factory.constrain(.centerX, ofBoth: stackView, and: view)
        factory.constrain([.left,.top], ofBoth: stackView, and: view, by: 80)
        factory.activateAll()

        self.view = view
    }

    @objc func edit() {
        let prompt = KeyboardFieldPromptController()
        self.present(prompt, animated: true, completion: nil)
    }
}

