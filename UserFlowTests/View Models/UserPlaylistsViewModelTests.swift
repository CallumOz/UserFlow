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
import RxBlocking
import RxTest

class UserPlaylistsViewModelTests: XCTestCase {

    var router: MockUserPlaylistsRouter!
    var interactor: MockUserPlaylistsInteractor!

    var viewModel: UserPlaylistsViewModel!

    private var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()

        disposeBag = DisposeBag()

        router = MockUserPlaylistsRouter()
        interactor = MockUserPlaylistsInteractor()

        viewModel = UserPlaylistsViewModel(
            router: router,
            interactor: interactor
        )
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_initialState() {
        XCTAssertEqual(viewModel.playlists.value.count, 0)
        XCTAssertEqual(viewModel.isLoading.value, false)
    }

    func test_loadOnViewWillAppear() {
        let testSchedular = TestScheduler(initialClock: 0)
        let viewWillAppear = testSchedular.createHotObservable([next(50, ())])

        let observer = testSchedular.createObserver(Void.self)

        interactor.calledLoad.asObservable()
            .subscribe({ (event) in
                observer.on(event)
            })
            .disposed(by: disposeBag)

        viewWillAppear
            .subscribe(onNext: { () in
                self.viewModel.viewWillAppear()
            })
            .disposed(by: disposeBag)

        testSchedular.start()

        let expectedEvents = [
            next(50, ())
        ]

        XCTAssertEqual(observer.events.count, expectedEvents.count)
    }

    func test_loadPlaylists() {
        let testSchedular = TestScheduler(initialClock: 0)
        let viewWillAppear = testSchedular.createHotObservable([next(50, ())])

        interactor.calledLoad.asObservable()
            .subscribe(onNext: { () in
                self.interactor.playlists.value = Array(repeating: MockPlaylistEntity(), count: 25)
            })
            .disposed(by: disposeBag)

        viewWillAppear
            .subscribe(onNext: { () in
                self.viewModel.viewWillAppear()
            })
            .disposed(by: disposeBag)

        testSchedular.start()

        XCTAssertEqual(viewModel.playlists.value.count, 25)
    }

    func test_loadMore() {
        let testSchedular = TestScheduler(initialClock: 0)
        let viewWillAppear = testSchedular.createHotObservable([next(50, ())])

        var willShowEvents: [Recorded<Event<Int>>] = []

        for i in 0..<25 {
            willShowEvents.append(next(50 + i * 2, i))
        }

        let willShow = testSchedular.createHotObservable(willShowEvents)

        interactor.calledLoad.asObservable()
            .subscribe(onNext: { () in
                var playlists = self.interactor.playlists.value
                playlists.append(contentsOf: Array<PlaylistEntityType>(repeating: MockPlaylistEntity(), count: 25))
                self.interactor.playlists.value = playlists
                self.interactor.mockLoad.onCompleted()
            })
            .disposed(by: disposeBag)

        viewWillAppear
            .subscribe(onNext: { () in
                self.viewModel.viewWillAppear()
            })
            .disposed(by: disposeBag)

        willShow
            .subscribe(onNext: { (index) in
                self.viewModel.willShowItem(at: index)
            })
            .disposed(by: disposeBag)

        testSchedular.start()

        XCTAssertEqual(interactor.hasMore.value, true)
        XCTAssertEqual(interactor.playlists.value.count, 50)
        XCTAssertEqual(viewModel.isLoading.value, false)
        XCTAssertEqual(viewModel.playlists.value.count, 50)
    }
}

