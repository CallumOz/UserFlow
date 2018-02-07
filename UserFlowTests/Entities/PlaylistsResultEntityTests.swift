//
//  PlaylistsResultEntityTests.swift
//  UserFlowTests
//
//  Created by Callum Henshall on 07/02/2018.
//  Copyright © 2018 Callum Henshall. All rights reserved.
//

import XCTest
@testable import UserFlow
import SwiftyJSON

class PlaylistsResultEntityTests: XCTestCase {

    override func setUp() {
        super.setUp()

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_init() {
        let url = "https://google.com"

        let json = JSON(dictionaryLiteral:
            ("data", JSON(arrayLiteral:
                JSON(dictionaryLiteral:
                    ("title", JSON(stringLiteral: ""))
                    )
                )
            ),
            ("next", JSON(stringLiteral: url))
        )

        let playlistResult = PlaylistsResultEntity(json: json)

        XCTAssertEqual(playlistResult.data?.count, 1)
        XCTAssertEqual(playlistResult.next, URL(string: url)!)
    }
}

