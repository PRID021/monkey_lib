import 'package:flutter/material.dart';
import 'package:monkey_lib/service/theme/app_theme.dart';
import 'package:monkey_lib/utils/constraints/app_constraints.dart';
import 'package:monkey_lib/widgets/custom_text_form_field.dart';

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
  const MyHomePage({key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomTextFormField(
                context,
                titleText: "Label Text Form Field",
                trailing: const Icon(
                  Icons.keyboard_arrow_down,
                  size: AppSize.lIconSize,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
