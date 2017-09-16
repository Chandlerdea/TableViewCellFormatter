# TableViewCellFormatter
TabeViewCellFormatter is a library for creating and configuring table view and collection view cells. Using type erasure, you can easily configure your cells in a more delarative way. This is an idea that I have been using and expanding on, but if you have any ideas or problems with this framework, please let me know with a PR. I would love feedback, whether it be positive or negative.

## Installation
### Carthage
Add this line you your `Cartfile`

    github "Chandlerdea/TableViewCellFormatter"
    
### Swift Package Manager
In your `Packages.swift` file, add this code

    import PackageDescription
    
    let package = Package(
        url: "https://github.com/Chandlerdea/TableViewCellFormatter/TableViewCellFormatter.swift"
        majorVersion: 1
    )
    
## Use 
The basic structure of the program is simple.
First, you have the `TableViewSection` protocol, which look like this: 

    public protocol TableViewSection {
    
        var rowCount: Int { get }
    
        func cell(for indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell
    }
   
This is the interface that the table view data source interacts with. Usually, I have an array of objects conforming to this protocol, and the data source methods can use this to figure out how many sections its has, has many rows each sections has, and get cells for index paths.

You also have the `TableViewRow` protocol, which looks like this:

    public protocol TableViewRow {
    
        associatedtype Cell
    
        var indexPath: IndexPath { get }
    
        var cellReuseIdentifier: String { get }
    
        func configure(_ cell: Cell)
    }

This protocol has all information needed to dequeue and configure a cell. Since the protocol has an associated type, that means you cannot have a protocol of this type. To get around the issue, there is a `AnyTableViewRow` struct, which looks like this:

    public struct AnyTableViewRow<CellType: UITableViewCell>: TableViewRow {
    
        private var _configure: (CellType) -> Void
        private var _indexPath: IndexPath
        private var _cellReuseIdentifier: String

        public init<R: TableViewRow>(row: R) where R.Cell == CellType {
            self._configure = row.configure
            self._indexPath = row.indexPath
            self._cellReuseIdentifier = row.cellReuseIdentifier
        }

        public init(indexPath: IndexPath, configure: @escaping (CellType) -> Void) {
            self._indexPath = indexPath
            self._configure = configure
            self._cellReuseIdentifier = CellType.reuseIdentifier
        }

        // MARK: TableViewRow

        public var indexPath: IndexPath {
            return self._indexPath
        }

        public var cellReuseIdentifier: String {
            return self._cellReuseIdentifier
        }

        public func configure(_ cell: CellType) {
            self._configure(cell)
        }
    }
    
This type allows you to essentially remove the associated type requirement for the `TableViewRow` protocol, and reference it as a property.
