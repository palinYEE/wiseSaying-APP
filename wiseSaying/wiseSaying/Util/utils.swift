//
//  utils.swift
//  wiseSaying
//
//  Created by yoon-yeoungjin on 2023/01/04.
//

import UIKit
import CoreData

func convert(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter.string(from: date)
}

func readCoreData() throws -> [NSManagedObject]? {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
    let managedContext = appDelegate.persistentContainer.viewContext
    
    // Entity의 fetchRequest 생성
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserData")
    
    // 정렬 또는 조건 설정
    //    let sort = NSSortDescriptor(key: "createDate", ascending: false)
    //    fetchRequest.sortDescriptors = [sort]
    //    fetchRequest.predicate = NSPredicate(format: "isFinished = %@", NSNumber(value: isFinished))
    
    do {
        // fetchRequest를 통해 managedContext로부터 결과 배열을 가져오기
        let resultCDArray = try managedContext.fetch(fetchRequest)
        return resultCDArray
    } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
        throw error
    }
}

func Output_Alert(vs: ViewController ,title : String, message : String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    let okButton = UIAlertAction(title: "확인", style: .default) { (action) in
        /* 데이터 삭제 함수 추가 필요 */
    }
    let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    alertController.addAction(cancel)
    alertController.addAction(okButton)
    return vs.present(alertController, animated: true, completion: nil)
}
