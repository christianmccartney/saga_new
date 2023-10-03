//
//  EquipmentView.swift
//  saga
//
//  Created by Christian McCartney on 11/30/21.
//

import SwiftUI

struct EquipmentView: View {
    @EnvironmentObject var context: GameContext
    var size: CGSize
    
//    var backgroundSprite: UIImage {
//        if let cgImage = context.coreScene.playerEntity?.spriteNode.texture?.cgImage() {
//            return UIImage(cgImage: cgImage).maskWithColor(color: .white) ?? UIImage()
//        } else {
//            return UIImage()
//        }
//    }
    
    var body: some View {
        ZStack(alignment: .center) {
            // Background
            BackgroundView()
            
            // Content
            HStack {
                // Item slots
                VStack {
                    ItemSlotView(itemSlot: .head)
                        .frame(width: EQUIPMENT_SLOT_SIZE, height: EQUIPMENT_SLOT_SIZE)
                    HStack {
                        ItemSlotView(itemSlot: .left_hand)
                            .frame(width: EQUIPMENT_SLOT_SIZE, height: EQUIPMENT_SLOT_SIZE)
                        ItemSlotView(itemSlot: .chest)
                            .frame(width: EQUIPMENT_SLOT_SIZE, height: EQUIPMENT_SLOT_SIZE)
                        ItemSlotView(itemSlot: .right_hand)
                            .frame(width: EQUIPMENT_SLOT_SIZE, height: EQUIPMENT_SLOT_SIZE)
                    }
                    HStack {
                        ItemSlotView(itemSlot: .item)
                            .frame(width: EQUIPMENT_SLOT_SIZE, height: EQUIPMENT_SLOT_SIZE)
                        ItemSlotView(itemSlot: .legs)
                            .frame(width: EQUIPMENT_SLOT_SIZE, height: EQUIPMENT_SLOT_SIZE)
                        ItemSlotView(itemSlot: .ring)
                            .frame(width: EQUIPMENT_SLOT_SIZE, height: EQUIPMENT_SLOT_SIZE)
                    }
                    HStack {
                        ItemSlotView(itemSlot: .item)
                            .frame(width: EQUIPMENT_SLOT_SIZE, height: EQUIPMENT_SLOT_SIZE)
                        ItemSlotView(itemSlot: .feet)
                            .frame(width: EQUIPMENT_SLOT_SIZE, height: EQUIPMENT_SLOT_SIZE)
                        ItemSlotView(itemSlot: .ring)
                            .frame(width: EQUIPMENT_SLOT_SIZE, height: EQUIPMENT_SLOT_SIZE)
                    }
                }
                .frame(width: size.width * 0.4)
                // Inventory
                InventoryView()
                    .frame(width: size.width * 0.4)
                    .padding(EdgeInsets(top: 128, leading: 0, bottom: 64, trailing: 64))
            }
            
            // Close button
            ZStack(alignment: .topTrailing) {
                Color.clear
                Button(action: dismiss) {
                    Image("close_stone")
                        .interpolation(.none)
                        .resizable()
                        .frame(width: STANDARD_BUTTON_SIZE, height: STANDARD_BUTTON_SIZE)
                }
                .padding()
            }
        }
        .frame(width: size.width * 0.8, height: size.height * 0.8)
    }
    
    private func dismiss() {
        context.equipmentModal = false
    }
}

struct BackgroundView: View {
    var body: some View {
        Rectangle()
            .fill(PixelRGBU8.dGray.color)
            .border(width: 3, edges: [.top], color: .white, offset: 3)
            .border(width: 3, edges: [.top, .leading, .trailing], color: Colors.gray, size: 3, offset: 3)
            .border(width: 3, edges: [.bottom], color: Colors.darkGray, size: 3, offset: 3)
            .border(Colors.black, width: 3)
    }
}

extension HorizontalAlignment {
    enum MyHorizontal: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat { d[HorizontalAlignment.center] }
    }
    static let equipment = HorizontalAlignment(MyHorizontal.self)
}

extension VerticalAlignment {
    enum MyVertical: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat { d[VerticalAlignment.center] }
    }
    static let equipment = VerticalAlignment(MyVertical.self)
}

extension Alignment {
    static let equipment = Alignment(horizontal: .equipment, vertical: .equipment)
}
