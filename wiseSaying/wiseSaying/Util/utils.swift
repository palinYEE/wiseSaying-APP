//
//  utils.swift
//  wiseSaying
//
//  Created by yoon-yeoungjin on 2023/01/04.
//

import UIKit
import CoreData

/**
 날짜 변환 함수
 - Parameter date: Date 형식의 데이터
 - Returns: "yyyy-MM-dd HH:mm:ss" 형식의 문자열 데이터
 */
func convert(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter.string(from: date)
}

/**
 NSManagedObjectContext 객체를 선언하는 함수
 - Returns: NSManagedObjectContext 객체
 */
func createAppDelegateViewContext() -> NSManagedObjectContext? {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return nil}
    return appDelegate.persistentContainer.viewContext
}

/**
 CoreData 에서 데이터를 읽는 함수
 - Returns:[NSManagedObject] 데이터 객체
 */
func readCoreData() throws -> [NSManagedObject]? {
    guard let managedContext = createAppDelegateViewContext() else {return nil}
    // Entity의 fetchRequest 생성
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserData")
    
    do {
        // fetchRequest를 통해 managedContext로부터 결과 배열을 가져오기
        let resultCDArray = try managedContext.fetch(fetchRequest)
        return resultCDArray
    } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
        throw error
    }
}

/**
 CoreData 에서 데이터를 삭제하는 함수
 - Parameter datasList: [NSManagedObject] 형식의 데이터로 삭제할 데이터가 들어있는 Array
 */
func deleteCoreData(datasList: [NSManagedObject]) {
    guard let managedContext = createAppDelegateViewContext() else {return}
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "UserData")
    
    do {
        for datas in datasList{
            fetchRequest.predicate = NSPredicate(format: "uuid = %@", datas.value(forKey: "uuid") as! CVarArg)
            let test = try managedContext.fetch(fetchRequest)
            let objectToDelete = test[0] as! NSManagedObject
            managedContext.delete(objectToDelete)
            do {
                try managedContext.save()
            } catch {
                print(error)
            }
        }
    } catch {
        print(error)
    }
}

/**
 CoreData에서 데이터를 만드는 함수
 - Parameters:
    - author: (String) 저자 데이터
    - body: (String) 명언 본문 데이터
    - title: (String) 명언 제목 데이터
 */
func createCoreData(author: String, body: String, title: String) {
    guard let managedContext = createAppDelegateViewContext() else {return}
    // managedContext 내부에 있는 entity 호출
    let entity = NSEntityDescription.entity(forEntityName: "UserData", in: managedContext)!
    
    // entity 객체 생성
    let object = NSManagedObject(entity: entity, insertInto: managedContext)
    object.setValue(body, forKey: "body")
    object.setValue(author, forKey: "author")
    object.setValue(UUID(), forKey: "uuid")
    object.setValue(Date(), forKey: "createDate")
    object.setValue(Date(), forKey: "recentDate")
    object.setValue(title, forKey: "wiseTitle")
    
    do {
        try managedContext.save()
    } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
    }
}

/**
 CoreData에서 데이터를 업데이트 하는 함수
 - Parameters:
    - uuid: (CVarArg) 업데이트할 데이터 uuid
    - author: (String) 변경할 저자 데이터
    - body: (String) 변경할 명언 본문 데이터
    - title: (String) 변경할 명언 제목 데이터
 */
func updateCoreData(uuid: CVarArg, author: String, body: String, title: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "UserData")
    fetchRequest.predicate = NSPredicate(format: "uuid = %@", uuid)
    
    do {
        let newData = try managedContext.fetch(fetchRequest)
        let objectUpdate = newData[0] as! NSManagedObject
        objectUpdate.setValue(body, forKey: "body")
        objectUpdate.setValue(author, forKey: "author")
        objectUpdate.setValue(title, forKey: "wiseTitle")
        objectUpdate.setValue(Date(), forKey: "recentDate")
        do {
            try managedContext.save()
        } catch {
            print(error)
        }
    } catch {
        print(error)
    }
}

/**
 버튼 생성 시 title 및 color 셋팅하는 함수
 - Parameters
    - button: inout UIButton 객체로 title, color 를 셋팅할 버튼 객체
    - title: String 변수로 타이틀 문자열
    - titleColor: UIColor 객체로 타이틀 문자색 설정
    - backgroundColor: UIColor 객체로 버튼의 백그라운드 색 설정
 */
func settingButtonTitleAndColor(button: inout UIButton , title: String, titleColor: UIColor, backgroundColor: UIColor) {
    button.setTitle(title, for: .normal)
    button.setTitleColor(titleColor, for: .normal)
    button.backgroundColor = backgroundColor
}

/**
 버튼 생성 시 ViewController 아래에 위치하도록 셋팅하는 함수
 - Parameters
    - button: UIButton 객체로 위치를 셋팅할 버튼 객체
    - vc: UIViewController 객체로 위치 값 불러올 ViewController
 - Returns
    - NSLayoutConstraint 객체가 리턴된다.
 */
func settingBottombutton(button: UIButton, vc: UIViewController) -> NSLayoutConstraint {
    button.translatesAutoresizingMaskIntoConstraints = false                                // contranint를 코드로 조정할 때 호출하는 코드
    button.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
    button.leftAnchor.constraint(equalTo: vc.view.leftAnchor, constant: 0).isActive = true
    button.rightAnchor.constraint(equalTo: vc.view.rightAnchor, constant: 0).isActive = true
    button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    return button.bottomAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
}

/**
 버튼의 constant 값을 조정하여 버튼 위치를 위아래로 변경하는 함수
 - Parameters
    - button : inout NSLayoutConstraint 객체로 위치 셋팅할 버튼 객체
    - constantValue: CGFloat 변수로 이동할 값
 */
func moveButton(button:inout NSLayoutConstraint ,constantValue: CGFloat) {
    button.constant =  constantValue
}
