//
//  Map.swift
//  saga
//
//  Created by Christian McCartney on 12/4/21.
//

import SpriteKit

extension Map {
    // CAREFUL: Maybe gonna run into issues with maps that arent square?
    func nearbyRoom(_ room: RectangularRoom, _ x: Int, _ y: Int, _ dx: Int = 1, _ dy: Int = 1) -> Bool {
        guard x-dx > 0, x+dx < count, y-dy > 0, y+dy < count else { return true }
        for px in x-dx...x+dx {
            for py in y-dy...y+dy {
                if !room.contains(px, py), self[py][px] {
                    return true
                }
            }
        }
        return false
    }
    
    func visualize() {
        var rowCount = 0
        for x in self.reversed() {
            print("[ ", terminator: "")
            for y in x {
                print("\(y ? 1 : 0) ", terminator: "")
            }
            print(" ] \(rowCount)")
            rowCount += 1
        }
    }
    
//    var physicsBodies: [SKPhysicsBody] {
//        var bodies: [SKPhysicsBody] = []
//
//        for x in 1..<self.count-1 {
//            for y in 1..<self[x].count-1 {
//
//            }
//        }
//
//        return bodies
//    }
    
    static func tileImage(col: Int, row: Int, fillMap: Map) -> UIImage? {
        let n = fillMap[row+1][col]
        let s = fillMap[row-1][col]
        let e = fillMap[row][col+1]
        let w = fillMap[row][col-1]
        
        let ne = fillMap[row+1][col+1]
        let nw = fillMap[row+1][col-1]
        let se = fillMap[row-1][col+1]
        let sw = fillMap[row-1][col-1]
        
        let neighbors = [n, s, e, w].compactMap { $0 ? true : nil }.count
        let diagonals = [ne, nw, se, sw].compactMap { $0 ? true : nil }.count
        if neighbors == 4 {
            // 1 1 0
            // 1 1 1
            // 1 1 1
            if diagonals == 3 {
                if !ne {
                    return UIImage(named: "yellow_highlight_15")
                }
                if !nw {
                    return UIImage(named: "yellow_highlight_18")
                }
                if !se {
                    return UIImage(named: "yellow_highlight_16")
                }
                if !sw {
                    return UIImage(named: "yellow_highlight_17")
                }
            // 0 1 0
            // 1 1 1
            // 1 1 1
            // or
            // 0 1 1
            // 1 1 1
            // 1 1 0
            } else if diagonals == 2 {
                if !ne, !nw {
                    return UIImage(named: "yellow_highlight_19")
                }
                if !ne, !se {
                    return UIImage(named: "yellow_highlight_20")
                }
                if !se, !sw {
                    return UIImage(named: "yellow_highlight_21")
                }
                if !sw, !nw {
                    return UIImage(named: "yellow_highlight_22")
                }
                if !nw, !se {
                    return UIImage(named: "yellow_highlight_45")
                }
                if !ne, !sw {
                    return UIImage(named: "yellow_highlight_46")
                }
            // 0 1 0
            // 1 1 1
            // 1 1 0
            } else if diagonals == 1 {
                if se {
                    return UIImage(named: "yellow_highlight_41")
                }
                if sw {
                    return UIImage(named: "yellow_highlight_42")
                }
                if nw {
                    return UIImage(named: "yellow_highlight_43")
                }
                if ne {
                    return UIImage(named: "yellow_highlight_44")
                }
            }
        } else if neighbors == 3 {
            // 1 1 1
            // 1 1 1
            // 1 0 1
            if diagonals == 4 {
                if !n {
                    return UIImage(named: "yellow_highlight_2")
                }
                if !s {
                    return UIImage(named: "yellow_highlight_8")
                }
                if !e {
                    return UIImage(named: "yellow_highlight_6")
                }
                if !w {
                    return UIImage(named: "yellow_highlight_4")
                }
            // 1 1 0
            // 1 1 0
            // 1 1 1
            // or
            // 1 0 1
            // 1 1 1
            // 1 1 0
            } else if diagonals == 3 {
                if !n, !se {
                    return UIImage(named: "yellow_highlight_33")
                }
                if !n, !sw {
                    return UIImage(named: "yellow_highlight_37")
                }
                if !s, !nw {
                    return UIImage(named: "yellow_highlight_36")
                }
                if !s, !ne {
                    return UIImage(named: "yellow_highlight_40")
                }
                if !e, !sw {
                    return UIImage(named: "yellow_highlight_35")
                }
                if !e, !nw {
                    return UIImage(named: "yellow_highlight_39")
                }
                if !w, !ne {
                    return UIImage(named: "yellow_highlight_34")
                }
                if !w, !se {
                    return UIImage(named: "yellow_highlight_38")
                }
                if !n {
                    return UIImage(named: "yellow_highlight_2")
                }
                if !s {
                    return UIImage(named: "yellow_highlight_8")
                }
                if !e {
                    return UIImage(named: "yellow_highlight_6")
                }
                if !w {
                    return UIImage(named: "yellow_highlight_4")
                }
                // 1 1 0
                // 1 1 0
                // 1 1 0
                // or
                // 1 1 1
                // 0 1 1
                // 0 1 0
            } else if diagonals == 2 {
                if !n, !se {
                    return UIImage(named: "yellow_highlight_33")
                }
                if !n, !sw {
                    return UIImage(named: "yellow_highlight_37")
                }
                if !s, !nw {
                    return UIImage(named: "yellow_highlight_36")
                }
                if !s, !ne {
                    return UIImage(named: "yellow_highlight_40")
                }
                if !e, !sw {
                    return UIImage(named: "yellow_highlight_35")
                }
                if !e, !nw {
                    return UIImage(named: "yellow_highlight_39")
                }
                if !w, !ne {
                    return UIImage(named: "yellow_highlight_34")
                }
                if !w, !se {
                    return UIImage(named: "yellow_highlight_38")
                }
                if !n {
                    return UIImage(named: "yellow_highlight_2")
                }
                if !s {
                    return UIImage(named: "yellow_highlight_8")
                }
                if !e {
                    return UIImage(named: "yellow_highlight_6")
                }
                if !w {
                    return UIImage(named: "yellow_highlight_4")
                }
                // 1 1 0
                // 1 1 0
                // 0 1 0
                // or
                // 0 1 0
                // 1 1 0
                // 0 1 1
            } else if diagonals == 1 {
                if !n, !se {
                    if !sw {
                        return UIImage(named: "yellow_highlight_29")
                    }
                    return UIImage(named: "yellow_highlight_33")
                }
                if !n, !sw {
                    return UIImage(named: "yellow_highlight_37")
                }
                if !s, !nw {
                    if !ne {
                        return UIImage(named: "yellow_highlight_32")
                    }
                    return UIImage(named: "yellow_highlight_36")
                }
                if !s, !ne {
                    return UIImage(named: "yellow_highlight_40")
                }
                if !e, !sw {
                    if !nw {
                        return UIImage(named: "yellow_highlight_31")
                    }
                    return UIImage(named: "yellow_highlight_35")
                }
                if !e, !nw {
                    return UIImage(named: "yellow_highlight_39")
                }
                if !w, !ne {
                    if !se {
                        return UIImage(named: "yellow_highlight_30")
                    }
                    return UIImage(named: "yellow_highlight_34")
                }
                if !w, !se {
                    return UIImage(named: "yellow_highlight_38")
                }
                // 0 0 0
                // 1 1 1
                // 0 1 0
            } else if diagonals == 0 {
                if !n {
                    return UIImage(named: "yellow_highlight_29")
                }
                if !s {
                    return UIImage(named: "yellow_highlight_32")
                }
                if !e {
                    return UIImage(named: "yellow_highlight_31")
                }
                if !w {
                    return UIImage(named: "yellow_highlight_30")
                }
            }
        } else if neighbors == 2 {
            // 1 1 1
            // 1 1 0
            // 1 0 1
            if diagonals == 4 {
                if !n, !s {
                    return UIImage(named: "yellow_highlight_23")
                }
                if !e, !w {
                    return UIImage(named: "yellow_highlight_24")
                }
                if !n, !e {
                    return UIImage(named: "yellow_highlight_3")
                }
                if !n, !w {
                    return UIImage(named: "yellow_highlight_1")
                }
                if !s, !e {
                    return UIImage(named: "yellow_highlight_9")
                }
                if !s, !w {
                    return UIImage(named: "yellow_highlight_7")
                }
            // 0 1 1
            // 0 1 0
            // 1 1 1
            // or
            // 1 0 0
            // 1 1 0
            // 1 1 1
            } else if diagonals == 3 {
                if n, s {
                    return UIImage(named: "yellow_highlight_24")
                }
                if e, w {
                    return UIImage(named: "yellow_highlight_23")
                }
                if !n, !e {
                    return UIImage(named: "yellow_highlight_3")
                }
                if !n, !w {
                    return UIImage(named: "yellow_highlight_1")
                }
                if !s, !w {
                    return UIImage(named: "yellow_highlight_7")
                }
                if !s, !e {
                    return UIImage(named: "yellow_highlight_9")
                }
                // 1 0 0
                // 1 1 0
                // 1 1 0
            } else if diagonals == 2 {
                if !n, !s {
                    return UIImage(named: "yellow_highlight_23")
                }
                if !e, !w {
                    return UIImage(named: "yellow_highlight_24")
                }
                if !n, !e {
                    return UIImage(named: "yellow_highlight_3")
                }
                if !n, !w {
                    return UIImage(named: "yellow_highlight_1")
                }
                if !s, !e {
                    return UIImage(named: "yellow_highlight_9")
                }
                if !s, !w {
                    return UIImage(named: "yellow_highlight_7")
                }
                // 0 1 0
                // 0 1 0
                // 1 1 0
                // or
                // 0 0 0
                // 1 1 0
                // 1 1 0
                // or
                // 1 1 0
                // 0 1 1
                // 0 0 0
             } else if diagonals == 1 {
                 if n, s {
                     return UIImage(named: "yellow_highlight_24")
                 }
                 if e, w {
                     return UIImage(named: "yellow_highlight_23")
                 }
                 if n, e {
                     if ne {
                         return UIImage(named: "yellow_highlight_7")
                     }
                     return UIImage(named: "yellow_highlight_27")
                 }
                 if n, w {
                     if nw {
                         return UIImage(named: "yellow_highlight_9")
                     }
                     return UIImage(named: "yellow_highlight_28")
                 }
                 if s, e {
                     if se {
                         return UIImage(named: "yellow_highlight_1")
                     }
                     return UIImage(named: "yellow_highlight_25")
                 }
                 if s, w {
                     if sw {
                         return UIImage(named: "yellow_highlight_3")
                     }
                     return UIImage(named: "yellow_highlight_26")
                 }
                // 0 0 0
                // 0 1 1
                // 0 1 0
                // or
                // 0 0 0
                // 1 1 1
                // 0 0 0
             } else if diagonals == 0 {
                 if n, s {
                     return UIImage(named: "yellow_highlight_24")
                 }
                 if e, w {
                     return UIImage(named: "yellow_highlight_23")
                 }
                 if n, e {
                     return UIImage(named: "yellow_highlight_27")
                 }
                 if n, w {
                     return UIImage(named: "yellow_highlight_28")
                 }
                 if s, e {
                     return UIImage(named: "yellow_highlight_25")
                 }
                 if s, w {
                     return UIImage(named: "yellow_highlight_26")
                 }
             }
            // 1 0 0
            // 1 1 0
            // 1 0 0
        } else if neighbors == 1 {
            if n {
                return UIImage(named: "yellow_highlight_11")
            }
            if s {
                return UIImage(named: "yellow_highlight_13")
            }
            if e {
                return UIImage(named: "yellow_highlight_12")
            }
            if w {
                return UIImage(named: "yellow_highlight_14")
            }
        } else if neighbors == 0 {
            if diagonals > 0 {
                return UIImage(named: "yellow_highlight_10")
            }
        }
        return UIImage(named: "yellow_highlight_0")
    }
}
