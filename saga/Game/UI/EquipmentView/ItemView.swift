//
//  ItemView.swift
//  saga
//
//  Created by Christian McCartney on 1/1/22.
//

import SwiftUI

struct ItemView: View {
    let item: Item
    let frame: CGRect
    @State var position: CGPoint
    
    var body: some View {
        Image(item.type.rawValue)
            .interpolation(.none)
            .resizable()
            .frame(width: EQUIPMENT_SLOT_SIZE, height: EQUIPMENT_SLOT_SIZE)
            .position(position)
            .gesture(dragGesture)
    }
    
    private static let size = CGSize(width: EQUIPMENT_SLOT_SIZE, height: EQUIPMENT_SLOT_SIZE)
    
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                if frame.contains(CGRect(origin: value.location, size: .zero).insetBy(dx: -50, dy: -50)) {
                    self.position = value.location
                }
            }
    }
}
