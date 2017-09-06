//
//  NextToArriveViewModel.swift
//  iSEPTA
//
//  Created by Mark Broski on 9/5/17.
//  Copyright © 2017 Mark Broski. All rights reserved.
//

import Foundation
import ReSwift
import UIKit
import SeptaSchedule

typealias CellModel = NextToArriveRowDisplayModel

class NextToArriveViewModel: NSObject, StoreSubscriber {

    @IBOutlet weak var nextToArriveViewController: UpdateableFromViewModel?
    @IBOutlet weak var schedulesDelegate: SchedulesViewModelDelegate?
    typealias StoreSubscriberStateType = ScheduleRequest?
    var scheduleRequest: ScheduleRequest?
    var transitMode: TransitMode! {
        didSet {
            if transitMode == .rail && scheduleRequest?.selectedRoute == nil {
                let action = LoadAllRailRoutes()
                store.dispatch(action)
            }
        }
    }

    var targetForScheduleAction: TargetForScheduleAction { return store.state.targetForScheduleActions() }

    fileprivate var selectRouteRowDisplayModel: NextToArriveRowDisplayModel?
    fileprivate var selectStartRowDisplayModel: NextToArriveRowDisplayModel?
    fileprivate var selectEndRowDisplayModel: NextToArriveRowDisplayModel?
    fileprivate var displayModel = [NextToArriveRowDisplayModel]()

    func scheduleTitle() -> String? {
        return scheduleRequest?.transitMode.nextToArriveTitle()
    }

    func newState(state: StoreSubscriberStateType) {
        scheduleRequest = state
        guard let transitMode = state?.transitMode else { return }
        self.transitMode = transitMode
        buildDisplayModel()
        nextToArriveViewController?.viewModelUpdated()
        schedulesDelegate?.formIsComplete(scheduleRequest?.selectedEnd != nil)
    }

    func buildDisplayModel() {

        displayModel = [
            configureSelectRouteDisplayModel(),
            configureSelectStartDisplayModel(),
            configureSelectEndDisplayModel(),
        ]
    }

    func transitModeTitle() -> String? {
        guard let transitMode = scheduleRequest?.transitMode else { return nil }
        return transitMode.routeTitle()
    }

    func shouldDisplaySectionHeaderForSection(_ section: Int) -> Bool {
        guard let transitMode = scheduleRequest?.transitMode else { return false }
        if section == 0 && transitMode == .rail {
            return false
        } else {
            return true
        }
    }

    deinit {
        unsubscribe()
    }
}

// MARK: -  Loading table view cells
extension NextToArriveViewModel {

    func numberOfRows() -> Int {
        return 4
    }

    func cellIdForRow(_ row: Int) -> String {
        guard let transitMode = scheduleRequest?.transitMode else { return "" }
        if transitMode == .rail && row == 0 {
            return "noRouteNeeded"
        } else {
            if row == 0 && scheduleRequest?.selectedRoute != nil {
                return "routeSelectedCell"
            } else {
                return "singleStringCell"
            }
        }
    }

    func configureCell(_ cell: UITableViewCell, atRow row: Int) {
        guard row < displayModel.count else { return }
        let rowModel = displayModel[row]
        if let cell = cell as? SingleStringCell {
            cell.label!.font = changeFontWeight(font: cell.label!.font, weight: rowModel.fontWeight)
            cell.setLabelText(rowModel.text)
            cell.setEnabled(rowModel.isSelectable)
            cell.setShouldFill(rowModel.shouldFillCell)
            cell.searchIcon.isHidden = !rowModel.showSearchIcon

        } else if let cell = cell as? RouteSelectedTableViewCell, let selectedRoute = scheduleRequest?.selectedRoute {
            cell.routeIdLabel.text = "\(selectedRoute.routeId):"
            cell.routeShortNameLabel.text = rowModel.text
            cell.pillView.backgroundColor = rowModel.pillColor
        }
    }

    func changeFontWeight(font currentFont: UIFont, weight: UIFont.Weight) -> UIFont {
        return UIFont.systemFont(ofSize: currentFont.pointSize, weight: weight)
    }

    func canCellBeSelected(atRow row: Int) -> Bool {
        guard row < displayModel.count else { return false }
        return displayModel[row].isSelectable
    }

    func rowSelected(_ row: Int) {
        guard row < displayModel.count,
            let viewController = displayModel[row].targetController else { return }
        let action = PresentModal(
            viewController: viewController,
            description: "User Wishes to pick a route")

        store.dispatch(action)

        if let stopToEdit = StopToSelect(rawValue: row) {
            let editStopAction = CurrentStopToEdit(targetForScheduleAction: targetForScheduleAction, stopToEdit: stopToEdit)
            store.dispatch(editStopAction)
        }
    }
}

extension NextToArriveViewModel: SubscriberUnsubscriber {
    override func awakeFromNib() {
        super.awakeFromNib()
        subscribe()
    }

    func subscribe() {
        store.subscribe(self) {
            $0.select {
                $0.nextToArriveState.scheduleState.scheduleRequest
            }.skipRepeats { $0 == $1 }
        }
    }

    func unsubscribe() {
        store.unsubscribe(self)
    }
}