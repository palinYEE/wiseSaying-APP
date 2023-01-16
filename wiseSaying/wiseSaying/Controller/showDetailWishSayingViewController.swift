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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
