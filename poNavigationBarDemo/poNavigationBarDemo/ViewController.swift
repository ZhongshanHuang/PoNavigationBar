//
//  ViewController.swift
//  PoNavigationBar
//
//  Created by 154427919@qq.com on 03/01/2021.
//  Copyright (c) 2021 154427919@qq.com. All rights reserved.
//

import UIKit
import PoNavigationBar

class ViewController: UIViewController {

    lazy var tableView: UITableView = UITableView(frame: .zero, style: .plain)
    var dataList: [String: Any] = [:]
    let titles: [String] = ["style", "color", "image"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        extendedLayoutIncludesOpaqueBars = true
        
        setupUI()
        mockDataList()
        tableView.reloadData()
        print(#function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    private func setupUI() {
        title = "PoNavigationBar"
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 0
        tableView.rowHeight = 44
        tableView.estimatedSectionHeaderHeight = 0
        tableView.sectionHeaderHeight = 30
        tableView.frame = view.bounds
        view.addSubview(tableView)
        
        tableView.register(UINib(nibName: "ImageCell", bundle: nil), forCellReuseIdentifier: "ImageCell")
        tableView.register(UINib(nibName: "ColorCell", bundle: nil), forCellReuseIdentifier: "ColorCell")
        tableView.register(UINib(nibName: "SwitchCell", bundle: nil), forCellReuseIdentifier: "SwitchCell")
        tableView.register(Header.self, forHeaderFooterViewReuseIdentifier: "Header")
    }
    
    private func mockDataList() {
        // bar style
        let styles: [(String, Bool)] = [("Hidden", false), ("Transparent", false), ("Transluent", false), ("Black Bar Style", true), ("Shadow Image", true)]
        dataList["style"] = styles
        
        // color
        let colors: [(String, UIColor)] = [("Magenta", .magenta), ("Black", .black), ("White", .white), ("Gray",  .gray), ("Red", .red), ("Orange", .orange)]
        dataList["color"] = colors
        
        // image
        let images: [(String, UIImage)] = [("Blue", UIImage(named: "blue")!), ("Green",  UIImage(named: "green")!), ("Purple",  UIImage(named: "purple")!), ("Red",  UIImage(named: "red")!), ("Yellow",  UIImage(named: "yellow")!)]
        dataList["image"] = images
    }
    
    deinit {
        print(self.description + "dealloc")
    }
    
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = (dataList[titles[section]] as? NSArray)?.count ?? 0
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result: UITableViewCell
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            let model = (dataList[titles[indexPath.section]] as! [(String, Bool)])[indexPath.row]
            cell.titleLabel.text = model.0
            cell.switchButton.isOn = model.1
            result = cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ColorCell", for: indexPath) as! ColorCell
            let model = (dataList[titles[indexPath.section]] as! [(String, UIColor)])[indexPath.row]
            cell.titleLabel.text = model.0
            cell.colorView.backgroundColor = model.1
            result = cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImageCell
            let model = (dataList[titles[indexPath.section]] as! [(String, UIImage)])[indexPath.row]
            cell.titleLabel.text = model.0
            cell.imageColor.image = model.1
            result = cell
        default:
            result = UITableViewCell()
        }
        return result
    }
    
    
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header") as? Header
        header?.titleLabel.text = titles[section]
        return header
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 { return false }
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = ViewController()
                    
        let blackStyle = (tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as! SwitchCell).switchButton.isOn
        vc.poNavigationBarConfigure.barStyle = blackStyle ? .black : .default
        
        let hidden = (tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! SwitchCell).switchButton.isOn
        vc.poNavigationBarConfigure.isHidden = hidden
        if hidden {
            navigationController?.pushViewController(vc, animated: true)
            return
        }
        
        let transparent = (tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! SwitchCell).switchButton.isOn
        if transparent {
            vc.poNavigationBarConfigure.isTranslucent = true
            vc.poNavigationBarConfigure.backgroundImage = UIImage()
            vc.poNavigationBarConfigure.shadowImage = UIImage()
            if #available(iOS 13.0, *) {
                let appearance = poCopyNavigationBarStandardAppearance
                appearance?.configureWithTransparentBackground()
                
                vc.poNavigationBarConfigure.standardAppearance = appearance
                vc.poNavigationBarConfigure.scrollEdgeAppearance = appearance
            }
            
            navigationController?.pushViewController(vc, animated: true)
            return
        }

        let transluent = (tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! SwitchCell).switchButton.isOn
        vc.poNavigationBarConfigure.isTranslucent = transluent
        
        let shadowImage = (tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as! SwitchCell).switchButton.isOn
        vc.poNavigationBarConfigure.shadowImage = shadowImage ? nil : UIImage()
        
        switch indexPath.section {
        case 1: // color
            let model = (dataList[titles[indexPath.section]] as! [(String, UIColor)])[indexPath.row]
            vc.poNavigationBarConfigure.barTintColor = model.1
        case 2: // image
            let model = (dataList[titles[indexPath.section]] as! [(String, UIImage)])[indexPath.row]
            vc.poNavigationBarConfigure.backgroundImage = model.1
        default:
            fatalError("Not Implement")
        }
        if #available(iOS 13.0, *) {
            let appearance = poCopyNavigationBarStandardAppearance
            if transluent {
                appearance?.configureWithDefaultBackground()
                appearance?.backgroundEffect = UIBlurEffect(style: .light)
                appearance?.backgroundColor = vc.poNavigationBarConfigure.barTintColor?.withAlphaComponent(0.3)
            } else {
                appearance?.configureWithOpaqueBackground()
                appearance?.backgroundColor = vc.poNavigationBarConfigure.barTintColor
            }
            appearance?.backgroundImage = vc.poNavigationBarConfigure.backgroundImage
            
            if vc.poNavigationBarConfigure.shadowImage != nil {
                appearance?.shadowImage = vc.poNavigationBarConfigure.shadowImage
                appearance?.shadowColor = UIColor.clear
            }
            
            vc.poNavigationBarConfigure.standardAppearance = appearance
            vc.poNavigationBarConfigure.scrollEdgeAppearance = appearance
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

