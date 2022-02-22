//
//  CoinManager.swift
//  BitcoinPricePicker
//
//  Created by Mustafa on 13.01.2022.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoin(_ coinManager: CoinManager, coin: CoinModel)
    func didFailWithError(_ error: Error)
}

struct CoinManager{
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC/"
    let apiKey = "?apikey=885C7CE6-D98C-4A2D-A114-BCF820251B7D"
    
    var delegate: CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR","TRY"]
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)\(currency)\(apiKey)"
        performRequest(with: urlString)
        print(urlString)
    }
    //MARK: - Request Process
    func performRequest(with urlString: String) {
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                }
                
                if let safeData = data {
                    
                    if let coin = self.parseJSON(safeData) {
                        self.delegate?.didUpdateCoin(self, coin: coin)
                    }
                }
            }
            task.resume()
        }
    }
    //MARK: - Turning data to the swift format.
    func parseJSON(_ coinData: Data) -> CoinModel? {
        
        let decoder = JSONDecoder()
        
        do {
            
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            
            let name = decodedData.asset_id_quote
            let price = decodedData.rate
            
            let coin = CoinModel(price: price, name: name)
            
            return coin
        } catch  {
            print(error)
            return nil
        }
    }
}
