import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('SelectableText 示例')),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SizedBox(
                    width: 430,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.white), // 背景色
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SelectableText(
                          """<?xml version="1.0" encoding="UTF-8"?>
                        <library>
                          <section name="Science Fiction">
                              <book id="b001">
                    <title>Interstellar Odyssey</title>
                    <author>Jane Doe</author>
                    <publishedYear>2045</publishedYear>
                    <price currency="USD">19.99</price>
                              </book>
                              <book id="b002">
                    <title>Galactic Frontiers</title>
                    <author>John Smith</author>
                    <publishedYear>2038</publishedYear>
                    <price currency="EUR">14.50</price>
                              </book>
                          </section>
                          <section name="Fantasy">
                              <book id="b003">
                    <title>Mysteries of the Enchanted Forest</title>
                    <author>Emily White</author>
                    <publishedYear>2030</publishedYear>
                    <price currency="GBP">12.99</price>
                              </book>
                          </section>
                          <section name="Biographies">
                              <book id="b004">
                    <title>Visionary Leaders of the 21st Century</title>
                    <author>Richard Brown</author>
                    <publishedYear>2025</publishedYear>
                    <price currency="USD">25.00</price>
                              </book>
                          </section>
                        </library>""",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
