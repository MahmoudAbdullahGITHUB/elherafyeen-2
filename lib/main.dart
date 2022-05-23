import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/pages/auth/authentication_page.dart';
import 'package:elherafyeen/pages/auth/language_page.dart';
import 'package:elherafyeen/pages/auth/login_page.dart';
import 'package:elherafyeen/pages/auth/more_auth/account_type.dart';
import 'package:elherafyeen/pages/auth/shipping_page.dart';
import 'package:elherafyeen/pages/home/tab_bar_page.dart';
import 'package:elherafyeen/utilities/NavigationStack.dart';
import 'package:elherafyeen/utilities/routes.dart';
import 'package:elherafyeen/utilities/shared_preferences.dart';
import 'package:elherafyeen/utilities/strings.dart';
import 'package:elherafyeen/vendor_details_phone.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';
import 'package:uni_links/uni_links.dart';
import 'package:video_player/video_player.dart';

import 'models/register_model.dart';
import 'utilities/custom_theme_mode.dart';

String defaultHome = Routes.MainRoute;
bool firstLaunch = false;
String default_qr = RegisterModel.shared.user_id + "/elherafyeen";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await PreferenceUtils.init();
  // await Firebase.initializeApp();
  await RegisterModel.shared.getUserData();
  // Remove this method to stop OneSignal Debugging
  if (!Platform.isWindows) {
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.init("27bd6152-f7e4-491d-a885-11b82fbd99ff", iOSSettings: {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.inAppLaunchUrl: false
    });
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);

    await OneSignal.shared
        .promptUserForPushNotificationPermission(fallbackToSettings: true);
    if (RegisterModel.shared.id != null && RegisterModel.shared.id != "") {
      OneSignal.shared.setExternalUserId(RegisterModel.shared.id);
    }
  }
  runApp(
    EasyLocalization(
        supportedLocales: [
          Locale('ar', 'EG'),
          Locale('ar', 'KW'),
          Locale('en', 'US'),
          Locale('fr', 'FR')
        ],
        path: 'translations',
        startLocale: Locale('ar', 'EG'),
        fallbackLocale: Locale('en', 'US'),
        // saveLocale: true,
        child: Directionality(
          textDirection: m.TextDirection.rtl,
          child: MyApp(),
        )),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  // This widget is the root of your application.
  final Map<String, Widget Function(BuildContext context)> routes = {
    Routes.MainRoute: (context) => MyHomePage(),
    // Routes.MainRoute: (context) => ShippingPage(
    //   staff: false,
    // ),
    // Routes.MainRoute: (context) => AccountType(),
    Routes.LoginRoute: (context) => LoginPage(),
    Routes.AuthenticationRoute: (context) => AuthenticationPage(),
    Routes.HomeRoute: (context) => TabBarPage(
          currentIndex: 0,
        ),
  };

  @override
  Widget build(BuildContext context) {
    return InheritedDataModel(
      child: MaterialApp(
        title: "appName".tr(),
        theme: CustomThemeMode.light(context),
        initialRoute: defaultHome,
        routes: routes,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  VideoPlayerController playerController;
  VoidCallback listener;
  String initialLink = "";
  Uri _latestUri;
  String phone = "";
  StreamSubscription _sub;
  String _latestLink = 'Unknown';

  String _initialLink;
  Uri _initialUri;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    OneSignal.shared.setNotificationOpenedHandler((openedResult) async {
      var additionalData = openedResult.notification.payload.additionalData;
      print("ONE SIGNAL ADDING" + additionalData.toString());

      if (additionalData.toString() != null) {
        try {
          Map json = jsonDecode(additionalData.toString());
          if (json['phone'] != null) {
            Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(
                    builder: (_) =>
                        VendorDetailsPhone(phone: json['phone'].toString())),
                (route) => false);
          }
        } catch (e) {
          Fluttertoast.showToast(
              msg: e.toString(), toastLength: Toast.LENGTH_LONG);
        }
      }
    });
  }

  bool firstLaunch = false;

  prepare() async {
    // final prefs = await SharedPreferences.getInstance();
    // firstLaunch = prefs.getBool("fLaunch") ?? false;
    // if (firstLaunch == null || firstLaunch == false) {
    //   initializeVideo();
    //
    //   playerController.play();
    //   Future.delayed(Duration(seconds: 5), () async {
    //     await RegisterModel.shared.getUserData();
    //     await RegisterModel.shared.getLang();
    //     if (phone != "") {
    //       Navigator.pushAndRemoveUntil(
    //           context,
    //           CupertinoPageRoute(
    //               builder: (_) => VendorDetailsPhone(phone: phone)),
    //           (route) => false);
    //     } else {
    //       print("this our token" + RegisterModel.shared.token.toString());
    //       Navigator.pushReplacement(
    //           context,
    //           CupertinoPageRoute(
    //             builder: (context) => (RegisterModel.shared.token != null &&
    //                     RegisterModel.shared.token != "" &&
    //                     RegisterModel.shared.phone != null &&
    //                     RegisterModel.shared.phone != "")
    //                 ? TabBarPage(currentIndex: 0)
    //                 : LanguagePage(),
    //           ));
    //       prefs.setBool("fLaunch", true);
    //     }
    //   });
    // } else {
    // initializeVideo();

    // playerController.play();
    await RegisterModel.shared.getUserData();
    await RegisterModel.shared.getLang();
    String launchLang = await RegisterModel.shared.getLaunchLang();

    if (phone != "") {
      Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (_) => VendorDetailsPhone(phone: phone)),
          (route) => false);
    } else {
      print("this our token " + RegisterModel.shared.token.toString());
      print('launch lang $launchLang');

      ///  save the language in Shared Preference and not show it more and more
      // var valueLang = PreferenceUtils.getString('${Strings.SPAppLanguage}','');
      // print('$valueLang == valueLang');
      Navigator.pushReplacement(
        context,

        /// beso
        // CupertinoPageRoute(
        //   builder: (context) =>
        //   (RegisterModel.shared.token != null &&
        //           RegisterModel.shared.token != "" &&
        //           RegisterModel.shared.phone != null &&
        //           RegisterModel.shared.phone != ""
        //   )
        //       ? TabBarPage(currentIndex: 0)
        //       : LanguagePage(),
        // ),
        CupertinoPageRoute(
            builder: (context) => launchLang != 'notSelectedBefore'
                ? (RegisterModel.shared.token != null &&
                        RegisterModel.shared.token != "" &&
                        RegisterModel.shared.phone != null &&
                        RegisterModel.shared.phone != "")
                    ? TabBarPage(currentIndex: 0)
                    : AuthenticationPage()
                    // : AccountType()
                : LanguagePage()),
      );
    }
    // }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (!Platform.isWindows) {
      await initPlatformStateForStringUniLinks();

      await initPlatformStateForUriUniLinks();
    }
    prepare();
  }

  /// An implementation using a [String] link
  Future<void> initPlatformStateForStringUniLinks() async {
    // Attach a listener to the links stream
    _sub = getLinksStream().listen((String link) {
      if (!mounted) return;
      setState(() {
        _latestLink = link ?? 'Unknown';
        _latestUri = null;
        try {
          if (link != null) _latestUri = Uri.parse(link);
        } on FormatException {}
      });
    }, onError: (Object err) {
      if (!mounted) return;
      setState(() {
        _latestLink = 'Failed to get latest link: $err.';
        _latestUri = null;
      });
    });

    // Attach a second listener to the stream
    getLinksStream().listen((String link) {
      print('got link: $link');
    }, onError: (Object err) {
      print('got err: $err');
    });

    // Get the latest link
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      _initialLink = await getInitialLink();
      print('initial link: $_initialLink');
      if (_initialLink != null) _initialUri = Uri.parse(_initialLink);
    } on PlatformException {
      _initialLink = 'Failed to get initial link.';
      _initialUri = null;
    } on FormatException {
      _initialLink = 'Failed to parse the initial link as Uri.';
      _initialUri = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _latestLink = _initialLink;
      _latestUri = _initialUri;
      if (_latestUri?.pathSegments?.last != null) {
        print("mahmoud" + _latestUri.pathSegments.last.toString());
        phone = _latestUri.pathSegments.last.toString();
      }
    });
  }

  /// An implementation using the [Uri] convenience helpers
  Future<void> initPlatformStateForUriUniLinks() async {
    // Attach a listener to the Uri links stream
    _sub = getUriLinksStream().listen((Uri uri) {
      if (!mounted) return;
      setState(() {
        _latestUri = uri;
        _latestLink = uri?.toString() ?? 'Unknown';
      });
    }, onError: (Object err) {
      if (!mounted) return;
      setState(() {
        _latestUri = null;
        _latestLink = 'Failed to get latest link: $err.';
      });
    });

    // Attach a second listener to the stream
    getUriLinksStream().listen((Uri uri) {
      print('got uri: ${uri?.path} ${uri?.queryParametersAll}');
    }, onError: (Object err) {
      print('got err: $err');
    });

    // Get the latest Uri
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      _initialUri = await getInitialUri();
      print('initial uri: ${_initialUri?.path}'
          ' ${_initialUri?.queryParametersAll}');
      _initialLink = _initialUri?.toString();
    } on PlatformException {
      _initialUri = null;
      _initialLink = 'Failed to get initial uri.';
    } on FormatException {
      _initialUri = null;
      _initialLink = 'Bad parse the initial link as Uri.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _latestUri = _initialUri;
      _latestLink = _initialLink;
    });
  }

  void initializeVideo() {
    playerController = VideoPlayerController.asset('assets/hhh.mp4');
    playerController.initialize();
    playerController.setVolume(1.0);

    playerController.play();
  }

  @override
  void deactivate() {
    if (playerController != null) {
      playerController.setVolume(0.0);
      playerController.removeListener(listener);
    }
    super.deactivate();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (playerController != null) playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "appName".tr(),
      debugShowCheckedModeBanner: false,
      theme: CustomThemeMode.light(context),
      builder: (context, widget) => ResponsiveWrapper.builder(
          BouncingScrollWrapper.builder(context, widget),
          maxWidth: 1200,
          minWidth: 450,
          defaultScale: true,
          breakpoints: [
            ResponsiveBreakpoint.resize(450, name: MOBILE),
            ResponsiveBreakpoint.autoScale(800, name: TABLET),
            ResponsiveBreakpoint.autoScale(1000, name: TABLET),
            ResponsiveBreakpoint.resize(1200, name: DESKTOP),
            ResponsiveBreakpoint.autoScale(2460, name: "4K"),
          ],
          // landscapeBreakpoints: [
          //   ResponsiveBreakpoint.autoScaleDown(800, name: TABLET),
          // ],
          background: Container(color: Color(0xFFF5F5F5))),
      // localizationsDelegates: context.localizationDelegates,
      // <-- add this
      // supportedLocales: context.supportedLocales, // <-- add this
      // locale: context.locale, // <-- add this
      home: Directionality(
        textDirection: m.TextDirection.ltr,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            child: Center(
              child: Container(
                height: MediaQuery.of(context).size.height * .7,
                width: MediaQuery.of(context).size.width,
                child: (playerController != null &&
                        playerController.value != null
                    ? AspectRatio(
                        aspectRatio: playerController.value.aspectRatio,
                        child: VideoPlayer(
                          playerController,
                        ),
                      )
                    : Container(child: Image.asset("assets/Group 2751.png"))),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
