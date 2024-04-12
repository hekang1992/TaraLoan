//
//  AppDelegate.swift
//  FutureCash
//
//  Created by apple on 2024/3/25.
//

import UIKit
import AdSupport
import AppTrackingTransparency
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.rootViewController = LaunchViewController()
        getPushApple()
        getRootVc()
        keyboardManager()
//        getFontNames()
        window?.makeKeyAndVisible()
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if #available(iOS 14.0, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var strToken = ""
        for byte in deviceToken {
            strToken += String(format: "%02x", byte)
        }
        print("strToken===\(strToken)")
        getTapToken(deviceToken: strToken)
    }
    
    func keyboardManager(){
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 5.px()
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enable = true
    }
    
    func getRootVc() {
        FCNotificationCenter.addObserver(self, selector: #selector(setUpRootVc), name: NSNotification.Name(FCAPPLE_ROOT_VC), object: nil)
    }
    
    @objc func setUpRootVc() {
        window?.rootViewController = BaseNavViewController(rootViewController: HomeViewController())
    }
    
    func getPushApple() {
        FCNotificationCenter.addObserver(self, selector: #selector(applePush(_ :)), name: NSNotification.Name(FCAPPLE_PUSH), object: nil)
    }
    
    @objc func applePush(_ notification: Notification) {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
        }
        if #available(iOS 16.0, *) {
            center.setBadgeCount(0) { error in
                
            }
        } else {
            
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
    
    func getTapToken(deviceToken: String) {
        let subject = DeviceInfo.getIdfv()
        let dict = ["subject": subject,
                    "shock": deviceToken]
        FCRequset.shared.requestAPI(params: dict, pageUrl: addedPlease, method: .post) { baseModel in
            let conceive = baseModel.conceive
            if conceive == 0 || conceive == 00 {
                print("push>>>>>success")
            }
        } errorBlock: { error in
            
        }
    }
    
    func getFontNames() {
        let familyNames = UIFont.familyNames
        for familyName in familyNames {
            let fontNames = UIFont.fontNames(forFamilyName: familyName)
            for fontName in fontNames {
                print("fontName>>>>>>>>>>>>>>\(fontName)")
            }
        }
    }
    
    deinit {
        FCNotificationCenter.removeObserver(self)
    }
    
}

