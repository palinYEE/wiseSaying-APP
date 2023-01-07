//
//  ViewController.swift
//  wiseSaying
//
//  Created by yoon-yeoungjin on 2023/01/01.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var wiseSayingTableView: UITableView!
    
    var mainDatas: [NSManagedObject] = []
    var deleteDatas: [NSManagedObject] = []
    
    private func tableViewSetting() {
        self.wiseSayingTableView.dataSource = self
        self.wiseSayingTableView.delegate = self
    }
    
    private func navigationBarSetting() {
        self.title = "wiseSaying"
    }
    
    // 데이터 추가 버튼
    @IBAction func wiseSayingPlus(_ sender: Any) {
        performSegue(withIdentifier: "detailWiseSaying", sender: nil)
    }
    
    // 데이터 삭제 버튼
    @IBAction func wiseSayingDelete(_ sender: Any) {
        if wiseSayingTableView.isEditing {
            wiseSayingTableView.setEditing(false, animated: true)
        } else {
            wiseSayingTableView.setEditing(true, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        do {
            let loadDatas: [NSManagedObject] = try readCoreData()!
            self.mainDatas = loadDatas
            self.wiseSayingTableView.reloadData()
        } catch {
            print(error)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarSetting()
        tableViewSetting()
        // Do any additional setup after loading the view.
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wishSayingTableViewCell", for: indexPath) as! wishSayingTableViewCell
        cell.author.text = mainDatas[indexPath.row].value(forKey: "author") as? String
        cell.body.text = mainDatas[indexPath.row].value(forKey: "body") as? String
        let date = mainDatas[indexPath.row].value(forKey: "date") as? Date
        cell.dateString.text = convert(date: date!)
        
        if self.isEditing {
             self.wiseSayingTableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableView.ScrollPosition.none)
        }

        return cell
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.wiseSayingTableView.setEditing(editing, animated: true)

        self.wiseSayingTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing{
            print(indexPath.row, mainDatas[indexPath.row])
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            print(indexPath.row, mainDatas[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.init(rawValue: 3)!
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
      return true
    }

}
