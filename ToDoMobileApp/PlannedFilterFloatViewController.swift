//
//  PlannedFilterFloatViewController.swift
//  ToDoMobileApp
//
//  Created by đào sơn on 15/04/2022.
//

import UIKit

class PlannedFilterFloatViewController: UIViewController {
    
    @IBOutlet weak private var filterTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        filterTableView.delegate = self
        filterTableView.dataSource = self
        filterTableView.register(UINib(nibName: "PlannedFilterFloatTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PlannedFilterFloatTableViewCell")
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PlannedFilterFloatViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = filterTableView.dequeueReusableCell(withIdentifier: "PlannedFilterFloatTableViewCell") as! PlannedFilterFloatTableViewCell
        cell.initCell(indexPath: indexPath)
        return cell
    }
    
    
}
