//
//  MinimapView.swift
//  saga
//
//  Created by Christian McCartney on 12/4/21.
//

import SwiftUI
import SpriteKit

private enum MinimapTileDefinition: Int {
    case center = 0
    case horizontal = 1
    case vertical = 2
    case none = 3
    
}

struct MinimapView: View {
    var size: CGSize
    
    var body: some View {
        ZStack {
            BackgroundView()
        }
        .frame(width: size.width * 0.2, height: size.height * 0.2)
    }
    
//    private func images(for map: Map) -> [UIImage] {
//        var images = [UIImage]()
//
//        for y in 1..<map.count-1 {
//            for x in 1..<map[y].count-1 {
//                guard let image = Map.tileImage(col: x, row: y, fillMap: map) else {
//                    fatalError("Should have gotten something here")
//                }
//                images.append(image)
//            }
//        }
//        return images
//    }
}
