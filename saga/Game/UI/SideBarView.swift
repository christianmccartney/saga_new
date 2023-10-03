//
//  SideBarView.swift
//  saga
//
//  Created by Christian McCartney on 12/2/21.
//

import SwiftUI

struct SideBarView: View {
    @EnvironmentObject var context: GameContext
    var size: CGSize
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                Button(action: equipment) {
                    Image("option_equip")
                        .interpolation(.none)
                        .resizable()
                        .frame(width: STANDARD_BUTTON_SIZE, height: STANDARD_BUTTON_SIZE)
                }
                .padding()
                Spacer()
            }
        }
        .frame(width: STANDARD_PANEL_SIZE, height: size.height * 0.5)
    }
    
    func equipment() {
        context.equipmentModal.toggle()
    }
}
