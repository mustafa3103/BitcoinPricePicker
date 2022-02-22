//
//  CoinModel.swift
//  BitcoinPricePicker
//
//  Created by Mustafa on 16.01.2022.
//

import Foundation

struct CoinModel {
    
    let price: Double
    let name: String
    
    var priceString: String {
        return String(format: "%.2f", price)
    }
}
