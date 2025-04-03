import UIKit

class KnowledgeView: UIViewController {
    private let tableView = UITableView()
    private var knowledgeBase: [(image: UIImage, label: String)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadKnowledgeBase()
    }

    private func setupUI() {
        view.backgroundColor = .white

        // Configure table view
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "KnowledgeCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        // Layout constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func loadKnowledgeBase() {
        knowledgeBase = StorageManager.shared.loadTrainingData()
        tableView.reloadData()
    }
}

extension KnowledgeView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return knowledgeBase.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "KnowledgeCell", for: indexPath)
        let item = knowledgeBase[indexPath.row]
        cell.textLabel?.text = item.label
        cell.imageView?.image = item.image
        return cell
    }
}
