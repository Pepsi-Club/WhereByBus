import Foundation

import Domain

public protocol RegularAlarmCoordinator: Coordinator {
    func startAddRegularAlarmFlow()
    func startAddRegularAlarmFlow(with: RegularAlarmResponse)
}
