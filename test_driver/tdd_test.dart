import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('App', () {
    FlutterDriver? driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();

      //sleep pra esperar carregar firebase, hive etc
      sleep(const Duration(seconds: 10));
    });

    test('inserir login e senha corretos', () async {
      final userFieldFinder = find.byValueKey("userfield");
      final passFieldFinder = find.byValueKey("passfield");
      final loginButtonFinder = find.byValueKey("botaologin");
      final homePageTextFinder = find.byValueKey("boasvindas");
      await driver!.tap(userFieldFinder);
      await driver!.enterText("test@gmail.com");
      await driver!.tap(passFieldFinder);
      await driver!.enterText("test123");
      await driver!.tap(loginButtonFinder);
      expect(await driver!.getText(homePageTextFinder), "Bem vindo test!");
    });

    test('adicionar pressao', () async {
      //acha o botao de historico de pressao e aperta
      final histPressaoButton = find.byValueKey("histPressaoButton");
      await driver!.tap(histPressaoButton);

      //acha o botao de adicionar pressao e aperta
      final botaoAddPressao = find.byValueKey("botaoAddPressao");
      await driver!.tap(botaoAddPressao);

      //insere valor no campo de pressao do popup e clica em salvar
      final addPressaoField = find.byValueKey("addPressaoField");
      await driver!.tap(addPressaoField);
      await driver!.enterText("9/6");
      final salvarButton = find.byValueKey("salvarButton");
      await driver!.tap(salvarButton);

      // procura a entrada nova na lista
      final newEntryFinder = find.byValueKey("pressaoListText_0");
      expect(await driver!.getText(newEntryFinder), "Pressão: 9/6");

      // voltar pra home
      final appbarButton = find.byValueKey("appbarButton");
      await driver!.tap(appbarButton);
    });

    test('adicionar glicemia', () async {
      //acha o botao de historico de glicemia e aperta
      final histGlicemiaButton = find.byValueKey("histGlicemiaButton");
      await driver!.tap(histGlicemiaButton);

      //acha o botao de adicionar glicemia e aperta
      final botaoAddGlicemia = find.byValueKey("botaoAddGlicemia");
      await driver!.tap(botaoAddGlicemia);

      //insere valor no campo de glicemia do popup e clica em salvar
      final addGlicemiaField = find.byValueKey("addGlicemiaField");
      await driver!.tap(addGlicemiaField);
      await driver!.enterText("83");
      final salvarButton = find.byValueKey("salvarButton");
      await driver!.tap(salvarButton);

      // procura a entrada nova na lista
      final newEntryFinder = find.byValueKey("glicemiaListText_0");
      expect(await driver!.getText(newEntryFinder), "83mg/dL");

      // voltar pra home
      final appbarButton = find.byValueKey("appbarButton");
      await driver!.tap(appbarButton);
    });

    test('adicionar peso', () async {
      //acha o botao de historico de peso e aperta
      final histPesoButton = find.byValueKey("histPesoButton");
      await driver!.tap(histPesoButton);

      //acha o botao de adicionar Peso e aperta
      final botaoAddPeso = find.byValueKey("botaoAddPeso");
      await driver!.tap(botaoAddPeso);

      //insere valor no campo de Peso do popup e clica em salvar
      final addPesoField = find.byValueKey("addPesoField");
      await driver!.tap(addPesoField);
      await driver!.enterText("80");
      final salvarButton = find.byValueKey("salvarButton");
      await driver!.tap(salvarButton);

      // procura a entrada nova na lista
      final newEntryFinder = find.byValueKey("pesoListText_0");
      expect(await driver!.getText(newEntryFinder), "80.0kg");

      // voltar pra home
      final appbarButton = find.byValueKey("appbarButton");
      await driver!.tap(appbarButton);
    });

    tearDownAll(() async {
      if (driver != null) {
        driver!.close();
      }
    });
  });
}
