import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monkey_lib/service/theme/app_theme.dart';
import 'package:monkey_lib/utils/pretty_json.dart';
import 'package:monkey_lib/widgets/custom_layout_widgets/custom_box.dart';
import 'package:monkey_lib/widgets/custom_layout_widgets/custom_column.dart';
import 'package:monkey_lib/widgets/custom_layout_widgets/custom_expand.dart';
import 'package:monkey_lib/widgets/custom_load_more/custom_load_more.dart';
import 'package:monkey_lib/widgets/custom_load_more/scroll_layout_injector.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppStyle.initAppTheme(
    appThemes: appThemes,
    defaultAppTheme: appThemes.first,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: AppStyle.defaultAppThemeData,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }

  @override
  void initState() {
    super.initState();
    SystemUtils.window.onPlatformBrightnessChanged = () {
      setState(() {
        AppStyle.onPlatformBrightnessChanged();
      });
    };
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int indexStart = 0;
  int numberItems = 30;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: false,
        extendBody: true,
        body: Column(
          children: [
            const SizedBox(
              height: 24,
            ),
            Expanded(
              child: CustomLoadMore<int>(
                storageKey: const PageStorageKey("custom_load_more"),
                bucketGlobal: PageStorageBucket(),
                customScrollableLayoutBuilderInjector:
                    MonkeyScrollableLayoutBuilderInjector(),
                mainAxisDirection: Axis.horizontal,
                initBuilder: (context) {
                  return const Center(child: CircularProgressIndicator());
                },
                onRefresh: () {
                  indexStart = 0;
                  numberItems = 50;
                },
                loadMoreBuilder: (context) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Text("Hold on, loading more..."),
                      CircularProgressIndicator(),
                    ],
                  );
                },
                initFailedBuilder: (context, retryCallback) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("init failed"),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white38,
                        ),
                        onPressed: () {
                          Logger.w("retry init failed");
                          retryCallback.call();
                        },
                        child: const Text("Retry",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  );
                },
                loadMoreFailedBuilder: (context, retryLoadMoreCallback) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text("load more failed"),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white38,
                        ),
                        onPressed: () {
                          retryLoadMoreCallback.call();
                          Logger.w("retry load more failed");
                        },
                        child: const Text("Retry",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  );
                },
                noMoreBuilder: (context) {
                  return const Center(child: Text("no more"));
                },
                loadMoreCallback: () async {
                  if (Random().nextBool()) throw Exception("load more failed");
                  ScaffoldMessengerState scaffoldMessengerState =
                      ScaffoldMessenger.of(context);
                  await Future.delayed(const Duration(seconds: 1));
                  var values =
                      List.generate(numberItems, (index) => index + indexStart);
                  indexStart += numberItems;
                  SnackBar snackBar = SnackBar(
                    content:
                        Text('Load more success! with ${values.length} items'),
                    duration: const Duration(microseconds: 700),
                  );
                  scaffoldMessengerState.showSnackBar(snackBar);
                  return values;
                },
                listItemBuilder: (context, index, item) {
                  return Container(
                    color: Colors.primaries[index % Colors.primaries.length],
                    width: 200,
                    height: 100,
                    child: Center(
                      child: Text("$item"),
                    ),
                    // child: ListTile(
                    //   title: Text("$item"),
                    //   subtitle: Text(
                    //       "Id mollit fugiat occaecat excepteur Lorem exercitation excepteur."),
                    // ),
                  );
                },
                initCallBack: () async {
                  await Future.delayed(const Duration(seconds: 1));
                  var values =
                      List.generate(numberItems, (index) => index + indexStart);
                  indexStart += numberItems;
                  return values;
                },
                shrinkWrap: false,
              ),
            ),
          ],
        ),
      ),
    );

    // return Scaffold(
    //   body: CustomColumn(
    //     align: CustomColumAlign.center,
    //     children: [
    //       CustomExpand(
    //         child: Container(
    //           color: Colors.black,
    //         ),
    //       ),
    //       Container(
    //         // height: 100,
    //         color: Colors.red,
    //         child: Text(
    //           "Eu reprehenderit sunt quis commodo reprehenderit laboris do non fugiat.",
    //           style: Theme.of(context).textTheme.headline4,
    //           textAlign: TextAlign.center,
    //         ),
    //       ),
    //       Container(
    //         // height: 0,
    //         color: Color.fromRGBO(233, 30, 99, 1),
    //         child: Center(
    //           child: Text(
    //             "Ipsum esse nisi fugiat pariatu id 211.",
    //             style: Theme.of(context).textTheme.bodyText1,
    //             textAlign: TextAlign.center,
    //           ),
    //         ),
    //       ),
    //       Center(child: Text("Cupidatat velit et laboris ea in et.")),
    //       CustomExpand(
    //         flex: 3,
    //         child: Container(
    //           color: Color.fromARGB(255, 66, 45, 45),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}

class HorizontalLoader extends StatefulWidget {
  const HorizontalLoader({Key? key}) : super(key: key);

  static final colors = [
    Colors.red,
    Colors.indigoAccent,
    Colors.purple,
    Colors.amberAccent,
    Colors.orange,
    Colors.purple,
    Colors.cyanAccent,
    Colors.red,
    Colors.indigoAccent,
    Colors.purple,
  ];

  @override
  State<HorizontalLoader> createState() => _HorizontalLoaderState();
}

class _HorizontalLoaderState extends State<HorizontalLoader> {
  int distance = 70; // offset
  bool isActive = false;
  double progress = 0.0;

  // Base logic. you can also use this logic with ScrollController()
  bool _handleNotification(ScrollNotification notify) {
    double outRangeLoading = distance + notify.metrics.maxScrollExtent;
    double currentPixel = notify.metrics.pixels;

    if (notify.metrics.extentAfter <= 0.0) {
      if (currentPixel >= outRangeLoading) {
        networkLoader();
      }

      calculateProgress(outRangeLoading, currentPixel);
    }
    return true;
  }

  // Some math
  void calculateProgress(outRangeLoading, currentPixel) {
    double current, currentAsPrecent;

    current = outRangeLoading - currentPixel;
    currentAsPrecent = (100 * current) / distance;

    setState(() {
      progress = (100 - currentAsPrecent) * 0.01;
    });
  }

  // To simulate loading data from Network
  void networkLoader() async {
    isActive = true;
    await Future.delayed(Duration(seconds: 3));
    isActive = false;
    setState(() {
      progress = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 200, bottom: 200),
        child: Stack(
          children: [
            Positioned(
              right: 15,
              top: 210,
              child: isActive
                  ? CupertinoActivityIndicator()
                  : CupertinoActivityIndicator.partiallyRevealed(
                      progress: progress,
                    ),
            ),
            NotificationListener<ScrollNotification>(
              onNotification: _handleNotification,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: HorizontalLoader.colors.length + 1,
                itemBuilder: (context, index) {
                  if (index == HorizontalLoader.colors.length) {
                    return isActive ? SizedBox(width: 50) : SizedBox();
                  }
                  return Container(
                    width: 100,
                    height: 100,
                    color: HorizontalLoader.colors[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
