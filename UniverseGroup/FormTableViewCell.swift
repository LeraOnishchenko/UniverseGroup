//
//  FormTableViewCell.swift
//  UniverseGroup
//
//  Created by lera on 04.07.2024.
//

import UIKit
import RxSwift
import SnapKit

class FormTableViewCell: UITableViewCell{
    static let identifier = "AnswerCell"
    var title = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if (selected){
            title.textColor = .white
        }
        else {
            title.textColor = .black
        }
    }
    
    func setupUI() {
        self.contentView.addSubview(title)
        title.numberOfLines = 0
        title.textAlignment = .left
        title.textColor = .black
        title.font = UIFont.font(.SFPRODISPLAYREGULAR, ofSize: 16)
        title.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    func configare(text: String){
        title.text = text
        setupUI()
        
    }
}
