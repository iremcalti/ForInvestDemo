//
//  StocksViewModel.swift
//  ForInvestDemo
//
//  Created by İrem Çaltı on 17.12.2023.
//

import UIKit

protocol StocksViewModelInterface {
    var view: StocksVCInterface? {get set}
    func getStocks()
    func createMyPageDict(myPages: [MyPageModel]) -> [String: String]
    var lastData: [StocksListModel]? {get set}
    var colorModel: [StockTableColorModel] {get set}
}

final class StocksViewModel {
    var view: StocksVCInterface?
    var lastData: [StocksListModel]?
    var colorModel: [StockTableColorModel] = []
    
    init() {
    }
    
}

extension StocksViewModel: StocksViewModelInterface {
    
    func getStocks() {
        let urlString = "https://sui7963dq6.execute-api.eu-central-1.amazonaws.com/default/ForeksMobileInterviewSettings"
        
        NetworkManager.shared.fetchData(type: StocksModel.self, urlString: urlString) { result in
            switch result {
            case .success(let data):
                self.view?.loadData(stocks: data)
            case .failure(let error):
                print(error)
            }
        }
    }
    func getStocks(stocks: StocksModel) {
        
        guard let pageDefaults = stocks.mypageDefaults else {
            return
        }
        
        let fields = adjustFields(stocks: pageDefaults)
        let urlString = "https://sui7963dq6.execute-api.eu-central-1.amazonaws.com/default/ForeksMobileInterview?fields=\(StocksModel.Constants.fields)&stcs=\(fields)"
        
        NetworkManager.shared.fetchData(type: StocksDetailModel.self, urlString: urlString) { result in
            switch result {
            case .success(let data):
                if let dataL = data.l, let lastData = self.lastData {
                    self.compareValues(newData: dataL, lastData: lastData)
                    self.view?.updateData(stocksDetails: data)
                }
                self.lastData = data.l
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func compareValues(newData: [StocksListModel], lastData: [StocksListModel]) {
        
        
        guard let mypageDefaults = view?.stockList?.mypageDefaults, let mypage = view?.stockList?.mypage, let left =  view?.selectedLeftTitle, let right = view?.selectedRightTitle else {
            return
        }
        
        var leftTitle = ""
        var rightTitle = ""
        
        for i in mypage {
            
            if i.name == left {
                leftTitle = i.key
            }
            
            if i.name == right {
                rightTitle = i.key
            }
            
        }
        
        var list: [StockTableColorModel] = []
        var image = UIImage()
        var leftLabelColor =  UIColor.gray
        var rightLabelColor = UIColor.gray
        
        if newData.count == lastData.count {
            for i in 0...mypageDefaults.count-1 {
                if newData[i].las > lastData[i].las {
                    image = UIImage(named: "upArrow")!
                }
                else if newData[i].las < lastData[i].las {
                    image = UIImage(named: "downArrow")!
                }
                
                if (newData[i].dictionary[leftTitle] as! String) < (lastData[i].dictionary[leftTitle] as! String) {
                    leftLabelColor = .red
                }
                
                else if (newData[i].dictionary[leftTitle] as! String) > (lastData[i].dictionary[leftTitle] as! String) {
                    leftLabelColor = .green
                }
                
                if (newData[i].dictionary[rightTitle] as! String) < (lastData[i].dictionary[rightTitle] as! String) {
                    rightLabelColor = .red
                }
                
                else if (newData[i].dictionary[rightTitle] as! String) > (lastData[i].dictionary[rightTitle] as! String) {
                    rightLabelColor = .green
                }
                
                list.append(StockTableColorModel(image: image, leftLabelColor: leftLabelColor, rightLabelColor: rightLabelColor))
            }
            colorModel = list
        }
    }
    
    func adjustFields(stocks: [MypageDefaultsModel]) -> String {
        var field = ""
        for item in stocks {
            field.append(item.tke + "~")
        }
        
        return field
    }
    
    func createMyPageDict(myPages: [MyPageModel]) -> [String: String] {
        var pagesDict: [String: String] = [:]
        for p in myPages[0...4] {
            pagesDict[p.name] = p.key
        }
         
        return pagesDict
    }
    
}
