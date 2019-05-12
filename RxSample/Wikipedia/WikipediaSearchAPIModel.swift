//
//  WikipediaSearchAPIModel.swift
//  RxSample
//
//  Created by 渡邊丈洋 on 2019/05/07.
//  Copyright © 2019 渡邊丈洋. All rights reserved.
//

import Foundation
import RxSwift

class WikipediaSearchAPIModel {
    
    let client = WikipediaAPIClient()
    
    // wikipedia検索実体 Wikipedia APIでの検索結果をObservableで扱えるようにするためのメソッド
    func searchWikipedia(_ parameters:[String:String]) -> Observable<[ResultWiki]> {
        // [Result]型のObservableオブジェクトを生成
        return Observable<[ResultWiki]>.create { (observer) -> Disposable in
            // Wikipedia APIへHTTPリクエストを送信
            let request = self.client.getRequest(parameters).responseJSON{ response in    // -------（1）
                // 結果にエラーがあればonErrorに渡して処理を終える
                if let error = response.error {    // -------（2）
                    observer.onError(error)
                }
                // 結果をパースして[Result]に変換
                let results = self.parseJson(response.result.value as? [String: Any] ?? [:])    // -------（3）
                // onNextに渡す
                observer.onNext(results)
                // 完了
                observer.onCompleted()
            }
            return Disposables.create { request.cancel() }
        }
    }
    
    // JSON解析メソッド  ＊前回のサンプルと同様
    private func parseJson(_ json: Any) -> [ResultWiki] {
        guard let items = json as? [String: Any] else { return [] }
        var results = [ResultWiki]()
        // JSONの階層を追って検索結果を配列で返す
        if let queryItems = items["query"] as? [String:Any] {
            if let searchItems  = queryItems["search"] as? [[String: Any]] {
                searchItems.forEach{
                    guard let title = $0["title"] as? String,
                        let pageid = $0["pageid"] as? Int else {
                            return
                    }
                    results.append(ResultWiki(title: title, pageid: pageid))
                }
            }
        }
        return results
    }
}
