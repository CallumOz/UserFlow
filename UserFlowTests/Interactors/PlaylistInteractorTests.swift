//
//  PlaylistInteractorTests.swift
//  UserFlowTests
//
//  Created by Callum Henshall on 07/02/2018.
//  Copyright © 2018 Callum Henshall. All rights reserved.
//

import XCTest
@testable import UserFlow
import RxSwift
import RxTest
import RxBlocking

class PlaylistInteractorTests: XCTestCase {

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
        let title = "Test title"
        let duration: Int = 42
        let tracklist: URL = URL(string: "https://google.com")!
        let picture: URL = URL(string: "https://deezer.com")!
        let creator: UserEntityType? = nil

        let playlist = MockPlaylistEntity(
            title: title,
            duration: duration,
            tracklist: tracklist,
            picture: picture,
            creator: creator
        )

        let interactor = PlaylistInteractor(playlist: playlist)

        XCTAssertEqual(interactor.hasMore.value, true)
        XCTAssertEqual(interactor.title.value, title)
        XCTAssertEqual(interactor.duration.value, TimeInterval(duration))
        XCTAssertEqual(interactor.logo.value, picture)
        XCTAssertEqual(interactor.author.value, nil)
        XCTAssertEqual(interactor.tracks.value.count, 0)
    }
}

