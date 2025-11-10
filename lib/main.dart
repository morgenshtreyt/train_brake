import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(TrainBrakeApp());
}

class TrainBrakeApp extends StatelessWidget {
  const TrainBrakeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Железнодорожные калькуляторы',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MainMenu(),
    );
  }
}

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Железнодорожные калькуляторы")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TrainBrakeCalculator(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                textStyle: TextStyle(fontSize: 18),
              ),
              child: Text("Закрепление состава"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecuperationCalculator(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                textStyle: TextStyle(fontSize: 18),
              ),
              child: Text("Расчет рекуперации"),
            ),
          ],
        ),
      ),
    );
  }
}

class TrainBrakeCalculator extends StatefulWidget {
  const TrainBrakeCalculator({super.key});

  @override
  _TrainBrakeCalculatorState createState() => _TrainBrakeCalculatorState();
}

class _TrainBrakeCalculatorState extends State<TrainBrakeCalculator> {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController shoesController = TextEditingController();

  double? slope;
  bool? loaded;
  String result = "";

  void calculate() {
    try {
      double weight = double.parse(weightController.text);
      int shoes = int.parse(shoesController.text);

      if (slope == null || loaded == null) {
        setState(() {
          result = "Выберите уклон и тип поезда!";
        });
        return;
      }

      double tbCoef = 0;
      double toCoef = 0;

      if (slope == 0.006) {
        tbCoef = loaded! ? 0.6 : 1.0;
        toCoef = 1.0;
      } else if (slope == 0.012) {
        tbCoef = loaded! ? 0.6 : 1.0;
        toCoef = 1.0;
      } else if (slope == 0.018) {
        tbCoef = loaded! ? 1.0 : 1.6;
        toCoef = loaded! ? 1.6 : 1.6;
      }

      int tbNeeded = (weight * tbCoef / 100).ceil();
      double weightFixed = shoes * 100 / tbCoef;
      double remainingWeight = max(0, weight - weightFixed);

      String res = "Требуется башмаков: $tbNeeded\n";
      if (remainingWeight > 0) {
        int toNeeded = (remainingWeight * toCoef / 100).ceil();
        int rtNoSplit = (toNeeded / 4).ceil();
        int rtSplit = (toNeeded / 2).ceil();
        res +=
            "Вагонов без раздельного торможения: $rtNoSplit\n"
            "Вагонов с раздельным торможением: $rtSplit";
      } else {
        res += "Имеющегося количества башмаков достаточно.";
      }

      setState(() {
        result = res;
      });
    } catch (e) {
      setState(() {
        result = "Ошибка: проверьте ввод данных!";
      });
    }
  }

