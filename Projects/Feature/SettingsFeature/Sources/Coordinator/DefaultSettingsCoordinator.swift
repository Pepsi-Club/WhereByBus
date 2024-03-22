import UIKit

import FeatureDependency

public final class DefaultSettingsCoordinator {
    public var parent: Coordinator?
    public var childs: [Coordinator] = []
    public var navigationController: UINavigationController
    public var coordinatorType: CoordinatorType = .setting

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    public func start() {
        let settingsViewController = SettingsViewController(
            viewModel: SettingsViewModel(coordinator: self)
        )
        navigationController.setViewControllers(
            [settingsViewController],
            animated: false
        )
    }
}

extension DefaultSettingsCoordinator: SettingsCoordinator {
    public func setDefaultAlarm() {
        let setAlarmVC = AlarmSettingViewController(
            viewModel: SettingsViewModel(coordinator: self)
        )
        navigationController.pushViewController(setAlarmVC, animated: true)
    }
    
    public func presentPrivacy(url: String) {
        let privacyVC = PrivacyWebViewController(
            viewModel: PrivacyWebViewModel(
                coordinator: self,
                urlString: url
            )
        )
        navigationController.pushViewController(privacyVC, animated: true)
    }
}
