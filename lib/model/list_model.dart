import 'package:flutter/material.dart';

class ListModel with ChangeNotifier{
  int listInfo;

  ListModel({required this.listInfo});

  void changeListinfo(index){
    listInfo = index;
    notifyListeners();
  }
}