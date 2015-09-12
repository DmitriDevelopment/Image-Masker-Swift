//
//  ViewController.swift
//  ImageMasker
//
//  Created by Дмитрий Буканович on 12.09.15.
//  Copyright (c) 2015 Дмитрий Буканович. All rights reserved.
//

import UIKit

class FrameViewController: UIViewController {
    
    var rotationMasker : MaskerView!
    var horizontalMasker : MaskerView!
    var verticalMasker : MaskerView!
    var vertical4Masker : MaskerView!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageRotate = UIImage(named: "eathinfire")

        rotationMasker = MaskerView(frame: CGRectMake(self.view.bounds.width / 2, 20, self.view.bounds.width / 2, self.view.bounds.width / 2))
        rotationMasker.image = imageRotate
        let rotationSettings = MaskSettings(type : MaskerType.Rotation, padding : 1)
        rotationMasker.maskProperties = rotationSettings
        view.addSubview(rotationMasker)
    
        
        let imageHorizontalShift = UIImage(named: "ocean")
        
        horizontalMasker = MaskerView(frame: CGRectMake(self.view.bounds.width / 2, self.view.bounds.width / 2, self.view.bounds.width / 2, self.view.bounds.width / 2))
        horizontalMasker.image = imageHorizontalShift
        let horizontalSettings = MaskSettings(type : MaskerType.HorisontalShift, padding : 1)
        horizontalMasker.maskProperties = horizontalSettings
        view.addSubview(horizontalMasker)
        
        let imageVerticalShift = UIImage(named: "bottle")
        
        verticalMasker = MaskerView(frame: CGRectMake(0, 20, self.view.bounds.width / 2, self.view.bounds.width / 2))
        verticalMasker.image = imageVerticalShift
        let verticalSettings = MaskSettings(type : MaskerType.VerticalShift, padding : 1)
        verticalMasker.maskProperties = verticalSettings
        view.addSubview(verticalMasker)
        
        let image4VerticalShift = UIImage(named: "bottle4")
        
        vertical4Masker = MaskerView(frame: CGRectMake(0, self.view.bounds.width / 2 + 20, self.view.bounds.width / 2, self.view.bounds.width / 2 * 1.5))
        vertical4Masker.image = image4VerticalShift
        vertical4Masker.maskProperties = verticalSettings
        view.addSubview(vertical4Masker)



        let timer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "setOffset", userInfo: nil, repeats: true)

    
    }

    func setOffset() {
        
        var offset = CGFloat( 1.0 / CGFloat((arc4random_uniform(9) + 1)))
        offset = arc4random_uniform(2) > 0 ? +offset : -offset

        
        rotationMasker.setContentOffset(offset, animated: true)
        
        offset = CGFloat( 1.0 / CGFloat((arc4random_uniform(9) + 1)))
        offset = arc4random_uniform(2) > 0 ? +offset : -offset
        
        horizontalMasker.setContentOffset(offset, animated: true)
        
        offset = CGFloat( 1.0 / CGFloat((arc4random_uniform(9) + 1)))
        offset = arc4random_uniform(2) > 0 ? +offset : -offset
        
        verticalMasker.setContentOffset(offset, animated: true)
        
        offset = CGFloat( 1.0 / CGFloat((arc4random_uniform(9) + 1)))
        offset = arc4random_uniform(2) > 0 ? +offset : -offset
        
        vertical4Masker.setContentOffset(offset, animated: true)

        
                
    }
    @IBAction func tap(sender: AnyObject) {
        
        horizontalMasker.frame = CGRectMake(self.view.bounds.width / 2, self.view.bounds.width / 2, self.view.bounds.width / 2, self.view.bounds.width / 4)
        
    }
    
}













