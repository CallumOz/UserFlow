//
//  PlaylistRouter.swift
//  UserFlow
//
//  Created by Callum Henshall on 04/02/2018.
//  Copyright © 2018 Callum Henshall. All rights reserved.
//

import UIKit

protocol PlaylistRouterType: class {

}

class PlaylistRouter: PlaylistRouterType {

    private weak var viewController: PlaylistViewController!

    private let playlist: PlaylistEntityType

    init(playlist: PlaylistEntityType) {
        self.playlist = playlist
    }

    func push(from navigationController: UINavigationController) {
        let interactor = PlaylistInteractor(playlist: playlist)
        let viewModel = PlaylistViewModel(router: self, interactor: interactor)
        let vc = PlaylistViewController.instantiate(viewModel: viewModel)

        viewController = vc

        navigationController.pushViewController(vc, animated: true)
    }
}

