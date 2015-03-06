//
//  ViewController.swift
//  NervousCat
//
//  Created by 韦体东 on 15/3/1.
//  Copyright (c) 2015年 韦体东. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    /*var  mats = [[UIButton]]()
    var  cat:UIImageView  = UIImageView(frame: CGRectMake(CGFloat(20 + 28*4 + 14), CGFloat(170 + 28*3), 28, 56))
    
    func matChange(sender: UIButton) {
        sender.setImage(UIImage(named: (0 == sender.tag) ? "yellow2.png" : "gray.png"), forState: .Normal)
        sender.tag = (0 == sender.tag) ? 1 : 0
    }
    
    func createMat() {
        for var row = 0; row < 9; ++row {
            var rowmats = [UIButton]()
            for var col = 0; col < 9; ++col {
                var colmat = UIButton(frame: CGRectMake(CGFloat(20 + 28*col + ((0==(row%2)) ? 14 : 0)), CGFloat(170 + 28*row), 28, 28))
                colmat.setImage(UIImage(named: "gray.png"), forState: .Normal)
                colmat.addTarget(self, action: "matChange:", forControlEvents: UIControlEvents.TouchUpInside)
                colmat.tag = 0
                rowmats.append(colmat)
                
                self.view.addSubview(colmat)
            }
            mats.append(rowmats)
        }
    }
    
    func createCat() {
        var left = UIImage(named: "left2.png")
        var middle = UIImage(named: "middle2.png")
        var right = UIImage(named: "right2.png")
        //cat.animationImages = [left as AnyObject, middle as AnyObject, right as AnyObject]
        /*var images = Array<UIImage>()
        images.append(left!)
        images.append(middle!)
        images.append(right!)
        cat.animationImages = images*/
        
        cat.animationImages = [left!, middle!, right!]
        
        cat.animationDuration = 1
        cat.startAnimating()
        self.view.addSubview(cat)
    }
    
    func makeFence() {
        var fenceCount:Int = (Int)(arc4random() % 40) + 10
        for var idx = 0; idx < fenceCount; ++idx {
            var randRow = (Int)(arc4random() % 9)
            var randCol = (Int)(arc4random() % 9)
            matChange(mats[randRow][randCol])
        }
    }
    */
    
    var mats:Mats? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var background = UIImageView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        background.image = UIImage(named: "background1.png")
        self.view.addSubview(background)
        
        //createMat()
        //createCat()
        //makeFence()
        mats = Mats(viewer: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

