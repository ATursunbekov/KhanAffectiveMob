//
//  MainTableViewCell.swift
//  KhanMobileEffect
//
//  Created by Alikhan Tursunbekov on 4/6/25.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    static let identifier = "MainTableViewCell"
    
    var checkPressed: (() -> Void)?
    
    lazy var checkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "unchecked"), for: .normal)
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 1
        label.text = "Уборка в квартире"
        return label
    }()
    
    lazy var descLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 2
        label.text = "Сходить в спортзал или сделать тренировку дома. Не забыть про разминку и растяжку!"
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .darkGray
        label.text = "02/10/24"
        return label
    }()
    
    lazy var linerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#4E545E")
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        checkButton.addTarget(self, action: #selector(checkButtonPressed), for: .touchUpInside)
    }
    
    func setupConstraints() {
        contentView.addSubview(checkButton)
        checkButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(24)
            make.top.equalToSuperview().offset(12)
        }
        
        contentView.addSubview(titleLabel)      
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkButton.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalTo(checkButton.snp.centerY)
        }
        
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkButton.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkButton.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(descLabel.snp.bottom).offset(8)
        }
        
        contentView.addSubview(linerView)
        linerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
    
    func configureData(title: String, desc: String, date: String, isDone: Bool) {
        updateLabel(titleLabel, text: title, isStrikethrough: isDone)
        descLabel.text = desc
        dateLabel.text = date
        checkButton.setImage( isDone ? UIImage(named: "checked") : UIImage(named: "unchecked"), for: .normal)
    }
    
    func changeVal(isDone: Bool) {
        checkButton.setImage( isDone ? UIImage(named: "checked") : UIImage(named: "unchecked"), for: .normal)
        titleLabel.textColor = isDone ? .darkGray : .white
        descLabel.textColor = isDone ? .darkGray : .white
        updateLabel(titleLabel, text: titleLabel.text ?? "", isStrikethrough: isDone)
    }
    
    func updateLabel(_ label: UILabel, text: String, isStrikethrough: Bool) {
        if isStrikethrough {
            let attributes: [NSAttributedString.Key: Any] = [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .strikethroughColor: UIColor.darkGray,
                .foregroundColor: UIColor.darkGray,
                .font: label.font as Any
            ]
            label.attributedText = NSAttributedString(string: text, attributes: attributes)
        } else {
            label.attributedText = NSAttributedString(string: text, attributes: [
                .foregroundColor: UIColor.white,
                .font: label.font as Any
            ])
        }
    }
    
    @objc
    func checkButtonPressed() {
        checkPressed?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
