import UIKit

import Core
import Domain
import FeatureDependency

import RxSwift

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // register 함수만들고 앱 실행될때 함수 호출될 수 있게!
        register()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    func register() {
        DIContainer.register(
            type: BusStopUseCase.self,
            DefaultBusStopUseCase(
                busStopArrivalInfoRepository: MockBusStopArrivalInfoRepository(),
                favoritesRepository: MockFavoritesRepository(),
                regularAlarmEditingService: MockRegualrAlarmEditingService()
            )
        )
    }
}
