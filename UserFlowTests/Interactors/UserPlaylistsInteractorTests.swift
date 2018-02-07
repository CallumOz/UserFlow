//
//  UserPlaylistsInteractorTests.swift
//  UserFlowTests
//
//  Created by Callum Henshall on 04/02/2018.
//  Copyright © 2018 Callum Henshall. All rights reserved.
//

import XCTest
@testable import UserFlow
import RxSwift
import RxTest
import RxBlocking

class UserPlaylistsInteractorTests: XCTestCase {

    private var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()

        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_initialState() {
        let interactor = UserPlaylistsInteractor(userID: "5")

        XCTAssertTrue(interactor.playlists.value.count == 0)
        XCTAssertTrue(interactor.hasMore.value)
    }

    func test_load_once() {
        let interactor = UserPlaylistsInteractor(userID: "5")

        do {
            let events = try interactor.load().toBlocking(timeout: 5).toArray()

            let expectedEvents: [Void] = []

            XCTAssertEqual(events.count, expectedEvents.count)
        }
        catch {
            XCTFail("Timed out")
        }
    }
}

