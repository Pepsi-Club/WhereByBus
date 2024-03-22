//
//  BusStopInformationView.swift
//  NearMapFeatureDemo
//
//  Created by Muker on 2/7/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import DesignSystem
import Domain

public final class BusStopInformationView: UIView {
	
	// MARK: - UI Property
	
	private let symbolSize = 50
	
	private let busStopSymbol: UIImageView = {
		let image = UIImageView(
			image: UIImage(systemName: "mappin.and.ellipse")!
		)
		image.tintColor = DesignSystemAsset.gray5.color
		return image
	}()
	
    private let busStopNameLabel: UILabel = {
		let label = UILabel()
		label.font = DesignSystemFontFamily.NanumSquareNeoOTF.extraBold.font(
			size: 15
		)
        label.textColor = .black
		return label
	}()
	
    private let busStopDescription: UILabel = {
		let label = UILabel()
		label.font = DesignSystemFontFamily.NanumSquareNeoOTF.light.font(
			size: 13
		)
        label.textColor = .black
		return label
	}()
	
    private let distanceFromBusStopLabel: UILabel = {
		let label = UILabel()
		label.font = DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(
			size: 13
		)
        label.textColor = .black
		return label
	}()
	
    private let separationView: UIView = {
		let view = UIView()
		view.backgroundColor = DesignSystemAsset.gray5.color
		return view
	}()
	
	private lazy var busStopNameStackView: UIStackView = {
		let stackView = UIStackView(
			arrangedSubviews: [
                busStopNameLabel,
                busStopDescription
            ]
		)
		stackView.axis = .vertical
		stackView.distribution = .fillEqually
		stackView.alignment = .leading
		stackView.spacing = 3
		return stackView
	}()
	
	// MARK: - Life Cycle
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configureUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Function
	
	private func configureUI() {
        self.backgroundColor = DesignSystemAsset.gray1.color
		
		[
			busStopSymbol,
			busStopNameStackView,
			distanceFromBusStopLabel,
			separationView,
		].forEach {
			self.addSubview($0)
			$0.translatesAutoresizingMaskIntoConstraints = false
		}
		
		NSLayoutConstraint.activate([
			
			// busStopSymbol
			busStopSymbol.topAnchor.constraint(
				equalTo: self.topAnchor,
				constant: 20
			),
			busStopSymbol.leftAnchor.constraint(
				equalTo: self.leftAnchor,
				constant: 20
			),
			busStopSymbol.heightAnchor.constraint(
				equalToConstant: CGFloat(symbolSize)
			),
			busStopSymbol.widthAnchor.constraint(
				equalToConstant: CGFloat(symbolSize)
			),
			
			// busStopNameStackView
			busStopNameStackView.topAnchor.constraint(
				equalTo: self.topAnchor,
				constant: 20
			),
			busStopNameStackView.leftAnchor.constraint(
				equalTo: busStopSymbol.rightAnchor,
				constant: 15
			),
			busStopNameStackView.rightAnchor.constraint(
				equalTo: self.rightAnchor,
				constant: -10
			),
			busStopNameStackView.heightAnchor.constraint(
				equalToConstant: CGFloat(symbolSize)
			),
			
			// separationView
			separationView.topAnchor.constraint(
				equalTo: busStopNameStackView.bottomAnchor,
				constant: 10
			),
			separationView.leftAnchor.constraint(
				equalTo: self.leftAnchor,
				constant: 20
			),
			separationView.rightAnchor.constraint(
				equalTo: self.rightAnchor,
				constant: -10
			),
			separationView.heightAnchor.constraint(
				equalToConstant: 1
			),
			
			// distanceFromBusStopLabel
			distanceFromBusStopLabel.topAnchor.constraint(
				equalTo: separationView.bottomAnchor,
				constant: 10
			),
			distanceFromBusStopLabel.leftAnchor.constraint(
				equalTo: self.leftAnchor,
				constant: 20 + CGFloat(symbolSize) + 15
			),
			distanceFromBusStopLabel.rightAnchor.constraint(
				equalTo: self.rightAnchor,
				constant: -10
			),
		])
		
	}
    
    func updateUI(response: BusStopInfoResponse, distance: String) {
        busStopNameLabel.text = response.busStopName
        if !response.busStopId.isEmpty && !response.direction.isEmpty {
        }
        let description = !response.busStopId.isEmpty &&
        !response.direction.isEmpty ?
        "\(response.busStopId) | \(response.direction) 방면" : ""
        busStopDescription.text = description
        distanceFromBusStopLabel.text = distance
    }
}
