//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

final class UserTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        self.textLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        self.detailTextLabel?.font = UIFont.preferredFont(forTextStyle: .body)
    }
}

final class ChangeColorTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        let stackView: UIStackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        self.contentView.backgroundColor = .red
        self.contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
        
        for i in 0..<3 {
            let button: UIButton = UIButton(type: .custom)
            switch i {
            case 0:
                button.setTitle("Red", for: .normal)
                button.addTarget(self, action: #selector(self.changeRed(_:)), for: .touchUpInside)
            case 1:
                button.setTitle("Green", for: .normal)
                button.addTarget(self, action: #selector(self.changeGreen(_:)), for: .touchUpInside)
            case 2:
                button.setTitle("Blue", for: .normal)
                button.addTarget(self, action: #selector(self.changeBlue(_:)), for: .touchUpInside)
            default:
                break
            }
            stackView.addArrangedSubview(button)
        }
    }
    
    func changeRed(_ sender: UIButton) {
        self.contentView.backgroundColor = .red
    }
    
    func changeGreen(_ sender: UIButton) {
        self.contentView.backgroundColor = .green
    }
    
    func changeBlue(_ sender: UIButton) {
        self.contentView.backgroundColor = .blue
    }
}


final class TableViewController: UITableViewController {
    
    private var dataSource: TableViewDataSource
    
    override init(style: UITableViewStyle) {
        self.dataSource = DataSource()
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.dataSource = DataSource()
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.dataSource.registerCells(with: self.tableView)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.tableFooterView = UIView()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource.sectionCount
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.rowCount(for: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.dataSource.cell(for: indexPath, in: tableView)
    }
}

struct DataSource: TableViewDataSource {
    
    private let profileRow: AnyTableViewRow<UserTableViewCell> = {
        let path: IndexPath = IndexPath(row: 0, section: 0)
        return AnyTableViewRow(indexPath: path, configure: { (cell: UserTableViewCell) -> Void in
            cell.textLabel?.text = "Chandler De Angelis"
            cell.detailTextLabel?.text = "iOS Developer"
        })
    }()
    
    private let colorsRow: AnyTableViewRow<ChangeColorTableViewCell> = {
        let path: IndexPath = IndexPath(row: 1, section: 0)
        return AnyTableViewRow(indexPath: path, configure: .none)
    }()
    
    func registerCells(with tableView: UITableView) {
        self.profileRow.registerCell(with: tableView)
        self.colorsRow.registerCell(with: tableView)
    }
    
    var sectionCount: Int {
        return 1
    }
    
    func rowCount(for section: Int) -> Int {
        return 2
    }
    
    func cell(for indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
        let reuseIdentifier: String
        switch indexPath {
        case self.profileRow.indexPath:
            reuseIdentifier = self.profileRow.cellReuseIdentifier
        case self.colorsRow.indexPath:
            reuseIdentifier = self.colorsRow.cellReuseIdentifier
        default:
            fatalError("No row for index path")
        }
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        switch cell {
        case let cell as UserTableViewCell:
            self.profileRow.configure(cell)
        default:
            break
        }
        return cell
    }
    
}

let vc: TableViewController = TableViewController(style: .plain)
PlaygroundPage.current.liveView = vc.view




