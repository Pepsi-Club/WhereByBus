import UIKit

import Domain
import Core
import DesignSystem

import RxSwift
import RxCocoa

public final class SearchViewController: UIViewController {
    private let viewModel: SearchViewModel
    
    private let cellTapEvent = PublishSubject<BusStopInfoResponse>()
    private let disposeBag = DisposeBag()
    
    private var dataSource: SearchDataSource!
    
    private let searchTextFieldView = SearchTextFieldView()
    
    private let recentSearchlabel: UILabel = {
        let label = UILabel()
        label.font =
        DesignSystemFontFamily.NanumSquareNeoOTF.bold.font(size: 15)
        label.textColor = .black
        label.text = "최근 검색 정류장"
        return label
    }()
    
    private let removeBtn: UIButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = DesignSystemAsset.gray5.color
        var titleContainer = AttributeContainer()
        titleContainer.font =
        DesignSystemFontFamily.NanumSquareNeoOTF.bold.font(size: 15)
        config.attributedTitle = AttributedString(
            "삭제",
            attributes: titleContainer
        )
        let button = UIButton(configuration: config)
        return button
    }()
    
    private let seoulLabel: UILabel = {
        let label = UILabel()
        label.font =
        DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(size: 15)
        label.textColor = DesignSystemAsset.gray5.color
        label.text = "서울"
        return label
    }()
    
    private let tvBackgroundView = SearchTVRecentSearchBGView()
    
    private lazy var recentSearchTableView: UITableView = {
        let table = UITableView(
            frame: .zero,
            style: .insetGrouped
        )
        table.register(SearchTVCell.self)
        table.backgroundColor = DesignSystemAsset.tableViewColor.color
        table.dataSource = dataSource
        table.contentInset.top = -20
        return table
    }()
    
    private let nearByStopPaddingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(
            red: 230/255,
            green: 237/255,
            blue: 255/255,
            alpha: 1.0
        )
        return view
    }()
    
    private let nearByStopView = DeagreeSearchNearStopView()
    
    private var tableViewBtmConstraint: NSLayoutConstraint!
    
    public init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureDataSource()
        bind()
        hideKeyboard()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        configureNavigation()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        searchTextFieldView.removeFromSuperview()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        [
            recentSearchlabel,
            removeBtn,
            seoulLabel,
            nearByStopPaddingView,
            nearByStopView,
            recentSearchTableView,
        ].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let safeArea = view.safeAreaLayoutGuide
        tableViewBtmConstraint = recentSearchTableView.bottomAnchor.constraint(
            equalTo: nearByStopPaddingView.topAnchor
        )
        NSLayoutConstraint.activate([
            recentSearchlabel.topAnchor.constraint(
                equalTo: safeArea.topAnchor,
                constant: 20
            ),
            recentSearchlabel.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor,
                constant: 15
            ),
            recentSearchlabel.heightAnchor.constraint(
                equalToConstant: 15
            ),
            
            removeBtn.centerYAnchor.constraint(
                equalTo: recentSearchlabel.centerYAnchor
            ),
            removeBtn.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor,
                constant: -10
            ),
            
            seoulLabel.topAnchor.constraint(
                equalTo: safeArea.topAnchor,
                constant: 15
            ),
            seoulLabel.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor,
                constant: 15
            ),
            seoulLabel.heightAnchor.constraint(
                equalToConstant: 15
            ),
            
            nearByStopPaddingView.bottomAnchor.constraint(
                equalTo: safeArea.bottomAnchor,
                constant: -200
            ),
            nearByStopPaddingView.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor
            ),
            nearByStopPaddingView.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor
            ),
            
            nearByStopView.topAnchor.constraint(
                equalTo: nearByStopPaddingView.topAnchor,
                constant: 25
            ),
            nearByStopView.centerXAnchor.constraint(
                equalTo: safeArea.centerXAnchor
            ),
            nearByStopView.widthAnchor.constraint(
                equalTo: view.widthAnchor,
                multiplier: 0.95
            ),
            nearByStopView.heightAnchor.constraint(
                equalToConstant: 87
            ),
            nearByStopView.bottomAnchor.constraint(
                equalTo: nearByStopPaddingView.bottomAnchor,
                constant: -25
            ),
            
            recentSearchTableView.topAnchor.constraint(
                equalTo: recentSearchlabel.bottomAnchor,
                constant: 10
            ),
            recentSearchTableView.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor
            ),
            recentSearchTableView.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor
            ),
            
            tableViewBtmConstraint,
        ])
    }
    
    private func bind() {
        let nearByStopTapGesture = UITapGestureRecognizer()
        nearByStopView.addGestureRecognizer(nearByStopTapGesture)
        
        let input = SearchViewModel.Input(
            viewWillAppearEvent: rx.methodInvoked(
                           #selector(UIViewController.viewWillAppear)
                       ).map { _ in },
            textFieldChangeEvent: searchTextFieldView.rx.text
                .orEmpty
                .skip(1)
                .asObservable(),
            removeBtnTapEvent: removeBtn.rx.tap.asObservable(),
            nearByStopTapEvent: nearByStopTapGesture.rx.event.map { _ in },
            cellTapEvent: cellTapEvent
        )
        
        let output = viewModel.transform(input: input)
        
        output.recentSearchedResponse
            .filter { _ in
                output.tableViewSection.value == .recentSearch
            }
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(
                onNext: { viewController, responses in
                    viewController.updateSnapshot(
                        section: .recentSearch,
                        responses: responses
                    )
                }
            )
            .disposed(by: disposeBag)
        
        output.nearByStopInfo
            .withUnretained(self)
            .subscribe(
                onNext: { viewController, tuple in
                    let (response, distance) = tuple
                    viewController.nearByStopView.updateUI(
                        busStopName: response.busStopName,
                        distance: distance
                    )
                }
            )
            .disposed(by: disposeBag)
        
        output.searchedResponse
            .filter { _ in
                output.tableViewSection.value == .searchedData
            }
            .withUnretained(self)
            .subscribe(
                onNext: { viewController, responses in
                    viewController.updateSnapshot(
                        section: .searchedData,
                        responses: responses
                    )
                }
            )
            .disposed(by: disposeBag)
        
        output.tableViewSection
            .withLatestFrom(
                output.recentSearchedResponse
            ) { section, recentSearch in
                (section, recentSearch)
            }
            .withUnretained(self)
            .subscribe(
                onNext: { viewController, tuple in
                    let (section, recentSearch) = tuple
                    viewController.tableViewBtmConstraint.isActive = false
                    switch section {
                    case .recentSearch:
                        viewController.tableViewBtmConstraint
                        = viewController.recentSearchTableView.bottomAnchor
                            .constraint(
                                equalTo: viewController.nearByStopPaddingView
                                    .topAnchor
                            )
                        viewController.updateSnapshot(
                            section: .recentSearch,
                            responses: recentSearch
                        )
                    case .searchedData:
                        viewController.tableViewBtmConstraint
                        = viewController.recentSearchTableView.bottomAnchor
                            .constraint(
                                equalTo: viewController.view.safeAreaLayoutGuide
                                    .bottomAnchor
                            )
                
                    }
                    viewController.tableViewBtmConstraint.isActive = true
                }
            )
            .disposed(by: disposeBag)
        
        searchTextFieldView.rx.text.orEmpty
                .map { !$0.isEmpty }
                .bind { [weak self] hasText in
                    self?.recentSearchlabel.isHidden = hasText
                    self?.removeBtn.isHidden = hasText
                    self?.seoulLabel.isHidden = !hasText
                }
                .disposed(by: disposeBag)
    }
    
    private func configureNavigation() {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.backItem?.title = ""
        
        guard let navigationView = navigationController?.navigationBar
        else { return }
        navigationView.addSubview(searchTextFieldView)
        searchTextFieldView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchTextFieldView.topAnchor.constraint(
                equalTo: navigationView.topAnchor,
                constant: 2.5
            ),
            searchTextFieldView.trailingAnchor.constraint(
                equalTo: navigationView.trailingAnchor,
                constant: -10
            ),
            searchTextFieldView.widthAnchor.constraint(
                equalTo: navigationView.widthAnchor,
                multiplier: 0.85
            ),
            searchTextFieldView.heightAnchor.constraint(
                equalTo: navigationView.heightAnchor,
                multiplier: 0.9
            )
        ])
    }
    
    private func configureDataSource() {
        dataSource = .init(
            tableView: recentSearchTableView,
            cellProvider: { [weak self] tableView, indexPath, response in
                guard let self,
                      let cell = tableView.dequeueReusableCell(
                        withIdentifier: SearchTVCell.identifier,
                        for: indexPath
                      ) as? SearchTVCell
                else { return .init() }
                cell.updateUI(response: response)
                let tapGesture = UITapGestureRecognizer()
                cell.addGestureRecognizer(tapGesture)
                tapGesture.rx.event
                    .map { _ in
                        response
                    }
                    .withUnretained(self)
                    .subscribe(
                        onNext: { viewController, response in
                            viewController.cellTapEvent.onNext(response)
                        }
                    )
                    .disposed(by: cell.disposeBag)
                return cell
            }
        )
    }
    
    private func updateSnapshot(
        section: SearchSection,
        responses: [BusStopInfoResponse]
    ) {
        switch section {
        case .recentSearch:
            if responses.isEmpty {
                recentSearchTableView.backgroundView = tvBackgroundView
            } else {
                recentSearchTableView.backgroundView = nil
            }
        case .searchedData:
            recentSearchTableView.backgroundView = nil
        }
        var snapshot = SearchSnapshot()
        snapshot.appendSections([section])
        snapshot.appendItems(
            responses,
            toSection: section
        )
        dataSource.apply(
            snapshot,
            animatingDifferences: false
        )
    }
}

extension SearchViewController {
    typealias SearchDataSource =
    UITableViewDiffableDataSource<SearchSection, BusStopInfoResponse>
    typealias SearchSnapshot =
    NSDiffableDataSourceSnapshot<SearchSection, BusStopInfoResponse>
}

enum SearchSection: CaseIterable {
    case recentSearch, searchedData
}
