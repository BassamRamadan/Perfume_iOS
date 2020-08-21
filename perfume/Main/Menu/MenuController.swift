//
//  ViewController.swift
//  ios-swift-collapsible-table-section-in-grouped-section
//
//  Created by Yong Su on 5/31/16.
//  Copyright © 2016 Yong Su. All rights reserved.
//
import UIKit
    
class menuController: common, UITableViewDelegate, UITableViewDataSource {
        
        // MARK: - Outlets
        let kHeaderSectionTag: Int = 6900;
        @IBOutlet weak var tableView: UITableView!
        @IBOutlet var tableViewHeight: NSLayoutConstraint!
    
        @IBOutlet var username: UILabel!
        @IBOutlet var email: UILabel!
    
        var expandedSectionHeaderNumber: Int = -1
        var expandedSectionHeader: UITableViewHeaderFooterView!
        var sectionItems: Array<Array<publicFilteringData>> = [[],[]]
        var sectionNames: Array<String> = []
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            sectionNames = [ "الماركات", "العطور"];
            self.tableView!.tableFooterView = UIView()
            
            username.text = CashedData.getUserName() ?? ""
            email.text = CashedData.getUserEmail() ?? ""
            getBrands(){
                (data) in
                self.sectionItems[0] = data
                self.tableView.reloadData()
                self.updateConstraints()
                
                self.getGenders(){
                    (data) in
                    self.sectionItems[1] = data
                    self.tableView.reloadData()
                    self.updateConstraints()
                }
                
            }
        }
        
        func updateConstraints() {
            tableView.layoutIfNeeded()
            tableViewHeight.constant = tableView.contentSize.height
        }
    
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "toResults"{
                if let des = segue.destination as? UINavigationController {
                    let linkVC = des.viewControllers[0] as! perfumeResults
                    let indx = sender as! IndexPath
                    if sectionNames[indx.section] == "الماركات"{
                        linkVC.maps = ["brands_ids":[self.sectionItems[indx.section][indx.row].id]]
                    }else{
                        linkVC.maps = ["genders":[self.sectionItems[indx.section][indx.row].id]]
                    }
                    linkVC.pagTitle = self.sectionItems[indx.section][indx.row].name ?? ""
                }
            }
        }
        // MARK: - Tableview Methods
        
        func numberOfSections(in tableView: UITableView) -> Int {
            if sectionNames.count > 0 {
                tableView.backgroundView = nil
                return sectionNames.count
            } else {
                let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
                messageLabel.text = "Retrieving data.\nPlease wait."
                messageLabel.numberOfLines = 0;
                messageLabel.textAlignment = .center;
                messageLabel.font = UIFont(name: "HelveticaNeue", size: 20.0)!
                messageLabel.sizeToFit()
                self.tableView.backgroundView = messageLabel;
            }
            return 0
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if (self.expandedSectionHeaderNumber == section) {
                let arrayOfItems = self.sectionItems[section] as! NSArray
                return arrayOfItems.count;
            } else {
                return 0;
            }
        }
        
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            if (self.sectionNames.count != 0) {
                return self.sectionNames[section] as? String
            }
            return ""
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 44.0;
        }
        
        func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
            return 0;
        }
        
        func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
            //recast your view as a UITableViewHeaderFooterView
            let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
            header.contentView.backgroundColor = .white
            header.textLabel?.textColor = UIColor.black
            header.textLabel?.textAlignment = .right
            header.textLabel?.font = UIFont(name: "SefidUI-Bold", size: 17)
            if let viewWithTag = self.view.viewWithTag(kHeaderSectionTag + section) {
                viewWithTag.removeFromSuperview()
            }
            let theImageView = UIImageView(frame: CGRect(x: 20, y: 13, width: 18, height: 18));
            theImageView.image = UIImage(named: "ic_left_arrow")
            theImageView.tag = kHeaderSectionTag + section
            header.addSubview(theImageView)
            
            // make headers touchable
            header.tag = section
            let headerTapGesture = UITapGestureRecognizer()
            headerTapGesture.addTarget(self, action: #selector(menuController.sectionHeaderWasTouched(_:)))
            header.addGestureRecognizer(headerTapGesture)
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "menuContentCell", for: indexPath) as! menuContentCell
            let section = self.sectionItems[indexPath.section]
            
            cell.title.text = section[indexPath.row].name ?? ""
            cell.count.text = "\(section[indexPath.row].productsCount ?? 0)"
            
            return cell
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            performSegue(withIdentifier: "toResults", sender: indexPath)
        }

        
        // MARK: - Expand / Collapse Methods
        
        @objc func sectionHeaderWasTouched(_ sender: UITapGestureRecognizer) {
            let headerView = sender.view as! UITableViewHeaderFooterView
            let section    = headerView.tag
            let eImageView = headerView.viewWithTag(kHeaderSectionTag + section) as? UIImageView
            
            if (self.expandedSectionHeaderNumber == -1) {
                self.expandedSectionHeaderNumber = section
                tableViewExpandSection(section, imageView: eImageView!)
            } else {
                if (self.expandedSectionHeaderNumber == section) {
                    tableViewCollapeSection(section, imageView: eImageView!)
                } else {
                    let cImageView = self.view.viewWithTag(kHeaderSectionTag + self.expandedSectionHeaderNumber) as? UIImageView
                    tableViewCollapeSection(self.expandedSectionHeaderNumber, imageView: cImageView!)
                    tableViewExpandSection(section, imageView: eImageView!)
                }
            }
        }
        
        func tableViewCollapeSection(_ section: Int, imageView: UIImageView) {
            let sectionData = self.sectionItems[section] as! NSArray
            
            self.expandedSectionHeaderNumber = -1;
            if (sectionData.count == 0) {
                return;
            } else {
                UIView.animate(withDuration: 0.4, animations: {
                    imageView.image = UIImage(named: "ic_left_arrow")
                })
                var indexesPath = [IndexPath]()
                for i in 0 ..< sectionData.count {
                    let index = IndexPath(row: i, section: section)
                    indexesPath.append(index)
                }
                self.tableView!.beginUpdates()
                self.tableView!.deleteRows(at: indexesPath, with: UITableView.RowAnimation.fade)
                self.tableView!.endUpdates()
                updateConstraints()
            }
        }
        
        func tableViewExpandSection(_ section: Int, imageView: UIImageView) {
            let sectionData = self.sectionItems[section] as! NSArray
            
            if (sectionData.count == 0) {
                self.expandedSectionHeaderNumber = -1;
                return;
            } else {
                UIView.animate(withDuration: 0.4, animations: {
                    imageView.image = UIImage(named: "ic_down_arrow")
                })
                var indexesPath = [IndexPath]()
                for i in 0 ..< sectionData.count {
                    let index = IndexPath(row: i, section: section)
                    indexesPath.append(index)
                }
                self.expandedSectionHeaderNumber = section
                self.tableView!.beginUpdates()
                self.tableView!.insertRows(at: indexesPath, with: UITableView.RowAnimation.fade)
                self.tableView!.endUpdates()
                updateConstraints()
            }
        }
        // MARK: - Actions
        @IBAction func ContactUs(_ sender: Any){
            if let mainVC = self.parent as? MainViewController {
                mainVC.hideSideMenu()
            }
            openSetting(pagTitle: "ContactUs")
        }
        
        @IBAction func AboutUs(_ sender: Any){
            if let mainVC = self.parent as? MainViewController {
                mainVC.hideSideMenu()
            }
            openSetting(pagTitle: "AboutUs")
        }
        
        @IBAction func Policy(_ sender: Any){
            if let mainVC = self.parent as? MainViewController {
                mainVC.hideSideMenu()
            }
            openSetting(pagTitle: "Policy")
           
        }
    
     
    
    
        
}

