//
//  EditPopup.swift
//  KhanMobileEffect
//
//  Created by Alikhan Tursunbekov on 5/6/25.
//

import UIKit

class EditPopup: UIViewController {
    
    var editPressed: () -> Void
    var sharePressed: () -> Void
    var deletePressed: () -> Void
    
    init(editPressed: @escaping () -> Void, sharePressed: @escaping () -> Void, deletePressed: @escaping () -> Void) {
        self.editPressed = editPressed
        self.sharePressed = sharePressed
        self.deletePressed = deletePressed
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#272729")
        view.layer.cornerRadius = 12
        return view
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
    
    lazy var editButton: UIButton = {
        let button = UIButton()
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .black
        label.text = "Редактировать"
        let iamge = UIImageView(image: UIImage(named: "editButton"))
        button.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        button.addSubview(iamge)
        iamge.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
        }
        button.layer.cornerRadius = 12
        button.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        button.backgroundColor = UIColor(hex: "#C0C0C0")
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#858A8E")
        button.addSubview(view)
        view.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(0.5)
        }
        return button
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton()
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .black
        label.text = "Поделиться"
        let iamge = UIImageView(image: UIImage(named: "export"))
        button.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        button.addSubview(iamge)
        iamge.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
        }
        button.backgroundColor = UIColor(hex: "#C0C0C0")
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#858A8E")
        button.addSubview(view)
        view.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(0.5)
        }
        return button
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor(hex: "#D70015")
        label.text = "Удалить"
        let iamge = UIImageView(image: UIImage(named: "trash"))
        button.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        button.addSubview(iamge)
        iamge.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
        }
        button.layer.cornerRadius = 12
        button.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        button.backgroundColor = UIColor(hex: "#C0C0C0")
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        setupTarget()
    }
    
    func setupConstraints() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        
        view.addSubview(backView)
        backView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(106)
        }
        
        backView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        backView.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        backView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(descLabel.snp.bottom).offset(8)
        }
        
        view.addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(254)
            make.height.equalTo(44)
            make.top.equalTo(backView.snp.bottom).offset(20)
        }
        
        view.addSubview(shareButton)
        shareButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(254)
            make.height.equalTo(44)
            make.top.equalTo(editButton.snp.bottom)
        }
        
        view.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(254)
            make.height.equalTo(44)
            make.top.equalTo(shareButton.snp.bottom)
        }
    }
    
    func setupTarget() {
        editButton.addTarget(self, action: #selector(editAction), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareAction), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
    }
    
    @objc
    func editAction() {
        dismiss(animated: false)
        editPressed()
    }
    
    @objc
    func shareAction() {
        dismiss(animated: false)
        sharePressed()
    }
    
    @objc
    func deleteAction() {
        dismiss(animated: false)
        deletePressed()
    }
}
