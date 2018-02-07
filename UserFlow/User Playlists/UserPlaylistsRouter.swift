//
//  UserPlaylistsRouter.swift
//  UserFlow
//
//  Created by Callum Henshall on 03/02/2018.
//  Copyright © 2018 Callum Henshall. All rights reserved.
//

import UIKit

protocol UserPlaylistsRouterType: class {
    func showPlaylistTracks(for playlist: PlaylistEntityType)
}

class UserPlaylistsRouter: UserPlaylistsRouterType {

    private weak var viewController: UserPlaylistsViewController!
    private weak var navigationController: UINavigationController!

    private weak var viewModel: UserPlaylistsViewModelType!

    private let userID: String

    init(userID: String) {
        self.userID = userID
    }

    func show(in window: UIWindow) {
        let interactor = UserPlaylistsInteractor(userID: userID)
        let viewModel = UserPlaylistsViewModel(router: self, interactor: interactor)
        let vc = UserPlaylistsViewController.instantiate(viewModel: viewModel)

        let nc = UINavigationController(rootViewController: vc)

        self.viewController = vc
        self.navigationController = nc
        self.viewModel = viewModel

        window.rootViewController = nc
    }

    func showPlaylistTracks(for playlist: PlaylistEntityType) {
        let router = PlaylistRouter(playlist: playlist)
        router.push(from: navigationController)
    }
}

