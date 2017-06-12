//
//  HistoryTVC.swift
//  TweeterTags
//
//  Created by James Dorrian on 26/03/2017.
//  Copyright © 2017 JD_13369451. All rights reserved.
//

import UIKit

class HistoryTVC: UITableViewController {
    
    var array100:[String]? {
        get {
            return UserDefaults.standard.object(forKey: "last100") as? [String]
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (array100 != nil) {
            return array100!.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell" , for: indexPath)
        print(array100![indexPath.row])
        cell.textLabel?.text = array100![indexPath.row]
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let destination =  segue.destination as? TweetsTVC{
                if let StringSender =  sender as? UITableViewCell{
                    destination.twitterQueryText = (StringSender.textLabel?.text)!
                }
            }
    }

    override func viewDidLoad() {
        self.title="Search History"
    }

}
