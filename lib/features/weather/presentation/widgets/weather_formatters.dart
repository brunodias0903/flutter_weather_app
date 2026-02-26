import 'weather_language.dart';

String formatWeatherDate(DateTime date, UiLanguage language) {
  const weekdaysPt = <String>[
    'Segunda',
    'Terca',
    'Quarta',
    'Quinta',
    'Sexta',
    'Sabado',
    'Domingo',
  ];
  const weekdaysEn = <String>[
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  const monthsPt = <String>[
    'janeiro',
    'fevereiro',
    'marco',
    'abril',
    'maio',
    'junho',
    'julho',
    'agosto',
    'setembro',
    'outubro',
    'novembro',
    'dezembro',
  ];
  const monthsEn = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  if (language.isPtBr) {
    return '${weekdaysPt[date.weekday - 1]}, ${date.day} de ${monthsPt[date.month - 1]}';
  }

  return '${weekdaysEn[date.weekday - 1]}, ${date.day} ${monthsEn[date.month - 1]}';
}

String? capitalize(String? value) {
  if (value == null || value.isEmpty) return null;
  return '${value[0].toUpperCase()}${value.substring(1)}';
}

String formatUpdatedAt(DateTime updatedAt, UiLanguage language) {
  final localDate = updatedAt.toLocal();
  final hour = localDate.hour.toString().padLeft(2, '0');
  final minute = localDate.minute.toString().padLeft(2, '0');
  final prefix = language.isPtBr ? 'Atualizado' : 'Updated';
  return '$prefix: $hour:$minute';
}
