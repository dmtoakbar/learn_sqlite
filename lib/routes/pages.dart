import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_sqllite/routes/names.dart';
import 'package:learn_sqllite/splash/bloc/splash_bloc.dart';
import 'package:learn_sqllite/splash/splash_screen.dart';
import 'package:flutter/material.dart';

class AppPages {
static List<PageEntity> routes() {
  return  [
    PageEntity(
        route: RouteNames.initial,
        page: const SplashScreen(),
        bloc: BlocProvider(
          create: (_)=>SplashBloc(),
        )
    ),
  ];
}

// bloc
static List<dynamic> allBlocProviders(BuildContext context) {
  List<dynamic> blocProvider = <dynamic>[];
  for(var bloc in routes()) {
    blocProvider.add(bloc.bloc);
  }
  return blocProvider;
}
// routing
static MaterialPageRoute GenerateRouteSettings(RouteSettings settings) {
  if(settings.name != null) {
    var result = routes().where((element) => element.route==settings.name);
    return MaterialPageRoute(builder: (_)=> result.first.page, settings: settings);
  }
  return MaterialPageRoute(builder: (_) => Container(child: Text("Page not Found"),), settings: settings );
}

}

class PageEntity {
  String route;
  Widget page;
  dynamic bloc;
  PageEntity({required this.route, required this.page, required this.bloc});
}