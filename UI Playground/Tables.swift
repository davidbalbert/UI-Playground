//
//  Tables.swift
//  UI Playground
//
//  Created by David Albert on 9/9/22.
//

import SwiftUI

struct MyTableRepresentable: NSViewRepresentable {
    class Coordinator: NSObject, NSTableViewDelegate, NSTableViewDataSource {
        func numberOfRows(in tableView: NSTableView) -> Int {
            5
        }

        func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
            guard let tableColumn = tableColumn else {
                return nil
            }

            let cellView: NSTableCellView
            if let v = tableView.makeView(withIdentifier: tableColumn.identifier, owner: self) as? NSTableCellView {
                cellView = v
            } else {
                let textField = NSTextField()
                textField.translatesAutoresizingMaskIntoConstraints = false
                textField.isBezeled = false
                textField.drawsBackground = false
                textField.font = NSFont.systemFont(ofSize: NSFont.systemFontSize)

                cellView = NSTableCellView()
                cellView.autoresizingMask = .height
                cellView.textField = textField
                cellView.addSubview(textField)

                textField.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 2).isActive = true
                textField.widthAnchor.constraint(equalTo: cellView.widthAnchor, constant: -2).isActive = true
                textField.centerYAnchor.constraint(equalTo: cellView.centerYAnchor, constant: 0).isActive = true

            }

            cellView.textField?.stringValue = "\(tableColumn.title) \(row)"

            return cellView
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeNSView(context: Context) -> NSScrollView {
        let tableView = NSTableView()

        let c1 = NSTableColumn(identifier: .init("Foo"))
        c1.title = "Foo"
        tableView.addTableColumn(c1)

        let c2 = NSTableColumn(identifier: .init("Bar"))
        c2.title = "Bar"
        tableView.addTableColumn(c2)

        let c3 = NSTableColumn(identifier: .init("Baz"))
        c3.title = "Baz"
        tableView.addTableColumn(c3)

        tableView.delegate = context.coordinator
        tableView.dataSource = context.coordinator

        let scrollView = NSScrollView()
        scrollView.documentView = tableView

        return scrollView
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
    }
}

protocol TableColumnContent_ {
    associatedtype TableRowValue: Identifiable
}

protocol TableColumnTitles {
    var titles: [String] { get }
}

struct TableColumn_<RowValue>: TableColumnContent_ where RowValue: Identifiable {
    typealias TableRowValue = RowValue

    var title: String

    init(_ label: String) {
        self.title = label
    }
}

extension TableColumn_: TableColumnTitles {
    var titles: [String] {
        [title]
    }
}

struct TupleTableColumnContent_<RowValue, T>: TableColumnContent_ where RowValue: Identifiable {
    typealias TableRowValue = RowValue

    var value: T

    init(value: T) {
        self.value = value
    }
}

extension TupleTableColumnContent_: TableColumnTitles {
    var titles: [String] {
        var res: [String] = []

        // TODO: Switch to Regex in Swift 5.7
        for child in Mirror(reflecting: value).children {
            if child.label?.range(of: #"^\.[0-9]+"#, options: .regularExpression) != nil, let t = child.value as? TableColumnTitles {
                res.append(contentsOf: t.titles)
            }
        }

        return res
    }
}

@resultBuilder struct TableColumnBuilder_<RowValue> where RowValue: Identifiable {
    static func buildBlock<Column>(_ column: Column) -> Column where RowValue == Column.TableRowValue, Column: TableColumnContent_ {
        column
    }

    static func buildBlock<C0, C1>(_ c0: C0, _ c1: C1) -> TupleTableColumnContent_<RowValue, (C0, C1)> where RowValue == C0.TableRowValue, C0: TableColumnContent_, C1: TableColumnContent_, C0.TableRowValue == C1.TableRowValue {
        TupleTableColumnContent_<RowValue, (C0, C1)>(value: (c0, c1))
    }

    static func buildBlock<C0, C1, C2>(_ c0: C0, _ c1: C1, _ c2: C2) -> TupleTableColumnContent_<RowValue, (C0, C1, C2)> where RowValue == C0.TableRowValue, C0: TableColumnContent_, C1: TableColumnContent_, C2: TableColumnContent_, C0.TableRowValue == C1.TableRowValue, C1.TableRowValue == C2.TableRowValue {
        TupleTableColumnContent_<RowValue, (C0, C1, C2)>(value: (c0, c1, c2))
    }

    static func buildBlock<C0, C1, C2, C3>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3) -> TupleTableColumnContent_<RowValue, (C0, C1, C2, C3)> where RowValue == C0.TableRowValue, C0: TableColumnContent_, C1: TableColumnContent_, C2: TableColumnContent_, C3: TableColumnContent_, C0.TableRowValue == C1.TableRowValue, C1.TableRowValue == C2.TableRowValue, C2.TableRowValue == C3.TableRowValue {
        TupleTableColumnContent_<RowValue, (C0, C1, C2, C3)>(value: (c0, c1, c2, c3))
    }
}

struct MyTable<Value, Columns>: View where Value == Columns.TableRowValue, Columns: TableColumnContent_ {
    var columns: Columns

    init(@TableColumnBuilder_<Value> columns: () -> Columns) {
        self.columns = columns()
    }

    var body: some View {
        VStack {
            HStack {
                if let titles = (columns as? TableColumnTitles)?.titles {
                    ForEach(titles, id: \.self) { title in
                        Text(title)
                    }
                }
            }
        }
        .frame(maxHeight: .infinity)
    }
}

struct Person: Identifiable {
    var id = UUID()
    var firstName: String
    var lastName: String
}

struct Tables: View {
    @TableColumnBuilder<Person, Never> var columns: some TableColumnContent {
        TableColumn("First name", value: \.firstName)
        TableColumn("Last name", value: \.lastName)
    }

    var firstNameColumn: TableColumn<Person, Never, Text, Text> {
        TableColumn("First name", value: \.firstName)
    }

    var body: some View {
        VStack {
            MyTable {
                TableColumn_<Person>("First name")
                TableColumn_<Person>("Last name")
                TableColumn_<Person>("Something else")
                TableColumn_<Person>("Hmm")
            }

            Table {
                TableColumn("First name", value: \.firstName)
                TableColumn("Last name", value: \.lastName)
            } rows: {
                TableRow(Person(firstName: "David", lastName: "Albert"))
                TableRow(Person(firstName: "Bridget", lastName: "McCarthy"))
            }
        }
        .eraseToAnyView()
    }

    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif
}

struct Tables_Previews: PreviewProvider {
    static var previews: some View {
        Tables()
    }
}
