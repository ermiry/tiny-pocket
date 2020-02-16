import 'package:bloc/bloc.dart';

import 'package:pocket/pages/account.dart';
import 'package:pocket/pages/home/home.dart';
// import 'package:magic/pages/about.dart';
import 'package:pocket/pages/settings.dart';

enum NavigationEvents {
  AccountPageClickedEvent,

  HomePageClickedEvent,
  // AboutPageClickedEvent,
  SettingsPageClickedEvent,
}

abstract class NavigationStates {}

class NavigationBloc extends Bloc <NavigationEvents, NavigationStates> {

  @override
  NavigationStates get initialState => new HomePage();

  @override
  Stream <NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.AccountPageClickedEvent:
        yield AccountPage();
        break;

      case NavigationEvents.HomePageClickedEvent:
        yield HomePage();
        break;
      // case NavigationEvents.AboutPageClickedEvent:
      //   yield AboutPage();
      //   break;
      case NavigationEvents.SettingsPageClickedEvent:
        yield SettingsPage();
        break;
    }
  }

}