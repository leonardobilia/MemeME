//
//  UITextField+Ext.swift
//  MemeME
//
//  Created by Leonardo Bilia on 1/14/19.
//  Copyright © 2019 Leonardo Bilia. All rights reserved.
//

import UIKit

extension UITextField {
    
    func setBottomBorder() {
        self.borderStyle = UITextField.BorderStyle.none
        self.backgroundColor = UIColor.clear
        
        let borderLine = UIView()
        borderLine.frame = CGRect(x: 0, y: self.frame.height + 16, width: self.frame.width, height: 0.5)
        borderLine.backgroundColor = UIColor.white
        self.addSubview(borderLine)
    }
}