  Widget buildSlopeButton(double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: slope == value ? Colors.black : Colors.white,
          foregroundColor: slope == value ? Colors.white : Colors.black,
          side: BorderSide(color: Colors.black),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
        onPressed: () => setState(() => slope = value),
        child: Text("$value‰"),
      ),
    );
  }

  Widget buildLoadButton(bool isLoaded) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: loaded == isLoaded ? Colors.black : Colors.white,
          foregroundColor: loaded == isLoaded ? Colors.white : Colors.black,
          side: BorderSide(color: Colors.black),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        onPressed: () => setState(() => loaded = isLoaded),
        child: Text(isLoaded ? "Груженный" : "Порожний"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Калькулятор закрепления поезда"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: weightController,
                decoration: InputDecoration(labelText: "Вес поезда (т)"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: shoesController,
                decoration: InputDecoration(
                  labelText: "Башмаков на локомотиве",
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              Text("Выберите уклон:"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildSlopeButton(0.006),
                  buildSlopeButton(0.012),
                  buildSlopeButton(0.018),
                ],
              ),
              SizedBox(height: 16),
              Text("Тип поезда:"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [buildLoadButton(true), buildLoadButton(false)],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  side: BorderSide(color: Colors.black),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                onPressed: calculate,
                child: Text("Рассчитать"),
              ),
              SizedBox(height: 16),
              Text(result, style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}

class RecuperationCalculator extends StatefulWidget {
  const RecuperationCalculator({super.key});

  @override
  _RecuperationCalculatorState createState() => _RecuperationCalculatorState();
}

class _RecuperationCalculatorState extends State<RecuperationCalculator> {
  final TextEditingController urController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  String? startStation;
  String? endStation;
  String result = "";

  final Map<String, double> distances = {
    'Московка-Ишим': 291.4,
    'Входная-Ишим': 271.1,
    'Московка-Барабинская': 316.0,
    'Входная-Барабинская': 340.0,
    'Московка-Иртышское': 179.0,
    'Входная-Иртышское': 164.0,
    'Омск-пасс-Ишим': 280.0,
    'Карбышево-1-Ишим': 260.0,
    'Омск-пасс-Барабинская': 305.0,
    'Карбышево-1-Барабинская': 330.0,
    'Омск-пасс-Иртышское': 168.0,
    'Карбышево-1-Иртышское': 154.0,
  };

  final List<String> stations = [
    "Входная",
    "Московка",
    "Омск-пасс",
    "Карбышево-1",
    "Иртышское",
    "Ишим",
    "Барабинская",
  ];

  // Функция для преобразования запятой в точку
  double parseNumber(String text) {
    // Заменяем запятую на точку и убираем лишние символы
    String normalized = text
        .replaceAll(',', '.')
        .replaceAll(RegExp(r'[^0-9.]'), '');
    return double.parse(normalized);
  }

  void calculateRecuperation() {
    try {
      // Используем функцию преобразования вместо прямого double.parse
      double ur = parseNumber(urController.text);
      double weight = parseNumber(weightController.text);

      if (startStation == null || endStation == null) {
        setState(() {
          result = "Выберите станции отправления и прибытия!";
        });
        return;
      }

      if (startStation == endStation) {
        setState(() {
          result = "Станции отправления и прибытия не должны совпадать!";
        });
        return;
      }

      String routeKey = '$startStation-$endStation';
      String reverseKey = '$endStation-$startStation';

      double distance = distances[routeKey] ?? distances[reverseKey] ?? 0.0;

      if (distance == 0.0) {
        setState(() {
          result = "Расстояние для выбранного маршрута не найдено";
        });
        return;
      }

      // Удваиваем УР для станции Ишим
      double actualUr = (endStation == "Ишим") ? ur * 2 : ur;

      double ep = (actualUr * (weight * distance)) / 10000;
      double units = ep / 100; // перевод в единицы (1 ед. = 100 кВтч)

      setState(() {
        result =
            "Маршрут: $startStation → $endStation\n"
            "Расстояние: ${distance.toStringAsFixed(1)} км\n"
            "Удельная рекуперация: ${actualUr.toStringAsFixed(1)} кВтч/ткмбр\n"
            "Минимальный объем возврата: ${ep.toStringAsFixed(1)} кВтч (${units.toStringAsFixed(1)} ед.)";
      });
    } catch (e) {
      setState(() {
        result =
            "Ошибка: проверьте ввод данных! Используйте точку или запятую для десятичных чисел.";
      });
    }
  }

  List<String> getAvailableEndStations() {
    if (startStation == null) return stations;
    return stations.where((station) => station != startStation).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Расчет рекуперации"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: urController,
                decoration: InputDecoration(
                  labelText: "УР, кВтч/ткмбр",
                  hintText: "Введите плановый уровень (например: 2.7 или 2,7)",
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                // Добавляем подсказку в плейсхолдер
              ),
              SizedBox(height: 16),
              TextField(
                controller: weightController,
                decoration: InputDecoration(
                  labelText: "Вес поезда (т)",
                  hintText: "Введите вес поезда",
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 16),
              Text("Станция отправления:"),
              DropdownButtonFormField<String>(
                value: startStation,
                items: stations.map((station) {
                  return DropdownMenuItem(value: station, child: Text(station));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    startStation = value;
                    endStation = null;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Выберите станцию",
                ),
              ),
              SizedBox(height: 16),
              Text("Станция прибытия:"),
              DropdownButtonFormField<String>(
                value: endStation,
                items: getAvailableEndStations().map((station) {
                  return DropdownMenuItem(value: station, child: Text(station));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    endStation = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Выберите станцию",
                ),
              ),

              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  side: BorderSide(color: Colors.black),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: calculateRecuperation,
                child: Text("Рассчитать рекуперацию"),
              ),
              SizedBox(height: 16),
              Text(result, style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
