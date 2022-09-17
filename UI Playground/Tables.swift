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

struct TableColumnOutput<RowValue>: Identifiable where RowValue: Identifiable {
    var id = UUID()
    var title: String
    var content: (RowValue) -> AnyView

    func makeBody(_ value: RowValue) -> AnyView {
        content(value)
    }
}

protocol TableColumnContent_ {
    associatedtype TableRowValue: Identifiable
    associatedtype Body: View

    var titles: [String] { get }
    var outputs: [TableColumnOutput<TableRowValue>] { get }
    func makeBody(_ value: TableRowValue) -> Body
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

    var titles: [String] {
        [title]
    }

    var outputs: [TableColumnOutput<RowValue>] {
        [
            TableColumnOutput(title: title) { value in
                AnyView(
                    HStack {
                        content(value)
                        Spacer()
                    }
                )
            }
        ]
    }

    func makeBody(_ value: RowValue) -> Content {
        content(value)
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

    var titles: [String] {
        content.0.titles + content.1.titles
    }

    var outputs: [TableColumnOutput<RowValue>] {
        content.0.outputs + content.1.outputs
    }

    @ViewBuilder func makeBody(_ value: RowValue) -> some View {
        content.0.makeBody(value)
        content.1.makeBody(value)
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

    var outputs: [TableColumnOutput<RowValue>] {
        content.0.outputs + content.1.outputs + content.2.outputs
    }

    @ViewBuilder func makeBody(_ value: RowValue) -> some View {
        content.0.makeBody(value)
        content.1.makeBody(value)
        content.2.makeBody(value)
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

    var outputs: [TableColumnOutput<RowValue>] {
        content.0.outputs + content.1.outputs + content.2.outputs + content.3.outputs
    }

    @ViewBuilder func makeBody(_ value: RowValue) -> some View {
        content.0.makeBody(value)
        content.1.makeBody(value)
        content.2.makeBody(value)
        content.3.makeBody(value)
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

//struct Table_<Value, Rows, Columns>: View where Value == Rows.TableRowValue, Rows: TableRowContent_, Columns: TableColumnContent_, Rows.TableRowValue == Columns.TableRowValue {
//    var columns: Columns
//    var rows: Rows
//
//    init(@TableColumnBuilder_<Value> columns: () -> Columns, @TableRowBuilder_<Value> rows: () -> Rows) {
//        self.columns = columns()
//        self.rows = rows()
//    }
//
//    var body: some View {
//        VStack {
//            HStack {
//                ForEach(columns.titles, id: \.self) { title in
//                    Text(title)
//                }
//            }
//
//            ForEach(rows.values) { value in
//                HStack {
//                    columns.makeContent(value)
//                }
//            }
//        }
//        .frame(maxHeight: .infinity)
//    }
//}

class TableHostCell_: NSTableCellView {
    var hostingView: NSHostingView<AnyView>

    init(_ content: AnyView) {
        hostingView = NSHostingView(rootView: content)
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        super.init(frame: .zero)
        addSubview(hostingView)

        hostingView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2).isActive = true
        hostingView.widthAnchor.constraint(equalTo: widthAnchor, constant: -2).isActive = true
        hostingView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct TableConfiguration<Value> where Value: Identifiable {
    var columns: [TableColumnOutput<Value>]
    var rows: [Value]

    func column(for id: UUID) -> TableColumnOutput<Value>? {
        columns.first(where: { $0.id == id })
    }

    var rowCount: Int {
        rows.count
    }
}

struct TableRepresentable<Value>: NSViewRepresentable where Value: Identifiable {
    var configuration: TableConfiguration<Value>

    class Coordinator: NSObject, NSTableViewDelegate, NSTableViewDataSource {
        var configuration: TableConfiguration<Value>

        init(configuration: TableConfiguration<Value>) {
            self.configuration = configuration
        }

        func numberOfRows(in tableView: NSTableView) -> Int {
            configuration.rowCount
        }

        func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
            guard let tableColumn else {
                return nil
            }

            guard let columnId = UUID(uuidString: tableColumn.identifier.rawValue) else {
                return nil
            }

            guard let column = configuration.column(for: columnId) else {
                return nil
            }

            let cellView: TableHostCell_
            if let v = tableView.makeView(withIdentifier: tableColumn.identifier, owner: self) as? TableHostCell_ {
                cellView = v
            } else {
                cellView = TableHostCell_(AnyView(EmptyView()))
            }

            cellView.hostingView.rootView = column.makeBody(configuration.rows[row])

            return cellView
        }
    }


    func makeCoordinator() -> Coordinator {
        Coordinator(configuration: configuration)
    }

    func makeNSView(context: Context) -> NSScrollView {
        let tableView = NSTableView()
        tableView.usesAlternatingRowBackgroundColors = true

        for column in configuration.columns {
            let tableColumn = NSTableColumn(identifier: .init(column.id.uuidString))
            tableColumn.title = column.title
            tableView.addTableColumn(tableColumn)
        }

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
        TableRepresentable(configuration: TableConfiguration(columns: columns.outputs, rows: rows.values))
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
