import 'package:flutter/material.dart';
import 'package:flutter_expandable_table/flutter_expandable_table.dart';

const Color primaryColor = Color(0xFF1e2f36); //corner
const Color accentColor = Color(0xFF0d2026); //background
const TextStyle textStyle = TextStyle(color: Colors.white);
const TextStyle textStyleSubItems = TextStyle(color: Colors.grey);


class TableExp extends StatefulWidget {
  const TableExp({ Key? key }) : super(key: key);

  @override
  State<TableExp> createState() => _TableExpState();
}

class _TableExpState extends State<TableExp> {
 ExpandableTable _buildSimpleTable() {
    const int COLUMN_COUNT = 20;
    const int ROW_COUNT = 20;

    //Creation header
    ExpandableTableHeader header = ExpandableTableHeader(
        firstCell: Container(
            color: primaryColor,
            margin: const EdgeInsets.all(1),
            child: const Center(
                child: Text(
              'Simple\nTable',
              style: textStyle,
            ))),
        children: List.generate(
            COLUMN_COUNT - 1,
            (index) => Container(
                color: primaryColor,
                margin: const EdgeInsets.all(1),
                child: Center(
                    child: Text(
                  'Column $index',
                  style: textStyle,
                )))));
//Creation rows
    List<ExpandableTableRow> rows = List.generate(
        ROW_COUNT,
        (rowIndex) => ExpandableTableRow(
              height: 50,
              firstCell: Container(
                  color: primaryColor,
                  margin: const EdgeInsets.all(1),
                  child: Center(
                      child: Text(
                    'Row $rowIndex',
                    style: textStyle,
                  ))),
              children: List<Widget>.generate(
                  COLUMN_COUNT - 1,
                  (columnIndex) => Container(
                      color: primaryColor,
                      margin: const EdgeInsets.all(1),
                      child: Center(
                          child: Text(
                        'Cell $rowIndex:$columnIndex',
                        style: textStyle,
                      )))),
            ));

    return ExpandableTable(
      rows: rows,
      header: header,
      scrollShadowColor: accentColor,
    );
  }

  ExpandableTable _buildExpandableTable() {
    const int COLUMN_COUNT = 20;
    const int SUB_COLUMN_COUNT = 5;
    const int ROW_COUNT = 6;

    //Creation header
    ExpandableTableHeader subHeader = ExpandableTableHeader(
        firstCell: Container(
            color: primaryColor,
            margin: const EdgeInsets.all(1),
            child: const Center(
                child: Text(
              'Expandable Column',
              style: textStyleSubItems,
            ))),
        children: List.generate(
            SUB_COLUMN_COUNT,
            (index) => Container(
                color: primaryColor,
                margin: const EdgeInsets.all(1),
                child: Center(
                    child: Text(
                  'Sub Column $index',
                  style: textStyleSubItems,
                )))));

    //Creation header
    ExpandableTableHeader header = ExpandableTableHeader(
        firstCell: Container(
            color: primaryColor,
            margin: const EdgeInsets.all(1),
            child: const Center(
                child: Text(
              'Expandable\nTable',
              style: textStyle,
            ))),
        children: List.generate(
            COLUMN_COUNT - 1,
            (index) => index == 6
                ? subHeader
                : Container(
                    color: primaryColor,
                    margin: const EdgeInsets.all(1),
                    child: Center(
                        child: Text(
                      'Column $index',
                      style: textStyle,
                    )))));

    //Creation sub rows
    List<ExpandableTableRow> subTows1 = List.generate(
        ROW_COUNT,
        (rowIndex) => ExpandableTableRow(
              height: 30,
              firstCell: Container(
                  color: primaryColor,
                  margin: const EdgeInsets.all(1),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Sub Sub Row $rowIndex',
                      style: textStyleSubItems,
                    ),
                  )),
              children: List<Widget>.generate(
                  COLUMN_COUNT + SUB_COLUMN_COUNT - 1,
                  (columnIndex) => Container(
                      color: primaryColor,
                      margin: const EdgeInsets.all(1),
                      child: Center(
                          child: Text(
                        'Cell $rowIndex:$columnIndex',
                        style: textStyleSubItems,
                      )))),
            ));
    List<ExpandableTableRow> subTows = List.generate(
        ROW_COUNT,
        (rowIndex) => ExpandableTableRow(
            height: 50,
            firstCell: Container(
                color: primaryColor,
                margin: const EdgeInsets.all(1),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Sub Row $rowIndex',
                      style: textStyleSubItems,
                    ),
                  ),
                )),
            children: subTows1,
            legend: Container(
              color: primaryColor,
              margin: const EdgeInsets.all(1),
              child: const Center(
                child: Text(
                  'Expandible sub Row...',
                  style: textStyle,
                ),
              ),
            )));
    //Creation rows
    List<ExpandableTableRow> rows = List.generate(
        ROW_COUNT,
        (rowIndex) => ExpandableTableRow(
              height: 50,
              firstCell: Container(
                  color: primaryColor,
                  margin: const EdgeInsets.all(1),
                  child: Center(
                      child: Text(
                    'Row $rowIndex',
                    style: textStyle,
                  ))),
              legend: rowIndex == 0
                  ? Container(
                      color: primaryColor,
                      margin: const EdgeInsets.all(1),
                      child: const Center(
                        child: Text(
                          'Expandible Row...',
                          style: textStyle,
                        ),
                      ),
                    )
                  : null,
              children: rowIndex == 0
                  ? subTows
                  : List<Widget>.generate(
                      COLUMN_COUNT + SUB_COLUMN_COUNT - 1,
                      (columnIndex) => Container(
                          color: primaryColor,
                          margin: const EdgeInsets.all(1),
                          child: Center(
                              child: Text(
                            'Cell $rowIndex:$columnIndex',
                            style: textStyle,
                          )))),
            ));

    return ExpandableTable(
      rows: rows,
      header: header,
      scrollShadowColor: accentColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildExpandableTable();
  }
}
