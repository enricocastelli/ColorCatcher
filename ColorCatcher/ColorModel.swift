//
//  ColorModel.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 27/02/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit

struct ColorObjectModel: Decodable {
    
    var colors: [ColorModel]

    enum CodingKeys:  Any, CodingKey
    {
        case colors
    }
}

struct ColorModel: Decodable {
    
    var hex: String
    var name: String
    var desc: String

    enum CodingKeys:  Any, CodingKey
    {
        case hex
        case name
        case desc
    }
}
