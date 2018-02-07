//
//  PlaylistViewController.swift
//  UserFlow
//
//  Created by Callum Henshall on 04/02/2018.
//  Copyright © 2018 Callum Henshall. All rights reserved.
//

import UIKit
import RxSwift
import SDWebImage

class PlaylistViewController: UITableViewController {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var creatorLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!

    private var viewModel: PlaylistViewModelType!
    private let disposeBag = DisposeBag()

    static func instantiate(viewModel: PlaylistViewModelType) -> PlaylistViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PlaylistViewController") as! PlaylistViewController

        vc.viewModel = viewModel

        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLoading()
        setupPlaylistInfo()
        setupTableView()
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

extension PlaylistViewController {
    private func setupLoading() {
        viewModel.isLoading.asObservable()
            .subscribe(onNext: { (isLoading) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
            })
            .disposed(by: disposeBag)
    }

    private func setupPlaylistInfo() {
        viewModel.logo.asObservable()
            .subscribe(onNext: { [weak self] (url) in
                if let url = url {
                    self?.coverImageView.sd_setImage(with: url)
                }
                else {
                    self?.coverImageView.sd_cancelCurrentImageLoad()
                }
            })
            .disposed(by: disposeBag)

        viewModel.title.asObservable()
            .subscribe(onNext: { [weak self] (title) in
                self?.titleLabel.text = title
            })
            .disposed(by: disposeBag)

        viewModel.author.asObservable()
            .subscribe(onNext: { [weak self] (author) in
                self?.creatorLabel.text = author
            })
            .disposed(by: disposeBag)

        let durationFormatter = DateComponentsFormatter()
        durationFormatter.allowedUnits = [.minute, .second]
        durationFormatter.zeroFormattingBehavior = .pad
        durationFormatter.unitsStyle = .positional

        viewModel.duration.asObservable()
            .map { (duration) -> String? in
                return duration.flatMap { (duration) -> String? in
                    return durationFormatter.string(from: duration)
                }
            }
            .subscribe(onNext: { [weak self] (duration) in
                self?.durationLabel.text = duration
            })
            .disposed(by: disposeBag)
    }

    private func setupTableView() {
        tableView.register(
            UINib(nibName: "PlaylistTrackTableViewCell", bundle: nil),
            forCellReuseIdentifier: Reusable.trackCellIdentifier
        )

        viewModel.tracks.asObservable()
            .subscribe(onNext: { [weak self] (tracks) in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }

    struct Reusable {
        static let trackCellIdentifier: String = "TrackCell"
    }
}

extension PlaylistViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.willShowItem(at: indexPath.row)
    }
}

extension PlaylistViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tracks.value.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Reusable.trackCellIdentifier) as! PlaylistTrackTableViewCell

        cell.viewModel = viewModel.tracks.value[indexPath.row]

        return cell
    }
}

