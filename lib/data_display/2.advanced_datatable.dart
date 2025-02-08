import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'advanced_datatable 示例'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, this.title});
  final String? title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var rowsPerPage = AdvancedPaginatedDataTable.defaultRowsPerPage;
  final source = ExampleSource();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: SingleChildScrollView(
        child: AdvancedPaginatedDataTable(
          addEmptyRows: false,
          source: source,
          showFirstLastButtons: true,
          rowsPerPage: rowsPerPage,
          availableRowsPerPage: [1, 5, 10, 50],
          dataRowHeight: 30,
          onRowsPerPageChanged: (newRowsPerPage) {
            if (newRowsPerPage != null) {
              setState(() {
                rowsPerPage = newRowsPerPage;
              });
            }
          },
          columns: [
            DataColumn(label: Text('Row no')),
            DataColumn(label: Text('Value'))
          ],
          customTableFooter: (source, offset) {
            return _buildCustomFooter(source, offset, rowsPerPage);
          },
        ),
      ),
    );
  }
}

Widget _buildCustomFooter(
    AdvancedDataTableSource<dynamic> source, int offset, int rowsPerPage) {
  final maxPagesToShow = 6;
  final maxPagesBeforeCurrent = 3;
  final lastRequestDetails = source.lastDetails!;
  final rowsForPager =
      lastRequestDetails.filteredRows ?? lastRequestDetails.totalRows;
  final totalPages = (rowsForPager / rowsPerPage).ceil();
  final currentPage = (offset ~/ rowsPerPage) + 1;
  List<int> pageList = [];

  if (currentPage > 1) {
    pageList.addAll(
      List.generate(currentPage - 1, (index) => index + 1),
    );
    pageList.removeWhere(
      (element) => element < currentPage - maxPagesBeforeCurrent,
    );
  }
  pageList.add(currentPage);
  pageList.addAll(
    List.generate(
      maxPagesToShow - (pageList.length - 1),
      (index) => (currentPage + 1) + index,
    ),
  );
  pageList.removeWhere((element) => element > totalPages);

  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      ElevatedButton(
        onPressed: currentPage > 1
            ? () {
                // 上一页
                source.setNextView(startIndex: (currentPage - 2) * rowsPerPage);
              }
            : null,
        child: Text('< 上一页'),
      ),
      SizedBox(width: 10),
      Row(
        children: pageList
            .map(
              (e) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: TextButton(
                  onPressed: e != currentPage
                      ? () {
                          source.setNextView(startIndex: (e - 1) * rowsPerPage);
                        }
                      : null,
                  style: ButtonStyle(
                    minimumSize: WidgetStateProperty.all(
                        Size(30, 30)), // ✅ 改为 WidgetStateProperty
                    padding: WidgetStateProperty.all(
                        EdgeInsets.zero), // ✅ 改为 WidgetStateProperty
                  ),
                  child: Text(e.toString()),
                ),
              ),
            )
            .toList(),
      ),
      SizedBox(width: 10),
      ElevatedButton(
        onPressed: currentPage < totalPages
            ? () {
                // 下一页
                source.setNextView(startIndex: currentPage * rowsPerPage);
              }
            : null,
        child: Text('下一页 >'),
      ),
    ],
  );
}

class RowData {
  final int index;
  final String value;

  RowData(this.index, this.value);
}

class ExampleSource extends AdvancedDataTableSource<RowData> {
  final data = List<RowData>.generate(
      335, (index) => RowData(index, 'Value for no. $index'));

  @override
  DataRow? getRow(int index) {
    final currentRowData = lastDetails!.rows[index];
    return DataRow(cells: [
      DataCell(
        Text(currentRowData.index.toString()),
      ),
      DataCell(
        Text(currentRowData.value),
      )
    ]);
  }

  @override
  int get selectedRowCount => 0;

  @override
  Future<RemoteDataSourceDetails<RowData>> getNextPage(
      NextPageRequest pageRequest) async {
    return RemoteDataSourceDetails(
      data.length,
      data
          .skip(pageRequest.offset)
          .take(pageRequest.pageSize)
          .toList(), //again in a real world example you would only get the right amount of rows
    );
  }
}
