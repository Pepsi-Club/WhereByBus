//
//  SearchTVSearchedBGView.swift
//  SearchFeature
//
//  Created by 유하은 on 2024/03/12.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import DesignSystem

public final class SearchTVSearchedBGView: UIView {
    private let nearStopNameLabel: UILabel = {
        let label = UILabel()
        label.font =
        DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(size: 14)
        label.textColor = DesignSystemAsset.gray6.color
        label.text = "찾는 검색어가 없습니다."
        
        return label
    }()
}
