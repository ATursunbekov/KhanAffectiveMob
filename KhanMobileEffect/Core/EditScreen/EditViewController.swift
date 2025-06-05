import UIKit
import SnapKit

class EditViewController: UIViewController {
    
    private var todoItem: TodoModel?
    private var endAction: (TodoModel) -> Void
    
    init(todo: TodoModel? = nil, endAction: @escaping (TodoModel) -> Void) {
        self.todoItem = todo
        self.endAction = endAction
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let titleTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        tv.textColor = .white
        tv.backgroundColor = UIColor(white: 0.15, alpha: 0.0)
        tv.isEditable = true
        tv.layer.cornerRadius = 8
        tv.clipsToBounds = true
        return tv
    }()
    
    let descTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        tv.textColor = .white
        tv.backgroundColor = UIColor(white: 0.15, alpha: 0.0)
        tv.isEditable = true
        tv.clipsToBounds = true
        return tv
    }()
    
    let titlePlaceholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите заголовок"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = .gray
        return label
    }()
    
    let descPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите описание"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.darkGray
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
        setupConstraints()
        setupPlaceholders()
        
        titleTextView.text = todoItem?.title ?? ""
        descTextView.text = todoItem?.todo ?? ""
        dateLabel.text = todoItem?.date ?? ""
        
        titlePlaceholderLabel.isHidden = !titleTextView.text.isEmpty
        descPlaceholderLabel.isHidden = !descTextView.text.isEmpty
        
        titleTextView.delegate = self
        descTextView.delegate = self
    }
    
    func setupTitle() {
        view.backgroundColor = .black
        navigationItem.hidesBackButton = true

        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.setTitle(" Назад", for: .normal)
        backButton.tintColor = UIColor(hex: "#FED702")
        backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    func setupConstraints() {
        view.addSubview(titleTextView)
        view.addSubview(dateLabel)
        view.addSubview(descTextView)
        
        titleTextView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(80)
        }

        dateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(titleTextView.snp.bottom).offset(10)
        }

        descTextView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
    }
    
    func setupPlaceholders() {
        titleTextView.addSubview(titlePlaceholderLabel)
        descTextView.addSubview(descPlaceholderLabel)
        
        titlePlaceholderLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextView.textContainerInset.top)
            make.leading.equalTo(titleTextView.textContainerInset.left + 5)
        }
        
        descPlaceholderLabel.snp.makeConstraints { make in
            make.top.equalTo(descTextView.textContainerInset.top)
            make.leading.equalTo(descTextView.textContainerInset.left + 5)
        }
    }
    
    @objc private func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    deinit {
        if var res = todoItem {
            res.title = titleTextView.text ?? ""
            res.todo = descTextView.text ?? ""
            endAction(res)
        } else {
            endAction(TodoModel(title: titleTextView.text ?? "", todo: descTextView.text ?? ""))
        }
    }
}

// MARK: - UITextViewDelegate
extension EditViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        titlePlaceholderLabel.isHidden = !titleTextView.text.isEmpty
        descPlaceholderLabel.isHidden = !descTextView.text.isEmpty
    }
}
