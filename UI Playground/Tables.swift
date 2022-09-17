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

// MARK: - Columns

protocol TableColumnContent_ {
    associatedtype TableRowValue: Identifiable
    associatedtype V: View

    var titles: [String] { get }
    func makeContent(_ value: TableRowValue) -> V
}

struct TableColumn_<RowValue, Content>: TableColumnContent_ where RowValue: Identifiable, Content: View {

    typealias TableRowValue = RowValue

    var title: String
    var content: (RowValue) -> Content

    init(_ title: String, @ViewBuilder content: @escaping (RowValue) -> Content) {
        self.title = title
        self.content = content
    }

    var titles: [String] {
        [title]
    }

    func makeContent(_ value: RowValue) -> Content {
        content(value)
    }
}

struct TupleTableColumnContent2<RowValue, C0, C1>: TableColumnContent_ where RowValue: Identifiable, RowValue == C0.TableRowValue, C0: TableColumnContent_, C1: TableColumnContent_, C0.TableRowValue == C1.TableRowValue {
    typealias TableRowValue = RowValue

    let content: (C0, C1)

    init (_ content: (C0, C1)) {
        self.content = content
    }

    var titles: [String] {
        content.0.titles + content.1.titles
    }

    @ViewBuilder func makeContent(_ value: RowValue) -> some View {
        content.0.makeContent(value)
        content.1.makeContent(value)
    }
}

struct TupleTableColumnContent3<RowValue, C0, C1, C2>: TableColumnContent_ where RowValue: Identifiable, RowValue == C0.TableRowValue, C0: TableColumnContent_, C1: TableColumnContent_, C2: TableColumnContent_, C0.TableRowValue == C1.TableRowValue, C1.TableRowValue == C2.TableRowValue{
    typealias TableRowValue = RowValue

    let content: (C0, C1, C2)

    init (_ content: (C0, C1, C2)) {
        self.content = content
    }

    var titles: [String] {
        content.0.titles + content.1.titles + content.2.titles
    }

    @ViewBuilder func makeContent(_ value: RowValue) -> some View {
        content.0.makeContent(value)
        content.1.makeContent(value)
        content.2.makeContent(value)
    }
}

struct TupleTableColumnContent4<RowValue, C0, C1, C2, C3>: TableColumnContent_ where RowValue: Identifiable, RowValue == C0.TableRowValue, C0: TableColumnContent_, C1: TableColumnContent_, C2: TableColumnContent_, C3: TableColumnContent_, C0.TableRowValue == C1.TableRowValue, C1.TableRowValue == C2.TableRowValue, C2.TableRowValue == C3.TableRowValue {
    typealias TableRowValue = RowValue

    let content: (C0, C1, C2, C3)

    init (_ content: (C0, C1, C2, C3)) {
        self.content = content
    }

    var titles: [String] {
        content.0.titles + content.1.titles + content.2.titles + content.3.titles
    }

    @ViewBuilder func makeContent(_ value: RowValue) -> some View {
        content.0.makeContent(value)
        content.1.makeContent(value)
        content.2.makeContent(value)
        content.3.makeContent(value)
    }
}

@resultBuilder struct TableColumnBuilder_<RowValue> where RowValue: Identifiable {
    static func buildBlock<Column>(_ column: Column) -> Column where RowValue == Column.TableRowValue, Column: TableColumnContent_ {
        column
    }

    static func buildBlock<C0, C1>(_ c0: C0, _ c1: C1) -> TupleTableColumnContent2<RowValue, C0, C1> where RowValue == C0.TableRowValue, C0: TableColumnContent_, C1: TableColumnContent_, C0.TableRowValue == C1.TableRowValue {
        TupleTableColumnContent2<RowValue, C0, C1>((c0, c1))
    }

    static func buildBlock<C0, C1, C2>(_ c0: C0, _ c1: C1, _ c2: C2) -> TupleTableColumnContent3<RowValue, C0, C1, C2> where RowValue == C0.TableRowValue, C0: TableColumnContent_, C1: TableColumnContent_, C2: TableColumnContent_, C0.TableRowValue == C1.TableRowValue, C1.TableRowValue == C2.TableRowValue {
        TupleTableColumnContent3<RowValue, C0, C1, C2>((c0, c1, c2))
    }

    static func buildBlock<C0, C1, C2, C3>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3) -> TupleTableColumnContent4<RowValue, C0, C1, C2, C3> where RowValue == C0.TableRowValue, C0: TableColumnContent_, C1: TableColumnContent_, C2: TableColumnContent_, C3: TableColumnContent_, C0.TableRowValue == C1.TableRowValue, C1.TableRowValue == C2.TableRowValue, C2.TableRowValue == C3.TableRowValue {
        TupleTableColumnContent4<RowValue, C0, C1, C2, C3>((c0, c1, c2, c3))
    }
}

// MARK: - Rows

protocol TableRowContent_ {
    associatedtype TableRowValue: Identifiable
    var values: [TableRowValue] { get }
}

