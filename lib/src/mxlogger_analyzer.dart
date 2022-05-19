

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mxlogger_analyzer/src/widget/file_listview.dart';

import 'package:flutter_mxlogger_analyzer/src/theme/mx_theme.dart';

import 'mxlogger_log_page.dart';


class MXLoggerAnalyzer extends StatefulWidget {


   MXLoggerAnalyzer({Key? key,required this.logDir}) : super(key: key);
  String logDir;
  @override
  _MXLoggerAnalyzerState createState() => _MXLoggerAnalyzerState();
}

class _MXLoggerAnalyzerState extends State<MXLoggerAnalyzer> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MXTheme.themeColor,

      body: FileListView(
        dirPath: widget.logDir,
        callback: (String fileName,int size){
          String path = widget.logDir + fileName;

          Navigator.push(context, MaterialPageRoute(builder: (context){
            return MXLoggerLogPage(
              logPath: path,
              fileSize: size,
            );
          }));
        },
      )


    );
  }
}

