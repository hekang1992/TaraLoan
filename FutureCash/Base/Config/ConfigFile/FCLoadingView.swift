//
//  FCLoadingView.swift
//  FutureCash
//
//  Created by apple on 2024/4/12.
//

import UIKit
import Foundation
import Lottie

class LoadView: UIView {
    
    private lazy var grayView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25.px()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        return view
    }()
    
    private lazy var hudView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "loading.json", bundle: Bundle.main)
        animationView.loopMode = .loop
        animationView.play()
        return animationView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(grayView)
        grayView.addSubview(hudView)
        setConstraints()
    }
    
    private func setConstraints() {
        grayView.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.size.equalTo(CGSizeMake(100.px(), 100.px()))
        }
        
        hudView.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.size.equalTo(CGSize(width: 80.px(), height: 80.px()))
        }
    }
}

class ViewHud {
    static func createLoadView() -> LoadView {
        let loadView = LoadView()
        if let keyWindow = UIApplication.shared.windows.first {
            loadView.frame = keyWindow.bounds
        }
        return loadView
    }
}
