//
//  StocksModel.swift
//  ForInvestDemo
//
//  Created by İrem Çaltı on 17.12.2023.
//

import UIKit

struct StocksModel : Codable {
    let mypageDefaults : [MypageDefaultsModel]?
    let mypage : [MyPageModel]?
    
    struct Constants {
        static let fields = "tke,clo,las,pdd,ddi,low,hig"
        static let cellName = "StockTableViewCell"
    }
}

struct MypageDefaultsModel : Codable {
    let cod : String
    let gro : String
    let tke : String
    let def : String
}

struct MyPageModel : Codable {
    let name : String
    let key : String
}

struct StocksDetailModel : Codable {
    let l : [StocksListModel]?
}

struct StocksListModel : Codable {
    let tke : String
    let clo : String
    let pdd : String
    let las : String
    let ddi : String
    let low : String
    let hig : String
}

struct JSON {
    static let encoder = JSONEncoder()
}
extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSON.encoder.encode(self))) as? [String: Any] ?? [:]
    }
}
