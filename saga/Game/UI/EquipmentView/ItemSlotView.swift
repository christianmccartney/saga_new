//
//  ItemSlotView.swift
//  saga
//
//  Created by Christian McCartney on 12/2/21.
//

import SwiftUI

enum ItemSlot: String {
    case head
    case chest
    case right_hand
    case left_hand
    case legs
    case feet
    case item
    case ring
    
    var imageName: String {
        "equipment_\(rawValue)"
    }
}

struct ItemSlotView: View {
    var itemSlot: ItemSlot
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Colors.black)
                .border(Colors.darkGray, width: 3)
            Image(itemSlot.imageName)
                .interpolation(.none)
                .resizable()
                .opacity(0.5)
                .frame(width: STANDARD_BUTTON_SIZE, height: STANDARD_BUTTON_SIZE)
        }
    }
}
