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
                cellView.identifier = tableColumn.identifier

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
    associatedtype Body: View

    func makeBody(_ value: TableRowValue) -> Body
    func makeCellView(_ value: TableRowValue, tableView: NSTableView, tableColumn: NSTableColumn) -> NSView?
    func addNSTableColumns(to tableView: NSTableView)
}

struct TableColumn_<RowValue, Content>: TableColumnContent_, Identifiable where RowValue: Identifiable, Content: View {
    typealias TableRowValue = RowValue

    var title: String
    var content: (RowValue) -> Content

    var id = UUID()

    init(_ title: String, @ViewBuilder content: @escaping (RowValue) -> Content) {
        self.title = title
        self.content = content
    }

    func makeBody(_ value: RowValue) -> Content {
        content(value)
    }

    func makeCellView(_ value: RowValue, tableView: NSTableView, tableColumn: NSTableColumn) -> NSView? {
        guard id == UUID(uuidString: tableColumn.identifier.rawValue) else {
            return nil
        }

        let body = makeBody(value)

        let cellView: TableHostCell_<Content>
        if let v = tableView.makeView(withIdentifier: tableColumn.identifier, owner: nil) as? TableHostCell_<Content> {
            cellView = v
            cellView.setRootView(body)
        } else {
            cellView = TableHostCell_(body)
            cellView.identifier = tableColumn.identifier
        }

        return cellView
    }

    func addNSTableColumns(to tableView: NSTableView) {
        let tableColumn = NSTableColumn(identifier: .init(id.uuidString))
        tableColumn.title = title
        tableView.addTableColumn(tableColumn)
    }
}

extension TableColumn_ {
    init(_ title: String, value keyPath: KeyPath<RowValue, String>) where Content == Text {
        self.title = title
        self.content = { Text($0[keyPath: keyPath]) }
    }

    init(_ title: String, value keyPath: KeyPath<RowValue, String?>) where Content == Text {
        self.title = title
        self.content = { Text($0[keyPath: keyPath] ?? "") }
    }
}

struct TupleTableColumnContent2<RowValue, C0, C1>: TableColumnContent_ where RowValue: Identifiable, RowValue == C0.TableRowValue, C0: TableColumnContent_, C1: TableColumnContent_, C0.TableRowValue == C1.TableRowValue {
    typealias TableRowValue = RowValue

    let content: (C0, C1)

    init (_ content: (C0, C1)) {
        self.content = content
    }

    @ViewBuilder func makeBody(_ value: RowValue) -> some View {
        content.0.makeBody(value)
        content.1.makeBody(value)
    }

    func makeCellView(_ value: RowValue, tableView: NSTableView, tableColumn: NSTableColumn) -> NSView? {
        content.0.makeCellView(value, tableView: tableView, tableColumn: tableColumn) ??
        content.1.makeCellView(value, tableView: tableView, tableColumn: tableColumn)
    }

    func addNSTableColumns(to tableView: NSTableView) {
        content.0.addNSTableColumns(to: tableView)
        content.1.addNSTableColumns(to: tableView)
    }
}

struct TupleTableColumnContent3<RowValue, C0, C1, C2>: TableColumnContent_ where RowValue: Identifiable, RowValue == C0.TableRowValue, C0: TableColumnContent_, C1: TableColumnContent_, C2: TableColumnContent_, C0.TableRowValue == C1.TableRowValue, C1.TableRowValue == C2.TableRowValue{
    typealias TableRowValue = RowValue

    let content: (C0, C1, C2)

    init (_ content: (C0, C1, C2)) {
        self.content = content
    }

    @ViewBuilder func makeBody(_ value: RowValue) -> some View {
        content.0.makeBody(value)
        content.1.makeBody(value)
        content.2.makeBody(value)
    }

    func makeCellView(_ value: RowValue, tableView: NSTableView, tableColumn: NSTableColumn) -> NSView? {
        content.0.makeCellView(value, tableView: tableView, tableColumn: tableColumn) ??
        content.1.makeCellView(value, tableView: tableView, tableColumn: tableColumn) ??
        content.2.makeCellView(value, tableView: tableView, tableColumn: tableColumn)
    }

    func addNSTableColumns(to tableView: NSTableView) {
        content.0.addNSTableColumns(to: tableView)
        content.1.addNSTableColumns(to: tableView)
        content.2.addNSTableColumns(to: tableView)
    }
}

struct TupleTableColumnContent4<RowValue, C0, C1, C2, C3>: TableColumnContent_ where RowValue: Identifiable, RowValue == C0.TableRowValue, C0: TableColumnContent_, C1: TableColumnContent_, C2: TableColumnContent_, C3: TableColumnContent_, C0.TableRowValue == C1.TableRowValue, C1.TableRowValue == C2.TableRowValue, C2.TableRowValue == C3.TableRowValue {
    typealias TableRowValue = RowValue

