//
//  detailWiseSayingViewController.swift
//  wiseSaying
//
//  Created by yoon-yeoungjin on 2023/01/03.
//

import UIKit
import CoreData

class detailWiseSayingViewController: UIViewController {

    @IBOutlet weak var authorField: UITextField!
    @IBOutlet weak var bodyField: UITextField!
    
    var keyboardUpFlag: Bool = false
    
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
        if !self.keyboardUpFlag{
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
        if self.keyboardUpFlag {
            if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                self.view.frame.origin.y += keyboardHeight
                self.keyboardUpFlag = false
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
        guard let managedContext = createAppDelegateViewContext() else {return}
        // managedContext 내부에 있는 entity 호출
        let entity = NSEntityDescription.entity(forEntityName: "UserData", in: managedContext)!
        
        // entity 객체 생성
        let object = NSManagedObject(entity: entity, insertInto: managedContext)
        object.setValue(bodyField.text ?? "", forKey: "body")
        object.setValue(authorField.text ?? "", forKey: "author")
        object.setValue(UUID(), forKey: "uuid")
        object.setValue(Date(), forKey: "date")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
