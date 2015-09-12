//
//  AutolayoutViewController.swift
//  ImageMasker
//
//  Created by Дмитрий Буканович on 12.09.15.
//  Copyright (c) 2015 Дмитрий Буканович. All rights reserved.
//

import UIKit

class AutolayoutViewController: UIViewController {
    
    @IBOutlet weak var horizontalMaskView: MaskerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageHorizontalShift = UIImage(named: "ocean")
        
        horizontalMaskView.backgroundColor = view.backgroundColor
        horizontalMaskView.image = imageHorizontalShift
        let horizontalSettings = MaskSettings(type : MaskerType.HorisontalShift, padding : 15)
        horizontalMaskView.maskProperties = horizontalSettings
        
        
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "setOffset", userInfo: nil, repeats: true)
        
    }
    
    func setOffset() {
        
        var offset = CGFloat( 1.0 / CGFloat((arc4random_uniform(9) + 1)))
        offset = arc4random_uniform(2) > 0 ? +offset : -offset
        
        
        horizontalMaskView.setContentOffset(offset, animated: true)
        
        offset = CGFloat( 1.0 / CGFloat((arc4random_uniform(9) + 1)))
        offset = arc4random_uniform(2) > 0 ? +offset : -offset
        
    }
    
    
    
}
