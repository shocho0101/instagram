//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by 張翔 on 2017/10/18.
//  Copyright © 2017年 sho. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell{
    
    
    
    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var likeLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var captionLabel: UILabel!
    @IBOutlet var commenButton: UIButton!
   
    var postData: PostData!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setPostData(){
        self.postImageView.image = postData.image
        
        var commentText: String = ""
        var count = 0
        for comment in postData.comment{
            let name: String! = comment["name"]!
            let text: String! = comment["comment"]!
            if count == 0{
                commentText = commentText + "\(name!):\(text!)"
            }else{
                commentText = commentText + "\n\(name!):\(text!)"
            }
            count += 1
        }
        
        self.captionLabel.text = commentText
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"
        
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale!
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString: String = formatter.string(from: postData.date! as Date)
        self.dateLabel.text = dateString
        
        if postData.isLiked {
            self.likeButton.setImage(#imageLiteral(resourceName: "like_exist"), for: .normal)
        }else{
            self.likeButton.setImage(#imageLiteral(resourceName: "like_none"), for: .normal)
        }
        
    }
    
    
    
}
