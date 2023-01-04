//
//  utils.swift
//  wiseSaying
//
//  Created by yoon-yeoungjin on 2023/01/04.
//

import Foundation

func currentTimeGet() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter.string(from: Date())
}