struct TableRow_<Value>: TableRowContent_ where Value: Identifiable {
    typealias TableRowValue = Value

    var value: Value

    init(_ value: Value) {
        self.value = value
    }

    var values: [Value] {
        [value]
    }
}

struct TupleTableRowContent2<Value, C0, C1>: TableRowContent_ where Value: Identifiable, Value == C0.TableRowValue, C0: TableRowContent_, C1: TableRowContent_, C0.TableRowValue == C1.TableRowValue {

    typealias TableRowValue = Value

    var content: (C0, C1)

    init(_ content: (C0, C1)) {
        self.content = content
    }

    var values: [Value] {
        content.0.values + content.1.values
    }
}

struct TupleTableRowContent3<Value, C0, C1, C2>: TableRowContent_ where Value: Identifiable, Value == C0.TableRowValue, C0: TableRowContent_, C1: TableRowContent_, C2: TableRowContent_, C0.TableRowValue == C1.TableRowValue, C1.TableRowValue == C2.TableRowValue {

    typealias TableRowValue = Value

    var content: (C0, C1, C2)

    init(_ content: (C0, C1, C2)) {
        self.content = content
    }

    var values: [Value] {
        content.0.values + content.1.values + content.2.values
    }
}

struct TupleTableRowContent4<Value, C0, C1, C2, C3>: TableRowContent_ where Value: Identifiable, Value == C0.TableRowValue, C0: TableRowContent_, C1: TableRowContent_, C2: TableRowContent_, C3: TableRowContent_, C0.TableRowValue == C1.TableRowValue, C1.TableRowValue == C2.TableRowValue, C2.TableRowValue == C3.TableRowValue {

    typealias TableRowValue = Value

    var content: (C0, C1, C2, C3)

    init(_ content: (C0, C1, C2, C3)) {
        self.content = content
    }

    var values: [Value] {
        content.0.values + content.1.values + content.2.values + content.3.values
    }
}

@resultBuilder struct TableRowBuilder_<Value> where Value: Identifiable {
    static func buildBlock<Content>(_ content: Content) -> Content where Value == Content.TableRowValue, Content: TableRowContent_ {
        content
    }

    static func buildBlock<C0, C1>(_ c0: C0, _ c1: C1) -> TupleTableRowContent2<Value, C0, C1> where Value == C0.TableRowValue, C0: TableRowContent_, C1: TableRowContent_, C0.TableRowValue == C1.TableRowValue {
        TupleTableRowContent2<Value, C0, C1>((c0, c1))
    }

    static func buildBlock<C0, C1, C2>(_ c0: C0, _ c1: C1, _ c2: C2) -> TupleTableRowContent3<Value, C0, C1, C2> where Value == C0.TableRowValue, C0: TableRowContent_, C1: TableRowContent_, C2: TableRowContent_, C0.TableRowValue == C1.TableRowValue, C1.TableRowValue == C2.TableRowValue {
        TupleTableRowContent3<Value, C0, C1, C2>((c0, c1, c2))
    }

    static func buildBlock<C0, C1, C2, C3>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3) -> TupleTableRowContent4<Value, C0, C1, C2, C3> where Value == C0.TableRowValue, C0: TableRowContent_, C1: TableRowContent_, C2: TableRowContent_, C3: TableRowContent_, C0.TableRowValue == C1.TableRowValue, C1.TableRowValue == C2.TableRowValue, C2.TableRowValue == C3.TableRowValue {
        TupleTableRowContent4<Value, C0, C1, C2, C3>((c0, c1, c2, c3))
    }
}


// MARK: - Table

struct Table_<Value, Rows, Columns>: View where Value == Rows.TableRowValue, Rows: TableRowContent_, Columns: TableColumnContent_, Rows.TableRowValue == Columns.TableRowValue {
    var columns: Columns
    var rows: Rows

    init(@TableColumnBuilder_<Value> columns: () -> Columns, @TableRowBuilder_<Value> rows: () -> Rows) {
        self.columns = columns()
        self.rows = rows()
    }

    var body: some View {
        VStack {
            HStack {
                ForEach(columns.titles, id: \.self) { title in
                    Text(title)
                }
            }

            ForEach(rows.values) { value in
                HStack {
                    columns.makeContent(value)
                }
            }
        }
        .frame(maxHeight: .infinity)
    }
}

// MARK: - Usage

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
            let nativeTable = Table {
                TableColumn("First name", value: \.firstName)
                TableColumn("Last name", value: \.lastName)
            } rows: {
                TableRow(Person(firstName: "David", lastName: "Albert"))
                TableRow(Person(firstName: "Bridget", lastName: "McCarthy"))
            }

            let _ = dump(nativeTable)

            Table_ {
                TableColumn_<Person, Text>("First name") { person in
                    Text(person.firstName)
                }
                TableColumn_<Person, Text>("Last name") { person in
                    Text(person.lastName)
                }
            } rows: {
                TableRow_(Person(firstName: "David", lastName: "Albert"))
                TableRow_(Person(firstName: "Bridget", lastName: "McCarthy"))
            }

            nativeTable
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
