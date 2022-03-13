import 'package:flutter/material.dart';

class Item {
  String date;
  double temp;

  Item({required this.date, required this.temp});
}

class ForecastDataTableModel extends StatefulWidget {
  const ForecastDataTableModel({Key? key}) : super(key: key);

  @override
  State<ForecastDataTableModel> createState() => _ForecastDataTableModelState();
}

class _ForecastDataTableModelState extends State<ForecastDataTableModel> {
  List<Item> items = [];
  bool sort = false;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _dateController;
  late TextEditingController _tempController;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
    _tempController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return DataTable(sortColumnIndex: 1, sortAscending: sort, columns: [
      const DataColumn(
        label: Text('Дата'),
      ),
      DataColumn(
        numeric: true,
        onSort: (index, ascending) {
          var sortedItems = items;
          sortedItems.sort((a, b) => a.temp.compareTo(b.temp));
          items = ascending ? sortedItems : sortedItems.reversed.toList();
          setState(() {
            sort = ascending;
          });
        },
        label: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [Text('Температура')],
          )),
        ),
      )
    ], rows: [
      ...items.map(
        (element) => DataRow(
          cells: [
            DataCell(
              Text(element.date),
            ),
            DataCell(
              Text(element.temp.toString()),
            ),
          ],
        ),
      ),
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    _tempController.dispose();
    _dateController.dispose();
  }
}
