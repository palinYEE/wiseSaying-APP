//
//  ViewController.swift
//  wiseSaying
//
//  Created by yoon-yeoungjin on 2023/01/01.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var wiseSayingTableView: UITableView!    // TableView 객체
    var bottomButton: NSLayoutConstraint?                   // 데이터 삭제 확인 버튼 객체
    var mainDatas: [NSManagedObject] = []                   // 데이터 저장 Array
    var deleteDatas: [NSManagedObject] = []                 // 삭제할 데이터 저장 Array
    
    /**
    네비게이션 바의 왼쪽 상단 삭제 버튼 클릭 시 삭제 버튼 생성 함수.삭제할 데이터를 선택 하지 않았을 경우 "삭제할 데이터를 선택해 주세요." 문구가 나오고, 데이터를 선택했을 경우 선택한 데이터 개수가 문구로 나온다. 해당 버튼을 클릭시 경고 문구가 출력되면서 확인 버튼을 누르면 데이터를 삭제한다.
     */
    func makeButton() {
        let button = UIButton()
        button.setTitle("삭제할 데이터를 선택해 주세요.", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(deleteDataFunc), for: .touchUpInside)
        
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
    
    func showButton() {
        bottomButton?.constant = 0
    }
    
    func hideButton() {
        bottomButton?.constant = 100
    }
    
    /**
     데이터 삭제 버튼 클릭 시 나오는 경고 문구 함수
     - Parameters:
        - title: String 변수로 경고 문구의 title 데이터
        - message: String 변수로 경고 문구의 body 데이터
     */
    func Output_Alert(title : String, message : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "확인", style: .default) { (_) in
            /* 데이터 삭제 함수 추가 필요 */
            deleteCoreData(datasList: self.deleteDatas)
            if self.deleteDatas.count > 0 {
                for data in self.deleteDatas {
                    self.mainDatas.removeAll { ($0.value(forKey: "uuid") as? UUID) ==  (data.value(forKey: "uuid") as? UUID)}
                }
            }
            self.wiseSayingTableView.reloadData()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(cancel)
        alertController.addAction(okButton)
        return self.present(alertController, animated: true, completion: nil)
    }
    
    /**
    경고 문구를 나타나게 하는 함수
     */
    @objc func deleteDataFunc(){
        if deleteDatas.isEmpty {
            Output_Alert(title: "경고", message: "선택한 데이터가 없습니다.")
        } else {
            Output_Alert(title: "경고", message: "\(deleteDatas.count)개 데이터를 삭제하시겠습니까?")
        }
    }
    
    /**
     UiTableView의 dataSource, delegate  객체를 선언하는 함수
     */
    private func tableViewSetting() {
        self.wiseSayingTableView.dataSource = self
        self.wiseSayingTableView.delegate = self
    }
    
    /**
     네이게이션 바 title 셋팅 함수
     */
    private func navigationBarSetting() {
        self.title = "wiseSaying"
    }
    
    /**
     네비게이션 바에서 + 버튼 클릭시 입력 화면이 뜨는 Controller으로 넘어가는 함수
     */
    @IBAction func wiseSayingPlus(_ sender: Any) {
        performSegue(withIdentifier: "detailWiseSaying", sender: nil)
    }
    
    /**
    Segue 에 데이터를 넘겨주는 함수
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailWiseSaying" {
            let vc = segue.destination as! showDetailWishSayingViewController
            let indexPath = sender as! IndexPath
            let date = mainDatas[indexPath.row].value(forKey: "date") as? Date
            vc.senderDateString = convert(date: date!)
            vc.senderAuthor = (mainDatas[indexPath.row].value(forKey: "author") as? String)!
            vc.senderBody = (mainDatas[indexPath.row].value(forKey: "body") as? String)!
        }
    }
    
    /**
     네비게이션바에서 삭제 버튼 클릭시 변환 로직 구현 함수
     */
    @IBAction func wiseSayingDelete(_ sender: Any) {
        if wiseSayingTableView.isEditing {
            wiseSayingTableView.reloadData()
            self.hideButton()
            wiseSayingTableView.setEditing(false, animated: true)
        } else {
            self.deleteDatas.removeAll()
            self.bottomButton?.firstItem?.setTitle("삭제할 데이터를 선택해 주세요.", for:.normal)
            wiseSayingTableView.reloadData()
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
            performSegue(withIdentifier: "showDetailWiseSaying", sender: indexPath)
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
