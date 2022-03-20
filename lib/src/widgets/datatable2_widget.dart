import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class DataTable2Widget extends StatefulWidget {
  const DataTable2Widget({ Key? key }) : super(key: key);

  @override
  State<DataTable2Widget> createState() => _DataTable2WidgetState();
}

class _DataTable2WidgetState extends State<DataTable2Widget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: DataTable2(
            columnSpacing: 12,
            horizontalMargin: 12,
            minWidth: 600,
            columns: const [
              DataColumn2(
                label: Text('Column A'),
                size: ColumnSize.L,
              ),
              DataColumn(
                label: Text('Column B'),
              ),
              DataColumn(
                label: Text('Column C'),
              ),
              DataColumn(
                label: Text('Column D'),
              ),
              DataColumn(
                label: Text('Column NUMBERS'),
                numeric: true,
              ),
            ],
            rows: List<DataRow>.generate(
                20,
                (index) => DataRow(cells: [
                      DataCell(Text('A' * (10 - index % 10))),
                      DataCell(Text('B' * (10 - (index + 5) % 10))),
                      DataCell(Text('C' * (15 - (index + 5) % 10))),
                      DataCell(Text('D' * (15 - (index + 10) % 10))),
                      DataCell(Text(((index + 0.1) * 25.4).toString()))
                    ]))),
      ),
    );
  }
}