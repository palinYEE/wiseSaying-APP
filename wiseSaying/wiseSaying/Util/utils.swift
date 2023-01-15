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
 CoreData 에서 데이터를 읽는 함수
 - Returns:[NSManagedObject] 데이터 객체
 */
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

/**
 CoreData 에서 데이터를 삭제하는 함수
 - Parameter datasList: [NSManagedObject] 형식의 데이터로 삭제할 데이터가 들어있는 Array
 */
func deleteCoreData(datasList: [NSManagedObject]) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let managedContext = appDelegate.persistentContainer.viewContext
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

