//
//  ModeState.swift
//  DragCardContainer
//
//  Created by dfsx6 on 2023/2/27.
//

import Foundation


internal final class ModeState {
    
    internal var itemModels: [ItemModel] = []
    
    private weak var layout: Layout?
    
    internal init(layout: Layout) {
        self.layout = layout
    }
    
}

extension ModeState {
    internal func setItemModels(_ itemModels: [ItemModel]) {
        self.itemModels = itemModels
    }
}

extension ModeState {
    
}
