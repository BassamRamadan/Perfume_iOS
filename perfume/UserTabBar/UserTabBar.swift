//
//  UserTabBar.swift
//  perfume
//
//  Created by Bassam Ramadan on 4/25/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit

class UserTabBar: UITabBarController , UITabBarControllerDelegate {

    var index :Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = index ?? 0
    }
}
