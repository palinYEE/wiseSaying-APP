//
//  showDetailWishSayingViewController.swift
//  wiseSaying
//
//  Created by yoon-yeoungjin on 2023/01/09.
//

import UIKit
import UserNotifications

class showDetailWishSayingViewController: UIViewController {
    
    var senderDateString: String = ""
    var senderAuthor: String = ""
    var senderBody: String = ""
    var senderTitle: String = ""

    @IBOutlet weak var dateString: UILabel! {
        didSet {
            dateString.text = senderDateString
        }
    }
    @IBOutlet weak var author: UILabel! {
        didSet {
            author.text = senderAuthor
        }
    }
    @IBOutlet weak var body: UILabel! {
        didSet {
            body.text = senderBody
        }
    }
    @IBOutlet weak var Showtitle: UILabel! {
        didSet {
            Showtitle.text = senderTitle
        }
    }
    
    @IBAction func notiificationTextButton(_ sender: Any) {
        let content = UNMutableNotificationContent()
        content.title = Showtitle.text ?? ""
        content.body = body.text ?? ""
        content.badge = 1
        
//        let imageName = "image"
        //        let imagePath = Bundle.main.path(forResource: imageName, ofType: "", inDirectory: "Assets.xcassets") ?? ""
//        let imagePath = Bundle.main.path(forResource: imageName, ofType: "png", inDirectory: "Assets.xcassets")!
//        let imageUrl = URL(fileURLWithPath: imagePath)
        
//        let attachment = try! UNNotificationAttachment(identifier: imageName, url: imageUrl, options: .none)
//        content.attachments = [attachment]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: "notificationTest", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
