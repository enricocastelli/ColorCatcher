//
//  ColorRecognitionTests.swift
//  ColorCatcherTests
//
//  Created by Enrico Castelli on 29/10/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//


import XCTest
@testable import ColorCatcher

class ColorRecognitionTests: XCTestCase, ColorCalculator {
    
    func testColor() {
        var mainColor = UIColor(red: 14/255, green: 120/255, blue: 210/255, alpha: 1)
        var goalColor = UIColor(red: 200/255, green: 114/255, blue: 255/255, alpha: 1)
        XCTAssert(Int(getColorProximity(mainColor, goalColor)) == 100 - 29)
        
        mainColor = UIColor(red: 130/255, green: 100/255, blue: 120/255, alpha: 1)
        goalColor = UIColor(red: 0/255, green: 255/255, blue: 95/255, alpha: 1)
        XCTAssert(Int(getColorProximity(mainColor, goalColor)) == 100 - 92)
    }
    
    func testToLab() {
        var lab1 = toLAB(UIColor(red: 14/255, green: 120/255, blue: 210/255, alpha: 1))
        XCTAssert(Int(lab1.L) == 49)
        XCTAssert(Int(lab1.A) == 6)
        XCTAssert(Int(lab1.B) == -53)
        
        lab1 = toLAB(UIColor(red: 190/255, green: 140/255, blue: 2/255, alpha: 1))
        XCTAssert(Int(lab1.L) == 61)
        XCTAssert(Int(lab1.A) == 9)
        XCTAssert(Int(lab1.B) == 65)
     }
    
}
