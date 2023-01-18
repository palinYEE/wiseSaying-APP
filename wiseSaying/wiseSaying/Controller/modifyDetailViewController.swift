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
    
    /**
     데이터 수정 버튼 클릭 시 나오는 경고 문구 함수
     - Parameters:
        - title: String 변수로 경고 문구의 title 데이터
        - message: String 변수로 경고 문구의 body 데이터
     */
    func updateOutputAlert(title : String, message : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "확인", style: .default) { (_) in
            updateCoreData(uuid: self.uuid, author: self.authorField.text ?? "", body: self.bodyField.text ?? "", title: self.titleField.text ?? "")
            self.navigationController?.popViewController(animated: true)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(cancel)
        alertController.addAction(okButton)
        return self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func modifyAction(_ sender: Any) {
        updateOutputAlert(title: "수정", message: "데이터 수정 하시겠습니까?")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
