//
//  NextToArriveInfoViewController.swift
//  iSEPTA
//
//  Created by Mark Broski on 9/6/17.
//  Copyright © 2017 Mark Broski. All rights reserved.
//

import Foundation
import UIKit

class NextToArriveInfoViewController: UIViewController {
    @IBOutlet weak var slider: UIImageView!
    var timer: Timer?
    @IBOutlet var upSwipeGestureRecognizer: UISwipeGestureRecognizer!
    @IBOutlet var downSwipeGestureRecognizer: UISwipeGestureRecognizer!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var headerView: CurvedTopInfoView!
    @IBOutlet weak var tableView: UITableView!
    weak var nextToArriveDetailViewController: NextToArriveDetailViewController?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var tableFooterView: UIView! {
        didSet {
            tableFooterView.isHidden = true
        }
    }

    private var pendingRequestWorkItem: DispatchWorkItem?

    var millisecondsToDelayTableReload = 250
    var viewModel: NextToArriveInfoViewModel!

    override func viewDidLoad() {

        nextToArriveDetailViewController?.upSwipeGestureRecognizer = upSwipeGestureRecognizer
        nextToArriveDetailViewController?.downSwipeGestureRecognizer = downSwipeGestureRecognizer
        nextToArriveDetailViewController?.infoHeaderView = headerView
        viewModel = NextToArriveInfoViewModel()
        viewModel.registerViews(tableView: tableView)
        tableView.allowsSelection = false

        viewModel.delegate = self
        titleLabel.text = viewModel.viewTitle()
        tableView.tableFooterView = tableFooterView
    }

    @IBAction func viewNextToArriveInSchedulesTapped(_: Any) {
        guard let firstNextToArriveTrip = viewModel.firstTrip() else { return }
        if viewModel.transitMode() == .rail {
            activityIndicator.startAnimating()
            Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(twoSecondTimerFired(timer:)), userInfo: nil, repeats: true)
        }

        let action = NavigateToSchedulesFromNextToArrive(nextToArriveTrip: firstNextToArriveTrip)
        store.dispatch(action)
    }
}

extension NextToArriveInfoViewController { // refresh timer
    override func viewDidAppear(_: Bool) {
        initTimer()
    }

    override func viewWillDisappear(_: Bool) {
        timer?.invalidate()
    }

    func initTimer() {

        timer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(oneMinuteTimerFired(timer:)), userInfo: nil, repeats: true)
    }

    @objc func twoSecondTimerFired(timer: Timer) {
        timer.invalidate()
        activityIndicator.stopAnimating()
    }

    @objc func oneMinuteTimerFired(timer _: Timer) {

        millisecondsToDelayTableReload = 1000
        guard let target = store.state.targetForScheduleActions() else { return }

        switch target {
        case .nextToArrive:
            let action = NextToArriveRefreshDataRequested(refreshUpdateRequested: true)
            store.dispatch(action)
        case .favorites:
            let favoriteId = store.state.favoritesState.nextToArriveFavoriteId
            guard let nextToArriveFavoriteId = favoriteId,
                var matchingFavorite = store.state.favoritesState.favorites.filter({ $0.favoriteId == nextToArriveFavoriteId }).first else { return }
            matchingFavorite.refreshDataRequested = true
            let action = RequestFavoriteNextToArriveUpdate(favorite: matchingFavorite, description: "Refresh Next to arrive for favorite")
            store.dispatch(action)
        default:
            break
        }
    }
}

extension NextToArriveInfoViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in _: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(forSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = viewModel.cellIdAtIndexPath(indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        viewModel.configureCell(cell, atIndexPath: indexPath)
        return cell
    }

    func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let viewId = viewModel.viewIdForSection(section),
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: viewId) else { return nil }
        viewModel.configureSectionHeader(view: headerView, forSection: section)

        return headerView
    }

    func tableView(_: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.heightForHeaderInSection(section)
    }

    func tableView(_: UITableView, willDisplayHeaderView view: UIView, forSection _: Int) {
        view.backgroundColor = UIColor.green
    }
}

extension NextToArriveInfoViewController: UpdateableFromViewModel {
    func viewModelUpdated() {

        activityIndicator.startAnimating()
        pendingRequestWorkItem?.cancel()

        // Wrap our request in a work item
        let requestWorkItem = DispatchWorkItem { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.tableView.tableFooterView?.isHidden = self?.viewModel.numberOfSections() == 0
            self?.tableView.reloadData()
            //            self?.tableView.tableFooterView?.isHidden = false
        }

        // Save the new work item and execute it after 250 ms
        pendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(millisecondsToDelayTableReload), execute: requestWorkItem)
    }

    func updateActivityIndicator(animating _: Bool) {
    }

    func displayErrorMessage(message _: String, shouldDismissAfterDisplay _: Bool) {
    }
}
