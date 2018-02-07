//
//  PlaylistEntityTests.swift
//  UserFlowTests
//
//  Created by Callum Henshall on 07/02/2018.
//  Copyright © 2018 Callum Henshall. All rights reserved.
//

import XCTest
@testable import UserFlow
import SwiftyJSON

class PlaylistEntityTests: XCTestCase {
    
    override func setUp() {
        super.setUp()

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_init() {
        let title = "Test title"
        let duration: Int = 42
        let tracklist: String = "https://google.com"
        let picture: String = "https://deezer.com"

        let json = JSON(dictionaryLiteral:
            ("title", JSON(stringLiteral: title)),
                        ("duration", JSON(integerLiteral: duration)),
                        ("tracklist", JSON(stringLiteral: tracklist)),
                        ("picture", JSON(stringLiteral: picture))
        )

        let playlist = PlaylistEntity(json: json)

        XCTAssertEqual(playlist.title, title)
        XCTAssertEqual(playlist.duration, duration)
        XCTAssertEqual(playlist.tracklist, URL(string: tracklist))
        XCTAssertEqual(playlist.picture, URL(string: picture))
        XCTAssertTrue(playlist.creator == nil)
    }
}

