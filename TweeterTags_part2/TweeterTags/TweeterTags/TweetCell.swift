//
//  TweetCell.swift
//  TweeterTags
//
//  Created by James Dorrian on 20/03/2017.
//  Copyright © 2017 JD_13369451. All rights reserved.
//

import UIKit
class TweetCell: UITableViewCell {
    var tweet: TwitterTweet? {
        didSet {
            updateCell()
        }
    }
    
    @IBOutlet var tText: UILabel!
    @IBOutlet var tName: UILabel!
    @IBOutlet var cellDate: UILabel!
    @IBOutlet var cellImg: UIImageView!

    
    fileprivate func updateCell() {
        
        tText?.attributedText = nil
        tName?.text = nil
        cellDate?.text = nil
//        cellImg = nil //if i could set a placeholder image here this might work?? -No

        guard (tweet != nil) else {
            return
        }

        let hashtag = tweet?.hashtags
        let urls = tweet?.urls
        let mentions = tweet?.userMentions
        let attributedString = NSMutableAttributedString(string:tweet!.text)

        for tag in hashtag!{
        let range = (tweet!.text as NSString).range(of: tag.keyword)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red , range: range)
        }
        for url in urls!{
            let range = (tweet!.text as NSString).range(of: url.keyword)
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blue , range: range)
        }
        for mention in mentions!{
            let range = (tweet!.text as NSString).range(of: mention.keyword)
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.green , range: range)
        }
        tText?.attributedText = attributedString
        tName?.text = "\(tweet!.user)"
        tName.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        let date = tweet?.created
        let justTime = DateFormatter()
        justTime.dateFormat = "HH:MM a"
        cellDate?.text = justTime.string(from: date!)
    }
}
