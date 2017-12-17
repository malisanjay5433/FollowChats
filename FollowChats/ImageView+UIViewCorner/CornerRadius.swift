//
//  CornerRadius.swift
//  FollowChats
//
//  Created by Sanjay Mali on 16/12/17.
//  Copyright © 2017 Sanjay Mali. All rights reserved.
//

import UIKit

class CornerRadius: UIView {
        @IBInspectable
        var cornerRadius: CGFloat {
            get {
                return layer.cornerRadius
            }
            set {
                layer.cornerRadius = newValue
                layer.masksToBounds = newValue > 0
            }
        }
        
        @IBInspectable
        var borderWidth: CGFloat {
            get {
                return layer.borderWidth
            }
            set {
                layer.borderWidth = newValue
            }
        }
        
        @IBInspectable
        var borderColor: UIColor? {
            get {
                let color = UIColor.init(cgColor:layer.borderColor!)
                return color
            }
            set {
                layer.borderColor = newValue?.cgColor
            }
        }
        
        @IBInspectable
        var shadowRadius: CGFloat {
            get {
                return layer.shadowRadius
            }
            set {
                layer.shadowColor = UIColor.black.cgColor
                layer.shadowOffset = CGSize(width: 0, height: 2)
                layer.shadowOpacity = 0.4
                layer.shadowRadius = shadowRadius
            }
        }
        
}
