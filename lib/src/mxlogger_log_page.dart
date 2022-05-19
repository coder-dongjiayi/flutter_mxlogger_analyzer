import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_mxlogger_analyzer/src/theme/mx_theme.dart';
import 'package:flutter_mxlogger_analyzer/src/widget/log_listview.dart';
import 'package:flutter_mxlogger_analyzer/src/widget/search_bar.dart';

import 'mxlogger_detail_page.dart';

class MXLoggerLogPage extends StatefulWidget {
  const MXLoggerLogPage(
      {Key? key, required this.logPath, required this.fileSize})
      : super(key: key);
  final String logPath;
  final int fileSize;
  @override
  _MXLoggerLogPageState createState() => _MXLoggerLogPageState();
}

class _MXLoggerLogPageState extends State<MXLoggerLogPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  Future<List<Map<String, dynamic>>> _requestSource({String? keyWord}){
    var completer =  Completer<List<Map<String, dynamic>>>();
    Future((){
      File file = File(widget.logPath);
      List<String> msgList = file.readAsLinesSync();

      List<Map<String, dynamic>> _list = [];
      for (var element in msgList) {
        Map<String, dynamic> map = jsonDecode(element);
        if (map["header"] == null) {
          _list.add(map);
        }
      }
     return _list.reversed.toList();
    }).then((value){

      return completer.complete(value);
    });


   return completer.future;


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MXTheme.themeColor,
      appBar: AppBar(
        leadingWidth: 0,
        toolbarHeight: 60,
        backgroundColor: MXTheme.itemBackground,
        elevation: 0,
        leading: const SizedBox(),
        title: const SearchBar(),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _requestSource(),
          builder:
          (BuildContext context,
              AsyncSnapshot<List<Map<String, dynamic>>>? snapshot) {


        if (snapshot?.connectionState == ConnectionState.done) {
          List<Map<String, dynamic>> dataSource = snapshot?.data ?? [];
          if(dataSource.isEmpty == true){
            return SizedBox();
          }
          return LogListView(
            dataSource: dataSource,
            callback: (int index) {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return MXLoggerDetailPage(source: dataSource[index]);
              }));
            },
          );
        } else {
          return Center(child: const Text("加载中..."));
        }
      }),
    );
  }
}
