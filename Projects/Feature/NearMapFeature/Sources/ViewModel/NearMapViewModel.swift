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
    private let viewMode: NearMapMode
    
    var mapController: KMController?
    private var mapDisposeBag: [DisposableEventHandler?] = []
    
    private var selectedBusId = PublishSubject<String>()
    private var nearStopList = PublishSubject<[BusStopInfoResponse]>()
    private let disposeBag = DisposeBag()
	
    public init(
        coordinator: NearMapCoordinator,
        busStopId: String?
    ) {
        self.coordinator = coordinator
        if let busStopId {
            viewMode = .focused(busStopId: busStopId)
        } else {
            viewMode = .normal
        }
	}
	
	deinit {
		coordinator.finish()
	}
	
	public func transform(input: Input) -> Output {
        initKakaoMap()
		let output = Output(
            selectedBusStopInfo: .init(),
            navigationTitle: .init(value: "주변 정류장")
		)
        
        input.viewWillAppearEvent
            .withUnretained(self)
            .bind(
                onNext: { viewModel, _ in
                    viewModel.mapController?.startRendering()
                }
            )
            .disposed(by: disposeBag)
        
        input.viewWillDisappearEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                    viewModel.mapController?.stopRendering()
                }
            )
            .disposed(by: disposeBag)
        
        input.informationViewTapEvent
            .withLatestFrom(output.selectedBusStopInfo)
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, tuple in
                    let (response, _) = tuple
                    switch viewModel.viewMode {
                    case .normal:
                        viewModel.coordinator.startBusStopFlow(
                            busStopId: response.busStopId
                        )
                    case .focused:
                        break
                    }
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
        
        selectedBusId
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, busStopId in
                    switch viewModel.viewMode {
                    case .normal:
                        let selectedStopInfo = viewModel.useCase
                            .getSelectedBusStop(busStopId: busStopId)
                        output.selectedBusStopInfo.onNext(selectedStopInfo)
                    case .focused:
                        break
                    }
                }
            )
            .disposed(by: disposeBag)
        
        output.selectedBusStopInfo
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, tuple in
                    let (selectedBusStop, _) = tuple
                    guard let longitude = Double(selectedBusStop.longitude),
                          let latitude = Double(selectedBusStop.latitude)
                    else { return }
                    if let poi = viewModel.labelLayer?.getPoi(
                        poiID: selectedBusStop.busStopId
                    ) {
                        poi.changeStyle(
                            styleID: BusPointStyle.selected.styleId,
                            enableTransition: true
                        )
                    } else {
                        let poiOption = PoiOptions(
                            styleID: BusPointStyle.selected.styleId,
                            poiID: selectedBusStop.busStopId
                        )
                        poiOption.rank = 0
                        poiOption.clickable = true
                        let poi = viewModel.labelLayer?.addPoi(
                            option: poiOption,
                            at: .init(
                                longitude: longitude,
                                latitude: latitude
                            )
                        )
                        let handler = poi?.addPoiTappedEventHandler(
                            target: viewModel,
                            handler: NearMapViewModel.poiTappedHandler
                        )
                        viewModel.mapDisposeBag.append(handler)
                        poi?.show()
                    }
                    viewModel.moveCamera(
                        longitude: longitude,
                        latitude: latitude
                    )
                    switch viewModel.viewMode {
                    case .normal:
                        break
                    case .focused:
                        output.navigationTitle.accept(
                            selectedBusStop.busStopName
                        )
                    }
                }
            )
            .disposed(by: disposeBag)
        
        nearStopList
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, responses in
                    viewModel.makeBusIcon(responses: responses)
                }
            )
            .disposed(by: disposeBag)
        
        Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: false
        ) { [weak self] timer in
            guard let self else { return }
            switch viewMode {
            case .normal:
                useCase.getNearByStopInfo()
                    .subscribe(
                        onNext: { selectedBusStopInfo in
                            output.selectedBusStopInfo.onNext(
                                selectedBusStopInfo
                            )
                        }
                    )
                    .disposed(by: disposeBag)
            case .focused(let busStopId):
                output.selectedBusStopInfo.onNext(
                    useCase.getSelectedBusStop(busStopId: busStopId)
                )
            }
            timer.invalidate()
        }
        
        return output
	}
    
    private func initKakaoMap() {
        mapController?.delegate = self
        mapController?.initEngine()
        mapController?.startEngine()
        mapController?.authenticate()
    }
    
    private func addBusPointStyle() {
        let labelManager = mapView?.getLabelManager()
        
        let layerOption = LabelLayerOptions(
            layerID: labelLayerId,
            competitionType: .none,
            competitionUnit: .poi,
            orderType: .rank,
            zOrder: 10001
        )
        _ = labelManager?.addLabelLayer(option: layerOption)
        
        let busIconStyle = PoiIconStyle(
            symbol: UIImage(systemName: "bus")?
                .withTintColor(DesignSystemAsset.accentColor.color)
        )
        let selectedIconStyle = PoiIconStyle(
            symbol: UIImage(systemName: "bus")?
                .withTintColor(DesignSystemAsset.headerBlue.color)
        )
        let busPerLevelStyle = PerLevelPoiStyle(
            iconStyle: busIconStyle,
            level: 0
        )
        let selectedPerLevelStyle = PerLevelPoiStyle(
            iconStyle: selectedIconStyle,
            level: 0
        )
        let busPoiStyle = PoiStyle(
            styleID: BusPointStyle.normal.styleId,
            styles: [busPerLevelStyle]
        )
        let selectedBusStyle = PoiStyle(
            styleID: BusPointStyle.selected.styleId,
            styles: [selectedPerLevelStyle]
        )
        labelManager?.addPoiStyle(busPoiStyle)
        labelManager?.addPoiStyle(selectedBusStyle)
    }
    
    private func makeBusIcon(responses: [BusStopInfoResponse]) {
        responses
            .forEach { [weak self] response in
                guard let self else { return }
                guard labelLayer?.getPoi(poiID: response.busStopId) == nil,
                      let longitude = Double(response.longitude),
                      let latitude = Double(response.latitude)
                else { return }
                let poiOption = PoiOptions(
                    styleID: BusPointStyle.normal.styleId,
                    poiID: response.busStopId
                )
                poiOption.rank = 0
                poiOption.clickable = true
                let poi = labelLayer?.addPoi(
                    option: poiOption,
                    at: MapPoint(
                        longitude: longitude,
                        latitude: latitude
                    )
                )
                let handler = poi?.addPoiTappedEventHandler(
                    target: self,
                    handler: NearMapViewModel.poiTappedHandler
                )
                mapDisposeBag.append(handler)
                poi?.show()
            }
    }
    
    private func moveCamera(
        longitude: Double,
        latitude: Double
    ) {
        guard let mapView else { return }
        let cameraUpdate = CameraUpdate.make(
            target: .init(
                longitude: longitude,
                latitude: latitude
            ),
            mapView: mapView
        )
        let callback = { self.updateNearBusStopList() }
        mapView.moveCamera(
            cameraUpdate,
            callback: callback
        )
    }
    
    private func updateNearBusStopList() {
        guard let mapView else { return }
        let viewMaxPoint = CGPoint(
            x: mapView.viewRect.size.width,
            y: mapView.viewRect.size.height
        )
        let longitude1 = mapView.getPosition(.zero).wgsCoord.longitude
        let latitude1 = mapView.getPosition(.zero).wgsCoord.latitude
        let longitude2 = mapView.getPosition(viewMaxPoint).wgsCoord.longitude
        let latitude2 = mapView.getPosition(viewMaxPoint).wgsCoord.latitude
        
        let longitudeRange = longitude1 < longitude2 ?
        longitude1...longitude2 : longitude2...longitude1
        let latitudeRange = latitude2 < latitude1 ?
        latitude2...latitude1 : latitude1...latitude2
        
        nearStopList.onNext(
            useCase.getNearBusStopList(
                longitudeRange: longitudeRange,
                latitudeRange: latitudeRange
            )
        )
    }
    
    private func poiTappedHandler(_ param: PoiInteractionEventParam) {
        labelLayer?
            .getAllPois()?
            .forEach { poi in
                poi.changeStyle(
                    styleID: "busStop",
                    enableTransition: true
                )
            }
        selectedBusId.onNext(param.poiItem.itemID)
    }
    
    func removeMapController() {
        mapDisposeBag.forEach {
            $0?.dispose()
        }
        let labelManager = mapView?.getLabelManager()
        labelLayer?.clearAllItems()
        labelManager?.clearAllLabelLayers()
        mapController?.removeView("mapview")
        mapController?.stopRendering()
        mapController?.stopEngine()
        mapController?.clearMemoryCache("mapview")
        mapController?.delegate = nil
        mapController = nil
    }
}

