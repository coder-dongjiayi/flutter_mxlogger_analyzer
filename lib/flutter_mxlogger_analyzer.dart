library flutter_mxlogger_analyzer;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mxlogger_analyzer/src/mxlogger_analyzer.dart';
import 'package:flutter_mxlogger_analyzer/src/theme/mx_theme.dart';
export 'src/mxlogger_analyzer.dart';

OverlayEntry? _analyzerOverlayEntry;

bool _visible = true;

Offset offset = const Offset(100, 100);

void show(BuildContext materialContext, String dir) {
  if (_analyzerOverlayEntry != null) return;

  _analyzerOverlayEntry = OverlayEntry(builder: (context) {
    return Positioned(
        left: offset.dx,
        top: offset.dy,
        child: GestureDetector(
          onPanUpdate: (DragUpdateDetails details) {
            offset += details.delta;
            _analyzerOverlayEntry?.markNeedsBuild();
          },
          onTap: () async {

            _visible = false;
            _analyzerOverlayEntry?.markNeedsBuild();
            await _showModalBottomSheet(materialContext, dir);
            _visible = true;
            _analyzerOverlayEntry?.markNeedsBuild();
          },
          child: Visibility(
            visible: _visible,
            child: _analyzerIcon(),
          ),
        ));
  });

  Overlay.of(materialContext)?.insert(_analyzerOverlayEntry!);
}

Widget _analyzerIcon() {
  return Container(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
      color: MXTheme.themeColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("mx",
              style: TextStyle(
                  color: MXTheme.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  decoration: TextDecoration.none)),
          Text("Analyzer",
              style: TextStyle(
                  color: MXTheme.white,
                  fontSize: 17,
                  decoration: TextDecoration.none))
        ],
      ));
}

Future<void> _showModalBottomSheet(BuildContext context, String dir) {
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,

      backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
      builder: (_) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width,

          child: MXLoggerAnalyzer(logDir: dir),
        );
      });
}
