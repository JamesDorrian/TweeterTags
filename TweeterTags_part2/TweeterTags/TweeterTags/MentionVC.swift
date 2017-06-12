//
//  MentionVC.swift
//  TweeterTags
//
//  Created by James Dorrian on 20/03/2017.
//  Copyright © 2017 JD_13369451. All rights reserved.
//

import UIKit

class MentionVC: UITableViewController {
    var tweet: TwitterTweet?
    let headings = ["Images","URLs","Hashtags","Users"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = tweet?.user.name
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.headings.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 1){
            if let url = URL(string: (tweet?.urls[indexPath.row].keyword)!) {
                UIApplication.shared.openURL(url as URL)
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return (tweet?.media.count)!
        case 1:
            return (tweet?.urls.count)!
        case 2:
            return (tweet?.hashtags.count)!
        case 3:
            return (tweet?.userMentions.count)!
        default:
            return 0
        }
        
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            if((tweet?.media.count)! > 0){
                return self.headings[section]
            } else {
                return ""
            }
        } else if (section == 1) {
            if((tweet?.urls.count)! > 0){
                return self.headings[section]
            } else {
                return ""
            }
        } else if (section == 2) {
            if((tweet?.hashtags.count)! > 0){
                return self.headings[section]
            } else {
                return ""
            }
        } else if (section == 3 ) {
            if((tweet?.userMentions.count)! > 0){
                return self.headings[section]
            } else {
                return ""
            }
        }
        return ""
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //add 3 new cells so we can enable clicks of each and control which ones are visibile
        //will require if(tweet!.url.count >= 1){display} else {dont display}
        //urlCell
        //hashCell
        //mentionCell
        switch indexPath.section{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MentionCell",for: indexPath) as! MentionCell
            if let url:URL = tweet?.media[indexPath.row].url{
                print(url.absoluteString)
                do {
                    let data = try Data(contentsOf: url)
                    print("REACHED")
                    cell.imageView?.image = UIImage(data: data)
                } catch {
                    print("Received this error:\n\(error.localizedDescription)")
                }
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "urlCell",for: indexPath) as! urlCell
            cell.textLabel?.text = tweet!.urls[indexPath.row].keyword //2nd cell
            print(tweet!.urls[indexPath.row].keyword)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "hashCell",for: indexPath) as! hashCell
            cell.textLabel?.text = tweet!.hashtags[indexPath.row].keyword //3rd cell
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "mentionCell",for: indexPath) as! mentionCell
            cell.textLabel?.text = tweet!.userMentions[indexPath.row].keyword //4th cell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "urlCell",for: indexPath) as! urlCell
            return cell //will be null but doesnt matter
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0){
            return CGFloat(200)
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (sender as? MentionCell) != nil {
            if segue.identifier == "showPicture"{
                if let destination =  segue.destination as? ImageVC{
                    if self.tableView.indexPathForSelectedRow != nil{
                        destination.title = tweet?.user.screenName
                        destination.imageURL = (tweet?.media[0].url)!
                    }
                }
            }
        } else if let mediaCall = sender as? hashCell {
            if segue.identifier == "toTweetsTVC"{
                if let destination =  segue.destination as? TweetsTVC{
                    if self.tableView.indexPathForSelectedRow != nil{
                        destination.twitterQueryText = (mediaCall.textLabel?.text)!
                    }
            }
        }
        } else if let mediaCall = sender as? mentionCell {
            if segue.identifier == "toTweetsTVC"{
                if let destination =  segue.destination as? TweetsTVC{
                    if self.tableView.indexPathForSelectedRow != nil{
                        destination.twitterQueryText = (mediaCall.textLabel?.text)!
                    }
                }
            }
        }
    }
}

