

String translate(String weather) {
  switch (weather) {
    case 'Rain': return 'дождь';
  }
  return weather;
}

const Map<int, String> weekdays = {
  1: 'Понедельник',
  2: 'Вторник',
  3: 'Среда',
  4: 'Четверг',
  5: 'Пятница',
  6: 'Суббота',
  7: 'Воскресенье',
};

const Map<int, String> weekdaysShort = {
  1: 'пн.',
  2: 'вт.',
  3: 'ср.',
  4: 'чт.',
  5: 'пт.',
  6: 'сб.',
  7: 'вс.',
};

