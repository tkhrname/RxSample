import XCTest
@testable import RxSample

class RxSampleTests: XCTestCase {
    
    var subject: SearchEventViewController!
    var fakePresenter: FakeSearchEventPresenter!

    override func setUp() {
    }

    override func tearDown() {
    }

    func testExample() {
        // UISearchBarのテスト
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
    
    // UITableViewのテスト
    func test_updateBableViewが呼ばれた時にイベントが表示される() {
        let events = ["nobunaga", "hideyoshi", "ieyasu"]
        XCTContext.runActivity(named: "eventプロパティが更新されること") { _ in
            let viewcontroller = SearchEventViewController()
            let presenter = FakeSearchEventPresenter()
            viewcontroller.inject(presenter: presenter)
            viewcontroller.updateTableView(events: events)
            XCTAssertEqual(viewcontroller.events, events)
        }
        XCTContext.runActivity(named: "tableViewのセルが更新されること") { _ in
            let viewcontroller = SearchEventViewController()
            let presenter = FakeSearchEventPresenter()
            viewcontroller.inject(presenter: presenter)
            viewcontroller.loadViewIfNeeded()
            XCTAssertEqual(viewcontroller.tableView.numberOfRows(inSection: 0), 0)
            viewcontroller.updateTableView(events: events)
            XCTAssertEqual(viewcontroller.tableView.numberOfRows(inSection: 0), 3)
        }
    }
    
    // Presenterのテスト
    func test_didTapSearchButtonのテスト() {
        XCTContext.runActivity(named: "エラーが起きた時displayErrorが呼ばれる") { _ in
            let viewcontroller = FakeSearchEventViewController()
            let model = SearchEventModel()
            let presenter = SearchEventPresenter(viewController: viewcontroller, model: model)
            presenter.didTapSearchButton(text: "test")
            
            XCTAssertEqual(viewcontroller.dispalayError_callCount, 1)
        }
    }
    
    func testPerformanceExample() {
        self.measure {
        }
    }

}
