//
//  SpearBlueprint.swift
//  saga
//
//  Created by Christian McCartney on 10/31/21.
//

import CoreGraphics


struct SpearBlueprints {
    
    // MARK: Straight components
    private static let straightHiltWidth = 0.01
    static let straightBlade = Blueprint(
        origin: CGPoint(x: 0.05, y: 0.5),
        z: 2,
        shapes: [TriangleMask(a: CGPoint(x: 0.07, y: 0.5),
                              b: CGPoint(x: 0.22, y: 0.54),
                              c: CGPoint(x: 0.22, y: 0.46),
                              z: 0,
                              color: .metal),
//                 RectangleMask(a: CGPoint(x: 0.15, y: 0.48),
//                               b: CGPoint(x: 0.18, y: 0.52),
//                               z: 0,
//                               color: .metal)
                ])
    
    static let straightCrossguard = Blueprint(
        origin: CGPoint(x: 0.62, y: 0.5),
        z: 1,
        shapes: [
//            RectangleMask(a: CGPoint(x: 0.66, y: 0.43),
//                                   b: CGPoint(x: 0.69, y: 0.57),
//                                   z: 0,
//                                   color: .wood)
        ])

    static let straightHilt = Blueprint(
        origin: CGPoint(x: 0.6, y: 0.5),
        z: 0,
        shapes: [
            RectangleMask(a: CGPoint(x: 0.20, -straightHiltWidth),
                               b: CGPoint(x: 0.85, straightHiltWidth),
                               z: 0,
                               color: .wood)
        ])

    static let straightPommel = Blueprint(
        origin: CGPoint(x: 0.9, y: 0.5),
        z: 1,
        shapes: [
//            CircleMask(center: CGPoint(x: 0.92, y: 0.5),
//                            radius: 0.04,
//                            z: 0,
//                            color: .metal)
        ])
    
    // MARK: Parabolic components
    static let parabolicBlade = Blueprint(
        origin: CGPoint(x: 0.05, y: 0.5),
        z: 0,
        shapes: [BezierMask(start: CGPoint(x: 0.13, y: 0.4),
                            points: [(CGPoint(x: 0.13, y: 0.6), CGPoint(x: 0.20, y: 0.5)),
                                     (CGPoint(x: 0.14, y: 0.6), nil),
                                     (CGPoint(x: 0.14, y: 0.4), CGPoint(x: 0.28, y: 0.5)),
                                     (CGPoint(x: 0.13, y: 0.4), nil),
                                    ],
                            color: .metal)])
    
    static let parabolicCrossguard = Blueprint(
        origin: CGPoint(x: 0.6, y: 0.5),
        z: 1,
        shapes: [BezierMask(start: CGPoint(x: 0.61, y: 0.37),
                            points: [(CGPoint(x: 0.61, y: 0.63), CGPoint(x: 0.7, y: 0.5)),
                                     (CGPoint(x: 0.63, y: 0.63), nil),
                                     (CGPoint(x: 0.63, y: 0.37), CGPoint(x: 0.78, y: 0.5)),
                                     (CGPoint(x: 0.61, y: 0.37), nil),
                                    ],
                            color: .metal)])
    
    static let parabolicHilt = Blueprint(
        origin: CGPoint(x: 0.7, y: 0.5),
        z: 0,
        shapes: [BezierMask(start: CGPoint(x: 0.69, y: 0.47),
                            points: [(CGPoint(x: 0.9, y: 0.47), CGPoint(x: 0.8, y: 0.43)),
                                     (CGPoint(x: 0.9, y: 0.53), nil),
                                     (CGPoint(x: 0.69, y: 0.53), CGPoint(x: 0.8, y: 0.48)),
                                     (CGPoint(x: 0.69, y: 0.47), nil),
                                    ],
                            color: .wood)])
    
    static let parabolicPommel = Blueprint(
        origin: CGPoint(x: 0.9, y: 0.5),
        z: 1,
        shapes: [BezierMask(start: CGPoint(x: 0.94, y: 0.57),
                            points: [(CGPoint(x: 0.94, y: 0.43), CGPoint(x: 0.79, y: 0.5)),
                                     (CGPoint(x: 0.94, y: 0.45), nil),
                                     (CGPoint(x: 0.94, y: 0.55), CGPoint(x: 0.87, y: 0.5)),
                                     (CGPoint(x: 0.94, y: 0.57), nil),
                                    ],
                            color: .metal)])
    
    static func blueprint(for component: WeaponComponent, form: WeaponForm) -> Blueprint {
        switch form {
        case .straight:
            switch component {
            case .blade:
                return SpearBlueprints.straightBlade
            case .crossguard:
                return SpearBlueprints.straightCrossguard
            case .hilt:
                return SpearBlueprints.straightHilt
            case .pommel:
                return SpearBlueprints.straightPommel
            default:
                print("Shouldnt have gotten here")
            }
        case .parabolic:
            switch component {
            case .blade:
                return SpearBlueprints.parabolicBlade
            case .crossguard:
                return SpearBlueprints.straightCrossguard
            case .hilt:
                return SpearBlueprints.straightHilt
            case .pommel:
                return SpearBlueprints.straightPommel
            default:
                print("Shouldnt have gotten here")
            }
        case .cubic:
            print("Shouldnt have gotten here")
        case .wavy:
            print("Shouldnt have gotten here")
        case .twopronged:
            print("Shouldnt have gotten here")
        case .threepronged:
            print("Shouldnt have gotten here")
        }
        return SpearBlueprints.straightBlade
    }
}
