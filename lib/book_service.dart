import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'book.dart';

class BookService extends ChangeNotifier {
  // 책 목록
  List<Book> bookList = [];

  Future<void> addBooks(var serchedText) async {
    bookList.clear();
    Response response = await Dio().get(
      'https://www.googleapis.com/books/v1/volumes',
      queryParameters: {'q': serchedText},
    );
    for (var bookData in response.data['items']) {
      Book book = Book(
        title: bookData['volumeInfo']['title'] ??= '',
        subtitle: bookData['volumeInfo']['subtitle'] ??= '',
        thumbnail: bookData['volumeInfo']['imageLinks'] == null
            ? "https://i.ibb.co/2ypYwdr/no-photo.png"
            : bookData['volumeInfo']['imageLinks']['thumbnail'],
        previewLink: bookData['volumeInfo']['previewLink'] ??= '',
      );
      bookList.add(book);
    }
    notifyListeners();
  }
}
