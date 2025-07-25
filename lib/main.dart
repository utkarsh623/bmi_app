import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'splashscreen.dart';

// The main entry point of the app
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BMI Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const SplashScreen(),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  final List<String> weightUnits = ['kg', 'gram', 'lbs', 'pound'];
  final List<String> heightUnits = ['cm', 'm', 'feet'];

  String selectedWeightUnit = 'kg';
  String selectedHeightUnit = 'cm';

  double _bmi = 0.0;
  String result = '';
  String errorText = '';
  Color bgColor = Colors.white;
  Color meterColor = Colors.transparent;

  double convertWeightToKg(double weight, String unit) {
    switch (unit) {
      case 'kg':
        return weight;
      case 'gram':
        return weight / 1000;
      case 'lbs':
      case 'pound':
        return weight * 0.453592;
      default:
        return weight;
    }
  }

  double convertHeightToMeters(double height, String unit) {
    switch (unit) {
      case 'cm':
        return height / 100;
      case 'm':
        return height;
      case 'feet':
        return height * 0.3048;
      default:
        return height;
    }
  }

  double getNormalizedBMIValue(double bmi) {
    return (bmi.clamp(0, 40)) / 40;
  }

  void calculateBMI() {
    final wtText = weightController.text.trim();
    final htText = heightController.text.trim();

    if (wtText.isEmpty || htText.isEmpty) {
      setState(() {
        errorText = "Fill all the details.";
        result = "";
        _bmi = 0.0;
        meterColor = Colors.transparent;
      });
      return;
    }

    try {
      double weight = double.parse(wtText);
      double height = double.parse(htText);

      weight = convertWeightToKg(weight, selectedWeightUnit);
      height = convertHeightToMeters(height, selectedHeightUnit);

      final bmi = weight / (height * height);
      String msg = "";

      if (bmi > 25) {
        msg = 'You Are Overweight';
        bgColor = Colors.orange.shade200;
        meterColor = Colors.orange;
      } else if (bmi < 18) {
        msg = 'You Are Underweight';
        bgColor = Colors.red.shade200;
        meterColor = Colors.red;
      } else {
        msg = 'You Are Healthy';
        bgColor = Colors.green.shade200;
        meterColor = Colors.green;
      }

      setState(() {
        _bmi = bmi;
        result = '$msg\nBMI = ${bmi.toStringAsFixed(2)} kg/m²';
        errorText = "";
      });
    } catch (e) {
      setState(() {
        errorText = "Please enter valid numbers only.";
        result = "";
        _bmi = 0.0;
        meterColor = Colors.transparent;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'BMI',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 50,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 20),

                // Weight Field with Dropdown
                _buildInputField(
                  controller: weightController,
                  label: "Weight",
                  icon: Icons.line_weight,
                  units: weightUnits,
                  selectedUnit: selectedWeightUnit,
                  onChangedUnit: (value) {
                    setState(() => selectedWeightUnit = value!);
                  },
                ),
                const SizedBox(height: 18),

                // Height Field with Dropdown
                _buildInputField(
                  controller: heightController,
                  label: "Height",
                  icon: Icons.height,
                  units: heightUnits,
                  selectedUnit: selectedHeightUnit,
                  onChangedUnit: (value) {
                    setState(() => selectedHeightUnit = value!);
                  },
                ),
                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.calculate),
                    label: const Text(
                      "Calculate BMI",
                      style: TextStyle(fontSize: 19),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: calculateBMI,
                  ),
                ),
                const SizedBox(height: 28),

                if (errorText.isNotEmpty) ...[
                  Text(
                    errorText,
                    style: const TextStyle(fontSize: 18, color: Colors.redAccent),
                  ),
                  const SizedBox(height: 12),
                ],
                if (result.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.blueAccent, width: 1.5),
                    ),
                    child: Text(
                      result,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 21,
                        color: meterColor,
                      ),
                    ),
                  ),

                if (_bmi > 0)
                  Column(
                    children: [
                      const Text(
                        "Visual BMI Meter",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: TweenAnimationBuilder<double>(
                          tween: Tween<double>(
                              begin: 0,
                              end: getNormalizedBMIValue(_bmi)),
                          duration: const Duration(milliseconds: 800),
                          builder: (context, value, child) => LinearProgressIndicator(
                            value: value,
                            minHeight: 22,
                            color: meterColor,
                            backgroundColor: Colors.white60,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required List<String> units,
    required String selectedUnit,
    required void Function(String?) onChangedUnit,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
      ],
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.blue),
        filled: true,
        fillColor: Colors.grey.shade200.withOpacity(0.7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),
        prefixIcon: Icon(icon, color: Colors.blue),
        suffixIcon: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedUnit,
            items: units.map((String unit) {
              return DropdownMenuItem<String>(
                value: unit,
                child: Text(unit),
              );
            }).toList(),
            onChanged: onChangedUnit,
          ),
        ),
      ),
      style: const TextStyle(fontSize: 17),
    );
  }
}
