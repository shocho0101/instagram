//
//  PostData.swift
//  Instagram
//
//  Created by 張翔 on 2017/10/18.
//  Copyright © 2017年 sho. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class PostData: NSObject{
    var id: String?
    var image: UIImage?
    var imageString: String?
    var name: String?
    var caption: String?
    var date: NSDate?
    var likes: [String] = []
    var isLiked: Bool = false
    var comment: [[String: String?]]
    
    init(snapshot: DataSnapshot, myID: String) {
        self.id = snapshot.key
        
        let ValueDictionary = snapshot.value as! [String: Any]
        
        imageString = ValueDictionary["image"] as? String
        image = UIImage(data: NSData(base64Encoded: imageString!, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)! as Data)
        
        self.name = ValueDictionary["name"] as? String
        
        let time = ValueDictionary["time"] as? String
        self.date = NSDate(timeIntervalSinceReferenceDate: TimeInterval(time!)!)
        
        if let likes = ValueDictionary["likes"] as? [String]{
            self.likes = likes
        }
        
        for likeId in self.likes{
            if likeId == myID{
                self.isLiked =  true
                break
            }
        }
        
        comment = ValueDictionary["comment"] as! [[String: String?]]
    }
    
}

