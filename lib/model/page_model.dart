import 'package:flutter/material.dart';

class PageModel with ChangeNotifier{
  int pageInfo;
  PageModel({required this.pageInfo});

   void changePageinfo(index){
     pageInfo = index;
    notifyListeners();
  }
}