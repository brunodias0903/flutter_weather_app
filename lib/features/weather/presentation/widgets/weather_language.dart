enum UiLanguage { ptBr, en }

extension UiLanguageX on UiLanguage {
  String get apiLang => this == UiLanguage.ptBr ? 'pt_br' : 'en';

  String get flag => this == UiLanguage.ptBr ? '🇧🇷' : '🇺🇸';

  bool get isPtBr => this == UiLanguage.ptBr;
}
