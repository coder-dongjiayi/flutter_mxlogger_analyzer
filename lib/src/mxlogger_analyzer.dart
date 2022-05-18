

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mxlogger_analyzer/src/widget/file_listview.dart';

import 'package:flutter_mxlogger_analyzer/src/theme/mx_theme.dart';

import 'mxlogger_log_page.dart';

OverlayEntry? _analyzerOverlayEntry;

Offset offset = const Offset(100, 100);

void show(BuildContext materialContext,String dir) {
  if(_analyzerOverlayEntry != null) return;

  _analyzerOverlayEntry = OverlayEntry(builder: (context) {
    return Positioned(
        left: offset.dx,
        top: offset.dy,
        child: GestureDetector(
          onPanUpdate: (DragUpdateDetails details){
            offset += details.delta;
            _analyzerOverlayEntry?.markNeedsBuild();
          },
          onTap: () async{
            _analyzerOverlayEntry?.remove();
            _analyzerOverlayEntry = null;
            await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
                builder: (_) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    width: MediaQuery.of(context).size.width,
                    child:  MXLoggerAnalyzer(logDir: dir),
                  );
                });
            show(materialContext, dir);
          },
          child: Container(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
              color: MXTheme.themeColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("mx",style: TextStyle(color:MXTheme.white, fontSize: 9, fontWeight: FontWeight.w900, decoration: TextDecoration.none)),
                  Text("Analyzer",style: TextStyle(color:MXTheme.white, fontSize: 17, decoration: TextDecoration.none))
                ],
              )
          ),
        ));
  });

  Overlay.of(materialContext)!.insert(_analyzerOverlayEntry!);

}


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
      ),


    );
  }
}

