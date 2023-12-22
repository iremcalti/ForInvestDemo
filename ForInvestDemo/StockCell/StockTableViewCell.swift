//
//  StockTableViewCell.swift
//  ForInvestDemo
//
//  Created by İrem Çaltı on 17.12.2023.
//

import UIKit

class StockTableViewCell: UITableViewCell {
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var arrowSymbol: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var secondDataLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func loadCellData(model: StockTableModel?, colorModel: StockTableColorModel?) {
        if let model = model {
            nameLabel.text = model.title
            timeLabel.text = model.subtitle
            dataLabel.text = model.leftData
            secondDataLabel.text = model.rightData
        }
        if let colorModel = colorModel {
            arrowSymbol.image = colorModel.image
            dataLabel.textColor = colorModel.leftLabelColor
            secondDataLabel.textColor = colorModel.rightLabelColor
        }
    }
}
