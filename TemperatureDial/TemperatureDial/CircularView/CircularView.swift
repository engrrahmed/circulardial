//
//  CircularView.swift
//  TemperatureDial
//
//  Created by Rizwan Ahmed on 07/08/2019.
//  Copyright © 2019 Tintash. All rights reserved.
//

import UIKit

let pi = CGFloat(Double.pi)

@IBDesignable
class CircularView: UIView {
    
    
    
    //start angle: where we need to start the reading scale
    //Stop angle: where we need to start the reading scale
    @IBInspectable var startAngle           :CGFloat    = 0.0
    @IBInspectable var stopAngle            :CGFloat    = 2.0 * pi
    //total number of the calibrition lines need to add in between start and stop angle
    @IBInspectable var numberOfOuterLines   :Int        = 60
    // margin from the UIview bounds
    @IBInspectable var margin               :CGFloat    = 20.0
    //line width of the tick
    @IBInspectable var lineWidth            :CGFloat    = 2.0
    //line height of the tick
    @IBInspectable var lineHeight            :CGFloat    = 20.0
    
    //TODO: addded for testing purpose only
    let colors:[UIColor] = [.red, .green, .blue, .red, .green, .blue, .red, .green, .blue,  .red, .green, .blue]
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        let context = UIGraphicsGetCurrentContext()
        let diameter = min(bounds.width, bounds.height)
        let circle = UIBezierPath(ovalIn: CGRect(x: 0 , y: 0,
                                                 width: diameter,
                                                 height: diameter
            ).insetBy(dx: margin * 1.5, dy: margin * 1.5))
        let transform = CGAffineTransform(translationX: bounds.width/2 - diameter/2 ,y: bounds.height/2 - diameter/2)        
        circle.apply(transform)
        //        UIColor.yellow.setFill()
        //        circle.fill()
        UIColor.black.setStroke()
        circle.stroke()
        addGuageLines(context: context)
    }
    
    
    func addGuageLines(context : CGContext?) {
        
        let diameter = min(bounds.width, bounds.height)
        let centerPoint = center
        context?.saveGState()
        for index in 0..<numberOfOuterLines {
            
            let percent = CGFloat(CGFloat(index)/CGFloat(numberOfOuterLines))
            let angle = (percent * 2 * pi)
            let colorIndex = index % 12
            let radius = diameter / 2 - margin
            
            print ("Percentage of index,percent, pi, degree \(index), \(percent), \(angle), \(angle * 57.2958 ), \(colorIndex)")
            //            colors[colorIndex].setFill()
            UIColor.black.setFill()
            let guageTickPath = UIBezierPath(rect: CGRect(x: centerPoint.x,
                                                          y:centerPoint.y,
                                                          width: lineWidth,
                                                          height: lineHeight
            ))
            let transform = CGAffineTransform(translationX: bounds.width/2 - diameter/2 ,y: bounds.height/2 - diameter/2)
            guageTickPath.apply(transform)
            
            context?.translateBy(x: centerPoint.x, y: centerPoint.y)
            context?.rotate(by: angle)
            context?.translateBy(x: -centerPoint.x, y: -centerPoint.y)
            guageTickPath.fill()
            
            context?.restoreGState()
            context?.saveGState()
        }
        context?.restoreGState()
    }
    
}
