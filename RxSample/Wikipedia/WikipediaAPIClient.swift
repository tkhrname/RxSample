//
//  WikipediaAPIClient.swift
//  RxSample
//
//  Created by 渡邊丈洋 on 2019/05/07.
//  Copyright © 2019 渡邊丈洋. All rights reserved.
//

import Foundation
import Alamofire

// Wikipwdia APIだけでなく、他のAPIなどにも拡張できるように先にプロトコルから作成
protocol APIClient {
    var url: String { get }
    func getRequest(_ parameters: [String : String]) -> DataRequest
}

// Wikipedia APIを呼び出すクラス
class WikipediaAPIClient: APIClient {
    // Wikipedia APIのエンドポイント
    var url = "https://ja.wikipedia.org/w/api.php?format=json&action=query&list=search"
    
    // Wikipedia APIに向けてHTTPリクエストを実行
    func getRequest(_ parameters: [String : String]) -> DataRequest {
        return Alamofire.request(
            URL(string: url)!,
            method: .get,
            parameters: parameters,
            encoding: URLEncoding.default,
            headers: nil)
    }
    
}
