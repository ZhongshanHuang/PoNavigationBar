//
//  SecondViewController.swift
//  PoNavigationBar_Example
//
//  Created by HzS on 2023/9/6.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "second"
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.titleTextAttributes = [.foregroundColor: UIColor.red]
            
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.blue
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
    }

}
