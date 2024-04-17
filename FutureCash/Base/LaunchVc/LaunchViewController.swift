//
//  LaunchViewController.swift
//  FutureCash
//
//  Created by apple on 2024/3/25.
//

import UIKit
import Alamofire
import AppsFlyerLib
import AdSupport
import HandyJSON
import RxSwift

class LaunchViewController: FCBaseViewController, AppsFlyerLibDelegate {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        JudgNetWork()
        let iconImageView = UIImageView()
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.image = UIImage(named: "launch")
        view.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
    }
    
    func JudgNetWork() {
        NetworkManager.shared.observeNetworkStatus { [weak self] status in
            switch status {
            case .none:
                print("无网络连接")
                break
            case .wifi:
                print("网络>>>>>>>WIFI")
                self?.upApiInfo()
                break
            case .cellular:
                print("网络>>>>>>>4G/5G")
                self?.upApiInfo()
                break
            }
        }
    }
    
    func upApiInfo() {
        getApplePush()
        getAppleLocation()
        uploadGoogleMarket()
        delayTime(0.5) { [weak self] in
            self?.getRootVcPush()
        }
    }
    
//    func getLocation() {
//        LocationManager.shared.startUpdatingLocation { locationModel in
//            self?.obs.onNext(locationModel)
//        }
//    }
    
//    func upLocationInfo(_ model: LocationModel) {
//        let country = model.country
//        let city = model.city
//        if country.isEmpty && city.isEmpty {
//            self.uploadDeviceInfo()
//        }else{
//            self.uploadLocationInfo(model)
//        }
//    }
    
}

extension LaunchViewController {
    
    func uploadLocationInfo(_ model: LocationModel) {
        let dict = ["financial": model.country ,
                    "bowed": model.countryCode,
                    "income": model.province,
                    "steady": model.city,
                    "inspire": "\(model.district) \(model.street)",
                    "needed": model.longitude,
                    "alcoholic": model.latitude] as [String: Any]
        FCRequset.shared.requestAPI(params: dict, pageUrl: morningReally, method: .post) { [weak self] baseModel in
            let conceive = baseModel.conceive
            if conceive == 0 || conceive == 00 {
                self?.uploadDeviceInfo()
                print("uploadLocationInfo>>>>>>>success")
            }
        } errorBlock: { [weak self] error in
            self?.uploadDeviceInfo()
        }
    }
    
    func uploadDeviceInfo() {
        let dict = DeviceInfo.deviceInfo()
        if let base64String = dictToBase64(dict) {
            let dict = ["easily": base64String]
            FCRequset.shared.requestAPI(params: dict, pageUrl: thank, method: .post) { [weak self] baseModel in
                let conceive = baseModel.conceive
                if conceive == 0 || conceive == 00 {
                  print("uploadDeviceInfo>>>>>>>success")
                }
                self?.getRootVcPush()
            } errorBlock: { [weak self] error in
                self?.getRootVcPush()
            }
        }
    }
    
    func uploadGoogleMarket() {
        let idfv = DeviceInfo.getIdfv()
        let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        let dict = ["subject": idfv, "hesitated": idfa, "hints": "1"]
        FCRequset.shared.requestAPI(params: dict, pageUrl: ohBreakfast, method: .post) { [weak self] baseModel in
            let conceive = baseModel.conceive
            if conceive == 0 || conceive == 00 {
                print("uploadGoogleMarket>>>>>>>success")
                let model = JSONDeserializer<GoogleModel>.deserializeFrom(dict: baseModel.easily)
                if let pistol = model?.pistol, let profession = model?.profession {
                    self?.uploadGoogle(profession, pistol)
                }
            }
        } errorBlock: { error in
            
        }
    }
    
    func uploadGoogle(_ key: String, _ appId: String) {
        AppsFlyerLib.shared().appsFlyerDevKey = key
        AppsFlyerLib.shared().appleAppID = appId
        AppsFlyerLib.shared().delegate = self
        AppsFlyerLib.shared().start()
    }
    
    func dictToBase64(_ dict: [String: Any]) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict)
            let base64EncodedString = jsonData.base64EncodedString()
            return base64EncodedString
        } catch {
            print("Error: \(error)")
            return nil
        }
    }
    
    func onConversionDataSuccess(_ conversionInfo: [AnyHashable : Any]) {
        print("conversionInfo>>>>>>>\(conversionInfo)")
    }
    
    func onConversionDataFail(_ error: any Error) {
        print("error>>>>>>>>\(error.localizedDescription)")
    }
    
    func getApplePush() {
        FCNotificationCenter.post(name: NSNotification.Name(FCAPPLE_PUSH), object: nil)
    }
    
    func getAppleLocation() {
        FCNotificationCenter.post(name: NSNotification.Name(FCAPPLE_LOCATION), object: nil)
    }
    
}
