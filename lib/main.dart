import 'dart:async';
import 'dart:js' as js;

import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

import '/api/comment.dart';
import '/generated/fonts.dart';
import '/generated/logo.dart';
import 'models/Comments.dart';
import 'models/Product.dart';

enum AppTheme { light, dark }

const _DESTINATION_HOME = "home";
const _DESTINATION_PRODUCTS = "products";
const _DESTINATION_BLOG = "blog";

late StreamController<bool> lightThemeControl;
late AppTheme appTheme;
late TextDirection appDirection;
late String titleImage;
late Color titleColor;
late int currentNavIndex;
late bool isFirstRun;

void init() {
  isFirstRun = true;
  lightThemeControl = StreamController();
  appDirection = TextDirection.ltr;
  titleImage = Logos.saltechEnLogo;
  appTheme = AppTheme.light;
  titleColor = Colors.black87;
  currentNavIndex = 0;
}

void main(List<String> args) async {
  usePathUrlStrategy();
  init();
  var delegate = await LocalizationDelegate.create(
      fallbackLocale: 'en_US', supportedLocales: ['en_US', 'fa_IR']);
  runApp(LocalizedApp(delegate, MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final lightTheme = ThemeData.light(useMaterial3: true).copyWith(
      colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.lightBlue, brightness: Brightness.light),
    );
    final darkTheme = ThemeData.dark(useMaterial3: true).copyWith(
      colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.lightBlue, brightness: Brightness.dark),
    );

    var localizationDelegate = LocalizedApp.of(context).delegate;

    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: ChangeNotifierProvider(
        create: (BuildContext context) => AppState(),
        child: StreamBuilder<bool>(
          initialData: true,
          stream: lightThemeControl.stream,
          builder: (context, snapshot) {
            return MaterialApp(
              title: translate("title.name"),
              theme: snapshot.data == true ? lightTheme : darkTheme,
              debugShowCheckedModeBanner: false,
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                localizationDelegate
              ],
              supportedLocales: localizationDelegate.supportedLocales,
              locale: localizationDelegate.currentLocale,
              home: HomePage(),
            );
          },
        ),
      ),
    );
  }
}

class AppState extends ChangeNotifier {
  void changeLang(BuildContext context, {TextDirection? direction}) {
    if (appDirection == TextDirection.rtl || direction == TextDirection.ltr) {
      titleImage = Logos.saltechEnLogo;
      appDirection = TextDirection.ltr;
      changeLocale(context, "en_US");
    } else {
      titleImage = Logos.saltechFaLogo;
      appDirection = TextDirection.rtl;
      changeLocale(context, "fa_IR");
    }
    notifyListeners();
  }

  void changeTheme(ThemeData theme, {AppTheme? sysTheme}) {
    appTheme = sysTheme ?? appTheme;
    if (appTheme == AppTheme.light) {
      titleColor = Colors.lightBlue[50]!;
      appTheme = AppTheme.dark;
    } else {
      titleColor = Colors.black87;
      appTheme = AppTheme.light;
    }
    lightThemeControl.add(appTheme == AppTheme.light);
    notifyListeners();
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var systemTheme = MediaQuery.of(context).platformBrightness;
    SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(
      label: translate("title.name"),
      primaryColor: Theme.of(context).primaryColor.value,
    ));

    try {
      if (isFirstRun) {
        if (getCurrentLang() == "fa_IR") {
          appState.changeLang(context, direction: TextDirection.rtl);
        } else {
          appState.changeLang(context, direction: TextDirection.ltr);
        }
        appState.changeTheme(
          Theme.of(context),
          sysTheme:
              systemTheme == Brightness.dark ? AppTheme.light : AppTheme.dark,
        );
        isFirstRun = false;
      }
    } catch (e) {
      print("An Error Occurred!");
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return MobileEdition();
        } else if (constraints.maxWidth > 600 && constraints.maxWidth < 840) {
          return TabletEdition();
        } else {
          return DesktopEdition();
        }
      },
    );
  }
}

String getCurrentLang() {
  return js.JsObject.fromBrowserObject(js.context['state'])['lang'];
}

class DesktopEdition extends StatefulWidget {
  const DesktopEdition({super.key});

  @override
  State<DesktopEdition> createState() => _DesktopEditionState();
}

