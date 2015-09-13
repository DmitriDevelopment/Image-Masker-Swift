//
//  DifSizesViewController.swift
//  ImageMasker
//
//  Created by Дмитрий Буканович on 13.09.15.
//  Copyright (c) 2015 Дмитрий Буканович. All rights reserved.
//

import UIKit

class DifSizesViewController: UIViewController {

    @IBOutlet weak var testMaskerView: MaskerView!
    @IBOutlet weak var maskerWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var maskerHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let imageHorizontalShift = UIImage(named: "bottle")
        
        testMaskerView.backgroundColor = view.backgroundColor
        testMaskerView.image = imageHorizontalShift
    
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "setOffset", userInfo: nil, repeats: true)

    }

    @IBAction func widthBiggerAction(sender: AnyObject) {
        maskerWidthConstraint.constant = 300
        maskerHeightConstraint.constant = 100
   
    }
    
    
    @IBAction func equalAction(sender: AnyObject) {
        
        maskerWidthConstraint.constant = 200
        maskerHeightConstraint.constant = 200

        
    }
    
    
    @IBAction func heightBiggerAction(sender: AnyObject) {
        
        maskerWidthConstraint.constant = 100
        maskerHeightConstraint.constant = 300

        
    }
    
    @IBAction func changeImageAction(sender: AnyObject) {
        let image1 = UIImage(named: "bottle")!
        let image2 = UIImage(named: "ocean")!
        let image3 = UIImage(named: "bottle4")!
        let image4 = UIImage(named: "eathinfire")!
        
        let images = [image1, image2, image3, image4]
        let index = Int(arc4random_uniform(4))
        
        testMaskerView.image = images[index]
        
    }
    
    func setOffset() {
        
        var offset = CGFloat( 1.0 / CGFloat((arc4random_uniform(9) + 1)))
        offset = arc4random_uniform(2) > 0 ? +offset : -offset
        
        
        testMaskerView.setContentOffset(offset, animated: true)
        
    }

    
}

















