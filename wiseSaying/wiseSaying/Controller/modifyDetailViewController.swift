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

    var keyboardUpFlag: Bool = true
    var authorFieldEditing: Bool = false
    
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
     화면 터치시 키보드가 내려가게 하는 함수
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    /**
     노티피케이션을 추가하는 함수
     */
    func addKeyboardNotifications(){
        // 키보드가 나타날 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /**
     키보드가 나타났다는 알림을 받으면 실행할 함수
     */
    @objc func keyboardWillShow(_ noti: NSNotification){
        // 키보드의 높이만큼 화면을 올려준다.
        if !self.keyboardUpFlag && self.authorFieldEditing {
            if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                self.view.frame.origin.y -= keyboardHeight
                self.keyboardUpFlag = true
            }
        }
    }

    /**
     키보드가 사라졌다는 알림을 받으면 실행할 함수
     */
    @objc func keyboardWillHide(_ noti: NSNotification){
        // 키보드의 높이만큼 화면을 내려준다.
        if self.keyboardUpFlag && self.authorFieldEditing {
            if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                self.view.frame.origin.y += keyboardHeight
                self.authorFieldEditing = false
            }
        }
    }

    /**
     노티피케이션을 제거하는 함수
     */
    func removeKeyboardNotifications(){
        // 키보드가 나타날 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func selectAuthorTextField(_ sender:Any?){
        self.keyboardUpFlag = false
        self.authorFieldEditing = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.removeKeyboardNotifications()
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
        self.authorField.addTarget(self, action: #selector(selectAuthorTextField(_:)), for: .editingDidBegin)
    }
}
