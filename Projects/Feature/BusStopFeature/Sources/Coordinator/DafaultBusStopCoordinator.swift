import UIKit

import Domain
import FeatureDependency

public final class DefaultBusStopCoordinator: BusStopCoordinator {
    public var parent: Coordinator?
    public var childs: [Coordinator] = []
    public var navigationController: UINavigationController
    public var coordinatorProvider: CoordinatorProvider
    private var busStopId: String
    private let flow: FlowState
    public var coordinatorType: CoordinatorType = .busStop
    
    public init(
        parent: Coordinator?,
        navigationController: UINavigationController,
        busStopId: String,
        coordinatorProvider: CoordinatorProvider,
        flow: FlowState
    ) {
        self.parent = parent
        self.navigationController = navigationController
        self.busStopId = busStopId
        self.coordinatorProvider = coordinatorProvider
        self.flow = flow
    }
    
    public func start() {
        let fetchData = ArrivalInfoRequest(busStopId: busStopId)
        let busStopViewController = BusStopViewController(
            viewModel: BusStopViewModel(
                coordinator: self,
                fetchData: fetchData
            ),
            flow: flow
        )
        navigationController.pushViewController(
            busStopViewController,
            animated: false
        )
    }
}

extension DefaultBusStopCoordinator {
    // 정류장 위치뷰로 이동하기 위한
    public func busStopMapLocation(busStopId: String) {
        let nearMapCoordinator = coordinatorProvider.makeNearMapCoordinator(
            parent: self,
            navigationController: navigationController,
            flow: flow,
            busStopId: busStopId
        )
        childs.append(nearMapCoordinator)
        nearMapCoordinator.start()
    }
    
    public func moveToRegualrAlarm() {
        let alarmCoordinator = coordinatorProvider
            .makeAddRegularAlarmCoordinator(
                parent: self,
                navigationController: navigationController,
                flow: .fromAlarm
            )
        childs.append(alarmCoordinator)
        alarmCoordinator.start()
    }
    
}
