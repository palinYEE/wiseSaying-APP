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
    
    @IBAction func finishButton(_ sender: Any) {
        // App Delegate 호출
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
        // App Delegate 내부에 있는 viewContext 호출
        let managedContext = appDelegate.persistentContainer.viewContext
            
        // managedContext 내부에 있는 entity 호출
        let entity = NSEntityDescription.entity(forEntityName: "UserData", in: managedContext)!
            
        // entity 객체 생성
        let object = NSManagedObject(entity: entity, insertInto: managedContext)
        object.setValue(bodyField ?? "", forKey: "body")
        object.setValue(authorField ?? "", forKey: "author")
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
