# TableViewCellFormatter
TabeViewCellFormatter is a library for creating and configuring table view and collection view cells. Using type erasure, you can easily configure your cells in a more delarative way. This is an idea that I have been using and expanding on, but if you have any ideas or problems with this framework, please let me know with a PR. I would love feedback, whether it be positive or negative.

## Installation
### Carthage
Add this line you your `Cartfile`

    github "Chandlerdea/TableViewCellFormatter"
    
### Swift Package Manager
In your `Packages.swift` file, add this code

```swift
import PackageDescription

let package = Package(
    url: "https://github.com/Chandlerdea/TableViewCellFormatter/TableViewCellFormatter.swift"
    majorVersion: 1
)
```

## Use 
The basic structure of the program is simple.
First, you have the `TableViewDataSource` class, which looks like this:

```swift
open class TableViewDataSource: NSObject {

    public let sections: [TableViewSection]

    public init(sections: [TableViewSection]) {
        self.sections = sections
        super.init()
    }

    open func registerCells(with tableView: UITableView) {
        // Default implemetation
    }
}
// MARK: - UITableViewDataSource
extension TableViewDataSource: UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentSection: TableViewSection = self.sections[section]
        return currentSection.rowCount
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentSection: TableViewSection = self.sections[indexPath.section]
        return currentSection.cell(for: indexPath, in: tableView)
    }
}
```   

This class acts as the data source for a table view. To use this class, you need to either sublass it, or pass an array of objects that conform to `TableViewSection`. A `TableViewSection` determines how many rows are in the section, and dequeues cell from the table view. The interface looks like this:

```swift
public protocol TableViewSection {

    var rowCount: Int { get }

    func cell(for indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell
}
```

You also have the `TableViewRow` protocol, which looks like this:

```swift
public protocol TableViewRow {

    associatedtype Cell

    var indexPath: IndexPath { get }

    var cellReuseIdentifier: String { get }

    func configure(_ cell: Cell)
}
```

This protocol has all information needed to dequeue and configure a cell. Since the protocol has an associated type, that means you cannot have a property of this type. To get around the issue, there is a `AnyTableViewRow` struct, which looks like this:

```swift
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
```

This type allows you to essentially remove the associated type requirement for the `TableViewRow` protocol, and reference it as a property.

Usually I have structs that conform to `TableViewSection`, each with references to instances of `AnyTableViewRow<SomeCellClass>`. In the implementation of `cell(for:, in:)`, the cell is dequeued, and the row for the index path configures the cell. Once you have those, you can sublass `TableViewDataSource`, and add a convenience initialzer that passes those sections. Checkout the playground for an expample of this.
