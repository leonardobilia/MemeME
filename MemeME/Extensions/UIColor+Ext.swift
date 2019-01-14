//
//  UIColor+Ext.swift
//  MemeME
//
//  Created by Leonardo Bilia on 1/14/19.
//  Copyright © 2019 Leonardo Bilia. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a:CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
    
    static let appBaseDark = UIColor(r: 32, g: 36, b: 45, a: 1)
    static let appBaseLight = UIColor(r: 43, g: 49, b: 62, a: 1)
}
