//
//  ViewController.swift
//  BitcoinPricePicker
//
//  Created by Mustafa on 13.01.2022.
//

import UIKit

class CoinViewController: UIViewController {
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
    }
}
//MARK: - CoinManagerDelegate
extension CoinViewController: CoinManagerDelegate {
    
    func didFailWithError(_ error: Error) {
        print(error.localizedDescription)
        
    }
    
    func didUpdateCoin(_ CoinManager: CoinManager, coin: CoinModel) {
        
        DispatchQueue.main.async {
            self.bitcoinLabel.text = coin.priceString
            self.currencyLabel.text = coin.name
        }
    }
}
//MARK: - UIPickerViewDelegate
extension CoinViewController: UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return coinManager.currencyArray.count
    }
}
//MARK: - UIPickerViewDataSource
extension CoinViewController: UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let selectedCurrency = coinManager.currencyArray[row]
        
        coinManager.getCoinPrice(for: selectedCurrency)
    }
}
