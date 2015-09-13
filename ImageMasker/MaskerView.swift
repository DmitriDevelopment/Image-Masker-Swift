//
//  ImageMaskerView.swift
//  ImageMasker
//
//  Created by Дмитрий Буканович on 12.09.15.
//  Copyright (c) 2015 Дмитрий Буканович. All rights reserved.
//
import AVFoundation
import UIKit

enum MaskerType {
    case HorisontalShift, VerticalShift, Rotation
}


class MaskerView: UIView {

    // Layers
    private var mask : CAShapeLayer!
    private var maskLayer : CALayer!
    private var contentLayer : CALayer!
    
    
    /**
    Custom BezierPath. If not nill then this path will be used in "key-hole drawing"
    */
    var customKeyHolePath : ((frame : CGRect) -> UIBezierPath)!
    
    /**
    Custom Transform. If not nill then this transform will be used in image moving under "key-hole"
    */
    var customImageTransform : ((viewBounds : CGRect, imageFrame : CGRect) -> CATransform3D)! {
        didSet {
            contentLayer.transform = self.customImageTransform(viewBounds: self.bounds,imageFrame : self.contentLayer.frame)
        }
    }
    
    /**
    This property automatically define type by size properties of View and Image 
    
    default = true
    
    :Rules:
    
    * contentAspectRatio >= 1 and contentAspectRatio > viewAspectRation => type = .HorisontalShift
    
    * contentAspectRatio < 1 and contentAspectRatio > viewAspectRation => type = .VerticalShift
    
    * contentAspectRatio > 1 and contentAspectRatio < viewAspectRation => type = .HorisontalShift
    
    * contentAspectRatio <= 1 and contentAspectRatio < viewAspectRation => type = .VerticalShift
    
    * contentAspectRatio == 1 and contentAspectRatio == viewAspectRation => type = .Rotation

    */
    var autoType : Bool = true
    
    
    
    /**
    This property directionally defined type if autoType == false
    default = .HorisontalShift
    */
    var type : MaskerType = .HorisontalShift
    
    /**
    Property for padding from border of View to "key-hole"
    default = 10
    */
    var maskPadding : CGFloat = 10
    
    /**
    Content image property
    */
    var image : UIImage! {
        didSet {
            contentLayer.contents = image.CGImage
            self.setupSublayersLayout()
        }
    }
    
    
    // Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayers()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupLayers()
    }
    
    
    private func setupLayers() {
        self.clipsToBounds = true
        
        self.setupMaskLayer()
        self.setupContentLayer()
        
        maskLayer.addSublayer(contentLayer)
        
        self.layer.addSublayer(maskLayer)
        
        
    }
    
    
    // Layer setup
    
    
    private func setupContentLayer() {
        
        contentLayer = CALayer(layer: self.layer)
        contentLayer.contentsScale = UIScreen.mainScreen().scale
        contentLayer.contentsGravity = "resize"

        
    }
    
    
    private func setupMaskLayer() {
        
        maskLayer = CALayer()
        maskLayer.backgroundColor = UIColor.blackColor().CGColor
        
        mask = CAShapeLayer(layer: layer)
        mask.frame = self.bounds
        
        mask.fillColor = UIColor.blackColor().CGColor
        maskLayer.mask = mask


        
    }
    
    
    private func setPathToMask() {
        
        var newPath = UIBezierPath()
        switch self.type {
        case .HorisontalShift, .VerticalShift:
            newPath = UIBezierPath(rect: CGRectInset(self.bounds, maskPadding, maskPadding))
        case .Rotation:
            let radius = min(frame.height, frame.width) / 2
            newPath = UIBezierPath(arcCenter: mask.position,
                radius: radius - maskPadding,
                startAngle: CGFloat(-M_PI),
                endAngle: CGFloat(0),
                clockwise: true)
            newPath.closePath()
            
            
        }
        mask.path =  self.customKeyHolePath != nil ? self.customKeyHolePath(frame :self.bounds).CGPath : newPath.CGPath
    }
    
    
    // Layouts
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupSublayersLayout()
        
    }

    
    
    private func setupSublayersLayout() {
        
        let viewAspectRatio = bounds.width / bounds.height
        var contentAspectRatio : CGFloat = 1.0
        if let image = self.image {
            contentAspectRatio = CGFloat(image.size.width / image.size.height)
        }
        
        if autoType {
            self.automaticDefineTypeBy(contentAspectRatio, and: viewAspectRatio)
        }
        

        var contentFrame = self.bounds
        switch self.type {
        case .HorisontalShift:

            let frameWidth =  contentAspectRatio * (1 / viewAspectRatio) > 1 ? contentFrame.width * contentAspectRatio * (1 / viewAspectRatio) : contentFrame.width
            contentFrame = CGRectMake(-(frameWidth - contentFrame.width) / 2, 0, frameWidth, contentFrame.height)

        case .VerticalShift:
            let frameHeight =  (1 / contentAspectRatio) * viewAspectRatio > 1 ? contentFrame.height * (1 / contentAspectRatio) * viewAspectRatio : contentFrame.height
            contentFrame = CGRectMake(0, -(frameHeight - contentFrame.height) / 2, contentFrame.width, frameHeight)
            
        case .Rotation:
            break
        }
        
        
        
        contentLayer?.transform = CATransform3DIdentity
        contentLayer?.frame = contentFrame
        maskLayer?.frame = self.bounds
        mask?.frame = self.bounds
        
        setPathToMask()
        
    }
    
    private func automaticDefineTypeBy(contentAspectRatio : CGFloat, and viewAspectRatio : CGFloat) {
        
        if contentAspectRatio >= 1 && contentAspectRatio > viewAspectRatio {
            self.type = .HorisontalShift
        } else
            if contentAspectRatio < 1 && contentAspectRatio > viewAspectRatio {
                self.type = .VerticalShift
            } else
                if contentAspectRatio > 1 && contentAspectRatio < viewAspectRatio {
                    self.type = .HorisontalShift
                } else
                    if contentAspectRatio <= 1 && contentAspectRatio < viewAspectRatio {
                        self.type = .VerticalShift
                    } else
                        if contentAspectRatio == 1 && contentAspectRatio == viewAspectRatio {
                            self.type = .Rotation
        }

        
    }
    
    
    
    // Animation
    
    /**
    Set content's offset from Parent Layer

    :param: offset Value between -1.0 and 1.0
    :param: animated If true content set new position with implicit animation, 
            if false implicit animation are disable
    
    */

    func setContentOffset(offset : CGFloat, animated : Bool) {
        var clearOffset = offset >= 0 ? min(offset, 1) : max(offset, -1)
        
        if animated {
            self.setContentOffset(clearOffset)
        } else {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            self.setContentOffset(clearOffset)
            CATransaction.commit()
        }
    }
    
    
    private func setContentOffset(offset : CGFloat) {
        var transformMatrix = CATransform3D()

        
        switch self.type {
        case .HorisontalShift:
            transformMatrix = CATransform3DMakeTranslation((self.contentLayer.frame.width - self.bounds.size.width) / 2 * offset, 0, 0)
        case .VerticalShift:
            transformMatrix = CATransform3DMakeTranslation(0, ((self.contentLayer.frame.height - self.bounds.size.height) / 2) * offset, 0)
        case .Rotation:
            let angle = CGFloat(M_PI) * offset
            transformMatrix = CATransform3DMakeRotation(angle, 0, 0, 1)
        }
        
        contentLayer.transform =  transformMatrix
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    




}
