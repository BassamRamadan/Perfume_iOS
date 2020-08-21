//
//  MoveToMain.swift
//  ezhelhaa
//
//  Created by Bassam Ramadan on 3/31/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit

class MoveToMain: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       setupBackButtonWithDismiss()
    }
    func setupBackButtonWithDismiss() {
        self.navigationItem.hidesBackButton = true
        let backBtn: UIButton = drowbackButton()
        let backButton = UIBarButtonItem(customView: backBtn)
        self.navigationItem.setRightBarButton(backButton, animated: true)
        backBtn.addTarget(self, action: #selector(self.Dismiss), for: UIControl.Event.touchUpInside)
    }
    @objc func Dismiss() {
        common.openMain(currentController: self)
    }
    func drowbackButton()->UIButton {
        let notifBtn: UIButton = UIButton(type: UIButton.ButtonType.custom)
        notifBtn.setImage(UIImage(named: "ic_back_black"), for: [])
        notifBtn.setTitle("الرئيسية  ", for: .normal)
        notifBtn.setTitleColor(.black, for: .normal)
        notifBtn.semanticContentAttribute = .forceRightToLeft
        notifBtn.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        return notifBtn
        // Do any additional setup after loading the view
    }
}
