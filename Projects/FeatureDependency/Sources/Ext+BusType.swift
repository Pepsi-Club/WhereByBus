//
//  Ext+BusType.swift
//  FeatureDependency
//
//  Created by Jisoo HAM on 2/20/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import DesignSystem
import Domain

extension BusType {
    public var toColor: DesignSystemColors.Color {
        switch self {
        case .common:
            return DesignSystemAsset.gray4.color
        case .airport:
            return DesignSystemAsset.airportGold.color
        case .village:
            return DesignSystemAsset.limeGreen.color
        case .trunkLine:
            return DesignSystemAsset.regularAlarmBlue.color
        case .branchLine:
            return DesignSystemAsset.limeGreen.color
        case .circulation:
            return DesignSystemAsset.circulateYellow.color
        case .wideArea:
            return DesignSystemAsset.redBusColor.color
        case .incheon:
            return DesignSystemAsset.settingColor.color
        case .gyeonggi:
            return DesignSystemAsset.settingColor.color
        case .abolition:
            return DesignSystemAsset.gray4.color
        }
    }
}
