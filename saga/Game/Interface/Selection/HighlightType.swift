//
//  HighlightType.swift
//  saga
//
//  Created by Christian McCartney on 11/18/21.
//

public protocol AdjacencyTileGroupDefinition {
    var name: String { get }
    var adjacencyTextureProvider: AdjacencyTextureProviding { get }
}

public protocol AdjacencyTextureProviding {
    var textures: [String] { get }
}

struct HighlightTileGroupDefinition: AdjacencyTileGroupDefinition {
    let name: String
    let adjacencyTextureProvider: AdjacencyTextureProviding
}

enum HighlightType: String, AdjacencyTextureProviding {
    case yellow
    case blue

    var textures: [String] {
        return ["\(self.rawValue)_highlight_0",
                "\(self.rawValue)_highlight_1",
                "\(self.rawValue)_highlight_2",
                "\(self.rawValue)_highlight_3",
                "\(self.rawValue)_highlight_4",
                "\(self.rawValue)_highlight_5",
                "\(self.rawValue)_highlight_6",
                "\(self.rawValue)_highlight_7",
                "\(self.rawValue)_highlight_8",
                "\(self.rawValue)_highlight_9",
                "\(self.rawValue)_highlight_10",
                "\(self.rawValue)_highlight_11",
                "\(self.rawValue)_highlight_12",
                "\(self.rawValue)_highlight_13",
                "\(self.rawValue)_highlight_14",
                "\(self.rawValue)_highlight_15",
                "\(self.rawValue)_highlight_16",
                "\(self.rawValue)_highlight_17",
                "\(self.rawValue)_highlight_18",
                "\(self.rawValue)_highlight_19",
                "\(self.rawValue)_highlight_20",
                "\(self.rawValue)_highlight_21",
                "\(self.rawValue)_highlight_22",
                "\(self.rawValue)_highlight_23",
                "\(self.rawValue)_highlight_24",
                "\(self.rawValue)_highlight_25",
                "\(self.rawValue)_highlight_26",
                "\(self.rawValue)_highlight_27",
                "\(self.rawValue)_highlight_28",
                "\(self.rawValue)_highlight_29",
                "\(self.rawValue)_highlight_30",
                "\(self.rawValue)_highlight_31",
                "\(self.rawValue)_highlight_32",
                "\(self.rawValue)_highlight_33",
                "\(self.rawValue)_highlight_34",
                "\(self.rawValue)_highlight_35",
                "\(self.rawValue)_highlight_36",
                "\(self.rawValue)_highlight_37",
                "\(self.rawValue)_highlight_38",
                "\(self.rawValue)_highlight_39",
                "\(self.rawValue)_highlight_40",
                "\(self.rawValue)_highlight_41",
                "\(self.rawValue)_highlight_42",
                "\(self.rawValue)_highlight_43",
                "\(self.rawValue)_highlight_44",
                "\(self.rawValue)_highlight_45",
                "\(self.rawValue)_highlight_46",]
    }
}
