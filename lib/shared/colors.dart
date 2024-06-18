import 'dart:ui';

const tractianBlue = Color.fromARGB(255, 24, 93, 246);
const tractianBackground = Color.fromARGB(255, 202, 216, 229);

final statusColors = {
  'Em progresso': tractianBackground,
  'Aberta': const Color.fromARGB(0, 12, 255, 12),
};

final priorityColors = {
  'Alta': const Color.fromARGB(52, 255, 0, 0),
  'Média': const Color.fromARGB(52, 255, 255, 0),
  'Baixa': const Color.fromARGB(52, 0, 255, 0),
};
