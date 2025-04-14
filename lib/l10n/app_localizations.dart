import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static final FlutterLocalization localization = FlutterLocalization(
    delegates: [
      LocalizationDelegate(
        [
          Locale('en'),
          Locale('es'),
        ],
        assetBase: 'assets/i18n', //  Ruta a tus archivos de traducción
        fallback: Locale('en'),
        translations: [
          const En(),
          const Es(),
        ],
      ),
    ],
  );

  String translate(String key) {
    return Intl.message(
      _localizedValues[key] ?? '** $key not found',
      name: key,
      locale: locale.toString(),
      desc: 'The value for $key',
    );
  }

  static final Map<String, String> _localizedValues = {
    'title': 'Título',
    'habits': 'Hábitos',
    'glucosa': 'Glucosa',
    'configuracion': 'Configuración',
    //  ...  Añade más traducciones aquí
  };
}

class En extends Translations {
  const En();

  @override
  Map<String, dynamic> get keys => {
        'title': 'Title',
        'habits': 'Habits',
        'glucosa': 'Glucose',
        'configuracion': 'Settings',
      };
}

class Es extends Translations {
  const Es();

  @override
  Map<String, dynamic> get keys => {
        'title': 'Título',
        'habits': 'Hábitos',
        'glucosa': 'Glucosa',
        'configuracion': 'Configuración',
      };
}
