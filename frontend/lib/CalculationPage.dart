import 'package:flutter/material.dart';
import 'RESTService.dart';
import 'calculation_data.dart';

class CalculationPage extends StatefulWidget {
  const CalculationPage({Key? key}) : super(key: key);

  @override
  _CalculationPageState createState() => _CalculationPageState();
}

class _CalculationPageState extends State<CalculationPage> {
  TextEditingController illuminanceController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  List<CalculationData> calculationDataList = [];
  bool isLoading = false;

  void sendDataToBackend() async {
    setState(() {
      isLoading = true;
      calculationDataList.clear();
    });

    bool success = await RESTService.sendData(
        illuminanceController.text, areaController.text);

    if (success) {
      try {
        CalculationData data = await RESTService.getCalculationResult();
        setState(() {
          calculationDataList.clear();
          calculationDataList.add(data);
          isLoading = false;
        });
      } catch (error) {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    illuminanceController.dispose();
    areaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('촬영값 도출'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              '조도',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: illuminanceController,
              decoration: const InputDecoration(
                hintText: 'Enter illuminance',
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              '촬영 면적',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: areaController,
              decoration: const InputDecoration(
                hintText: 'Enter area',
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: sendDataToBackend,
              child: const Text('done'),
            ),
            const SizedBox(height: 40),
            const Text(
              '촬영 조건:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            isLoading
                ? const CircularProgressIndicator() // Display a loading indicator while waiting for the result
                : Expanded(
                    child: ListView.builder(
                      itemCount: calculationDataList.length,
                      itemBuilder: (context, index) {
                        CalculationData data = calculationDataList[index];
                        return ListTile(
                          title: Text(
                            data.name,
                            style: const TextStyle(fontSize: 16),
                          ),
                          subtitle: Text(
                            data.value,
                            style: const TextStyle(fontSize: 18),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
