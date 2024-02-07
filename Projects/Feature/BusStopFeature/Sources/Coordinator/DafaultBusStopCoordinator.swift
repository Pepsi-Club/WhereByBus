import UIKit

import FeatureDependency

public final class DefaultBusStopCoordinator: BusStopCoordinator {
    public var parent: Coordinator?
    public var childs: [Coordinator] = []
    public var navigationController: UINavigationController
//    var coordinatorProvider: CoordinatorProvider
    
    public init(
        parent: Coordinator?,
        navigationController: UINavigationController
//        coordinatorProvider: CoordinatorProvider
    ) {
        self.parent = parent
        self.navigationController = navigationController
//        self.coordinatorProvider = coordinatorProvider
    }
    
    public func start() {
        let busstopViewController = BusStopViewController(
            viewModel: BusStopViewModel(coordinator: self)
        )
        navigationController.setViewControllers(
            [busstopViewController],
            animated: false
        )
    }
    
    public func finish() {
        
    }
}

extension DefaultBusStopCoordinator {
    // 정류장 위치뷰로 이동하기 위한
    public func busStopMapLocation() {
//        let nearMapCoordinator = coordinatorProvider
//            .makeBusStopMapCoordinator(
//                navigationController: navigationController
//            )
//        
//        childs.append(nearMapCoordinator)
//        nearMapCoordinator.start()
    }
}
