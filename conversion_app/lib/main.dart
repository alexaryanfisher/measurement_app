import 'package:flutter/material.dart';

// This is a Flutter application that converts measurements from one unit of measure to another.

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Converter());
  }
}

class Converter extends StatefulWidget {
  @override
  _ConverterState createState() => _ConverterState();
}

class _ConverterState extends State<Converter> {
  @override
  void initState() {
    userInput = 0.0;
    _startMeasurement = 'meters (m)';
    _convertMeasurement = 'kilometers (km)';
    resultMessage = '';
    super.initState();
  }

  // The list of measurements available for conversion
  final List<String> measurements = [
    "meters (m)",
    "kilometers (km)",
    "centimeters (cm)",
    "millimeters (mm)",
    "inches (in)",
    "feet (ft)",
    "yards (yd)",
    "miles (mi)",
  ];

  final Map<String, int> measurementMap = {
    'meters (m)': 0,
    'kilometers (km)': 1,
    'centimeters (cm)': 2,
    'millimeters (mm)': 3,
    'inches (in)': 4,
    'feet (ft)': 5,
    'yards (yd)': 6,
    'miles (mi)': 7,
  };

  // Conversion formulas for each measurement type
  dynamic conversionFormulas = {
    '0': [1, 0.001, 100, 1000, 39.3701, 3.28084, 1.09361, 0.000621371],
    '1': [1000, 1, 100000, 1000000, 39370.1, 3280.84, 1093.61, 0.621371],
    '2': [0.01, 0.00001, 1, 10, 0.393701, 0.0328084, 0.0109361, 0.00000621371],
    '3': [
      0.001,
      0.000001,
      0.1,
      1,
      0.0393701,
      0.00328084,
      0.00109361,
      0.000000621371,
    ],
    '4': [0.0254, 0.0000254, 2.54, 25.4, 1, 0.0833333, 0.0277778, 0.0000157828],
    '5': [0.3048, 0.0003048, 30.48, 304.8, 12, 1, 0.333333, 0.000189394],
    '6': [0.9144, 0.0009144, 91.44, 914.4, 36, 3, 1, 0.000568182],
    '7': [1609.34, 1.60934, 160934, 1609340, 63360, 5280, 1760, 1],
  };

  // Converts the value from one measurement to another.
  void convert(double value, String from, String to) {
    int numFrom = measurementMap[from]!;
    int numTo = measurementMap[to]!;
    var multiplier = conversionFormulas[numFrom.toString()][numTo];
    var result = value * multiplier;

    resultMessage =
        '${userInput.toString()} ${_startMeasurement} is equal to ${result.toString()} ${_convertMeasurement}';

    setState(() {
      resultMessage = resultMessage;
    });
  }

  late double userInput;
  late String _startMeasurement;
  late String _convertMeasurement;
  late String resultMessage;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                "Measurement Conversion",
                style: TextStyle(fontSize: 30, color: Colors.blue),
              ),
              SizedBox(height: 50),
              Text("Value", style: TextStyle(fontSize: 20, color: Colors.grey)),
              SizedBox(height: 30),
              TextField(
                onChanged: (text) {
                  var input = double.tryParse(text);
                  if (input != null && input > 0) {
                    setState(() {
                      userInput = input;
                    });
                  }
                },
                style: TextStyle(
                  fontSize: 20,
                  color: const Color.fromARGB(255, 1, 3, 110),
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  labelText: "Enter value",
                  hintText: "Enter value",
                ),
              ),
              SizedBox(height: 20),
              Text("From", style: TextStyle(fontSize: 20, color: Colors.grey)),
              SizedBox(height: 10),
              DropdownButton(
                value: _startMeasurement,
                isExpanded: true,
                dropdownColor: Colors.white,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                hint: Text('Select measurement'),
                items:
                    measurements.map((String value) {
                      return DropdownMenuItem(value: value, child: Text(value));
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _startMeasurement = value ?? _startMeasurement;
                  });
                },
              ),
              Text("To", style: TextStyle(fontSize: 20, color: Colors.grey)),
              SizedBox(height: 10),
              DropdownButton(
                value: _convertMeasurement,
                isExpanded: true,
                dropdownColor: Colors.white,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                hint: Text('Select measurement'),
                items:
                    measurements.map((String value) {
                      return DropdownMenuItem(value: value, child: Text(value));
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _convertMeasurement = value!;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 100,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_startMeasurement.isEmpty ||
                          _convertMeasurement.isEmpty ||
                          userInput == 0.0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please fill all fields'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        return;
                      } else {
                        convert(
                          userInput,
                          _startMeasurement,
                          _convertMeasurement,
                        );
                      }
                    },
                    child: Text('Convert'),
                  ),
                ),
              ),
              SizedBox(height: 40),
              Text(
                resultMessage,
                style: TextStyle(fontSize: 25, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
