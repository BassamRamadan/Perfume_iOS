//
//  searching.swift
//  perfume
//
//  Created by Bassam Ramadan on 5/26/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit

class Filtering: common  {

    let kHeaderSectionTag: Int = 6900;
    @IBOutlet var TableView: UITableView!
    var FieldsIsAppear: Array<Bool> = []
    var FieldsArr: Array<FieldsData> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "تصفية النتائج"
        setupBackButtonWithDismiss()
        getFourMainCategory()
        getFields()
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toResults"{
            if let des = segue.destination as? UINavigationController{
                let linkVC = des.viewControllers[0] as! perfumeResults
                linkVC.maps = AppDelegate.fieldPriceId
                linkVC.pagTitle = "النتائج"
            }
        }
    }
    @IBAction func toResults(sender: UIButton){
        performSegue(withIdentifier: "toResults", sender: self)
    }
    @IBAction func SectionClicked(sender: UIButton){
        FieldsIsAppear[sender.tag] = !FieldsIsAppear[sender.tag]
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 2, animations:  {
            self.TableView.reloadData()
        })
    }
    fileprivate func getFourMainCategory() {
        self.getCommonCategory(AppDelegate.LocalUrl+"/brands"){
            (data) in
            self.ConvertToField("ماركة العطر", data)
        }
        self.getCommonCategory(AppDelegate.LocalUrl+"/genders"){
            (data) in
            self.ConvertToField("الجنس", data)
        }
        self.getCommonCategory(AppDelegate.LocalUrl+"/types"){
            (data) in
            self.ConvertToField("النوع", data)
        }
    }
    
    fileprivate func ConvertToField(_ name: String,_ data: [publicFilteringData]) {
        guard data.count != 0 else{
            return
        }
        self.FieldsArr.append(FieldsData(id: 0, name: name, Values:
            data.map{(row) ->Value in
                return Value(id: row.id ?? 0, value: row.name ?? "",productsCount: row.productsCount ?? 0)
            }
        ))
        self.FieldsIsAppear.append(true)
        self.TableView.reloadData()
    }
    
    fileprivate func getFields(){
        self.loading()
        let url = AppDelegate.LocalUrl + "/fields"
        let headers = [
            "Content-Type": "application/json" ,
            "Accept" : "application/json",
        ]
        AlamofireRequests.getMethod(url: url, headers: headers) { (error, success, jsonData) in
            do {
                let decoder = JSONDecoder()
                if error == nil {
                    if success {
                        let dataReceived = try decoder.decode(Fields.self, from: jsonData)
                        
                        self.FieldsArr.append(contentsOf: dataReceived.data ?? [])
                        
                        for _ in dataReceived.data ?? []{
                            self.FieldsIsAppear.append(true)
                        }
                        self.TableView.reloadData()

                    }else{
                        self.present(common.makeAlert(), animated: true, completion: nil)
                    }
                    self.stopAnimating()
                }else{
                    let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                    self.present(common.makeAlert(message: dataRecived.message ?? ""), animated: true, completion: nil)
                    self.stopAnimating()
                }
            }catch {
                self.present(common.makeAlert(), animated: true, completion: nil)
                self.stopAnimating()
            }
        }
    }
}
extension Filtering: UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.FieldsArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Filter", for: indexPath) as! FilterCell
        cell.FilterTable.isHidden = FieldsIsAppear[indexPath.row]
        cell.btnSection.tag = indexPath.row
        cell.titleSection.text = self.FieldsArr[indexPath.row].name ?? ""
        cell.Confige(section: self.FieldsArr[indexPath.row].name ?? "", data: self.FieldsArr[indexPath.row])
        
        if FieldsIsAppear[indexPath.row]{
            cell.btnSection.setImage(#imageLiteral(resourceName: "ic_acc_plus"), for: .normal)
        }else{
            cell.btnSection.setImage(#imageLiteral(resourceName: "ic_acc_mins"), for: .normal)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if FieldsIsAppear[indexPath.row]{
            return 70
        }
        return 270
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
