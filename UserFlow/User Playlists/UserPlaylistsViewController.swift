//
//  UserPlaylistsViewController.swift
//  UserFlow
//
//  Created by Callum Henshall on 03/02/2018.
//  Copyright © 2018 Callum Henshall. All rights reserved.
//

import UIKit
import RxSwift

class UserPlaylistsViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!

    private let columnLayout = ThreeColumnLayout()

    private var viewModel: UserPlaylistsViewModelType!
    private let disposeBag = DisposeBag()

    static func instantiate(viewModel: UserPlaylistsViewModelType) -> UserPlaylistsViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UserPlaylistsViewController") as! UserPlaylistsViewController

        vc.viewModel = viewModel
        
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("UserPlaylists.Title", comment: "User playlists view title")

        setupLoading()
        setupCollectionView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.viewWillAppear()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewModel.viewDidAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        viewModel.viewWillDisappear()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        viewModel.viewDidDisappear()
    }
}

extension UserPlaylistsViewController {
    private func setupLoading() {
        viewModel.isLoading.asObservable()
            .subscribe(onNext: { (isLoading) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
            })
            .disposed(by: disposeBag)
    }

    private func setupCollectionView() {
        columnLayout.scrollDirection = .vertical
        columnLayout.minimumInteritemSpacing = 10
        columnLayout.minimumLineSpacing = 10
        columnLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.collectionViewLayout = columnLayout

        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(
            UINib(nibName: "UserPlaylistCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: Reusable.playlistCellIdentifier
        )

        viewModel.playlists.asObservable()
            .subscribe(onNext: { [weak self] (_) in
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }

    struct Reusable {
        static let playlistCellIdentifier: String = "PlaylistCell"
    }
}

extension UserPlaylistsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        viewModel.didSelectItem(at: indexPath.row)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.willShowItem(at: indexPath.row)
    }
}

extension UserPlaylistsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.playlists.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Reusable.playlistCellIdentifier,
            for: indexPath
        ) as! UserPlaylistCollectionViewCell

        cell.viewModel = viewModel.playlists.value[indexPath.row]

        return cell
    }
}

