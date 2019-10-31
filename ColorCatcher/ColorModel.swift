//
//  ColorModel.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 27/02/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit


struct ColorModel: Decodable {
    
    let hex: String
    let name: String
    let description: String
    let type: ColorModelType
}

enum ColorModelType: String,Codable {
    case General
    case Name
    case Logo
    case History
    case Art
    case Movies
}
