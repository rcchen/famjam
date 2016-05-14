//
//  String.swift
//  FamJam
//
//  Created by Roger Chen on 5/11/16.
//  Copyright © 2016 Famjam. All rights reserved.
//

import CoreGraphics
import Foundation
import UIKit

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.max)
        
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
}
