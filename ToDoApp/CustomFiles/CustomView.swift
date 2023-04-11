//
//  CustomView.swift
//  Villa
//
//  Created by Umair Tanveer on 29/01/2021.
//

import UIKit

@IBDesignable class CustomView: UIView {
    
    @IBInspectable var cornarRadius:CGFloat = 0.0 {
        
        didSet {
            layer.cornerRadius = cornarRadius
            layer.masksToBounds = cornarRadius > 0
        }
        
    }
    
//    @IBInspectable var cornerRadius: CGFloat = 0 {
//            didSet {
//                layer.cornerRadius = cornerRadius
//                layer.masksToBounds = cornerRadius > 0
//            }
//        }
    
    var dashBorder: CAShapeLayer?
    @IBInspectable var dashWidth: CGFloat = 0
    @IBInspectable var dashColor: UIColor = .clear
    @IBInspectable var dashLength: CGFloat = 0
    @IBInspectable var betweenDashesSpace: CGFloat = 0

        

    @IBInspectable var borderWidth:CGFloat = 0.0 {
        
        didSet {
            layer.borderWidth = borderWidth
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var isCircle:Bool = false {
        
        didSet {
            if isCircle {
                layer.cornerRadius  = self.frame.size.width/2
            }else{
                layer.cornerRadius = cornarRadius
            }
        }
    }
    
    @IBInspectable var isOval:Bool = false {
        
        didSet {
            if isOval {
                layer.cornerRadius  = self.frame.size.height/2
            }else{
                layer.cornerRadius = cornarRadius
            }
        }
    }
    
    @IBInspectable var isClipToBound:Bool = false {
        
        didSet {
            if isClipToBound {
                self.clipsToBounds = true
            }else{
                self.clipsToBounds = false
            }
        }
    }
    
    @IBInspectable var borderColor:UIColor = UIColor.lightGray {
        
        didSet {
            layer.borderColor = borderColor.cgColor
            if borderWidth == 0 {borderWidth = 1.0}
        }
    }
    
    @IBInspectable var shadowColor: UIColor = UIColor.clear {
        
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize.zero {
        
        didSet {
            layer.shadowOffset = shadowOffset
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0.5 {
        
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    
    @IBInspectable var shadowRadius: CGFloat = 5.0 {
        
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var layerOpacity : Float = 0 {
        didSet{
            self.layer.opacity = layerOpacity
        }
    }
    
    override var frame: CGRect {
        didSet {
            if isCircle {
                layer.cornerRadius  = self.frame.size.width/2
            }else{
                layer.cornerRadius = cornarRadius
            }
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isCircle {
            layer.cornerRadius  = self.frame.size.width/2
        }else{
            layer.cornerRadius = cornarRadius
        }
        
        if isOval {
            layer.cornerRadius  = self.frame.size.height/2
        }else{
            layer.cornerRadius = cornarRadius
        }
        
        self.layer.masksToBounds = false
        
        dashBorder?.removeFromSuperlayer()
        let dashBorder = CAShapeLayer()
        dashBorder.lineWidth = dashWidth
        dashBorder.strokeColor = dashColor.cgColor
        dashBorder.lineDashPattern = [dashLength, betweenDashesSpace] as [NSNumber]
        dashBorder.frame = bounds
        dashBorder.fillColor = nil
        if cornarRadius > 0 {
            dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornarRadius).cgPath
        } else {
            dashBorder.path = UIBezierPath(rect: bounds).cgPath
        }
        layer.addSublayer(dashBorder)
        self.dashBorder = dashBorder
        
        
    }
    
    func getImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: false)
        let snapshotImageFromMyView = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshotImageFromMyView!
    }
    
}
