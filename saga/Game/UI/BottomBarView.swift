//
//  BottomBarView.swift
//  saga
//
//  Created by Christian McCartney on 12/2/21.
//

import SwiftUI

struct BottomBarView: View {
    @EnvironmentObject var context: GameContext
    var size: CGSize
    @State var abilities: [Ability?]
    @State var selectedAbility: Ability? = nil
    
    var body: some View {
        ZStack {
            BackgroundView()
            HStack {
                ForEach(abilities, id: \.self) { ability in
                    if let ability = ability {
                        Button(action: {
                            self.select(ability)
                        }) {
                            ZStack {
                                Image(selectedAbility == ability ? ButtonType.blank.textureName + "_press" : ButtonType.blank.textureName)
                                    .interpolation(.none)
                                    .resizable()
                                    .frame(width: STANDARD_BUTTON_SIZE, height: STANDARD_BUTTON_SIZE)
                                Image(ability.abilityTextureName)
                                    .interpolation(.none)
                                    .resizable()
                                    .frame(width: STANDARD_BUTTON_SIZE, height: STANDARD_BUTTON_SIZE)
                            }
                        }
                    } else {
                        Image("panel_empty")
                            .interpolation(.none)
                            .resizable()
                            .frame(width: STANDARD_BUTTON_SIZE, height: STANDARD_BUTTON_SIZE)
                    }
                }
                Spacer()
            }
            .padding()
        }
        .frame(width: size.width * 0.5, height: STANDARD_PANEL_SIZE)
        .onReceive(context.coreScene.$truncatedAbilities) { self.abilities = $0 }
    }
    
    private func select(_ ability: Ability) {
        if ability == selectedAbility {
            selectedAbility = nil
            context.coreScene?.selectedAbility = nil
            context.coreScene?.playerEntity?.selectedAbility = nil
        } else {
            selectedAbility = ability
            context.coreScene?.selectedAbility = ability
            context.coreScene?.playerEntity?.selectedAbility = ability
        }
    }
}
