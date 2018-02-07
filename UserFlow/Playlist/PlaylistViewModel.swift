//
//  PlaylistViewModel.swift
//  UserFlow
//
//  Created by Callum Henshall on 04/02/2018.
//  Copyright © 2018 Callum Henshall. All rights reserved.
//

import Foundation
import RxSwift

protocol PlaylistViewModelType: class {
    var logo: Variable<URL?> { get }
    var title: Variable<String?> { get }
    var author: Variable<String?> { get }
    var duration: Variable<TimeInterval?> { get }

    var tracks: Variable<[PlaylistTrackCellViewModelType]> { get }
    var isLoading: Variable<Bool> { get }

    func viewWillAppear()
    func viewDidAppear()
    func viewWillDisappear()
    func viewDidDisappear()

    func willShowItem(at index: Int)
}

class PlaylistViewModel: PlaylistViewModelType {
    let logo = Variable<URL?>(nil)
    let title = Variable<String?>("")
    let author = Variable<String?>("")
    let duration = Variable<TimeInterval?>(0)

    let tracks = Variable<[PlaylistTrackCellViewModelType]>([])
    let isLoading = Variable<Bool>(false)

    private let internalTracks = Variable<[PlaylistTrackCellViewModel]>([])

    private let router: PlaylistRouterType
    private let interactor: PlaylistInteractorType
    private let disposeBag = DisposeBag()

    init(router: PlaylistRouterType, interactor: PlaylistInteractorType) {
        self.router = router
        self.interactor = interactor

        self.interactor.logo.asObservable()
            .subscribe(onNext: { [weak self] (logo) in
                self?.logo.value = logo
            })
            .disposed(by: self.disposeBag)

        self.interactor.title.asObservable()
            .subscribe(onNext: { [weak self] (title) in
                self?.title.value = title
            })
            .disposed(by: self.disposeBag)

        self.interactor.author.asObservable()
            .subscribe(onNext: { [weak self] (author) in
                self?.author.value = author
            })
            .disposed(by: self.disposeBag)

        self.interactor.duration.asObservable()
            .subscribe(onNext: { [weak self] (duration) in
                self?.duration.value = duration
            })
            .disposed(by: self.disposeBag)

        self.internalTracks.asObservable()
            .map { (viewModels) -> [PlaylistTrackCellViewModelType] in
                return viewModels.map { $0 as PlaylistTrackCellViewModelType }
            }
            .subscribe(onNext: { [weak self] (viewModels) in
                self?.tracks.value = viewModels
            })
            .disposed(by: self.disposeBag)

        self.interactor.tracks.asObservable()
            .map { (tracks) -> [PlaylistTrackCellViewModel] in
                return tracks.map { PlaylistTrackCellViewModel(track: $0) }
            }
            .subscribe(onNext: { [weak self] (viewModels) in
                self?.internalTracks.value = viewModels
            })
            .disposed(by: self.disposeBag)
    }

    func viewWillAppear() {
        performInitialLoadIfNeeded()
    }

    func viewDidAppear() {

    }

    func viewWillDisappear() {

    }

    func viewDidDisappear() {

    }

    func willShowItem(at index: Int) {
        if index == internalTracks.value.count - 1 {
            loadMoreIfNeeded()
        }
    }
}

extension PlaylistViewModel {
    private func performInitialLoadIfNeeded() {
        if isLoading.value == false
            && internalTracks.value.count == 0
            && interactor.hasMore.value {

            isLoading.value = true
            interactor.load()
                .subscribe(onCompleted: { [weak self] in
                    self?.isLoading.value = false
                })
                .disposed(by: disposeBag)
        }
    }

    private func loadMoreIfNeeded() {
        if isLoading.value == false
            && interactor.hasMore.value == true {

            isLoading.value = true
            interactor.load()
                .subscribe(onCompleted: { [weak self] in
                    self?.isLoading.value = false
                })
                .disposed(by: disposeBag)
        }
    }
}

