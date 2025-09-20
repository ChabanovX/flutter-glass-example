import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
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

  LiquidGlassMaterial glassMaterial = LiquidGlassMaterial.popover;
  IOSBlurStyle blurStyle = IOSBlurStyle.systemThickMaterial;
  bool followSomeShit = true;

  Future<void> applyOptions() async {
    final opts = LiquidGlassOptions(
      followsWindowActiveState: followSomeShit,
      material: glassMaterial,
      iosBlurStyle: blurStyle,
    );
    _api.apply(opts);
  }

  Future<void> removeOptions() async {
    _api.remove();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: SafeArea(
        child: CupertinoPageScaffold(
          backgroundColor: CupertinoColors.transparent,
          navigationBar: CupertinoNavigationBar.large(
            largeTitle: Text('Tahoe Glass Example'),
          ),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    for (var e in LiquidGlassMaterial.values)
                      Column(
                        children: [
                          CupertinoButton.filled(
                            onPressed: () async {
                              setState(() {
                                glassMaterial = e;
                              });
                              await applyOptions();
                            },
                            child: SizedBox(
                              width: 200,
                              child: Center(child: Text(e.name)),
                            ),
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    Text('Current value: $glassMaterial'),
                    if (Platform.isIOS) ...[
                      SizedBox(height: 24),
                      Text('Current value: $blurStyle'),
                      CupertinoSegmentedControl(
                        children: {
                          for (var e in IOSBlurStyle.values) e: Text(e.name),
                        },
                        onValueChanged: (v) async {
                          setState(() {
                            blurStyle = v;
                          });
                          await applyOptions();
                        },
                      ),
                    ],
                    SizedBox(height: 32),
                    Container(
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Follows Apps active state:'),
                              SizedBox(width: 16),
                              CupertinoSwitch(
                                value: followSomeShit,
                                onChanged: (val) async {
                                  setState(() {
                                    followSomeShit = val;
                                  });
                                  await applyOptions();
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Whether to change background to inactive when focus disappears.',
                            style: CupertinoTheme.of(
                              context,
                            ).textTheme.tabLabelTextStyle,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32),
                    CupertinoButton(
                      child: SizedBox(
                        width: 200,
                        child: Column(
                          children: [
                            Center(
                              child: Text(
                                'Remove options',
                                style: TextStyle(
                                  color: CupertinoColors.destructiveRed,
                                ),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Removes native view completely',
                              style: CupertinoTheme.of(
                                context,
                              ).textTheme.tabLabelTextStyle,
                            ),
                            Text(
                              'Might produce unexpected behavior',
                              style: CupertinoTheme.of(
                                context,
                              ).textTheme.tabLabelTextStyle,
                            ),
                          ],
                        ),
                      ),
                      onPressed: () async => await removeOptions(),
                    ),
                    SizedBox(height: 48,),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
