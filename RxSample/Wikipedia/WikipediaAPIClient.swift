//
//  WikipediaAPIClient.swift
//  RxSample
//
//  Created by 渡邊丈洋 on 2019/05/07.
//  Copyright © 2019 渡邊丈洋. All rights reserved.
//

import Foundation

// Wikipwdia APIだけでなく、他のAPIなどにも拡張できるように先にプロトコルから作成
protocol APIClient {
    var url: String { get }
    func getRequest(_ parameters: [String : String]) -> URLRequest
}
