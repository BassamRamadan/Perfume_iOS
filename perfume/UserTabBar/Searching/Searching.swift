//
//  Searching.swift
//  perfume
//
//  Created by Bassam Ramadan on 4/20/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit

class Searching: UIViewController {

    @IBOutlet var SearchingTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
}
extension Searching: UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == SearchingTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchingCell
            
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentCell", for: indexPath) as! ContentCell
            
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let cell = tableView.cellForRow(at: indexPath) as! SearchingCell
        if cell.PlusIcon.image == #imageLiteral(resourceName: "ic_acc_plus"){
            cell.PlusIcon.image = #imageLiteral(resourceName: "ic_acc_mins")
            cell.ContentTableHeight.constant = 200
        }else{
            cell.PlusIcon.image = #imageLiteral(resourceName: "ic_acc_plus")
            cell.layoutIfNeeded()
            cell.ContentTableHeight.constant = 0
        }
    }
}
