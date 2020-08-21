//
//  Orders.swift
//  perfume
//
//  Created by Bassam Ramadan on 4/27/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit

class Orders: common {
    var myOrders = [OrdersData]()
    var noData = true
    @IBOutlet var ordersNumber : UILabel!
    @IBOutlet var tableView : UITableView!
    @IBOutlet var rejected : UIButton!
    @IBOutlet var completed : UIButton!
    @IBOutlet var pended : UIButton!
    
    @IBAction func pending(_ sender: UIButton) {
        pended.setTitleColor(.white, for: .normal)
        completed.setTitleColor(UIColor(named: "gray text"), for: .normal)
        rejected.setTitleColor(UIColor(named: "gray text"), for: .normal)
        getOrdersData(url: getUrl(status: "sent"))
    }
    @IBAction func completing(_ sender: UIButton) {
        completed.setTitleColor(.white, for: .normal)
        pended.setTitleColor(UIColor(named: "gray text"), for: .normal)
        rejected.setTitleColor(UIColor(named: "gray text"), for: .normal)
        getOrdersData(url: getUrl(status: "completed"))
    }
    @IBAction func rejecting(_ sender: UIButton) {
        rejected.setTitleColor(.white, for: .normal)
        pended.setTitleColor(UIColor(named: "gray text"), for: .normal)
        completed.setTitleColor(UIColor(named: "gray text"), for: .normal)
        getOrdersData(url: getUrl(status: "rejected"))
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let token = CashedData.getUserApiKey() ?? ""
        if token == ""{
            common.openLogin(sender: self.navigationController!)
        }else {
            if self.myOrders.count > 0{
                self.noData = false
            }else{
                self.noData = true
            }
            self.ordersNumber.text = "\(myOrders.count)"
            self.tableView.reloadData()
        }
    }
    
    func getUrl(status: String) -> String {
        return "https://services-apps.net/perfumecorner/public/api/my-orders?status=\(status)"
    }
    func getApiToken() -> String {
        return CashedData.getUserApiKey()!
    }
    
    @IBAction func back(sender: UIButton){
        self.navigationController?.dismiss(animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OrderDetails"{
            if let destination = segue.destination as? OrderDetails{
                destination.OrderId = sender as? Int
            }
        }
    }
    func getOrdersData(url: String){
        loading()
        let headers = [
            "Authorization": "Bearer " + getApiToken()
        ]
        AlamofireRequests.getMethod(url: url, headers:headers) { (error, success , jsonData) in
            do {
                let decoder = JSONDecoder()
                if error == nil{
                    let dataRecived = try decoder.decode(userOrders.self, from: jsonData)
                    if success{
                        self.myOrders = dataRecived.data ?? []
                        if self.myOrders.count > 0{
                            self.noData = false
                        }else{
                            self.noData = true
                        }
                        self.ordersNumber.text = "\(dataRecived.data?.count ?? 0)"
                        self.tableView.reloadData()
                        self.stopAnimating()
                    }
                    else  {
                        self.present(common.makeAlert(message: dataRecived.message ?? ""), animated: true, completion: nil)
                        self.stopAnimating()
                    }
                }else{
                    let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                    self.present(common.makeAlert(message: dataRecived.message ?? ""), animated: true, completion: nil)
                    self.stopAnimating()
                }
            } catch {
                self.present(common.makeAlert(), animated: true, completion: nil)
                self.stopAnimating()
            }
        }
        
    }
}
extension Orders: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if noData{
            return 1
        }
        return myOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if noData{
            let cell = tableView.dequeueReusableCell(withIdentifier: "noData", for: indexPath)
            cell.textLabel?.text = "لا يوجد طلبات مضافة حاليا"
            cell.textLabel?.textAlignment = .center
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Orders", for: indexPath) as! OrdersCell
            cell.id.text = "\(myOrders[indexPath.row].id ?? 0)"
            cell.createdAt.text = "\(myOrders[indexPath.row].createdAt ?? "")"
            cell.totalCost.text = "\(myOrders[indexPath.row].totalCost ?? "0.0")".replacingOccurrences(of: "-", with: "")
           
            cell.status.text = Status(ApiStatus: myOrders[indexPath.row].status ?? "")
            cell.icon.image  = StatusIcon(ApiStatus: myOrders[indexPath.row].status ?? "")
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if !noData{
            performSegue(withIdentifier: "OrderDetails", sender: myOrders[indexPath.row].id)
        }
    }
    func Status(ApiStatus : String)-> String{
        switch ApiStatus {
        case "pending":
            return "قيد المعاينة"
        case "completed":
            return "مكتمل "
        case "rejected":
            return "تم الرفض"
        default:
            return "جارى الشحن"
        }
    }
    func StatusIcon(ApiStatus : String)-> UIImage{
        switch ApiStatus {
        case "pending":
            return #imageLiteral(resourceName: "status_pending")
        case "completed":
            return #imageLiteral(resourceName: "status_delivered")
        case "rejected":
            return #imageLiteral(resourceName: "ic_no_cancel")
        default:
            return #imageLiteral(resourceName: "status_charging")
        }
    }
   
    
}