class _DesktopEditionState extends State<DesktopEdition> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    final theme = Theme.of(context);

    return Directionality(
      textDirection: appDirection,
      child: Scaffold(
        appBar: getAppBar(appState, theme),
        body: Row(
          children: [
            NavigationRail(
              labelType: NavigationRailLabelType.selected,
              destinations: [
                getNavDestination(
                    theme, Symbols.home_rounded, _DESTINATION_HOME,
                    isNavRail: true),
                getNavDestination(
                    theme, Symbols.storefront_rounded, _DESTINATION_PRODUCTS,
                    isNavRail: true),
                getNavDestination(
                    theme, Symbols.history_edu_rounded, _DESTINATION_BLOG,
                    isNavRail: true, iconSize: 25),
              ],
              selectedIndex: currentNavIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  currentNavIndex = index;
                });
              },
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: getContainerEdgeRadius(),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: buildBody(context),
                      // child: Center(
                      //   child: MaterialText(
                      //     "body.demo",
                      //     textStyle: theme.textTheme.displayMedium,
                      //     fontWeight: FontWeight.w900,
                      //     textColor: theme.colorScheme.primary,
                      //   ),
                      // ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  FutureBuilder<Comments> buildBody(BuildContext context) {
    final client =
        CommentsApi(Dio(BaseOptions(contentType: "application/json")));
    return FutureBuilder<Comments>(
      future: client.getComments("3b8b3581b1e0", Product(id: 9342)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final Comments comments = snapshot.data!;
          return ListView(
            children: [
              for (final comment in comments.results!)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListTile(
                    title: Text(
                      """{
                            "id": ${comment.id},
                            "likes": ${comment.likes},
                            "dislikes": ${comment.dislikes},
                            "text": ${comment.text},
                            "rank": ${comment.rate},
                      }""",
                    ),
                  ),
                )
            ],
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  getAppBar(AppState appState, ThemeData theme) {
    return AppBar(
      title: SalTechLogo(),
      actions: [
        SizedBox(width: 3),
        AnimatedIconButton(
          size: 24,
          onPressed: () {
            setState(() {
              appState.changeLang(context);
            });
          },
          duration: const Duration(milliseconds: 1),
          icons: [
            AnimatedIconItem(icon: Icon(Symbols.language_rounded)),
          ],
        ),
        ThemeButton(),
        SizedBox(width: 8),
      ],
    );
  }

  BorderRadius getContainerEdgeRadius() => appDirection == TextDirection.ltr
      ? BorderRadius.only(topLeft: Radius.circular(8))
      : BorderRadius.only(topRight: Radius.circular(8));
}

class TabletEdition extends StatefulWidget {
  const TabletEdition({super.key});

  @override
  State<TabletEdition> createState() => _TabletEditionState();
}

class _TabletEditionState extends State<TabletEdition> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    final theme = Theme.of(context);

    return Directionality(
      textDirection: appDirection,
      child: Scaffold(
        appBar: getAppBar(appState, theme),
        body: Center(
          child: MaterialText("body.demo",
              textStyle: theme.textTheme.displayMedium),
        ),
        drawer: NavigationDrawer(
          selectedIndex: currentNavIndex,
          tilePadding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
          onDestinationSelected: (index) {
            setState(() {
              currentNavIndex = index;
            });
          },
          children: <Widget>[
            SizedBox(height: 16),
            getNavDestination(theme, Symbols.home_rounded, _DESTINATION_HOME),
            getNavDestination(
                theme, Symbols.storefront_rounded, _DESTINATION_PRODUCTS),
            getNavDestination(
                theme, Symbols.history_edu_rounded, _DESTINATION_BLOG),
          ],
        ),
      ),
    );
  }

  getAppBar(AppState appState, ThemeData theme) {
    return AppBar(
      title: SalTechLogo(),
      leading: Builder(builder: (context) {
        return AnimatedIconButton(
          size: 24,
          duration: const Duration(milliseconds: 1),
          onPressed: () => Scaffold.of(context).openDrawer(),
          icons: [
            AnimatedIconItem(icon: Icon(Symbols.menu_rounded)),
          ],
        );
      }),
      actions: [
        Row(
          children: [
            SizedBox(width: 8),
            AnimatedIconButton(
              size: 24,
              onPressed: () {
                setState(() {
                  appState.changeLang(context);
                });
              },
              duration: const Duration(milliseconds: 1),
              icons: [
                AnimatedIconItem(icon: Icon(Symbols.language_rounded)),
              ],
            ),
            ThemeButton(),
            SizedBox(width: 8),
          ],
        ),
      ],
    );
  }
}

class MobileEdition extends StatefulWidget {
  const MobileEdition({super.key});

  @override
  State<MobileEdition> createState() => _MobileEditionState();
}

class _MobileEditionState extends State<MobileEdition> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    final theme = Theme.of(context);

    return Directionality(
      textDirection: appDirection,
      child: Scaffold(
        appBar: getAppBar(appState, theme),
        body: Center(
          child: MaterialText("body.demo",
              textStyle: theme.textTheme.displayMedium),
        ),
        drawer: NavigationDrawer(
          selectedIndex: currentNavIndex,
          tilePadding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
          onDestinationSelected: (index) {
            setState(() {
              currentNavIndex = index;
            });
          },
          children: <Widget>[
            SizedBox(height: 16),
            getNavDestination(theme, Symbols.home_rounded, _DESTINATION_HOME),
            getNavDestination(
                theme, Symbols.storefront_rounded, _DESTINATION_PRODUCTS),
            getNavDestination(
                theme, Symbols.history_edu_rounded, _DESTINATION_BLOG),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 8),
                AnimatedIconButton(
                  size: 24,
                  onPressed: () {
                    setState(() {
                      appState.changeLang(context);
                    });
                  },
                  duration: const Duration(milliseconds: 1),
                  icons: [
                    AnimatedIconItem(icon: Icon(Symbols.language_rounded)),
                  ],
                ),
                ThemeButton(),
                SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }

  getAppBar(AppState appState, ThemeData theme) {
    return AppBar(
      title: SalTechLogo(),
      leading: Builder(builder: (context) {
        return AnimatedIconButton(
          size: 24,
          duration: const Duration(milliseconds: 1),
          onPressed: () => Scaffold.of(context).openDrawer(),
          icons: [
            AnimatedIconItem(icon: Icon(Symbols.menu_rounded)),
          ],
        );
      }),
    );
  }
}

/// A Customization for Navigation Destinations
getNavDestination(ThemeData theme, IconData symbol, String destinationName,
    {bool isNavRail = false, double iconSize = 24}) {
  if (isNavRail) {
    return NavigationRailDestination(
      icon: Icon(symbol,
          fill: 0, weight: 400, grade: 200, opticalSize: 48, size: iconSize),
      selectedIcon: Icon(
        symbol,
        fill: 1,
        weight: 400,
        grade: 200,
        opticalSize: 48,
        size: iconSize + 1.25,
      ),
      label: MaterialText("navigation.$destinationName",
          textStyle: theme.textTheme.labelMedium),
    );
  } else {
    return NavigationDrawerDestination(
      icon: Icon(
        symbol,
        fill: 0,
        weight: 400,
        grade: 200,
        opticalSize: 48,
        size: 24,
      ),
      selectedIcon: Icon(
        symbol,
        fill: 1,
        weight: 400,
        grade: 200,
        opticalSize: 48,
        size: 25.25,
      ),
      label: MaterialText("navigation.$destinationName",
          textStyle: theme.textTheme.labelMedium),
    );
  }
}

class MaterialText extends StatelessWidget {
  const MaterialText(
    this.text, {
    super.key,
    required this.textStyle,
    this.textColor,
    this.fontWeight = FontWeight.w500,
    this.fontStyle = FontStyle.normal,
    this.isCode = false,
  });

  final String text;
  final TextStyle? textStyle;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final Color? textColor;
  final bool isCode;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Text(
      translate(text),
      style: (isCode
              ? Fonts.getCodeStyle(textStyle ?? theme.textTheme.displayMedium,
                  fontWeight: fontWeight, fontStyle: fontStyle)
              : Fonts.getTextStyle(appDirection,
                  textStyle ?? Theme.of(context).textTheme.displayMedium,
                  fontWeight: fontWeight, fontStyle: fontStyle))
          ?.copyWith(color: textColor),
    );
  }
}

class ThemeButton extends StatefulWidget {
  const ThemeButton({super.key});

  @override
  State<ThemeButton> createState() => _ThemeButtonState();
}

class _ThemeButtonState extends State<ThemeButton> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return AnimatedIconButton(
      size: 24,
      duration: const Duration(milliseconds: 400),
      onPressed: () {
        setState(() {
          appState.changeTheme(Theme.of(context));
        });
      },
      icons: appTheme == AppTheme.light
          ? [
              AnimatedIconItem(icon: Icon(Symbols.dark_mode_rounded, fill: 1)),
            ]
          : [
              AnimatedIconItem(icon: Icon(Symbols.light_mode_rounded, fill: 1)),
            ],
    );
  }
}

class SalTechLogo extends StatelessWidget {
  const SalTechLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 600) {
          return Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.string(Logos.saltechLogo,
                    height: 30,
                    colorFilter: ColorFilter.mode(titleColor, BlendMode.srcIn)),
              ),
              SizedBox(
                width: 2,
              ),
              SvgPicture.string(titleImage,
                  height: 16,
                  colorFilter: ColorFilter.mode(titleColor, BlendMode.srcIn)),
            ],
          );
        } else {
          return Row(
            children: [
              SvgPicture.string(Logos.saltechLogo,
                  height: 30,
                  colorFilter: ColorFilter.mode(titleColor, BlendMode.srcIn)),
              SizedBox(width: 10),
              SvgPicture.string(titleImage,
                  height: 16,
                  colorFilter: ColorFilter.mode(titleColor, BlendMode.srcIn)),
            ],
          );
        }
      },
    );
  }
}
