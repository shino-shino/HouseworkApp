//
//  AppColor.swift
//  HouseworkApp
//
//  Created by shinotai on 2021/09/28.
//


import Foundation
import UIKit

class appColor {
    // main
    class var primary: UIColor {
        return rgbColor(rgbValue: 0xf3e8ec)
    }

    // sub
    class var secondary: UIColor{
        return rgbColor(rgbValue: 0x2c1b34)
    }

    // 白っぽい灰色を返す
    class var background: UIColor{
        return rgbColor(rgbValue: 0xFAF9F9)
    }

    // #FFFFFFのように色を指定できるようにするメソッド！色が使いやすくなる。
    // ここでしか使わないので privateメソッドにする。
    private class func rgbColor(rgbValue: UInt) -> UIColor{
        return UIColor(
            red:   CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >>  8) / 255.0,
            blue:  CGFloat( rgbValue & 0x0000FF)        / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
