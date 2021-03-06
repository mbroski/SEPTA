// Septa. 2017

import UIKit
import SeptaSchedule
import ReSwift

class DatabaseStateWatcher: StoreSubscriber {

    typealias StoreSubscriberStateType = DatabaseState

    weak var delegate: BaseScheduleDataProvider?

    init() {
        subscribe()
    }

    func subscribe() {
        store.subscribe(self) {
            $0.select { $0.databaseState }
        }
    }

    func newState(state: StoreSubscriberStateType) {
        if state == .loaded {
            delegate?.subscribe()
        }
    }

    deinit {
        store.unsubscribe(self)
    }
}
