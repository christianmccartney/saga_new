//
//  main.swift
//  saga
//
//  Created by Christian McCartney on 10/22/21.
//

import SwiftUI
import SpriteKit

class GameContext: ObservableObject {
    var coreScene: CoreScene!
    @Published var equipmentModal: Bool = false

    func scene(size: CGSize) -> CoreScene {
        CoreScene.screenSizeRect = CGRect(
            x: ((size.width  * 0.5) * -1.0),
            y: ((size.height * 0.5) * -1.0),
            width: size.width,
            height: size.height)
        if let coreScene = coreScene {
            return coreScene
        }
        let scene = CoreScene()
        scene.size = size
        scene.scaleMode = .aspectFill
        coreScene = scene
        coreScene.context = self
        return scene
    }
}

@main
struct MainView: App {
    let context = GameContext()
    @State var equipmentModal: Bool = false
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            GeometryReader { (geometry) in
                // ---------- Test Generation Views
//                let context = FMContext(size: geometry.size)
//                FileStructureView().environmentObject(context)
                // ---------- Game Views
                ZStack {
                    SpriteView(scene: context.scene(size: geometry.size))
                    ZStack(alignment: .trailing) {
                        Color.clear
                        SideBarView(size: geometry.size)
                            .environmentObject(context)
                            .padding()
                    }
                    ZStack(alignment: .bottom) {
                        Color.clear
                        BottomBarView(size: geometry.size, abilities: context.coreScene.truncatedAbilities)
                            .environmentObject(context)
                            .padding()
                    }
//                    ZStack(alignment: .bottomLeading) {
//                        Color.clear
//                        MinimapView(size: geometry.size, map: MapController.shared.map)
//                            .padding()
//                    }
                    if equipmentModal {
                        EquipmentView(size: geometry.size)
                            .environmentObject(context)
                    }
////                    PrototypeNumberView(size: geometry.size)
                }
                // ----------
            }
            .onReceive(context.$equipmentModal) { equipmentModal = $0 }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .inactive {
                    print("Inactive")
                    context.coreScene?.pause(true)
                } else if newPhase == .active {
                    print("Active")
                    context.coreScene?.pause(false)
                } else if newPhase == .background {
                    print("Background")
                    context.coreScene?.pause(true)
                }
            }
        }
    }
}
