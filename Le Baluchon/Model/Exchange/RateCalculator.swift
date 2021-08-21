//
//  ConvertRate.swift
//  Le Baluchon
//
//  Created by Birkyboy on 14/08/2021.
//

import Foundation

class RateCalculator {

    var amountToConvert: String?
    var currentRate: Double?

    func convertAmount(completion: (Result<Double, ConversionError>) -> Void) {

        guard let currentRate = currentRate else {
            completion(.failure(.noData))
            return
        }
        if amountToConvert?.count == 0 {
            amountToConvert = "0"
        }
        guard let currency = amountToConvert?.replaceDecimal() else {
            completion(.failure(.calculation))
            return
        }
        guard !currency.singleDecimalSymbol else {
            completion(.failure(.format))
            return
        }
        guard let doubleCurrency = Double(currency) else {
            completion(.failure(.calculation))
            return
        }
        completion(.success(doubleCurrency * currentRate))
    }

    func invertRates() {
        guard let currentRate = self.currentRate, currentRate != 0 else {
            return
        }
        self.currentRate =  1 / currentRate
    }
}
