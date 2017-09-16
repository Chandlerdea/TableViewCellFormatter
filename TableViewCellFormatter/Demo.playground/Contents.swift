import UIKit
import PlaygroundSupport
import TableViewCellFormatter

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
    
    @objc func changeRed(_ sender: UIButton) {
        self.contentView.backgroundColor = .red
    }
    
    @objc func changeGreen(_ sender: UIButton) {
        self.contentView.backgroundColor = .green
    }
    
    @objc func changeBlue(_ sender: UIButton) {
        self.contentView.backgroundColor = .blue
    }
}


final class TableViewController: UITableViewController {
    
    private let dataSource: TableViewDataSource & UITableViewDataSource
    
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
        self.tableView.dataSource = self.dataSource
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.tableFooterView = UIView()
    }
}

struct FirstSection: TableViewSection {
    
    let profileRow: AnyTableViewRow<UserTableViewCell> = {
        let path: IndexPath = IndexPath(row: 0, section: 0)
        return AnyTableViewRow(indexPath: path, configure: { (cell: UserTableViewCell) -> Void in
            cell.textLabel?.text = "Chandler De Angelis"
            cell.detailTextLabel?.text = "iOS Developer"
        })
    }()
    
    var rowCount: Int {
        return 1
    }
    
    func cell(for indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: self.profileRow.cellReuseIdentifier, for: self.profileRow.indexPath)
        if let profileCell: UserTableViewCell = cell as? UserTableViewCell {
            self.profileRow.configure(profileCell)
        }
        return cell
    }
}

struct SecondSection: TableViewSection {
    
    let colorsRow: AnyTableViewRow<ChangeColorTableViewCell> = {
        let path: IndexPath = IndexPath(row: 1, section: 0)
        return AnyTableViewRow(indexPath: path)
    }()
    
    var rowCount: Int {
        return 1
    }
    
    func cell(for indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: self.colorsRow.cellReuseIdentifier, for: self.colorsRow.indexPath)
        if let colorsCell: ChangeColorTableViewCell = cell as? ChangeColorTableViewCell {
            self.colorsRow.configure(colorsCell)
        }
        return cell
    }
}

final class DataSource: TableViewDataSource {
    
    convenience init() {
        self.init(sections: [
            FirstSection(),
            SecondSection()
        ])
    }
    
    override func registerCells(with tableView: UITableView) {
        if let firstSection: FirstSection = self.sections.first as? FirstSection {
            firstSection.profileRow.registerCell(with: tableView)
        }
        if let secondSection: SecondSection = self.sections.last as? SecondSection {
            secondSection.colorsRow.registerCell(with: tableView)
        }
    }
}


let vc: TableViewController = TableViewController(style: .plain)
PlaygroundPage.current.liveView = vc.view