    let content: (C0, C1, C2, C3)

    init (_ content: (C0, C1, C2, C3)) {
        self.content = content
    }

    @ViewBuilder func makeBody(_ value: RowValue) -> some View {
        content.0.makeBody(value)
        content.1.makeBody(value)
        content.2.makeBody(value)
        content.3.makeBody(value)
    }

    func makeCellView(_ value: RowValue, tableView: NSTableView, tableColumn: NSTableColumn) -> NSView? {
        content.0.makeCellView(value, tableView: tableView, tableColumn: tableColumn) ??
        content.1.makeCellView(value, tableView: tableView, tableColumn: tableColumn) ??
        content.2.makeCellView(value, tableView: tableView, tableColumn: tableColumn) ??
        content.3.makeCellView(value, tableView: tableView, tableColumn: tableColumn)
    }

    func addNSTableColumns(to tableView: NSTableView) {
        content.0.addNSTableColumns(to: tableView)
        content.1.addNSTableColumns(to: tableView)
        content.2.addNSTableColumns(to: tableView)
        content.3.addNSTableColumns(to: tableView)
    }
}

@resultBuilder struct TableColumnBuilder_<RowValue> where RowValue: Identifiable {
    static func buildExpression<Content>(_ column: TableColumn_<RowValue, Content>) -> TableColumn_<RowValue, Content> {
        column
    }

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
    var count: Int { get }
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

    var count: Int {
        1
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

    var count: Int {
        content.0.count + content.1.count
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

    var count: Int {
        content.0.count + content.1.count + content.2.count
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

    var count: Int {
        content.0.count + content.1.count + content.2.count + content.3.count
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

struct TableCellModifier_: ViewModifier {
    func body(content: Content) -> some View {
        content.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
}

class TableHostCell_<Content>: NSTableCellView where Content: View {
    var hostingView: NSHostingView<ModifiedContent<Content, TableCellModifier_>>


    func setRootView(_ rootView: Content) {
        hostingView.rootView = rootView.modifier(TableCellModifier_())
    }

    init(_ content: Content) {
        hostingView = NSHostingView(rootView: content.modifier(TableCellModifier_()))
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        super.init(frame: .zero)
        addSubview(hostingView)

        hostingView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        hostingView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        hostingView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        hostingView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct TableRepresentable<Value, Columns>: NSViewRepresentable where Value: Identifiable, Columns: TableColumnContent_, Value == Columns.TableRowValue {
    var columns: Columns
    var rows: [Value]

    class Coordinator: NSObject, NSTableViewDelegate, NSTableViewDataSource {
        var columns: Columns
        var rows: [Value]

        init(columns: Columns, rows: [Value]) {
            self.columns = columns
            self.rows = rows
        }

        func numberOfRows(in tableView: NSTableView) -> Int {
            rows.count
        }

        func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
            guard let tableColumn else {
                return nil
            }

            return columns.makeCellView(rows[row], tableView: tableView, tableColumn: tableColumn)
        }

        func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
            return false
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(columns: columns, rows: rows)
    }

    func makeNSView(context: Context) -> NSScrollView {
        let tableView = NSTableView()
        tableView.usesAlternatingRowBackgroundColors = true
        tableView.allowsColumnReordering = false

        columns.addNSTableColumns(to: tableView)

        tableView.columnAutoresizingStyle = .uniformColumnAutoresizingStyle
        tableView.delegate = context.coordinator
        tableView.dataSource = context.coordinator

        let scrollView = NSScrollView()
        scrollView.documentView = tableView

        return scrollView
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
    }
}

struct Table_<Value, Rows, Columns>: View where Value == Rows.TableRowValue, Rows: TableRowContent_, Columns: TableColumnContent_, Rows.TableRowValue == Columns.TableRowValue {
    var columns: Columns
    var rows: Rows

    init(@TableColumnBuilder_<Value> columns: () -> Columns, @TableRowBuilder_<Value> rows: () -> Rows) {
        self.columns = columns()
        self.rows = rows()
    }

    var body: some View {
        TableRepresentable(columns: columns, rows: rows.values)
    }
}

// MARK: - Usage

struct Person: Identifiable {
    var id = UUID()
    var firstName: String
    var lastName: String
    var age: Int
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
                TableColumn("Age") { person in
                    Text("\(person.age)")
                }
            } rows: {
                TableRow(Person(firstName: "David", lastName: "Albert", age: 36))
                TableRow(Person(firstName: "Bridget", lastName: "McCarthy", age: 36))
            }

            Table_ {
                TableColumn_("First name", value: \.firstName)
                TableColumn_("Last name", value: \.lastName)
                TableColumn_("Age") { person in
                    Text("\(person.age)")
                }
            } rows: {
                TableRow_(Person(firstName: "David", lastName: "Albert", age: 36))
                TableRow_(Person(firstName: "Bridget", lastName: "McCarthy", age: 36))
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
