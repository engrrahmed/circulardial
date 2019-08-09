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
    
    // MARK:- Class variable
    //start angle: where we need to start the reading scale
    //Stop angle: where we need to start the reading scale
    @IBInspectable var startAngle           :CGFloat    = 0.0
    @IBInspectable var stopAngle            :CGFloat    = 2.0 * pi
    //total number of the calibrition lines need to add in between start and stop angle
    @IBInspectable var numberOfOuterLines   :Int        = 12
    // margin from the UIview bounds
    @IBInspectable var margin               :CGFloat    = 30.0
    //line width of the tick
    @IBInspectable var markWidth            :CGFloat    = 2.0
    //line height of the tick
    @IBInspectable var markLength           :CGFloat    = 20.0
    
    // pointing to current value of the guage
    var currentValueMarkIndex               :Int        = 10 //0
    var baseValueMarkIndex                  :Int        {
        get {
            return numberOfOuterLines / 2
        }
    }
    //tempdial related variables
    var markIndexOfLightColor               :Int        = 0
    var alphaValueForLightMark              :CGFloat    = 0.4
    
    
    var textMargin                          :CGFloat    = 4.0
    //TODO: added for testing purpose only
    let colors:[UIColor] = [.red, .green, .blue, .red, .green, .blue, .red, .green, .blue,  .red, .green, .blue]
    

    // MARK:- UIView draw method
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let context = UIGraphicsGetCurrentContext()
        //Added outer circle for testing purpose only
        addOuterCircle(rect: rect)
        
        //DialRect: in which dial needs to be drawn and keeping margin from the outer bound of the view.
        let dialRect = rect.insetBy(dx: margin * 1.5, dy: margin * 1.5)
        addOuterCircle(rect: dialRect)
        //created mark tick from Line using UIBezierPath
        addOuterLines(rect: dialRect, context: context)
        //created mark tick from rect using UIBezierPath
        //        addGuageLines(context: context, rect: dialRect)
    }
    
}



// MARK:-  Drawing methods
extension CircularView {
    // MARK:- Create outer circle of the dial
    func addOuterCircle (rect: CGRect) {
        let diameter = min(rect.width, rect.height)
        let circle = UIBezierPath(ovalIn: CGRect(x: 0 , y: 0,
                                                 width: diameter,
                                                 height: diameter
        ))
        let transform = CGAffineTransform(translationX: bounds.width/2 - diameter/2 ,y: bounds.height/2 - diameter/2)
        circle.apply(transform)
        /* If need to set the guage filling color
         UIColor.yellow.setFill()
         circle.fill()
         */
        UIColor.black.setStroke()
        circle.stroke()
    }
    
    // MARK:- Create text on the mark tick
    
    func drawText(name: String, centerPoint:CGPoint, radius:CGFloat, angle:CGFloat) {
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        context?.translateBy(x: centerPoint.x, y: centerPoint.y)
        context?.rotate(by: angle)
        context?.translateBy(x: -centerPoint.x, y: -centerPoint.y)
        
        let font = UIFont(name: "HelveticaNeue-Bold", size: 16)!
        let attributes = [NSAttributedString.Key.font: font,
                          NSAttributedString.Key.foregroundColor: UIColor.black]
        let textBounds = name.size(withAttributes: attributes)
        let transform = context?.ctm
        let radians = atan2(transform!.b, transform!.a)
        print("radian: \(radians) abs: \(abs(radians)) index: \(name) angle : \(angle)")
        if abs(radians) > pi / 2 && abs(radians) < 3 / 2 * pi {
            context?.saveGState()
            context?.rotate(by: pi)
            
            name.draw(at: CGPoint(x:-centerPoint.x - radius - textBounds.width , y:-centerPoint.y  - textBounds.height / 2), withAttributes:attributes)
            context?.restoreGState()
        } else {
            name.draw(at: CGPoint(x:centerPoint.x + radius, y:centerPoint.y - textBounds.height / 2), withAttributes:attributes)
        }
        context?.restoreGState()
    }
    
