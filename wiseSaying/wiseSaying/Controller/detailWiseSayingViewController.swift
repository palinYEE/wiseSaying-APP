//
//  detailWiseSayingViewController.swift
//  wiseSaying
//
//  Created by yoon-yeoungjin on 2023/01/03.
//

import UIKit

class detailWiseSayingViewController: UIViewController {

    @IBOutlet weak var authorField: UITextField!
    @IBOutlet weak var bodyField: UITextField!
    
    @IBAction func finishButton(_ sender: Any) {
        let inputData: wiseSayingModel = .init(bodyText: bodyField.text ?? "", author: authorField.text ?? "", datetime: currentTimeGet())
        mainData.append(inputData)
        print(inputData)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
