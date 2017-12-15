//
//  GradientView.swift
//  MediaOrganizer
//
//  Created by Carlos De la mora on 12/12/17.
//  Copyright © 2017 carlosdelamora. All rights reserved.
//

import Foundation
import UIKit

class GradientView: UIView{
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        backgroundColor = Constants.colors.gold
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    /*override func draw(_ rect: CGRect) {
        let goldComponents = Constants.colors.gold.cgColor.components!
        let purpleGrayComponents = Constants.colors.purpleGray.cgColor.components!
        let components: [CGFloat] = [goldComponents[0],goldComponents[1],goldComponents[2],1,purpleGrayComponents[0],purpleGrayComponents[1],purpleGrayComponents[2],1]
        let locations: [CGFloat] = [0,1]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorSpace: colorSpace, colorComponents: components, locations: locations, count: 2)
        
        let x = bounds.midX
        let y = bounds.midY - 50
        let centerPoint = CGPoint(x: x, y: y)
        let radius = max(x,y)
        
        let context = UIGraphicsGetCurrentContext()
        context?.drawRadialGradient(gradient!, startCenter: centerPoint, startRadius: 0, endCenter: centerPoint, endRadius: radius, options: .drawsAfterEndLocation)
        
    }*/
    
    
}
