import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('App', () {
    final userFieldFinder = find.byValueKey("userfield");
    final passFieldFinder = find.byValueKey("passfield");
    final loginButtonFinder = find.byValueKey("botaologin");
    final homePageTextFinder = find.byValueKey("boasvindas");
    final logoutButtonFinder = find.byValueKey("logout");

    FlutterDriver? driver;
    driver = null;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    test('inserir login e senha corretos', () async {
      //deve passar
      await driver!.tap(userFieldFinder);
      await driver!.enterText("test@gmail.com");
      await driver!.tap(passFieldFinder);
      await driver!.enterText("test123");
      await driver!.tap(loginButtonFinder);
      await driver!
          .waitFor(homePageTextFinder, timeout: const Duration(seconds: 5));

      expect(await driver!.getText(homePageTextFinder),
          "logado como: test@gmail.com");
      await driver!.tap(logoutButtonFinder);
    });

    // test('inserir login e senha incorretos', () async {
    //   //deve falhar
    //   await driver!.tap(userFieldFinder);
    //   await driver!.enterText("dsadnksal@gmail.com");
    //   await driver!.tap(passFieldFinder);
    //   await driver!.enterText("test123");
    //   await driver!.tap(loginButtonFinder);
    //   await driver!
    //       .waitFor(homePageTextFinder, timeout: const Duration(seconds: 5));

    //   expect(await driver!.getText(homePageTextFinder),
    //       "logado como: test@gmail.com");
    // });

    tearDownAll(() async {
      if (driver != null) {
        driver!.close();
      }
    });
  });
}
