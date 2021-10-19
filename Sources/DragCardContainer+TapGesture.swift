//
//  DragCardContainer+TapGesture.swift
//  YHDragContainer
//
//  Created by jun on 2021/10/18.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation
import UIKit

extension DragCardContainer {
    @objc internal func tapGestureRecognizer(tapGesture: UITapGestureRecognizer) {
        guard let cell = dynamicCardProperties.first?.cell else { return }
        delegate?.dragCard(self, didSelectIndexAt: currentIndex, withTopCell: cell)
    }
}
