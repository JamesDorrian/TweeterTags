//
//  TweetsTVC.swift
//  TweeterTags
//
//  Created by James Dorrian on 20/03/2017.
//  Copyright © 2017 JD_13369451. All rights reserved.
//

/////N.B. This is a version i created by removing files, some remenants of part 2 may still be in here but I removed everything I could find
import UIKit

class TweetsTVC: UITableViewController,UITextFieldDelegate{
    
    @IBOutlet weak var twitterQueryTextField: UITextField!{
        didSet {
            twitterQueryTextField.delegate = self
            twitterQueryTextField.text = twitterQueryText
        }
    }

    
    var tweets = [[TwitterTweet]]()
    var twitterQueryText:String = "#ucd"{
        didSet{
            lastSuccessfulRequest = nil
            twitterQueryTextField?.text = twitterQueryText
            tweets.removeAll()
            tableView.reloadData()
            refresh()
        }
    }
    
    fileprivate var lastSuccessfulRequest: TwitterRequest?
    
    fileprivate var nextRequestToAttempt: TwitterRequest? {
        guard (lastSuccessfulRequest != nil) else {
            guard (twitterQueryTextField != nil) else {
                return nil
            }
            return TwitterRequest(search: twitterQueryText, count: 15)
        }
        return lastSuccessfulRequest!.requestForNewer
    }
    
    fileprivate func refresh(_ sender: UIRefreshControl?) {
        guard let request = nextRequestToAttempt else {
            sender?.endRefreshing()
            return
        }
        request.fetchTweets { (newTweets) -> Void in
            DispatchQueue.main.async { () -> Void in
                if newTweets.count > 0 {
                    self.lastSuccessfulRequest = request
                    self.tweets.insert(newTweets, at: 0)
                    self.tableView.reloadData()
                }
                sender?.endRefreshing()
            }
        }
    }
    
    func refresh() {
        refreshControl?.beginRefreshing()
        refresh(refreshControl)
    }
    
    override func viewDidLoad() {
        twitterQueryTextField.delegate = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        refresh()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        twitterQueryText = textField.text!
        twitterQueryTextField.resignFirstResponder()
        return true
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweets.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweeterCell", for: indexPath) as! TweetCell
        let tweet = tweets[indexPath.section][indexPath.row]
        let url = tweet.user.profileImageURL!
        do {
            let data = try Data(contentsOf: url)
            print("REACHED")
            cell.imageView?.image = UIImage(data: data)
        } catch {
            print("received this error:\n\(error.localizedDescription)")
        }
        cell.tweet = tweets[indexPath.section][indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showInfo"{
            if let destination =  segue.destination as? MentionVC{
                if let index = self.tableView.indexPathForSelectedRow{
                    destination.tweet = tweets[index.section][index.row]
                }
            }
        }
    }
}
