//
//  FilterCell.swift
//  perfume
//
//  Created by Bassam Ramadan on 5/29/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit

class FilterCell: UITableViewCell {

    @IBOutlet var btnSection: UIButton!
    @IBOutlet var titleSection: UILabel!
    @IBOutlet var FilterTable: UITableView!
    var FieldsData: FieldsData?
    var section: String = ""
    var showCountInSections = ["التركيز","ماركة العطر","النوع","الجنس"]
    var maps: Dictionary<String,String> = [:]
    var idsHandler: ((Dictionary<String,Array<Int>>)->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
      
        maps["ماركة العطر"] = "brands_ids"
        maps["الجنس"] = "genders"
        maps["النوع"] = "types"
       
        
        FilterTable.delegate = self
        FilterTable.dataSource = self
      
    }
    func Confige(section:String ,data: FieldsData){
        FieldsData = data
        self.section = section
        FilterTable.reloadData()
    }
    @IBAction func SubCategoryClicked(sender: UIButton){
        if sender.backgroundImage(for: .normal) == #imageLiteral(resourceName: "check") {
            sender.setBackgroundImage(#imageLiteral(resourceName: "checked"), for: .normal)
            
            if self.section == "التركيز"{
                return
            }
            let str: String = maps[self.section] == nil ? "fields_values_ids" : maps[self.section] ?? ""
    
            if AppDelegate.fieldPriceId[str] == nil{
                AppDelegate.fieldPriceId[str] = []
            }
            if var array = AppDelegate.fieldPriceId[str]{
                array.append(sender.tag)
                AppDelegate.fieldPriceId[str] = array
            }
                
            
            
        }else{
            sender.setBackgroundImage(#imageLiteral(resourceName: "check"), for: .normal)
            
            if self.section == "التركيز"{
                return
            }
            let str: String = maps[self.section] == nil ? "fields_values_ids" : maps[self.section] ?? ""
            
           
            if var array = AppDelegate.fieldPriceId[str]{
                for (indx,x) in array.enumerated(){
                    if x == sender.tag{
                        array.remove(at: indx)
                }
                AppDelegate.fieldPriceId[str] = array
            }
                
            if AppDelegate.fieldPriceId[str] == []{
                AppDelegate.fieldPriceId[str] = nil
                return
            }
        }
    }
    idsHandler?(AppDelegate.fieldPriceId)
 }
}
extension FilterCell: UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.FieldsData?.Values?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView(frame: .init(x: 0, y: 0, width: tableView.frame.width, height: 1))
        v.backgroundColor = UIColor(named: "separator")
        return v
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as! valueCell
        
        cell.name.text = self.FieldsData?.Values?[indexPath.row].value ?? ""
        cell.check.tag = self.FieldsData?.Values?[indexPath.row].id ?? 0
        
        cell.count.isHidden = true
        if self.showCountInSections.firstIndex(of: self.section ?? "") != nil{
            cell.count.isHidden = false
            cell.count.text = "\(self.FieldsData?.Values?[indexPath.row].productsCount ?? 0)"
        }
        cell.check.setBackgroundImage(#imageLiteral(resourceName: "check"), for: .normal)
        
        
        let str: String = maps[self.section] == nil ? "fields_values_ids" : maps[self.section] ?? ""
        if AppDelegate.fieldPriceId[str]?.firstIndex(of: cell.check.tag) != nil{
            cell.check.setBackgroundImage(#imageLiteral(resourceName: "checked"), for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
