//
//  BaseHeadFile.swift
//  FutureCash
//
//  Created by apple on 2024/3/25.
//

import UIKit
import Foundation
import DeviceKit

// 宽度
let SCREEN_WIDTH = UIScreen.main.bounds.size.width
// 高度
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
// 状态栏高度
let STATUSBAR_HIGH = isFullScreenDevice(Device.current) ? 44 : 20
// 导航栏高度
let NAV_HIGH = 44 + STATUSBAR_HIGH;

let Key_Service = "Key_Service"

let Key_Account = "Key_Account"

//push
let FCNotificationCenter = NotificationCenter.default
let FCAPPLE_PUSH = "FCAPPLE_PUSH"

// 判断设备是否是全面屏
func isFullScreenDevice(_ device: Device) -> Bool {
    //    allXSeriesDevices
    let fullScreenModels: [Device] = Device.allDevicesWithSensorHousing
    
    return fullScreenModels.contains(device)
}

extension UIColor {
    static func randomColor() -> UIColor {
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
        let alpha = CGFloat.random(in: 0...1)
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}

extension UILabel {
    static func createLabel(font: UIFont, textColor: UIColor, textAlignment: NSTextAlignment) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = textColor
        label.textAlignment = textAlignment
        label.backgroundColor = UIColor.clear
        return label
    }
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
}

extension Double {
    func px() -> CGFloat {
        return CGFloat.init(CGFloat.init(self)/375.0 * SCREEN_WIDTH)
    }
}

extension CGFloat {
    func px() -> CGFloat {
        return CGFloat.init(CGFloat.init(self)/375.0 * SCREEN_WIDTH)
    }
}

extension Int {
    func px() -> CGFloat {
        return CGFloat.init(CGFloat.init(self)/375.0 * SCREEN_WIDTH)
    }
}

extension CGFloat {
    func minus() -> CGFloat{
        return 0 - self
    }
}

extension Data {
    static func compressQuality(image: UIImage, maxLength: Int) -> Data? {
        var compression: CGFloat = 0.7
        var data = image.jpegData(compressionQuality: compression)
        if let imageData = data, imageData.count < maxLength {
            return data
        }
        var max: CGFloat = 1.0
        var min: CGFloat = 0.0
        for _ in 0..<5 {
            compression = (max + min) / 2
            if let imageData = image.jpegData(compressionQuality: compression) {
                if imageData.count < Int(Double(maxLength) * 0.8) {
                    min = compression
                } else if imageData.count > maxLength {
                    max = compression
                } else {
                    break
                }
                data = imageData
            }
        }
        return data
    }
}

extension String {
    func convertBase64(_ dict: [String: Any]) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict)
            let base64EncodedString = jsonData.base64EncodedString()
            return base64EncodedString
        } catch {
            print("Error: \(error)")
            return nil
        }
    }
}

extension UIButton {
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.1
        animation.repeatCount = 2
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 8.px(), y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 8.px(), y: self.center.y))
        layer.add(animation, forKey: "position")
    }
}

extension UIViewController {
    func getCurrentUIVC() -> UIViewController? {
        guard let superVC = getCurrentVC() else {
            return nil
        }
        if let tabBarController = superVC as? UITabBarController {
            if let tabSelectVC = tabBarController.selectedViewController as? UINavigationController {
                return tabSelectVC.viewControllers.last
            } else {
                return tabBarController.selectedViewController
            }
        } else if let navigationController = superVC as? UINavigationController {
            return navigationController.viewControllers.last
        }
        return superVC
    }
    
    func getCurrentVC() -> UIViewController? {
        var result: UIViewController?
        var window = UIApplication.shared.keyWindow
        if window?.windowLevel != UIWindow.Level.normal {
            let windows = UIApplication.shared.windows
            for tmpWin in windows {
                if tmpWin.windowLevel == UIWindow.Level.normal {
                    window = tmpWin
                    break
                }
            }
        }
        if let frontView = window?.subviews.first {
            if let nextResponder = frontView.next {
                if let viewController = nextResponder as? UIViewController {
                    result = viewController
                } else {
                    result = window?.rootViewController
                }
            }
        }
        return result
    }
}
