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
    @IBOutlet weak var repeatTimeTextField: UITextField!
    
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
    
    @objc func tapDone() {
        if let datePicker = self.repeatTimeTextField.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateStyle = .medium // 2-3
            self.repeatTimeTextField.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.repeatTimeTextField.resignFirstResponder() // 2-5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textViewPlaceholder()
        self.authorField.addTarget(self, action: #selector(selectAuthorTextField(_:)), for: .editingDidBegin)
        self.repeatTimeTextField.setInputViewDatePicker(target: self, selector: #selector(tapDone))
    }
}

extension detailWiseSayingViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}

extension UITextField {
    func setInputViewDatePicker(target: Any, selector: Selector) {
        // UIDatePicker 오브젝트 선언 및 위치 셋팅
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y:0 , width: screenWidth, height: 216))
        datePicker.datePickerMode = .date
        
        if #available(iOS 14, *) {
//            datePicker.preferredDatePickerStyle = .wheels
            datePicker.sizeToFit()
        }
        self.inputView = datePicker
        // 툴바 생성 및 inputAccessoryView 에 등록
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
        self.inputAccessoryView = toolBar //9
        
    }
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
}
