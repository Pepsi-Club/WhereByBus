import UIKit

import Domain
import FeatureDependency

public final class DefaultRegularAlarmCoordinator: RegularAlarmCoordinator {
    public var parent: Coordinator?
    public var childs: [Coordinator] = []
    public var navigationController: UINavigationController
    public var coordinatorProvider: CoordinatorProvider
    public var coordinatorType: CoordinatorType = .regularAlarm
    
    public init(
        navigationController: UINavigationController,
        coordinatorProvider: CoordinatorProvider
    ) {
        self.navigationController = navigationController
        self.coordinatorProvider = coordinatorProvider
    }
    
    public func start() {
        let regularAlarmViewController = RegularAlarmViewController(
            viewModel: RegularAlarmViewModel(coordinator: self)
        )
        navigationController.setViewControllers(
            [regularAlarmViewController],
            animated: false
        )
    }
}

public extension DefaultRegularAlarmCoordinator {
    func startAddRegularAlarmFlow() {
        let addRegularAlarmCoordinator = DefaultAddRegularAlarmCoordinator(
            parent: self,
            navigationController: navigationController,
            coordinatorProvider: coordinatorProvider,
            flow: .fromAlarm
        )
        childs.append(addRegularAlarmCoordinator)
        addRegularAlarmCoordinator.start()
    }
    
    func startAddRegularAlarmFlow(with: RegularAlarmResponse) {
        let addRegularAlarmCoordinator = DefaultAddRegularAlarmCoordinator(
            parent: self,
            navigationController: navigationController,
            coordinatorProvider: coordinatorProvider,
            flow: .fromAlarm
        )
        childs.append(addRegularAlarmCoordinator)
        addRegularAlarmCoordinator.start(with: with)
    }
}
