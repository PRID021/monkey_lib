import 'package:flutter/material.dart';
import 'package:monkey_lib/service/theme/app_theme.dart';
import 'package:monkey_lib/utils/constraints/app_constraints.dart';
import 'package:monkey_lib/utils/pretty_json.dart';
import 'package:monkey_lib/widgets/custom_text_form_field.dart';
import 'package:device_preview/device_preview.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppStyle.initAppTheme(
    appThemes: appThemes,
    defaultAppTheme: appThemes.first,
  );

  runApp(DevicePreview(
      enabled: true,
      tools: [
        ...DevicePreview.defaultTools,
      ],
      builder: (context) {
        return const MyApp();
      }));
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
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomTextFormField(
                  context,
                  titleText: "Họ và tên",
                  hintText: "Nhập tên đầy đủ của bạn",
                  initialValue: "Nguyễn Văn A",
                  controller: TextEditingController(text: "Nguyễn Văn B"),
                  trailing: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () {},
                    child: const Icon(
                      Icons.cancel,
                      size: AppSize.lIconSize,
                    ),
                  ),
                  onChanged: (({required String newValue, oldValue}) {
                    Logger.w("newValue: $newValue  : oldValue: $oldValue");
                  },),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          formKey.currentState?.validate();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
