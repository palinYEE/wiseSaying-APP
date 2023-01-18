//
//  modifyDetailViewController.swift
//  wiseSaying
//
//  Created by yoon-yeoungjin on 2023/01/17.
//

import UIKit

class modifyDetailViewController: UIViewController {
    
    var uuid: CVarArg = ""
    var senderAuthor: String = ""
    var senderBody: String = ""
    var senderTitle: String = ""

    @IBOutlet weak var authorField: UITextField! {
        didSet {
            authorField.text = senderAuthor
        }
    }
    @IBOutlet weak var bodyField: UITextView! {
        didSet {
            bodyField.text = senderBody
        }
    }
    @IBOutlet weak var titleField: UITextField! {
        didSet {
            titleField.text = senderTitle
        }
    }
    
    @IBAction func modifyAction(_ sender: Any) {
        updateCoreData(uuid: uuid, author: authorField.text ?? "", body: bodyField.text ?? "", title: titleField.text ?? "")
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
