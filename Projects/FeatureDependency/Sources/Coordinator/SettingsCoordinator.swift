import Foundation

public protocol SettingsCoordinator: Coordinator {
    func setDefaultAlarm()
    func presentPrivacy(url: String)
}
