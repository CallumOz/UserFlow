//
//  UserPlaylistsViewModel.swift
//  UserFlow
//
//  Created by Callum Henshall on 03/02/2018.
//  Copyright © 2018 Callum Henshall. All rights reserved.
//

import Foundation
import RxSwift

protocol UserPlaylistsViewModelType: class {
    var playlists: Variable<[UserPlaylistCellViewModelType]> { get }
    var isLoading: Variable<Bool> { get }

    func viewWillAppear()
    func viewDidAppear()
    func viewWillDisappear()
    func viewDidDisappear()

    func willShowItem(at index: Int)
    func didSelectItem(at index: Int)
}

class UserPlaylistsViewModel: UserPlaylistsViewModelType {
    let playlists = Variable<[UserPlaylistCellViewModelType]>([])
    let isLoading = Variable<Bool>(false)

    private let internalPlaylists = Variable<[UserPlaylistCellViewModel]>([])

    private let router: UserPlaylistsRouterType
    private let interactor: UserPlaylistsInteractorType
    private let disposeBag = DisposeBag()

    init(router: UserPlaylistsRouterType, interactor: UserPlaylistsInteractorType) {
        self.router = router
        self.interactor = interactor

        self.internalPlaylists.asObservable()
            .map { (viewModels) -> [UserPlaylistCellViewModelType] in
                return viewModels.map { $0 as UserPlaylistCellViewModelType }
            }
            .subscribe(onNext: { [weak self] (viewModels) in
                self?.playlists.value = viewModels
            })
            .disposed(by: self.disposeBag)

        self.interactor.playlists.asObservable()
            .map { (playlists) -> [UserPlaylistCellViewModel] in
                return playlists.map { UserPlaylistCellViewModel(playlist: $0) }
            }
            .subscribe(onNext: { [weak self] (viewModels) in
                self?.internalPlaylists.value = viewModels
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
        if index == internalPlaylists.value.count - 1 {
            loadMoreIfNeeded()
        }
    }

    func didSelectItem(at index: Int) {
        let viewModel = internalPlaylists.value[index]
        router.showPlaylistTracks(for: viewModel.playlist)
    }
}

extension UserPlaylistsViewModel {
    private func performInitialLoadIfNeeded() {
        if isLoading.value == false
            && internalPlaylists.value.count == 0
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

