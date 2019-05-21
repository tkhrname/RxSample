//
//  RxSampleTests.swift
//  RxSampleTests
//
//  Created by 渡邊丈洋 on 2019/04/29.
//  Copyright © 2019 渡邊丈洋. All rights reserved.
//

import XCTest
@testable import RxSample

class RxSampleTests: XCTestCase {
    
    var subject: SearchEventViewController!
    var fakePresenter: FakeSearchEventPresenter!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTContext.runActivity(named: "PresenterのdidTapSearchButtonが呼ばれること") { activity in
            print(activity)
            let subject = SearchEventViewController()
            let fakePresenter = FakeSearchEventPresenter()
            subject.inject(presenter: fakePresenter)
            let searchBar = UISearchBar()
            searchBar.text = "hogehoge"
            
            subject.searchBarSearchButtonClicked(searchBar)
            
            XCTAssertEqual(fakePresenter.didTapSearchButton_arguments, "hogehoge")
        }
    }
    
    func test_updateBableViewが呼ばれた時にイベントが表示される() {
        let events = ["nobunaga", "hideyoshi", "ieyasu"]
        XCTContext.runActivity(named: "eventプロパティが更新されること") { _ in
            self.subject = SearchEventViewController()
            self.fakePresenter = FakeSearchEventPresenter()
            self.subject.inject(presenter: self.fakePresenter)
            subject.updateTableView(events: events)
            XCTAssertEqual(subject.events, events)
        }
        XCTContext.runActivity(named: "tableViewのセルが更新されること") { _ in
            self.subject = SearchEventViewController()
            self.fakePresenter = FakeSearchEventPresenter()
            self.subject.inject(presenter: self.fakePresenter)
            self.subject.loadViewIfNeeded()
            XCTAssertEqual(self.subject.tableView.numberOfRows(inSection: 0), 0)
            self.subject.updateTableView(events: events)
            XCTAssertEqual(self.subject.tableView.numberOfRows(inSection: 0), 3)
        }
    }
    
    func test_didTapSearchButtonのテスト() {
        XCTContext.runActivity(named: "エラーが起きた時displayErrorが呼ばれる") { _ in
            let viewcontroller = SearchEventViewController()
            let model = SearchEventModel()
            let presenter = SearchEventPresenter(viewController: viewcontroller, model: model)
            presenter.didTapSearchButton(text: "test")
            
        }
    }
    

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
