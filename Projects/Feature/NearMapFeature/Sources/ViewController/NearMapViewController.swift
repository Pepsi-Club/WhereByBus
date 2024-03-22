import UIKit

import DesignSystem

import KakaoMapsSDK
import RxSwift
import RxCocoa

public final class NearMapViewController: UIViewController {
	private let viewModel: NearMapViewModel
    
    private let kakaoMapTouchesEndedEvent = PublishSubject<Void>()
	private let disposeBag = DisposeBag()
	
	private lazy var kakaoMapView: KMViewContainer = {
		var view = KMViewContainer()
		view.clipsToBounds = true
		view.layer.cornerRadius = 15
        view.setDelegate(self)
		return view
	}()
	
	private let busStopInformationView: BusStopInformationView = {
		var label = BusStopInformationView()
		label.clipsToBounds = true
		label.layer.cornerRadius = 15
		return label
	}()
	
	private let separationView: UIView = {
		let view = UIView()
		view.backgroundColor = .black
		return view
	}()
	
	init(
		viewModel: NearMapViewModel
	) {
		self.viewModel = viewModel
		super.init(
            nibName: nil,
            bundle: nil
        )
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
    
    deinit {
        viewModel.removeMapController()
    }
    
	public override func viewDidLoad() {
		super.viewDidLoad()
		viewModel.mapController = KMController(viewContainer: kakaoMapView)
		configureUI()
		bind()
	}
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.isNavigationBarHidden = false
    }
	
	public func configureUI() {
		navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black,
			.font: DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(
				size: 16
			)
		]
		
		view.backgroundColor = .white
		
		[
			separationView,
			kakaoMapView,
			busStopInformationView,
		].forEach {
			view.addSubview($0)
			$0.translatesAutoresizingMaskIntoConstraints = false
		}
		
		NSLayoutConstraint.activate([
			separationView.topAnchor.constraint(
				equalTo: view.safeAreaLayoutGuide.topAnchor,
				constant: 0
			),
			separationView.leftAnchor.constraint(
				equalTo: view.safeAreaLayoutGuide.leftAnchor,
				constant: 0
			),
			separationView.rightAnchor.constraint(
				equalTo: view.safeAreaLayoutGuide.rightAnchor,
				constant: 0
			),
			separationView.heightAnchor.constraint(
				equalToConstant: 0.2
			),
			
			busStopInformationView.bottomAnchor.constraint(
				equalTo: view.safeAreaLayoutGuide.bottomAnchor,
				constant: -10
			),
			busStopInformationView.leftAnchor.constraint(
				equalTo: view.safeAreaLayoutGuide.leftAnchor,
				constant: 10
			),
			busStopInformationView.rightAnchor.constraint(
				equalTo: view.safeAreaLayoutGuide.rightAnchor,
				constant: -10
			),
			busStopInformationView.heightAnchor.constraint(
				equalToConstant: 130
			),
			
			kakaoMapView.topAnchor.constraint(
				equalTo: separationView.safeAreaLayoutGuide.topAnchor,
				constant: 8
			),
			kakaoMapView.bottomAnchor.constraint(
				equalTo: busStopInformationView.topAnchor,
				constant: -10
			),
			kakaoMapView.leftAnchor.constraint(
				equalTo: view.safeAreaLayoutGuide.leftAnchor,
				constant: 5
			),
			kakaoMapView.rightAnchor.constraint(
				equalTo: view.safeAreaLayoutGuide.rightAnchor,
				constant: -5
			),
		])
	}
	
	private func bind() {
		let tapGesture = UITapGestureRecognizer()
		busStopInformationView.addGestureRecognizer(tapGesture)
		
        let output = viewModel.transform(
            input: .init(
                viewWillAppearEvent: rx.methodInvoked(
                    #selector(UIViewController.viewWillAppear)
                ).map { _ in },
                viewWillDisappearEvent: rx.methodInvoked(
                    #selector(UIViewController.viewWillDisappear)
                ).map { _ in },
                kakaoMapTouchesEndedEvent: kakaoMapTouchesEndedEvent,
                informationViewTapEvent: tapGesture.rx.event.map { _ in }
            )
		)
        
        output.selectedBusStopInfo
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, tuple in
                    let (response, distance) = tuple
                    viewModel.busStopInformationView.updateUI(
                        response: response,
                        distance: distance
                    )
                }
            )
            .disposed(by: disposeBag)
        
        output.navigationTitle
            .withUnretained(self)
            .subscribe(
                onNext: { viewController, title in
                    viewController.navigationItem.title = title
                }
            )
            .disposed(by: disposeBag)
	}
}

extension NearMapViewController: K3fMapContainerDelegate {
    public func touchesEnded(_ touches: Set<AnyHashable>) {
        kakaoMapTouchesEndedEvent.onNext(())
    }
}
