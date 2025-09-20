import 'dart:io' show Platform, isIOS;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tahoe_effects/tahoe_effects.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _api = TahoeEffects();

  String msg = "Undefined";

  LiquidGlassMaterial glassMaterial = LiquidGlassMaterial.popover;
  IOSBlurStyle blurStyle = IOSBlurStyle.systemThickMaterial;
  bool followSomeShit = true;

  static const items = LiquidGlassMaterial.values;

  Future<void> applyOptions() async {
    final opts = LiquidGlassOptions(
      followsWindowActiveState: followSomeShit,
      material: glassMaterial,
      iosBlurStyle: blurStyle,
    );
    _api.apply(opts);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: SafeArea(
        child: CupertinoPageScaffold(
          backgroundColor: CupertinoColors.transparent,
          navigationBar: CupertinoNavigationBar.large(
            largeTitle: Text('Some Title'),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var e in items)
                          Column(
                            children: [
                              CupertinoButton.filled(
                                onPressed: () async {
                                  setState(() {
                                    glassMaterial = e;
                                  });
                                  await applyOptions();
                                },
                                child: SizedBox(width: 200, child: Center(child: Text(e.name))),
                              ),
                              SizedBox(height: 8),
                            ],
                          ),
                        Text('Current value: $glassMaterial'),
                        // CupertinoSegmentedControl(
                        //   children: {for (var e in items) e: Text(e.name)},
                        //   onValueChanged: (v) async {
                        //     setState(() {
                        //       glassMaterial = v;
                        //     });
                        //     await applyOptions();
                        //   },
                        // ),
                        SizedBox(height: 24),
                        if (Platform.isIOS) ...[
                          Text('Current value: $blurStyle'),
                          CupertinoSegmentedControl(
                            children: {
                              for (var e in IOSBlurStyle.values)
                                e: Text(e.name),
                            },
                            onValueChanged: (v) async {
                              setState(() {
                                blurStyle = v;
                              });
                              await applyOptions();
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
