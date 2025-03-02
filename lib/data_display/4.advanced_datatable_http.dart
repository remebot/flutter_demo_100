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
            DataColumn(label: Text('方法名称')),
            DataColumn(label: Text('ReqNonceStr')),
            DataColumn(label: Text('OpenUserID')),
            DataColumn(label: Text('请求入参')),
            DataColumn(label: Text('请求出参')),
            DataColumn(label: Text('响应时间')),
            DataColumn(label: Text('日志级别')),
            DataColumn(label: Text('创建时间')),
            DataColumn(label: Text('关联条数'))
          ],
          customTableFooter: (source, offset) {
            return _buildCustomFooter(source, offset, rowsPerPage);
          },
        ),
      ),
    );
  }
}

Widget _buildCustomFooter(AdvancedDataTableSource<dynamic> source, int offset, int rowsPerPage) {
  final maxPagesToShow = 6;
  final maxPagesBeforeCurrent = 3;
  final lastRequestDetails = source.lastDetails!;
  final rowsForPager = lastRequestDetails.filteredRows ?? lastRequestDetails.totalRows;
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
                    minimumSize: WidgetStateProperty.all(Size(30, 30)), // ✅ 改为 WidgetStateProperty
                    padding: WidgetStateProperty.all(EdgeInsets.zero), // ✅ 改为 WidgetStateProperty
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
  final String methodName;
  final String reqNonceStr;
  final String openUserID;
  final String request;
  final String response;
  final String time;
  final String logLevel;
  final String createTime;
  final String relatedCnt;

  RowData(this.methodName, this.reqNonceStr, this.openUserID, this.request, this.response, this.time, this.logLevel,
      this.createTime, this.relatedCnt);
}

class ExampleSource extends AdvancedDataTableSource<RowData> {
  final data = <RowData>[
    RowData('a1', 'b1', 'c1', 'd1', 'e1', 'f1', 'g1', 'h1', 'i1'),
    RowData('a2', 'b2', 'c2', 'd2', 'e2', 'f2', 'g2', 'h2', 'i2'),
    RowData('a3', 'b3', 'c3', 'd3', 'e3', 'f3', 'g3', 'h3', 'i3'),
    RowData('a4', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'),
    RowData('a5', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'),
    RowData('a6', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'),
    RowData('a7', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'),
    RowData('a8', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'),
    RowData('a9', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'),
    RowData('a10', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'),
    RowData('a11', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'),
    RowData('a12', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'),
    RowData('a13', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'),
    RowData('a14', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'),
    RowData('a15', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'),
    RowData('a16', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'),
    RowData('a17', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'),
    RowData('a18', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'),
    RowData('a19', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'),
    RowData('a20', 'b20', 'c', 'd', 'e', 'f', 'g', 'h', 'i'),
    RowData('a21', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'),
    RowData('a22', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'),
    RowData('a23', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'),
    RowData('a24', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'),
    RowData('a25', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'),
    RowData('a26', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'),
    RowData('a27', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'),
    RowData('a28', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'),
    RowData('a29', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'),
    RowData('a30', 'b30', 'c', 'd', 'e', 'f', 'g', 'h', 'i'),
  ];

  @override
  DataRow? getRow(int index) {
    final currentRowData = lastDetails!.rows[index];
    return DataRow(cells: [
      DataCell(
        Text(currentRowData.methodName),
      ),
      DataCell(
        Text(currentRowData.reqNonceStr),
      ),
      DataCell(
        Text(currentRowData.openUserID),
      ),
      DataCell(
        Text(currentRowData.request),
      ),
      DataCell(
        Text(currentRowData.response),
      ),
      DataCell(
        Text(currentRowData.time),
      ),
      DataCell(
        Text(currentRowData.logLevel),
      ),
      DataCell(
        Text(currentRowData.time),
      ),
      DataCell(
        Text(currentRowData.relatedCnt),
      ),
    ]);
  }

  @override
  int get selectedRowCount => 0;

  @override
  Future<RemoteDataSourceDetails<RowData>> getNextPage(NextPageRequest pageRequest) async {
    return RemoteDataSourceDetails(
      data.length,
      data
          .skip(pageRequest.offset)
          .take(pageRequest.pageSize)
          .toList(), //again in a real world example you would only get the right amount of rows
    );
  }
}
