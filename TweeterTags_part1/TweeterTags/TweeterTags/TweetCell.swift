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
        //cellImg = nil //if i could set a placeholder image here this might work?? -No

        guard (tweet != nil) else {
            return
        }
        tName?.text = "\(tweet!.user)"
        tText?.text = "\(tweet!.text)"
        tName.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        let date = tweet?.created
        let justTime = DateFormatter()
        justTime.dateFormat = "HH:MM a"
        cellDate?.text = justTime.string(from: date!)
    }
}
