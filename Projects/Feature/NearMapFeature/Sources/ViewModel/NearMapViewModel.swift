import Foundation
import CoreLocation

import Core
import DesignSystem
import Domain
import FeatureDependency

import RxSwift
import RxRelay
import KakaoMapsSDK

public final class NearMapViewModel
: NSObject, CLLocationManagerDelegate, ViewModel {
	@Injected(NearMapUseCase.self) var useCase: NearMapUseCase
    private let coordinator: NearMapCoordinator
    private let busStopId: String?
    private var busStopList: [BusStopInfoResponse] = []
    
    var mapController: KMController?
    private var mapView: KakaoMap? {
        mapController?.getView("mapview") as? KakaoMap
    }
    
    private var selectedBusId = PublishSubject<String>()
    private let disposeBag = DisposeBag()
	
	public init(
        coordinator: NearMapCoordinator,
        busStopId: String?
    ) {
        self.coordinator = coordinator
        self.busStopId = busStopId
	}
	
	deinit {
        mapController?.stopRendering()
        mapController?.stopEngine()
		coordinator.finish()
	}
	
	public func transform(input: Input) -> Output {
		let output = Output(
            selectedBusStop: useCase.nearByBusStop,
            navigationTitle: .init(value: "주변 정류장")
		)
        
        input.viewWillAppearEvent
            .withUnretained(self)
            .bind(
                onNext: { viewModel, _ in
                    viewModel.updateNearBusStopList()
                    viewModel.useCase.updateNearByBusStop()
                }
            )
            .disposed(by: disposeBag)
        
        input.informationViewTapEvent
            .withLatestFrom(output.selectedBusStop)
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, busStop in
                    guard !busStop.busStopId.isEmpty
                    else { return }
                    viewModel.coordinator.startBusStopFlow(
                        busStopId: busStop.busStopId
                    )
                }
            )
            .disposed(by: disposeBag)
        
        input.kakaoMapTouchesEndedEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                    viewModel.updateNearBusStopList()
                }
            )
            .disposed(by: disposeBag)
        
        useCase.nearByBusStop
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, response in
                    guard let longitude = Double(response.longitude),
                          let latitude = Double(response.latitude)
                    else { return }
                    let responses = viewModel.busStopId != nil ?
                    viewModel.busStopList :
                    [response]
                    viewModel.moveCamera(
                        responses: responses,
                        longitude: longitude,
                        latitude: latitude
                    )
                    if viewModel.busStopId != nil {
                        output.navigationTitle.accept(response.busStopName)
                    }
                }
            )
            .disposed(by: disposeBag)
        
        useCase.nearBusStopList
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, responses in
                    viewModel.makeBusIcon(responses: responses)
                }
            )
            .disposed(by: disposeBag)
        
        selectedBusId
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, busStopId in
                    viewModel.useCase.busStopSelected(busStopId: busStopId)
                }
            )
            .disposed(by: disposeBag)
        
		return output
	}
    
    func initKakaoMap() {
        mapController?.delegate = self
        mapController?.initEngine()
        mapController?.startEngine()
        mapController?.authenticate()
    }
    
    private func addBusPointStyle() {
        guard let mapView
        else { return }
        
        let labelManager = mapView.getLabelManager()
        
        let layerOption = LabelLayerOptions(
            layerID: "busStopLayer",
            competitionType: .none,
            competitionUnit: .poi,
            orderType: .rank,
            zOrder: 10001
        )
        _ = labelManager.addLabelLayer(option: layerOption)
        
        let busIconStyle = PoiIconStyle(
            symbol: UIImage(systemName: "bus")?
                .withTintColor(DesignSystemAsset.accentColor.color),
            anchorPoint: CGPoint(
                x: 0.0,
                y: 0.0
            )
        )
        let busPerLevelStyle = PerLevelPoiStyle(
            iconStyle: busIconStyle,
            level: 0
        )
        let busPoiStyle = PoiStyle(
            styleID: "busStop",
            styles: [busPerLevelStyle]
        )
        labelManager.addPoiStyle(busPoiStyle)
    }
    
    private func makeBusIcon(responses: [BusStopInfoResponse]) {
        guard let mapView
        else { return }
        
        let layer = mapView.getLabelManager()
            .getLabelLayer(layerID: "busStopLayer")
        
        let viewMaxPoint = CGPoint(
            x: mapView.viewRect.size.width,
            y: mapView.viewRect.size.height
        )
        let minLatitude = mapView.getPosition(viewMaxPoint).wgsCoord.latitude
        let maxLatitude = mapView.getPosition(.zero).wgsCoord.latitude
        let minLongitude = mapView.getPosition(.zero).wgsCoord.longitude
        let maxLongitude = mapView.getPosition(viewMaxPoint).wgsCoord.longitude
        
        responses
            .forEach { response in
                guard layer?.getPoi(poiID: response.busStopId) == nil
                else { return }
                let poiOption = PoiOptions(
                    styleID: "busStop",
                    poiID: response.busStopId
                )
                poiOption.rank = 0
                poiOption.clickable = true
                guard let longitude = Double(response.longitude),
                      let latitude = Double(response.latitude)
                else { return }
                let poi1 = layer?.addPoi(
                    option: poiOption,
                    at: MapPoint(
                        longitude: longitude,
                        latitude: latitude
                    )
                )
                _ = poi1?.addPoiTappedEventHandler(
                    target: self,
                    handler: NearMapViewModel.poiTappedHandler
                )
                poi1?.show()
            }
    }
    
    private func moveCamera(
        responses: [BusStopInfoResponse],
        longitude: Double,
        latitude: Double
    ) {
        guard let mapView
        else { return }
        let cameraUpdate = CameraUpdate.make(
            target: .init(
                longitude: longitude,
                latitude: latitude
            ),
            mapView: mapView
        )
        let callback: () = makeBusIcon(responses: responses)
        mapView.moveCamera(
            cameraUpdate,
            callback: { callback }
        )
    }
    
    private func updateNearBusStopList() {
        guard let mapView
        else { return }
        let viewMaxPoint = CGPoint(
            x: mapView.viewRect.size.width,
            y: mapView.viewRect.size.height
        )
        let minLatitude = mapView
            .getPosition(viewMaxPoint).wgsCoord.latitude
        let maxLatitude = mapView
            .getPosition(.zero).wgsCoord.latitude
        let minLongitude = mapView
            .getPosition(.zero).wgsCoord.longitude
        let maxLongitude = mapView
            .getPosition(viewMaxPoint).wgsCoord.longitude
        let longitudeRange = minLongitude < maxLongitude ?
        minLongitude...maxLongitude :
        maxLongitude...minLongitude
        let latitudeRange = minLatitude < maxLatitude ?
        minLatitude...maxLatitude :
        maxLatitude...minLatitude
        useCase.updateNearBusStopList(
            longitudeRange: longitudeRange,
            latitudeRange: latitudeRange
        )
    }
    
    private func poiTappedHandler(_ param: PoiInteractionEventParam) {
        selectedBusId.onNext(param.poiItem.itemID)
    }
}

