import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hw_week6_book_search/book_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'book.dart';

void main() {
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (context) => BookService())],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<BookService>(builder: (context, bookService, child) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            'Book Store',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.white,
          bottom: PreferredSize(
            preferredSize: Size(0, 60),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    child: Text(
                      'total ${bookService.bookList.length}',
                      textAlign: TextAlign.end,
                    ),
                  ),
                  TextField(
                    controller: textEditingController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      hintText: '원하시는 책을 검색해주세요.',
                      suffixIcon: IconButton(
                        onPressed: () async {
                          print(textEditingController.text);
                          await bookService
                              .addBooks(textEditingController.text);
                        },
                        icon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: bookService.bookList.isEmpty
            ? Center(
                child: Text(
                  '검색어를 입력해 주세요',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: bookService.bookList.length,
                itemBuilder: (context, index) {
                  Book book = bookService.bookList[index];
                  return ListTile(
                    leading: Image.network(
                      bookService.bookList[index].thumbnail,
                      width: MediaQuery.of(context).size.width * 0.15,
                      fit: BoxFit.cover,
                    ),
                    title: Text(bookService.bookList[index].title),
                    subtitle: Text(bookService.bookList[index].subtitle),
                    onTap: () {
                      launch(bookService.bookList[index].previewLink);
                    },
                  );
                }),
      );
    });
  }
}
