//
//  BCUITests.swift
//  App
//
//  Created by gnksbm on 2/19/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import XCTest

final class BCUITests: XCTestCase {
    @MainActor override func setUpWithError() throws {
        continueAfterFailure = false
        
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    override func tearDownWithError() throws {
    }

    @MainActor func testExample() throws {
        // MARK: Launch
        let app = XCUIApplication()
        app.launch()
        snapshot("0_EmptyFavorites")
        // MARK: BusStopVC에서 즐겨찾기 추가하고 BusStopVC Snapshot
        let btnForSearch = app.buttons["버스 정류장을 검색하세요"]
        btnForSearch.tap()
        addUIInterruptionMonitor(
            withDescription: "‘버스어디’ 앱이 사용자의 위치를 사용하도록 허용하겠습니까?"
        ) { alert in
            alert.buttons["한 번 허용"].tap()
            return true
        }
        sleep(5)
        snapshot("2_RecentSearch")
        let searchNavigationBar = app.navigationBars["SearchFeature.SearchView"]
        searchNavigationBar
            .textFields["버스 정류장을 검색하세요"]
            .tap()
        searchNavigationBar.textFields["버스 정류장을 검색하세요"]
            .typeText("은곡마을")
        
        app.tables.cells.containing(
            .staticText,
            identifier:"23412 | 세곡푸르지오.은곡삼거리 방면"
        ).staticTexts["23412 | 세곡푸르지오.은곡삼거리 방면"].tap()
        
        let elementsQuery = app.scrollViews.otherElements
        let tablesQuery = elementsQuery.tables
        
        tablesQuery.cells.containing(
            .staticText,
            identifier:"6600"
        ).buttons["favorite"].tap()
        tablesQuery.cells.containing(
            .staticText,
            identifier:"강남06"
        ).buttons["favorite"].tap()
        tablesQuery.cells.containing(
            .staticText,
            identifier:"452"
        ).buttons["favorite"].tap()
        tablesQuery.cells.containing(
            .staticText,
            identifier:"741"
        ).buttons["favorite"].tap()
        snapshot("4_BusStop")
        
        elementsQuery.buttons["Back"].tap()
        
        searchNavigationBar
            .textFields["은곡마을"]
            .buttons["Clear text"]
            .tap()
        
        searchNavigationBar
            .textFields["버스 정류장을 검색하세요"]
            .typeText("신분당선")
        snapshot("3_Search")
        
        app.tables.cells.containing(
            .staticText,
            identifier:"22010 | 지하철2호선강남역 방면"
        ).staticTexts["22010 | 지하철2호선강남역 방면"].tap()
        
        tablesQuery.cells.containing(
            .staticText,
            identifier:"140"
        ).buttons["favorite"].tap()
        tablesQuery.cells.containing(
            .staticText,
            identifier:"400"
        ).buttons["favorite"].tap()
        tablesQuery.cells.containing(
            .staticText,
            identifier:"1550광주"
        ).buttons["favorite"].tap()
        
        // MARK: Home에 돌아가 즐겨찾기 추가된 화면 Snapshot
        elementsQuery.buttons["Back"].tap()
        searchNavigationBar.buttons["Back"].tap()
        snapshot("1_Favorites")
        
        // MARK: NearMapVC로 이동해 10초 기다린뒤(위치정보 받은 뒤) Snapshot
        btnForSearch.tap()
        app.buttons
            .containing(
                .staticText,
                identifier: "주변정류장"
            )
            .element
            .tap()
        sleep(10)
        snapshot("5_NearMap")
        
        // MARK: AlarmTab으로 이동해 정류장 선택 후 요일 버튼을 누른 뒤 Snapshot
        let alarmTabBtn = XCUIApplication()
            .tabBars["Tab Bar"]
            .buttons["알람"]
        alarmTabBtn.tap()
        
        app.tabBars["Tab Bar"]
            .buttons["알람"]
            .tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["추가하기"]/*[[".buttons[\"추가하기\"].staticTexts[\"추가하기\"]",".staticTexts[\"추가하기\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
            .tap()
        addUIInterruptionMonitor(
            withDescription: "‘버스어디’에서 알림을 보내고자 합니다."
        ) { alert in
            alert.buttons["허용"].tap()
            return true
        }
        app.buttons["정류장 및 버스 찾기"]
            .tap()
        app.navigationBars["SearchFeature.SearchView"]
            .textFields["버스 정류장을 검색하세요"]
            .tap()
        app.navigationBars["SearchFeature.SearchView"]
            .textFields["버스 정류장을 검색하세요"]
            .typeText("은곡마을")
        app.tables
            .cells
            .containing(
                .staticText,
                identifier: "23412 | 세곡푸르지오.은곡삼거리 방면"
            )
            .staticTexts["23412 | 세곡푸르지오.은곡삼거리 방면"]
            .tap()
        
        app.scrollViews
            .otherElements
            .tables
            .cells
            .containing(
                .staticText,
                identifier: "2412"
            )
            .staticTexts["2412"]
            .tap()
        
        let datePicker = app.datePickers.pickerWheels
        datePicker.element(boundBy: 0).adjust(toPickerWheelValue: "7")
        datePicker.element(boundBy: 1).adjust(toPickerWheelValue: "30")
        datePicker.element(boundBy: 2).adjust(toPickerWheelValue: "AM")
        
        app.staticTexts["월"].tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["화"]/*[[".buttons[\"화\"].staticTexts[\"화\"]",".staticTexts[\"화\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.staticTexts["수"].tap()
        app.staticTexts["목"].tap()
        app.staticTexts["금"].tap()
        snapshot("6_RegularAlarm")
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
