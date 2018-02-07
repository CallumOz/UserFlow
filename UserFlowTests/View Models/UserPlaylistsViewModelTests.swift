//
//  UserPlaylistsViewModelTests.swift
//  UserFlowTests
//
//  Created by Callum Henshall on 03/02/2018.
//  Copyright © 2018 Callum Henshall. All rights reserved.
//

import XCTest
@testable import UserFlow
import RxSwift

class UserPlaylistsViewModelTests: XCTestCase {

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
        let viewModel = UserPlaylistsViewModel(
            router: MockUserPlaylistsRouter(),
            interactor: MockUserPlaylistsInteractor()
        )

        XCTAssertEqual(viewModel.playlists.value.count, 0)
        XCTAssertEqual(viewModel.isLoading.value, false)
    }
}

