//
//  RectangleView.swift
//  TemperatureDial
//
//  Created by Rizwan Ahmed on 07/08/2019.
//  Copyright © 2019 Tintash. All rights reserved.
//

import UIKit

@IBDesignable
class RectangleView: UIView {
    @IBOutlet var containerView         : UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initNib()
    }
    
    func initNib() {
        let bundle = Bundle(for: RectangleView.self)
        bundle.loadNibNamed("RectangleView", owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = bounds
        containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        isUserInteractionEnabled = true
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
