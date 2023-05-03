//
//  RootNavigationViewController.swift
//  ModernCollectionViewDemo
//
//  Created by Toshiharu Imaeda on 2023/05/03.
//

import UIKit
import ModernCollectionViewSample

class RootNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let rootVC = RootViewController.instantiateVC()
        setViewControllers([rootVC], animated: false)
    }
}
