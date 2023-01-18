//
//  detailWiseSayingViewController.swift
//  wiseSaying
//
//  Created by yoon-yeoungjin on 2023/01/03.
//

import UIKit
import CoreData

class detailWiseSayingViewController: UIViewController {

    @IBOutlet weak var bodyField: UITextView!
    @IBOutlet weak var authorField: UITextField!
    @IBOutlet weak var titleField: UITextField!
    var placeholderLabel : UILabel!
    
    var keyboardUpFlag: Bool = true
    var authorFieldEditing: Bool = false
    
    /**
     UITextView 에 Placeholder 셋팅하는 함수
     */
    func textViewPlaceholder(){
        bodyField.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "명언을 입력해 주세요..."
        placeholderLabel.font = .italicSystemFont(ofSize: (bodyField.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        bodyField.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (bodyField.font?.pointSize)! / 2)
        placeholderLabel.textColor = .tertiaryLabel
        placeholderLabel.isHidden = !bodyField.text.isEmpty
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.addKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.removeKeyboardNotifications()
    }

    
    @IBAction func finishButton(_ sender: Any) {
        createCoreData(author: authorField.text ?? "",
                       body: bodyField.text ?? "",
                       title: titleField.text ?? "")
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func selectAuthorTextField(_ sender:Any?){
        self.keyboardUpFlag = false
        self.authorFieldEditing = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textViewPlaceholder()
        self.authorField.addTarget(self, action: #selector(selectAuthorTextField(_:)), for: .editingDidBegin)

    }
}

extension detailWiseSayingViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
