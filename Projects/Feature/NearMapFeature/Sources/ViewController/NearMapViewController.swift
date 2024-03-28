import UIKit
import Domain

import DesignSystem

import RxSwift
import RxCocoa
import NMapsMap

public final class NearMapViewController: UIViewController {
    private let viewModel: NearMapViewModel
    
    private let busStopTapEvent = PublishSubject<String>()
    private let cameraMoveEvent =
    PublishSubject<(ClosedRange<Double>, ClosedRange<Double>)>()
    private let disposeBag = DisposeBag()
    
    private var drawedMarker = [NMFMarker]()
    
    private lazy var naverMapView: NMFMapView = {
        let mapView = NMFMapView()
        mapView.clipsToBounds = true
        mapView.layer.cornerRadius = 15
        mapView.addCameraDelegate(delegate: self)
        return mapView
    }()
    
    private let busStopInformationView: BusStopInformationView = {
        let label = BusStopInformationView()
        label.clipsToBounds = true
        label.layer.cornerRadius = 15
        return label
    }()
    
    init(viewModel: NearMapViewModel) {
        self.viewModel = viewModel
        super.init(
            nibName: nil,
            bundle: nil
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        [busStopInformationView, naverMapView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            busStopInformationView.bottomAnchor.constraint(
                equalTo: safeArea.bottomAnchor,
                constant: -10
            ),
            busStopInformationView.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor,
                constant: 10
            ),
            busStopInformationView.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor,
                constant: -10
            ),
            busStopInformationView.heightAnchor.constraint(
                equalToConstant: 130
            ),
            
            naverMapView.topAnchor.constraint(
                equalTo: safeArea.topAnchor
            ),
            naverMapView.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor,
                constant: 5
            ),
            naverMapView.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor,
                constant: -5
            ),
            naverMapView.bottomAnchor.constraint(
                equalTo: busStopInformationView.topAnchor,
                constant: -10
            ),
        ])
    }
    
    private func bind() {
        let tapGesture = UITapGestureRecognizer()
        busStopInformationView.addGestureRecognizer(tapGesture)
        
        let output = viewModel.transform(
            input: .init(
                viewWillAppearEvent: rx
                    .methodInvoked(#selector(UIViewController.viewWillAppear))
                    .map { _ in },
                informationViewTapEvent: tapGesture.rx.event.map { _ in },
                selectedBusStopId: busStopTapEvent,
                locationChangeEvent: cameraMoveEvent
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
                    viewModel.moveCamera(response: response)
                }
            )
            .disposed(by: disposeBag)
        
        output.nearStopList
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, responses in
                    responses.forEach { response in
                        viewModel.drawMarker(response: response)
                    }
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
    
    private func moveCamera(response: BusStopInfoResponse) {
        guard let latitude = Double(response.latitude),
              let longitude = Double(response.longitude)
        else { return }
        let location = NMGLatLng(
            lat: latitude,
            lng: longitude
        )
        let cameraUpdate = NMFCameraUpdate(
            position: .init(
                location,
                zoom: 17
            )
        )
        let distance = location.distance(to: naverMapView.cameraPosition.target)
        cameraUpdate.animation = distance > 10000 ? .none : .easeOut
        cameraUpdate.animationDuration = 1
        naverMapView.moveCamera(cameraUpdate)
    }
    
    private func drawMarker(response: BusStopInfoResponse) {
        guard let latitude = Double(response.latitude),
              let longitude = Double(response.longitude)
        else { return }
        guard !drawedMarker.contains(where: { marker in
            marker.position.lat == latitude &&
            marker.position.lng == longitude
        })
        else { return }
        let location = NMGLatLng(
            lat: latitude,
            lng: longitude
        )
        let marker = NMFMarker(position: location)
        let busStopImg = DesignSystemAsset.busStop.image
        marker.iconImage = NMFOverlayImage(
            image: busStopImg,
            reuseIdentifier: "busStop"
        )
        marker.mapView = naverMapView
        marker.userInfo = ["busStopId": response.busStopId]
        // YES일 경우 이벤트를 소비합니다. 그렇지 않을 경우 NMFMapView까지 이벤트가 전달되어
        // NMFMapViewTouchDelegate의 mapView:didTapMap:point:가 호출됩니다.
        marker.touchHandler = { [weak self] overlay in
            if let busStopId = overlay.userInfo["busStopId"] as? String {
                self?.busStopTapEvent.onNext(busStopId)
                return true
            } else {
                return false
            }
        }
        drawedMarker.append(marker)
    }
}

extension NearMapViewController: NMFMapViewCameraDelegate {
    public func mapView(
        _ mapView: NMFMapView,
        cameraDidChangeByReason reason: Int,
        animated: Bool
    ) {
        guard let location1 = mapView.coveringBounds.boundsLatLngs.first,
              let location2 = mapView.coveringBounds.boundsLatLngs.last
        else { return }
        let longitude1 = location1.lng
        let latitude1 = location1.lat
        let longitude2 = location2.lng
        let latitude2 = location2.lat
        
        let longitudeRange = longitude1 < longitude2 ?
        longitude1...longitude2 : longitude2...longitude1
        let latitudeRange = latitude2 < latitude1 ?
        latitude2...latitude1 : latitude1...latitude2
        cameraMoveEvent.onNext((longitudeRange, latitudeRange))
    }
}
