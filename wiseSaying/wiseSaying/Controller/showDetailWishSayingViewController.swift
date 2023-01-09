//
//  showDetailWishSayingViewController.swift
//  wiseSaying
//
//  Created by yoon-yeoungjin on 2023/01/09.
//

import UIKit

class showDetailWishSayingViewController: UIViewController {
    
    var senderDateString: String = ""
    var senderAuthor: String = ""
    var senderBody: String = ""

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