extension NearMapViewModel: MapControllerDelegate {
	public func addViews() {
        if let busStopId {
            useCase.busStopSelected(busStopId: busStopId)
        }
        
		let defaultPosition = MapPoint(
			longitude: 127.108678,
			latitude: 37.402001
		)
        
		let mapviewInfo = MapviewInfo(
			viewName: "mapview",
			appName: "openmap",
			viewInfoName: "map",
			defaultPosition: defaultPosition,
			defaultLevel: 16
		)
				
		if mapController?.addView(mapviewInfo) == Result.OK {
            addBusPointStyle()
		}
	}
	
	public func authenticationSucceeded() {
        mapController?.startRendering()
	}
	
	public func containerDidResized(_ size: CGSize) {
        guard let mapView
        else { return }
        mapView.viewRect = CGRect(
            origin: CGPoint(x: 0.0, y: 0.0),
            size: size
        )
    }
}

extension NearMapViewModel {
    public struct Input {
        let viewWillAppearEvent: Observable<Void>
        let kakaoMapTouchesEndedEvent: Observable<Void>
        let informationViewTapEvent: Observable<Void>
    }
    
    public struct Output {
        let selectedBusStop: PublishSubject<BusStopInfoResponse>
        let navigationTitle: BehaviorRelay<String>
    }
}
