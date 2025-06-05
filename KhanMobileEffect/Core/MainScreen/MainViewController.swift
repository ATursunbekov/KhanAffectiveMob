import UIKit
import SnapKit

protocol MainViewProtocol: AnyObject {
    func reloadData(data: [TodoModel])
    var presenter: MainPresenter? {get set}
}

class MainViewController: UIViewController {
    
    var tasks: [TodoModel] = []
    var presenter: MainPresenter?
    
    var filteredTasks: [TodoModel] = []
    var isFiltering: Bool {
        return !(searchBar.text?.isEmpty ?? true)
    }

    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search"
        sb.searchBarStyle = .minimal
        sb.searchTextField.backgroundColor = UIColor(white: 0.2, alpha: 1.0)
        sb.searchTextField.layer.cornerRadius = 10
        sb.searchTextField.clipsToBounds = true
        sb.searchTextField.textColor = .white
        sb.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [.foregroundColor: UIColor.lightGray]
        )
        sb.showsBookmarkButton = true
        let micIcon = UIImage(systemName: "mic.fill")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        sb.setImage(micIcon, for: .bookmark, state: .normal)

        let searchIcon = UIImage(systemName: "magnifyingglass")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        sb.setImage(searchIcon, for: .search, state: .normal)
        if let clearButton = sb.searchTextField.value(forKey: "_clearButton") as? UIButton {
            let clearImage = UIImage(systemName: "xmark.circle.fill")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
            clearButton.setImage(clearImage, for: .normal)
        }
        return sb
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.gray
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 106
        tableView.backgroundColor = .clear
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        label.text = "\(tasks.count) Задач"
        return label
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "edit"), for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
        setupConstraints()
        setupDelegates()
        editButton.addTarget(self, action: #selector(toggleEditMode), for: .touchUpInside)
        
        presenter?.viewDidLoad()
    }
    
    func setupTitle() {
        title = "Задачи"
        view.backgroundColor = .black
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    func setupConstraints() {
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(36)
        }
        
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(83)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom).offset(16)
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        bottomView.addSubview(amountLabel)
        amountLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
        }
        
        bottomView.addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.centerY.equalTo(amountLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    func setupDelegates() {
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @objc func toggleEditMode() {
        presenter?.navigateToEdit(vc: EditViewController(endAction: { [self] model in
            self.tasks.append(model)
            tableView.reloadData()
            self.presenter?.update(data: tasks)
        }))
    }
    
    func filterTasks(with query: String) {
        filteredTasks = tasks.filter {
            ($0.title?.lowercased().contains(query.lowercased()) ?? false) ||
            $0.todo.lowercased().contains(query.lowercased())
        }
        tableView.reloadData()
    }
}

// MARK: - UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterTasks(with: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - UITableViewDataSource & Delegate
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func currentTask(at indexPath: IndexPath) -> TodoModel {
        return isFiltering ? filteredTasks[indexPath.row] : tasks[indexPath.row]
    }
    
    func actualIndex(for filteredTask: TodoModel) -> Int? {
        return tasks.firstIndex { $0.title == filteredTask.title && $0.todo == filteredTask.todo }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredTasks.count : tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = currentTask(at: indexPath)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as? MainTableViewCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.configureData(title: task.title ?? "", desc: task.todo, date: task.date ?? "", isDone: task.completed)

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleCellLongPress(_:)))
        cell.addGestureRecognizer(longPressGesture)

        cell.checkPressed = { [weak self] in
            guard let self = self else { return }
            if let actualIndex = self.actualIndex(for: task) {
                self.tasks[actualIndex].completed.toggle()
                cell.changeVal(isDone: self.tasks[actualIndex].completed)
                self.presenter?.update(data: tasks)
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = currentTask(at: indexPath)
        guard let actualIndex = actualIndex(for: task) else { return }

        presenter?.navigateToEdit(vc: EditViewController(todo: task, endAction: { [weak self] updatedTask in
            guard let self = self else {return}
            self.tasks[actualIndex] = updatedTask
            self.filterTasks(with: self.searchBar.text ?? "")
            self.presenter?.update(data: self.tasks)
        }))
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let task = currentTask(at: indexPath)
        guard let actualIndex = actualIndex(for: task) else { return }

        if editingStyle == .delete {
            tasks.remove(at: actualIndex)
            filterTasks(with: searchBar.text ?? "")
            amountLabel.text = "\(tasks.count) Задач"
            presenter?.update(data: self.tasks)
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return !isFiltering
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedTask = tasks.remove(at: sourceIndexPath.row)
        tasks.insert(movedTask, at: destinationIndexPath.row)
    }

    @objc func handleCellLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        guard gestureRecognizer.state == .began,
              let cell = gestureRecognizer.view as? UITableViewCell,
              let indexPath = tableView.indexPath(for: cell) else { return }

        let task = currentTask(at: indexPath)
        guard let actualIndex = actualIndex(for: task) else { return }

        let controller = EditPopup(
            editPressed: { [weak self] in
                self?.presenter?.navigateToEdit(vc: EditViewController(todo: task, endAction: { updatedTask in
                    self?.tasks[actualIndex] = updatedTask
                    self?.filterTasks(with: self?.searchBar.text ?? "")
                    self?.presenter?.update(data: self?.tasks ?? [])
                }))
            },
            sharePressed: { [weak self] in
                let textToShare = "\(task.title ?? "")\n\n\(task.todo)\n\nДата: \(task.date ?? "")"
                let activityVC = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = self?.view
                self?.presenter?.presentView(vc: activityVC)
            },
            deletePressed: { [weak self] in
                guard let self = self else {return}
                self.tasks.remove(at: actualIndex)
                self.filterTasks(with: self.searchBar.text ?? "")
                self.amountLabel.text = "\(self.tasks.count) Задач"
                self.presenter?.update(data: self.tasks)
            }
        )

        controller.modalPresentationStyle = .overFullScreen
        presenter?.presentView(vc: controller)
    }
}

extension MainViewController: MainViewProtocol {
    func reloadData(data: [TodoModel]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.tasks = data
            self.amountLabel.text = "\(self.tasks.count) Задач"
            self.tableView.reloadData()
        }
    }
}
