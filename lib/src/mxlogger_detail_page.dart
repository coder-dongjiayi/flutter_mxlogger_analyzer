import 'dart:convert' as JSON;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mxlogger_analyzer/src/theme/mx_theme.dart';
import 'package:flutter_mxlogger_analyzer/src/level/mx_level.dart';
import 'package:flutter_mxlogger_analyzer/src/widget/flutter_json_viewer.dart';

class MXLoggerDetailPage extends StatefulWidget {
  const MXLoggerDetailPage({Key? key, required this.source}) : super(key: key);
  final Map<String, dynamic> source;
  @override
  _MXLoggerDetailPageState createState() => _MXLoggerDetailPageState();
}

class _MXLoggerDetailPageState extends State<MXLoggerDetailPage> {
  late Map<String, dynamic> _source;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _source = widget.source;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MXTheme.themeColor,
      appBar: AppBar(
        elevation: 0,
        title: Text("MXAnalyzer", style: TextStyle(color: MXTheme.white)),
        backgroundColor: MXTheme.themeColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back, color: MXTheme.white),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              _copyClipboard(context, _source.toString());
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Icon(Icons.copy_rounded, color: MXTheme.white, size: 25),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              level(_source["level"]),
               name(_source["name"]),
            ],
          ),

          const SizedBox(height: 10),

          tags(_source["tag"]),
          
          thread("${_source["thread_id"]}", _source["is_main_thread"]),

          const SizedBox(height: 10),
          time(_source["time"]),
          const SizedBox(height: 10),
          message(_source["msg"])
        ],
      ),
    );
  }

  Widget name(String name) {
    return Text("【$name】", style: TextStyle(color: MXTheme.text,fontSize: 18));
  }

  Widget tags(String tags) {
    List<String> tagList = tags.split(",").where((element) => element != "").toList();
    if (tagList.isEmpty) {
      return const SizedBox();
    }

    return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          children: List.generate(tagList.length, (index) {
            return _tag(tagList[index]);
          }),
        ));
  }

  Widget level(int level) {
    return Text("${levelName(level)}",
        style: TextStyle(color: MXTheme.colorLevel(level),fontWeight: FontWeight.w900,fontSize: 20));
  }

  Widget time(String time) {
    return Text("$time", style: TextStyle(color: MXTheme.text,fontSize: 17));
  }

  Widget thread(String threadId, bool isMain) {
    return Row(
      children: [
        Text("线程ID:$threadId",
            style: TextStyle(color: MXTheme.text,fontSize: 17)),
        const SizedBox(width: 10),
        Text(isMain == true ? "[main]" : "[child]",
            style: TextStyle(color: MXTheme.text,fontSize: 17))
      ],
    );
  }

  Widget _tag(String? tag) {
    if (tag == null || tag == "") return const SizedBox();
    return Container(
      decoration: BoxDecoration(
          color: MXTheme.tag,
          borderRadius: BorderRadius.all(Radius.circular(5))),
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
      child: Text(tag, style: TextStyle(color: MXTheme.text, fontSize: 12)),
    );
  }

  Widget message(String msg) {
    try {
      Map<String, dynamic> jsonMap = JSON.jsonDecode(msg);
      return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        color: MXTheme.itemBackground,
        child: JsonViewer(jsonMap),
      );
    } catch (error) {
      return GestureDetector(
        onLongPress: () {
          _copyClipboard(context, msg);
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          color: MXTheme.itemBackground,
          child: Text(msg, style: TextStyle(color: MXTheme.text, fontSize: 18)),
        ),
      );
    }
  }

  void _copyClipboard(BuildContext context, String msg) {
    Clipboard.setData(ClipboardData(text: msg));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: MXTheme.warn,
      content: Text(
        "内容已复制到剪切板",
        textAlign: TextAlign.center,
        style: TextStyle(color: MXTheme.white, fontSize: 18),
      ),
    ));
  }
}
