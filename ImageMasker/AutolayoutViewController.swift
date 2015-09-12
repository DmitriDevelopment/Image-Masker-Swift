//
//  AutolayoutViewController.swift
//  ImageMasker
//
//  Created by Дмитрий Буканович on 12.09.15.
//  Copyright (c) 2015 Дмитрий Буканович. All rights reserved.
//

import UIKit

class AutolayoutViewController: UIViewController {
    
    @IBOutlet weak var changedMaskView: MaskerView!
    @IBOutlet weak var horizontalMaskView: MaskerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageHorizontalShift = UIImage(named: "ocean")
        
        horizontalMaskView.backgroundColor = view.backgroundColor
        horizontalMaskView.image = imageHorizontalShift
        
        let imageRotate = UIImage(named: "eathinfire")
        changedMaskView.backgroundColor = view.backgroundColor
        changedMaskView.maskPadding = 1
        changedMaskView.image = imageRotate
        
        // Create custom path to "key-hole"
        changedMaskView.customKeyHolePath = {(frame : CGRect) in
            let radius = frame.height < frame.width ? (frame.height / 2) - 7 : (frame.width / 2) - 7
            let centerPoint1 = CGPointMake(frame.width / 2, frame.height / 2 - 5)
            let centerPoint2 = CGPointMake(frame.width / 2, frame.height / 2 + 5)
            let circlePath = UIBezierPath(arcCenter: centerPoint1,
                radius: radius,
                startAngle: CGFloat(-M_PI),
                endAngle: CGFloat(0),
                clockwise: true)
            circlePath.closePath()
            circlePath.moveToPoint(CGPointMake(centerPoint1.x, centerPoint1.y + 10))
            circlePath.addArcWithCenter(centerPoint2,
                radius: radius,
                startAngle: 0, endAngle: CGFloat(M_PI), clockwise: true)
            circlePath.closePath()

            return circlePath
        }
    
        
        
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "setOffset", userInfo: nil, repeats: true)
        
    }
    
    func setOffset() {
        
        var offset = CGFloat( 1.0 / CGFloat((arc4random_uniform(9) + 1)))
        offset = arc4random_uniform(2) > 0 ? +offset : -offset
        
        
        horizontalMaskView.setContentOffset(offset, animated: true)
        
        offset = CGFloat( 1.0 / CGFloat((arc4random_uniform(9) + 1)))
        offset = arc4random_uniform(2) > 0 ? +offset : -offset
        
        // create custom image moving
        changedMaskView.customImageTransform = {(viewBounds: CGRect, imageFrame : CGRect) in
            let translateTransform = CATransform3DMakeTranslation(((imageFrame.height - viewBounds.size.height) / 2) * offset, 0, 0)
            let angle = CGFloat(M_PI) * offset
            let rotationTransform = CATransform3DMakeRotation(angle, 0, 0, 1)
            let transform = CATransform3DConcat(translateTransform, rotationTransform)
            
            
            return transform
        }
        
        //        changedMaskView.setContentOffset(offset, animated: true)
        
    }
    
    
    
}












