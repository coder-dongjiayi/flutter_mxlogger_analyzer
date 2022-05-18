import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mxlogger/flutter_mxlogger.dart';

import 'package:flutter_mxlogger_analyzer/src/theme/mx_theme.dart';
import 'package:flutter_mxlogger_analyzer/src/widget/log_listview.dart';
import 'package:flutter_mxlogger_analyzer/src/widget/search_bar.dart';

import 'mxlogger_detail_page.dart';

class MXLoggerLogPage extends StatefulWidget {
  const MXLoggerLogPage({Key? key, required this.logPath, required this.fileSize}) : super(key: key);
  final String logPath;
  final int fileSize;
  @override
  _MXLoggerLogPageState createState() => _MXLoggerLogPageState();
}

class _MXLoggerLogPageState extends State<MXLoggerLogPage> {
  List<Map<String, dynamic>> dataSource = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadMoreData();
  }

  void loadMoreData(){

    List<String> msgList =   MXLogger.selectLogMsg(
        diskcacheFilePath: widget.logPath);

    List<Map<String, dynamic>> _list = [];
    for (var element in msgList) {
      Map<String,dynamic> map = jsonDecode(element);
      if(map["header"] == null){
        _list.add(map);
      }
    }
    dataSource = _list;
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MXTheme.themeColor,
      appBar: AppBar(
        leadingWidth: 0,
        toolbarHeight: 90,
        backgroundColor: MXTheme.itemBackground,
        elevation: 0,
        leading: const SizedBox(),
        title: const SearchBar(),
      ),
      body: LogListView(
        dataSource: dataSource,
        callback: (int index){
         Navigator.of(context).push(MaterialPageRoute(builder: (context){
           return  MXLoggerDetailPage(source: dataSource[index]);
         }));
        },

      ),
    );
  }
}
