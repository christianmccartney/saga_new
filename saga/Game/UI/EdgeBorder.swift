//
//  EdgeBorder.swift
//  saga
//
//  Created by Christian McCartney on 11/30/21.
//

import SwiftUI

extension View {
    func border(width: CGFloat, edges: [Edge], color: Color, size: Int = 0, offset: Int = 0) -> some View {
        overlay(EdgeBorder(width: width, edges: edges, size: CGFloat(size), offset: CGFloat(offset)).foregroundColor(color))
    }
}

struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]
    var size: CGFloat
    var offset: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat {
                switch edge {
                case .top, .bottom: return rect.minX + offset + size
                case .leading: return rect.minX + offset
                case .trailing: return rect.maxX - width - offset
                }
            }

            var y: CGFloat {
                switch edge {
                case .top: return rect.minY + offset
                case .leading, .trailing: return rect.minY + offset + size
                case .bottom: return rect.maxY - width - offset
                }
            }

            var w: CGFloat {
                switch edge {
                case .top, .bottom: return rect.width - offset - size - size - size
                case .leading, .trailing: return self.width
                }
            }

            var h: CGFloat {
                switch edge {
                case .top, .bottom: return self.width
                case .leading, .trailing: return rect.height - offset - size - size - size
                }
            }
            path.addPath(Path(CGRect(x: x, y: y, width: w, height: h)))
        }
        return path
    }
}
