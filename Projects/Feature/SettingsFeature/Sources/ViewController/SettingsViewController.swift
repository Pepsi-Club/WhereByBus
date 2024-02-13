import UIKit

import DesignSystem

import RxSwift

public final class SettingsViewController: UIViewController {
    private let viewModel: SettingsViewModel
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "설정"
        label.textColor = .black
        label.font
        = DesignSystemFontFamily.NanumSquareNeoOTF.heavy.font(size: 25)
        return label
    }()
    private let basicAlarmSetting: SettingView = {
        let view = SettingView(
            title: "알람 설정",
            rightTitle: "",
            isHiddenArrowRight: false
        )
        return view
    }()
    private lazy var developVersion: SettingView = {
        let view = SettingView(
            title: "개발 버전",
            rightTitle: "v \(appVersion ?? "")",
            isHiddenArrowRight: true
        )
        return view
    }()
    private var appVersion: String? {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String 
        else { return nil }
        return version
    }
    
    public init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureUI()
    }
    
    private func configureUI() {
        [titleLabel, basicAlarmSetting, developVersion]
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview($0)
            }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 15
            ),
            basicAlarmSetting.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 20
            ),
            basicAlarmSetting.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 15
            ),
            basicAlarmSetting.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -15
            ),
            developVersion.topAnchor.constraint(
                equalTo: basicAlarmSetting.bottomAnchor,
                constant: 10
            ),
            developVersion.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 15
            ),
            developVersion.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -15
            ),
        ])
    }
}
