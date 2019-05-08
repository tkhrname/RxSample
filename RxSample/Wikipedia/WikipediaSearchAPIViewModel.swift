//
//  WikipediaSearchAPIViewModel.swift
//  RxSample
//
//  Created by 渡邊丈洋 on 2019/05/07.
//  Copyright © 2019 渡邊丈洋. All rights reserved.
//

import Foundation
import RxSwift

class WikipediaSearchAPIViewModel {
    
    var searchWord = Variable<String>("")
    var items = Variable<[Result]>([])
    private let model = WikipediaSearchAPIModel()
    private var disposeBag = DisposeBag()
    // 略
    
    init() {
        // searchWordからWikipedia APIの検索結果を得てitemsにbind
        searchWord.asObservable()
            .filter { $0.count >= 3 }    // -------（1）
            .debounce(0.5, scheduler: MainScheduler.instance)
            .flatMapLatest { [unowned self] str in
                return self.model.searchWikipedia(["srsearch": str])    // -------（2）
            }
            .bind(to: self.items)
            .disposed(by: self.disposeBag)
    }
}
