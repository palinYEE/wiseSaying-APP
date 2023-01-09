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
    var bottomButton: NSLayoutConstraint?  // 버튼 관련 클래스 호출
    
    /**
     버튼 셋팅
     */
    func makeButton() {
        let button = UIButton()
        button.setTitle("삭제할 데이터를 선택해 주세요.", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(deleteData), for: .touchUpInside)
        
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        button.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        bottomButton = button.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        bottomButton?.isActive = true
        
        hideButton()
    }
    

    
    @objc func deleteData(){
        if deleteDatas.isEmpty {
            Output_Alert(vs: self, title: "경고", message: "선택한 데이터가 없습니다.")
        } else {
            Output_Alert(vs: self, title: "경고", message: "\(deleteDatas.count)개 데이터를 삭제하시겠습니까?")
        }
    }
    
    func showButton() {
        bottomButton?.constant = 0
    }
    
    func hideButton() {
        bottomButton?.constant = 100
    }

    
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
            self.hideButton()
            wiseSayingTableView.setEditing(false, animated: true)
        } else {
            self.showButton()
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
        makeButton()
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
            self.deleteDatas.append(mainDatas[indexPath.row])
            self.bottomButton?.firstItem?.setTitle("\(deleteDatas.count)개 선택하였습니다.", for: .normal)
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            self.deleteDatas.removeAll { ($0.value(forKey: "uuid") as? UUID) ==  (mainDatas[indexPath.row].value(forKey: "uuid") as? UUID)}
            if deleteDatas.count > 0 {
                self.bottomButton?.firstItem?.setTitle("\(deleteDatas.count)개 선택하였습니다.", for: .normal)
            } else {
                self.bottomButton?.firstItem?.setTitle("삭제할 데이터를 선택해 주세요.", for:.normal)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.init(rawValue: 3)!
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
      return true
    }

}
