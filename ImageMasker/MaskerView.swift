//
//  ImageMaskerView.swift
//  ImageMasker
//
//  Created by Дмитрий Буканович on 12.09.15.
//  Copyright (c) 2015 Дмитрий Буканович. All rights reserved.
//

import UIKit

enum MaskerType {
    case HorisontalShift, VerticalShift, Rotation
}

struct MaskSettings {
    let type : MaskerType
    let padding : CGFloat
}

class MaskerView: UIView {

    // Layers
    private var mask : CAShapeLayer!
    private var maskLayer : CALayer!
    private var contentLayer : CALayer!
    
    // Mask Properties
    
    
    private var contentAspectRatio : CGFloat  = 2
    private var viewAspectRation : CGFloat = 1
    
    /**
    Mask properties.Set to change behavior
    
    type : MaskerType
    
    * HorisontalShift - content shifting horizontally
    * VerticalShift - content shifting vertically
    * Rotation - content rotate around Z - axis
    
    padding : CGFloat
    
    Mask padding of Parent Layer's border

    */
    var maskProperties : MaskSettings! {
        didSet {
            self.type = maskProperties.type
            self.maskPadding = maskProperties.padding
            self.calculateContentAspectRatio()
            self.setupMask()
            self.setupSublayersLayout()

        }
    }
    
    private var type : MaskerType = .HorisontalShift
    private var maskPadding : CGFloat = 20
    
    /**
    Content image property
    
    */
    var image : UIImage! {
        didSet {
            contentLayer.contents = image.CGImage
            self.calculateContentAspectRatio()
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
        backgroundColor = UIColor.blueColor()
        
        self.setupMaskLayer()
        self.setupContentLayer()
        self.setupMask()
        
        maskLayer.addSublayer(contentLayer)
        
        self.layer.addSublayer(maskLayer)
        
        
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if let backgroundColor = self.superview?.backgroundColor {
            self.backgroundColor = backgroundColor
        }
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

        
    }
    
    private func setupMask() {
        
        mask = CAShapeLayer(layer: layer)
        mask.frame = self.bounds
        
        switch self.type {
        case .HorisontalShift, .VerticalShift:
            mask.path = UIBezierPath(rect: CGRectInset(self.bounds, maskPadding, maskPadding)).CGPath
        case .Rotation:
            let circlePath = UIBezierPath(arcCenter: mask.position,
                radius: (mask.bounds.height / 2) - maskPadding,
                startAngle: CGFloat(-M_PI),
                endAngle: CGFloat(0),
                clockwise: true)
            circlePath.closePath()
            
            mask.path = circlePath.CGPath
        }
        
        mask.fillColor = UIColor.blackColor().CGColor
        maskLayer.mask = mask
        
    }
    
    // Layouts
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupSublayersLayout()
        
    }

    
    
    private func setupSublayersLayout() {
        
        viewAspectRation = (type == .HorisontalShift) ? bounds.height / bounds.width : bounds.width / bounds.height

        var contentFrame = self.bounds
        switch self.type {
        case .HorisontalShift:
            let deltaXValue = contentAspectRatio == 1 ? 0 : (-(contentFrame.width / 2) * (contentAspectRatio / 2) * viewAspectRation)
            contentFrame = CGRectInset(contentFrame, deltaXValue, 0)
        case .VerticalShift:
            let deltaYValue = contentAspectRatio == 1 ? 0 : (-(contentFrame.height / 2) * (contentAspectRatio / 2) * viewAspectRation)
            contentFrame = CGRectInset(contentFrame, 0, deltaYValue)
        case .Rotation:
            break
        }
        
        contentLayer.transform = CATransform3DIdentity
        contentLayer.frame = contentFrame
        maskLayer.frame = self.bounds
        mask.frame = self.bounds
        
        
    }
    
    private func calculateContentAspectRatio() {
        if let image = self.image {
            switch self.type {
            case .HorisontalShift:
                contentAspectRatio = (image.size.width / image.size.height > 1) ? image.size.width / image.size.height : 1
            case .VerticalShift:
                contentAspectRatio =  (image.size.height / image.size.width > 1) ? image.size.height / image.size.width : 1
            case .Rotation:
                break
            }
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
            transformMatrix = CATransform3DMakeTranslation((self.bounds.size.width / 2) * (contentAspectRatio / 2) * offset * viewAspectRation, 0, 0)
            transformMatrix = contentAspectRatio == 1 ? CATransform3DIdentity : transformMatrix
        case .VerticalShift:
            transformMatrix = CATransform3DMakeTranslation(0, (self.bounds.size.height / 2) * (contentAspectRatio / 2) * offset * viewAspectRation, 0)
            transformMatrix = contentAspectRatio == 1 ? CATransform3DIdentity : transformMatrix
        case .Rotation:
            let angle = CGFloat(M_PI) * offset
            transformMatrix = CATransform3DMakeRotation(angle, 0, 0, 1)
        }
        
        contentLayer.transform = transformMatrix
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    




}
