import UIKit

import Domain
import FeatureDependency

public final class DefaultSearchCoordinator: SearchCoordinator {
    public var parent: Coordinator?
    public var childs: [Coordinator] = []
    public let navigationController: UINavigationController
    public let coordinatorProvider: CoordinatorProvider
    private let flow: FlowState
    public var coordinatorType: CoordinatorType = .search
    
    public init(
        parent: Coordinator?,
        navigationController: UINavigationController,
        coordinatorProvider: CoordinatorProvider,
        flow: FlowState
    ) {
        self.parent = parent
        self.navigationController = navigationController
        self.coordinatorProvider = coordinatorProvider
        self.flow = flow
    }
    
    public func start() {
        let searchViewController = SearchViewController(
            viewModel: SearchViewModel(coordinator: self)
        )
        navigationController.pushViewController(
            searchViewController,
            animated: true
        )
    }
}

extension DefaultSearchCoordinator {
    public func startBusStopFlow(stationId: String) {
        // BusStopCoordinatorFlow
        let busStopCoordinator = coordinatorProvider.makeBusStopCoordinator(
            parent: self,
            navigationController: navigationController,
            busStopId: stationId,
            flow: flow
        )
        childs.append(busStopCoordinator)
        busStopCoordinator.start()
    }
    
    public func startNearMapFlow() {
        let nearMapCoordinator = coordinatorProvider.makeNearMapCoordinator(
            parent: self,
            navigationController: navigationController,
            flow: flow, 
            busStopId: nil
        )
        childs.append(nearMapCoordinator)
        nearMapCoordinator.start()
    }
    
//    public func finishFlow() {
//        navigationController.popViewController(animated: true)
//        finish()
//    }
}
