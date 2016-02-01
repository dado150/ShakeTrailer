//
//  ViewController.swift
//  ShakeTrailer
//
//  Created by DAdo150 on 2/1/16.
//  Copyright © 2016 DAdo150. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var movieScreen: UIView!
    
    @IBAction func menu(sender: UIButton) {
    }
    
    @IBAction func saveButton(sender: UIButton) {
    }
    
    struct MovieBlock {
        var movieID = String()
        var displayTitle = String()
    }
    
    var movieList: [MovieBlock] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=50&playlistId=UUKVtW8ExxO21F2sNLtwrq_w&key=AIzaSyAJjIyppyws7NCRVBwKYWBjw1mAkpD05wQ")
        
        //        UUKVtW8ExxO21F2sNLtwrq_w
        
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error)
            } else {
                
                
                let jsonResult = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                let items = jsonResult["items"] as! NSArray
                for item in items {
                    
                    let infoVideo = item["snippet"] as! NSDictionary
                    let resources = infoVideo["resourceId"] as! NSDictionary
                    let videoId = resources["videoId"] as! String
                    let titolo = (infoVideo["title"] as? String)!
                    let finalTitle = self.shortenTitle(titolo)
                    
                    let movieBox:MovieBlock = MovieBlock(movieID: videoId, displayTitle: finalTitle)
                    self.movieList.append(movieBox)
                }
                
            }
            
        })
        task.resume()
    
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        movieScreen.layer.cornerRadius = 8

  
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
            let number: Int = 49
            let randomNumber = Int(arc4random_uniform(UInt32(number)))
            print(self.movieList[randomNumber].displayTitle)
        
            titleLabel.text = shortenTitle(self.movieList[randomNumber].displayTitle)
    }
    
    

    func shortenTitle(realTitle:String) -> String{
        
        if realTitle.rangeOfString("Official") != nil {
            
            let delimiter = "- Official"
            let newstr = realTitle
            var shortTitle = newstr.componentsSeparatedByString(delimiter)
            return shortTitle[0]
            //                            self.titleVideo.text = FinalTitle
            
        } else{
            
            return realTitle
            
        }
    }

}

