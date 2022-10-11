//
//  RoundedView.swift
//  GPA Calculator
//
//  Created by Spencer Kinsey-Korzym on 2/8/22.
//

import UIKit

@IBDesignable public class RoundedView: UIView {

    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 2.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

}
