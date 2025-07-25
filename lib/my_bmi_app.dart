import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      home: const MyHomePage(title: 'Your BMI'),
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
  var weightController = TextEditingController();
  var cmController = TextEditingController();

  var result = "";
  var bgColor = Colors.white;
  var errorText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          width: 300,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Text(
                  'BMI',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 50,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  showCursor: true,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                  ],
                  controller: weightController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade300,
                    hintText: 'Enter your weight',
                    suffixText: 'kg',
                    labelText: "Weight",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.line_weight),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  showCursor: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: cmController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade300,
                    hintText: 'Enter height in cm',
                    suffixText: 'cm',
                    labelText: "Height (cm)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.height),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    var wt = weightController.text.toString();
                    var cm = cmController.text.toString();

                    if (wt != "" && cm!="") {
                      try {
                        var iwt = double.parse(wt);
                        var icm = int.parse(cm);

                        var tm = icm / 100;

                        var bmi = iwt / (tm * tm);
                        var msg = "";

                        if (bmi > 25) {
                          msg = 'You Are Overweight';
                          bgColor = Colors.orange.shade300;
                        } else if (bmi < 18) {
                          msg = 'You Are Underweight';
                          bgColor = Colors.red.shade300;
                        } else {
                          msg = 'You Are Healthy';
                          bgColor = Colors.green.shade300;
                        }

                        setState(() {
                          result = '$msg\n BMI = ${bmi.toStringAsFixed(2)} kg/m square ';
                          errorText = "";
                        });
                      } catch (e) {
                        setState(() {
                          errorText = "Please enter valid numbers only.";
                          result = "";
                        });
                      }
                    } else {
                      setState(() {
                        errorText = "Fill all the details.";
                        result = "";
                      });
                    }
                  },
                  child: Text("Calculate"),
                ),
                SizedBox(height: 20),
                if (errorText.isNotEmpty)
                  Text(
                    errorText,
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                if (result.isNotEmpty)
                  Text(
                    result,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 22,
                      color: Colors.black,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
