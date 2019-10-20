//
//  TableDataSource.swift
//  WeatherLogger
//
//  Created by Radim Langer on 20/10/2019.
//  Copyright © 2019 Accenture. All rights reserved.
//

struct TableSection<Item> {
    var items: [Item]
}

struct TableCellDescriptor {

    public let cellClass: UITableViewCell.Type
    public let configure: ((UITableViewCell) -> Void)?

    public init<Cell: UITableViewCell>(cellClass: Cell.Type, configure: ((Cell) -> Void)? = nil) {

        self.cellClass = cellClass

        if let configure = configure {
            self.configure = { cell in (cell as? Cell).map(configure) }
        } else {
            self.configure = nil
        }
    }
}

class TableDataSource<Item>: NSObject, UITableViewDataSource {

    typealias Section = TableSection<Item>

    var sections: [Section] = []

    func cellDescriptor(for item: Item) -> TableCellDescriptor   {
        fatalError("⚠️ Implement in subclass!")
    }

    func item(at indexPath: IndexPath) -> Item? {

        guard
            case 0 ..< sections.count = indexPath.section,
            case 0 ..< sections[indexPath.section].items.count = indexPath.item
        else {
            return nil
        }

        return sections[indexPath.section].items[indexPath.item]
    }

    // MARK: - Setting TableView DataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let item = sections[indexPath.section].items[indexPath.row]
        let descriptor = cellDescriptor(for: item)
        let reuseIdentifier = String(describing: descriptor.cellClass)
        tableView.register(descriptor.cellClass, forCellReuseIdentifier: reuseIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        descriptor.configure?(cell)

        return cell
    }
}
