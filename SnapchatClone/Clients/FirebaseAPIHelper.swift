//
//  FirebaseAPIHelper.swift
//  
//
//  Created by Will Oakley on 10/24/18.
//

import Foundation
import Firebase
import FirebaseStorage

class FirebaseAPIClient {
    
    static func getSnaps(completion: @escaping ([SnapImage]) -> ()) {
        /* PART 2A START */
        var images : [SnapImage] = []
        let ref = Database.database().reference()
        let imageRef = ref.child("snapImages")
        imageRef.observe(.value, with: { (snapshot) in
            for snap in snapshot.children {
                let newSnap = snap as! DataSnapshot
                let dict = newSnap.value as! [String:Any]
                let imageName = dict["imageURL"]
                let storage = Storage.storage().reference(forURL: imageName as! String)
                storage.downloadURL(completion: { (url, error) in
                    do {
                        let data = try Data(contentsOf: url!)
                        let image = UIImage(data: data as Data)
                        let toAppend = SnapImage(sentBy: dict["sentBy"] as! String, sentTo: dict["sentTo"] as! String, timeSent: dict["timeSent"] as! String, image: image!)
                        images.append(toAppend)
                        print("added image")
                    } catch let error as NSError {
                        print ("Error getting image: %@", error)
                    }
                })
            }
            completion(images)
            
        })
        /* PART 2A FINISH */
    }
}
