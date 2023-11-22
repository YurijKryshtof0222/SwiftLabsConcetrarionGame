//
//  GameConfig.swift
//  Concetration
//
//  Created by Admin on 22/11/2023.
//  Copyright © 2023 Admin. All rights reserved.
//

import Foundation

struct GameCoinfig {
    let rows: Int
    let cols: Int
    let cardCount: Int
    
    init(rows: Int, cols: Int) {
        self.rows = rows
        self.cols = cols
        self.cardCount = rows * cols
    }
}
