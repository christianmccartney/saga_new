//
//  InventoryView.swift
//  saga
//
//  Created by Christian McCartney on 1/1/22.
//

import SwiftUI

let hat = Item(name: "hat", type: .hat_leather)
let gem = Item(name: "gem", type: .gem_ruby)
let coins = Item(name: "coins", type: .coins_gold)

class InventoryContext {
    var itemPositions: [UUID: CGPoint] = [:]
}

struct InventoryView: View {
    let context = InventoryContext()
    @State var items: [Item] = [hat, gem, coins]
    
    func position(id: UUID) -> CGPoint {
        if let position = context.itemPositions[id] {
            return position
        } else {
            let position = CGPoint(50, 50)
            context.itemPositions[id] = position
            return position
        }
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Colors.black)
                .border(Colors.darkGray, width: 3)
            GeometryReader { geometry in
                
                ForEach(items, id: \.self) { item in
                    let position = position(id: item.id)
                    ItemView(item: item, frame: geometry.frame(in: .local), position: position)
                }
            }
//            ForEach(0..<width, id: \.self) { x in
//                ForEach(0..<height, id: \.self) { y in
//
//                }
//            }
        }
    }
}
