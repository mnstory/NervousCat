//
//  CirclePoint.swift
//  NervousCat
//
//  Created by 韦体东 on 15/3/1.
//  Copyright (c) 2015年 韦体东. All rights reserved.
//

import Foundation
import UIKit

class Mat : NSObject {
    var row: Int
    var col: Int
    var cost: Int = -100
    var fix: Bool = false
    var viewer: UIButton = UIButton()
    var parent: Mats
    
    init(row: Int, col: Int, parent: Mats) {

        
        self.row = row
        self.col = col
        self.parent = parent
        super.init()
        viewer.frame = CGRectMake(CGFloat(20 + 28*col + ((0==(row%2)) ? 14 : 0)), CGFloat(170 + 28*row), 28, 28)
        viewer.setImage(UIImage(named: "gray.png"), forState: .Normal)
        viewer.addTarget(self, action: "fixChange", forControlEvents: UIControlEvents.TouchUpInside)
        parent.viewer.view.addSubview(viewer)
    }
    
    func reset() {
        fix = false;
        viewer.setImage(UIImage(named: "gray.png"), forState: .Normal)
    }
    func fixChange() {
        if parent.catRow == self.row && parent.catCol == self.col {
            return
        }
        
        viewer.setImage(UIImage(named: fix ? "gray.png" : "yellow2.png"), forState: .Normal)
        fix = !fix
        if !parent.jump() {
            var alert = UIAlertController(title: "提示", message: "你已经抓住猫了", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "再来一次", style: .Default, handler: {act in
                self.parent.restart()
            }))
            alert.addAction(UIAlertAction(title: "退出", style: .Default, handler: {
                act in
                self.parent.viewer.dismissViewControllerAnimated(false, completion: nil)
            }))
            
            parent.viewer.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
}

class Mats {
    var mats: [[Mat]]
    var catRow: Int
    var catCol: Int
    var catRowLast: Int = 0
    var catColLast: Int = 0
    var cat:UIImageView
    var viewer: ViewController
    
    init(viewer: ViewController) {
        self.viewer = viewer
        mats = [[Mat]]()
        catRow = 4
        catCol = 4
        cat = UIImageView()
        
        start(true)
    }
    
    func start(let create: Bool) {
        //create mats
        if create {
            for var row = 0; row < 9; ++row {
                var rowmats = [Mat]()
                for var col = 0; col < 9; ++col {
                    rowmats.append(Mat(row: row, col: col, parent: self))
                }
                mats.append(rowmats)
            }
        } else {
            for var row = 0; row < 9; ++row {
                for var col = 0; col < 9; ++col {
                    mats[row][col].reset()
                }
            }
        }
        
        //create cat
        var left = UIImage(named: "left2.png")
        var middle = UIImage(named: "middle2.png")
        var right = UIImage(named: "right2.png")
        
        cat.animationImages = [left!, middle!, right!]
        
        cat.animationDuration = 1
        cat.startAnimating()
        self.viewer.view.addSubview(cat)
        //create fence
        makeFence()
        setCatLocation()
    }
    
    func restart() {
        //mats = [[Mat]]()
        catRow = 4
        catCol = 4
        //cat = UIImageView()
        start(false)
    }
    
    func makeFence() {
        var fenceCount:Int = (Int)(arc4random() % 20) + 10
        for var idx = 0; idx < fenceCount; ++idx {
            var randRow = (Int)(arc4random() % 9)
            var randCol = (Int)(arc4random() % 9)
            mats[randRow][randCol].fixChange()
        }
    }
    
    enum Location : Int{
        case Left = 0,
        Right,
        UpLeft,UpRight,DownLeft,DownRight
        func getLocation(row: Int, col: Int) -> (Int, Int)? {
            var location:(Int, Int)?
            var odd = (0 != (row % 2))
            switch self {
            case .Left:
                location = (row, col-1)
            case .Right:
                location = (row, col+1)
            case .UpLeft:
                location =  odd ? (row-1, col-1) : (row-1, col)
            case .UpRight:
                location =  odd ? (row-1, col) : (row-1, col+1)
            case .DownLeft:
                location =  odd ? (row+1, col-1) : (row+1, col)
            case .DownRight:
                location =  odd ? (row+1, col) : (row+1, col+1)
            default:
                location = nil
            }
            if location?.0 > 8 || location?.0 < 0 || location?.1 > 8 || location?.1 < 0 {
                location = nil
            }
            return location
        }
        
        
    }
    
    func shuffle<T>(inout  arr: [T]) {
        var count: Int = arr.count
        for var i = 0; i < count/2; ++i {
            var rand = (Int)(arc4random() % (UInt32)(count))

            var save = arr[i]
            arr[i] = arr[rand]
            arr[rand] = save
        }
    }
    
    func jump1() -> Bool {
        var locations:[Location] = [.Left, .Right, .UpLeft, .UpRight, .DownLeft, .DownRight]
        shuffle(&locations)
        
        for var i = 0; i < locations.count; ++i {
            var loc = locations[i].getLocation(catRow, col: catCol)
            if nil == loc {
                continue
            }
            if catRowLast == loc!.0 && catColLast == loc!.1 {
                continue
            }
            var mat = mats[loc!.0][loc!.1]
            if mat.fix {
                continue
            }
            catRowLast = catRow
            catColLast = catCol
            catRow = loc!.0
            catCol = loc!.1
            
            setCatLocation()
            return true
        }
        return false
    }
    
    func jump() -> Bool {
        if jump1() {
            return jump1()
        }
        return false
    }

    
    func setCatLocation() {
        
        cat.frame = CGRectMake(CGFloat(20 + 28*catCol + ((0==(catRow%2)) ? 14 : 0)), CGFloat(170 + 28*(catRow-1)), 28, 56)
    }
}