import 'package:news/src/resources/news_api_provider.dart';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

void main(){
  test('FetchTopIds returns a list of integers', (){
    // setup test case
    final sum = 1+4;
    
    // expectations
    expect(sum, 5);
  });
}