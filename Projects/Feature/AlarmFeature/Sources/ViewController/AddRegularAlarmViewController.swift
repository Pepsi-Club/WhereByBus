//
//  AddRegularAlarmViewController.swift
//  AlarmFeature
//
//  Created by gnksbm on 2/1/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import DesignSystem

import RxSwift
import RxCocoa

final class AddRegularAlarmViewController: UIViewController {
    private let viewModel: AddRegularAlarmViewModel
    
    private let selectedWeekDay = BehaviorSubject<[Int]>(value: [])
    private let disposeBag = DisposeBag()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(
            size: 22
        )
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
    private let firstDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "1. 정류장 및 버스 등록하기"
        label.font = DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(
            size: 16
        )
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
    private let searchBtn: SearchBusStopBtn = {
        let btn = SearchBusStopBtn(
            image: UIImage(systemName: "magnifyingglass"),
            font: DesignSystemFontFamily.NanumSquareNeoOTF.bold.font(
                size: 14
            ),
            color: .black
        )
        return btn
    }()
    
    private let secondDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "2. 시간 등록하기"
        label.font = DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(
            size: 16
        )
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
    private let timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.setValue(UIColor.black, forKey: "textColor")
        return picker
    }()
    
    private let thirdDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "3. 요일 등록하기"
        label.font = DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(
            size: 16
        )
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
    private lazy var weekDayBtns = WeekDay.allCases.map {
        makeWeekDayBtn(weekDay: $0)
    }
    
    private lazy var weekDayBtnsStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: weekDayBtns
        )
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        return stackView
    }()
    
    private let completeBtn = BottomButton(title: "완료")
    
    init(viewModel: AddRegularAlarmViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setNavigation()
        bind()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        [
            titleLabel,
            firstDescriptionLabel,
            searchBtn,
            secondDescriptionLabel,
            timePicker,
            thirdDescriptionLabel,
            weekDayBtnsStackView,
            completeBtn
        ].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let safeArea = view.safeAreaLayoutGuide
        let screenHeight = UIScreen.main.bounds.height
        let descriptionGap: CGFloat = screenHeight > 700 ? 35 : 20
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: safeArea.topAnchor,
                constant: 10
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor,
                constant: 15
            ),
            
            firstDescriptionLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 30
            ),
            
            firstDescriptionLabel.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor,
                constant: 20
            ),
            
            searchBtn.topAnchor.constraint(
                equalTo: firstDescriptionLabel.bottomAnchor,
                constant: 15
            ),
            searchBtn.centerXAnchor.constraint(
                equalTo: safeArea.centerXAnchor
            ),
            searchBtn.widthAnchor.constraint(
                equalTo: safeArea.widthAnchor,
                multiplier: 0.8
            ),
            
            secondDescriptionLabel.topAnchor.constraint(
                equalTo: searchBtn.bottomAnchor,
                constant: descriptionGap
            ),
            secondDescriptionLabel.leadingAnchor.constraint(
                equalTo: firstDescriptionLabel.leadingAnchor
            ),
            
            timePicker.topAnchor.constraint(
                equalTo: secondDescriptionLabel.bottomAnchor
            ),
            timePicker.centerXAnchor.constraint(
                equalTo: safeArea.centerXAnchor
            ),
            timePicker.widthAnchor.constraint(
                equalTo: safeArea.widthAnchor,
                multiplier: 0.8
            ),
            
            thirdDescriptionLabel.topAnchor.constraint(
                equalTo: timePicker.bottomAnchor,
                constant: descriptionGap
            ),
            thirdDescriptionLabel.leadingAnchor.constraint(
                equalTo: firstDescriptionLabel.leadingAnchor
            ),
            
            weekDayBtnsStackView.topAnchor.constraint(
                equalTo: thirdDescriptionLabel.bottomAnchor,
                constant: 20
            ),
            weekDayBtnsStackView.centerXAnchor.constraint(
                equalTo: safeArea.centerXAnchor
            ),
            weekDayBtnsStackView.widthAnchor.constraint(
                equalTo: safeArea.widthAnchor,
                multiplier: 0.8
            ),
            weekDayBtnsStackView.heightAnchor.constraint(
                equalToConstant: 40
            ),
            
            completeBtn.centerXAnchor.constraint(
                equalTo: safeArea.centerXAnchor
            ),
            completeBtn.widthAnchor.constraint(
                equalTo: safeArea.widthAnchor,
                multiplier: 0.5
            ),
        ])
        
        if screenHeight > 700 {
            completeBtn.bottomAnchor.constraint(
                equalTo: safeArea.bottomAnchor,
                constant: -40
            ).isActive = true
        } else {
            completeBtn.bottomAnchor.constraint(
                equalTo: safeArea.bottomAnchor,
                constant: -5
            ).isActive = true
        }
    }
    
    private func bind() {
        let output = viewModel.transform(
            input: .init(
                viewWillAppear: rx
                    .methodInvoked(
                        #selector(UIViewController.viewWillAppear)
                    )
                    .map { _ in },
                searchBtnTapEvent: searchBtn.rx.tap.asObservable(),
                dateSelectEvent: timePicker.rx.date.asObservable(),
                weekDayBtnTapEvent: Observable.merge(
                    weekDayBtns
                        .map { btn in
                            btn.rx.tap
                                .map { _ in
                                    btn.tag
                                }
                        }
                ),
                completeBtnTapEvent: completeBtn.rx.tap.asObservable()
            )
        )
        
        output.title
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        output.regularAlarm
            .map { response in
                let title = response.busStopName.isEmpty
                || response.busName.isEmpty ?
                "정류장 및 버스 찾기" :
                "\(response.busStopName), \(response.busName)"
                return title
            }
            .withUnretained(self)
            .subscribe(
                onNext: { viewController, title in
                    viewController.searchBtn.updateTitle(title: title)
                }
            )
            .disposed(by: disposeBag)
        
        output.regularAlarm
            .withUnretained(self)
            .subscribe(
                onNext: { viewController, response in
                    viewController.weekDayBtns
                        .forEach { btn in
                            var color: UIColor
                            if response.weekday.contains(btn.tag) {
                                color = DesignSystemAsset.weekDayBlue.color
                            } else {
                                color = DesignSystemAsset.weekDayGray.color
                            }
                            btn.backgroundColor = color
                        }
                    let completeEnabled = !response.weekday.isEmpty
                    && !response.busStopName.isEmpty
                    && !response.busName.isEmpty
                    
                    viewController.completeBtn.isEnabled = completeEnabled
                }
            )
            .disposed(by: disposeBag)
        
        output.regularAlarm
            .map { response in
                response.time
            }
            .bind(to: timePicker.rx.date)
            .disposed(by: disposeBag)
    }
    
    private func setNavigation() {
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    private func makeWeekDayBtn(weekDay: WeekDay) -> UIButton {
        let btn = CircleButton(baseLine: .height)
        btn.tag = weekDay.rawValue
        btn.titleLabel?.font = .systemFont(ofSize: 16)
        btn.setTitle(weekDay.toString, for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = DesignSystemAsset.weekDayGray.color
        return btn
    }
}

extension AddRegularAlarmViewController {
    enum WeekDay: Int, CaseIterable {
        case monday = 2,
             tuesday,
             wednesday,
             thursday,
             friday,
             saturday,
             sunday = 1
        
        var toString: String {
            switch self {
            case .monday:
                return "월"
            case .tuesday:
                return "화"
            case .wednesday:
                return "수"
            case .thursday:
                return "목"
            case .friday:
                return "금"
            case .saturday:
                return "토"
            case .sunday:
                return "일"
            }
        }
    }
}
