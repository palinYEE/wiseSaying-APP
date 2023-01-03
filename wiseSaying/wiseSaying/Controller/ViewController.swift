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
    
    private func backgroundViewImageSetting() {
        // main view 에서 백그라운드 이미지 셋팅하는 함수 추가 필요
    }
    
    private func navigationBarSetting() {
        self.title = "wiseSaying"
        
    }
    @IBAction func wiseSayingPlus(_ sender: Any) {
        performSegue(withIdentifier: "detailWiseSaying", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundViewImageSetting()
        navigationBarSetting()
        tableViewSetting()
        // Do any additional setup after loading the view.
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wishSayingTableViewCell", for: indexPath) as! wishSayingTableViewCell
        return cell
    }
    
    
}
