//
//  wishSayingModel.swift
//  wiseSaying
//
//  Created by yoon-yeoungjin on 2023/01/04.
//

import Foundation

let buttonHideConstant: CGFloat = 100
let buttonShowConstant: CGFloat = 0

struct wiseSayingModel {
    var bodyText: String = ""   /* 명언 내용 */
    var author: String = ""     /* 명언 작성자 */
    var datetime: String = ""   /* 명언 등록 날짜 */
    
    init(bodyText: String, author: String, datetime: String) {
        self.bodyText = bodyText
        self.author = author
        self.datetime = datetime
    }
}