extension NearMapViewModel: MapControllerDelegate {
	public func addViews() {
		let defaultPosition = MapPoint(
			longitude: 126.979620,
			latitude: 37.570028
		)
        
		let mapviewInfo = MapviewInfo(
			viewName: "mapview",
			appName: "openmap",
			viewInfoName: "map",
			defaultPosition: defaultPosition,
			defaultLevel: 8
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
    
    public func viewWillDestroyed(_ view: ViewBase) {
    }
}

extension NearMapViewModel {
    public struct Input {
        let viewWillAppearEvent: Observable<Void>
        let viewWillDisappearEvent: Observable<Void>
        let kakaoMapTouchesEndedEvent: Observable<Void>
        let informationViewTapEvent: Observable<Void>
    }
    
    public struct Output {
        let selectedBusStopInfo: PublishSubject<(BusStopInfoResponse, String)>
        let navigationTitle: BehaviorRelay<String>
    }
}

extension NearMapViewModel {
    private enum NearMapMode {
        case normal, focused(busStopId: String)
    }
    
    private enum BusPointStyle: CaseIterable {
        case normal, selected
        
        var styleId: String {
            switch self {
            case .normal:
                return "busStop"
            case .selected:
                return "selectedBusStop"
            }
        }
    }
    
    private var labelLayerId: String {
        "busStopLayer"
    }
    
    private var mapView: KakaoMap? {
        mapController?.getView("mapview") as? KakaoMap
    }
    
    private var labelLayer: LabelLayer? {
        mapView?
            .getLabelManager()
            .getLabelLayer(layerID: labelLayerId)
    }
}
