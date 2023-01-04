//
//  ViewController.swift
//  wiseSaying
//
//  Created by yoon-yeoungjin on 2023/01/01.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var wiseSayingTableView: UITableView!
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.wiseSayingTableView.reloadData()
        wiseDataClass().mainDataDetail()    /* Debug */
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wishSayingTableViewCell", for: indexPath) as! wishSayingTableViewCell
        return cell
    }
    
    
}
