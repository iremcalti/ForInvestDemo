//
//  StocksViewController.swift
//  ForInvestDemo
//
//  Created by İrem Çaltı on 17.12.2023.
//

import UIKit

protocol StocksVCInterface {
    func loadData(stocks: StocksModel)
    func updateData(stocksDetails: StocksDetailModel)
    var stockList: StocksModel? {get set}
    var selectedLeftTitle: String {get set}
    var selectedRightTitle: String {get set}
}

class StocksViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var dataBtn: UIButton!
    @IBOutlet weak var secondDataBtn: UIButton!

    var viewModel = StocksViewModel()
    var stockList: StocksModel?
    var selectedLeftTitle: String = ""
    var selectedRightTitle: String = ""
    
    var tableStocks: [StockTableModel] = []
    var pageDict: [String:String] = [:]
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        configure()
        viewModel.view = self
        self.viewModel.getStocks()
        

    }
    private func configure() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: StocksModel.Constants.cellName, bundle: nil), forCellReuseIdentifier: StocksModel.Constants.cellName)
    }
    
    func setupMenu(items: [String: String]) -> UIMenu {
        
        let menuClosure = {(action: UIAction) in
                    
            self.menuAction(item: action)
        }
        
        var actionList: [UIAction] = []
        for item in items {
            let action = UIAction(title: item.key, identifier: UIAction.Identifier(item.value), handler: menuClosure)
            actionList.append(action)
        }
        
        let menu = UIMenu(children: actionList)
        return menu
    }
    
    func menuAction(item: UIAction) {
        
        guard let stockList = stockList else {
            return
        }
        
        if item.sender as? UIButton == dataBtn {
            selectedLeftTitle = item.title
        }
        else if item.sender as? UIButton == secondDataBtn {
            selectedRightTitle = item.title
        }
        timer.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.viewModel.getStocks(stocks: stockList)
        })
    }
    
    func adjuctButtons(menuItems: [String: String]) {
        DispatchQueue.main.async {
            
            self.selectedLeftTitle = self.dataBtn.titleLabel?.text ?? ""
            self.selectedRightTitle = self.secondDataBtn.titleLabel?.text ?? ""
            
            self.dataBtn.menu = self.setupMenu(items: menuItems)
            self.dataBtn.showsMenuAsPrimaryAction = true
            self.dataBtn.changesSelectionAsPrimaryAction = true
            
            self.secondDataBtn.menu = self.setupMenu(items: menuItems)
            self.secondDataBtn.showsMenuAsPrimaryAction = true
            self.secondDataBtn.changesSelectionAsPrimaryAction = true
        }
    }
}

extension StocksViewController: StocksVCInterface {
    func loadData(stocks: StocksModel) {
        stockList = stocks
        
        guard let pages = stocks.mypage else {
            return
        }
        
        pageDict = viewModel.createMyPageDict(myPages: pages)
        
        adjuctButtons(menuItems: pageDict)
        
        DispatchQueue.main.async { [self] in
            selectedLeftTitle = dataBtn.titleLabel?.text ?? ""
            selectedRightTitle = secondDataBtn.titleLabel?.text ?? ""
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                self.viewModel.getStocks(stocks: stocks)
                self.tableView.reloadData()
            })
        }
       
    }
    
    func updateData(stocksDetails: StocksDetailModel) {
        
        tableStocks = []
        guard let pages = stockList?.mypage, let list = stocksDetails.l else {
            return
        }
        
        var leftKey = ""
        var rightKey = ""
        
        for item in pages {
            if selectedLeftTitle ==  item.name {
                leftKey = item.key
            }
            if selectedRightTitle == item.name {
                rightKey = item.key
            }
        }

        for item in list {
            self.tableStocks.append(StockTableModel(title: item.tke , subtitle: item.clo , leftData: item[leftKey] as? String ?? "", rightData: item[rightKey] as? String ?? ""))
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension StocksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableStocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: StocksModel.Constants.cellName) as? StockTableViewCell {
            cell.loadCellData(model: tableStocks[indexPath.row], colorModel: viewModel.colorModel[indexPath.row])
            cell.selectionStyle = .none
            return cell
    }
        return UITableViewCell()
    }
}

