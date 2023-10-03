//
//  WeaponForm.swift
//  saga
//
//  Created by Christian McCartney on 10/26/21.
//

import Foundation
import CoreGraphics

// It would be better to define how components stick to each other instead of using absolute location for each
struct Blueprint {
    let origin: CGPoint
    let z: Int
    let shapes: [ShapeMask]
}

struct WeaponBlueprint {
    static let none = Blueprint(origin: CGPoint(x: 0, y: 0), z: 0, shapes: [])

    static func generate(for type: WeaponType, component: WeaponComponent, form: WeaponForm) -> Blueprint {
        switch type {
        case .sword:
            return SwordBlueprints.blueprint(for: component, form: form)
        case .axe:
            break
        case .spear:
            return SpearBlueprints.blueprint(for: component, form: form)
        case .club:
            break
        case .bow:
            break
        case .staff:
            break
        case .wand:
            break
        }
        return WeaponBlueprint.none
    }
}