    // MARK:- Create mark tick using line
    func addOuterLines(rect: CGRect, context : CGContext?) {
        
        let centerPoint = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let diameter = min(rect.width, rect.height)
        let radius = diameter / 2
        
        for index in 0..<numberOfOuterLines {
            
            var lineWidth   : CGFloat = markWidth
            var lineLength  : CGFloat = markLength
            
            if index == baseValueMarkIndex  || index == currentValueMarkIndex {
                lineWidth = 4.0
            }
            
            if index == currentValueMarkIndex {
                lineLength = markLength * 1.6
            }
            
            let percent = CGFloat(CGFloat(index )/CGFloat(numberOfOuterLines))
            let angle = (percent * 2 * pi)
            
            let path = UIBezierPath()
            path.lineWidth = lineWidth
            
            let starPoint = CGPoint(x: -lineLength / 2, y: 0)
            let endPoint = CGPoint(x: lineLength / 2 , y: 0)
            path.move(to: endPoint)
            path.addLine(to: starPoint)
            
            
            let transform = CGAffineTransform(translationX: radius, y: 0)
            path.apply(transform)
            path.lineCapStyle = .round
            //            UIColor.red.setStroke()
            let colorIndex = index % 12
            UIColor.black.setStroke()
//            colors[colorIndex].setStroke()
            
            context?.saveGState()
            //            context?.translateBy(x: centerPoint.x - lineLength  / 2 * cos(angle) * 0 , y: centerPoint.y - lineLength / 2 * sin(angle)  * 0)
            context?.translateBy(x: centerPoint.x, y: centerPoint.y)
            context?.rotate(by: angle)
            path.stroke()
            context?.restoreGState()
            drawText(name: "\(index)", centerPoint: centerPoint, radius:radius  + lineLength / 2 + textMargin, angle:angle)
        }
    }
}

// MARK:- Create mark tick using rect
extension CircularView  {
    func addGuageLines(context : CGContext?, rect: CGRect) {
        let diameter = min(rect.width, rect.height)
        let centerPoint = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        context?.saveGState()
        for index in 0..<numberOfOuterLines {
            
            let percent = CGFloat(CGFloat(index)/CGFloat(numberOfOuterLines))
            let angle = (percent * 2 * pi)
            let colorIndex = index % 12
            let radius = diameter / 2
            
            print ("Percentage of index,percent, pi, degree \(index), \(percent), \(angle), \(angle * 57.2958 ), \(colorIndex)")
            //            colors[colorIndex].setFill()
            UIColor.black.setFill()
            var lineWidth = markWidth
            if index == baseValueMarkIndex ||  index == currentValueMarkIndex{
                lineWidth  = markWidth * 2
            }
            let lineLength = (index == currentValueMarkIndex) ? markLength * 1.5 : markLength
            let markYpos = (index == currentValueMarkIndex) ? centerPoint.y -  markLength / 4 : centerPoint.y
            let guageTickPath = UIBezierPath(rect: CGRect(x:        centerPoint.x,
                                                          y:        markYpos,
                                                          width:    lineLength,
                                                          height:   lineWidth
            ))
            let transform = CGAffineTransform(translationX: radius  - lineLength / 2,y: radius * 0 )
            guageTickPath.apply(transform)
            context?.saveGState()
            context?.translateBy(x: centerPoint.x, y: centerPoint.y)
            context?.rotate(by: angle)
            context?.translateBy(x: -centerPoint.x, y: -centerPoint.y)
            let markAlphaValue:CGFloat = (index < markIndexOfLightColor) ?  alphaValueForLightMark : 1.0
            guageTickPath.fill(with: .xor, alpha: markAlphaValue)
            
            context?.restoreGState()
            
            drawText(name: "\(index)", centerPoint: centerPoint, radius: radius  + lineLength / 2 + textMargin, angle:angle)
        }
        context?.restoreGState()
    }
}
