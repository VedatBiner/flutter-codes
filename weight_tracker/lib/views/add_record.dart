import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';

class AddRecordView extends StatefulWidget {
  const AddRecordView({Key? key}) : super(key: key);
  @override
  State<AddRecordView> createState() => _AddRecordViewState();
}

class _AddRecordViewState extends State<AddRecordView> {
  int _selectedValue = 70;
  DateTime _selectedDate = DateTime.now();

  void pickDate(BuildContext context) async {
    // date picker göster
    var initialDate = DateTime.now();
    _selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      // bir yıl öncesi
      firstDate: initialDate.subtract(const Duration(days:365 )),
      // bir ay sonrası
      lastDate: initialDate.add(const Duration(days:30)),
      builder: (context, child){
        // tema mavi kalsın bazı kısımlarını değiştirelim.
        return Theme(data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Colors.black,
            onPrimary: Colors.white,
            secondary: Colors.yellowAccent,
            onSecondary: Colors.blue,
            error: Colors.red,
            onError: Colors.redAccent,
            background: Colors.blueAccent,
            onBackground: Colors.green,
            surface: Colors.blue,
            onSurface: Colors.black26,
          ),
        ), child: child??const Text(""));
      }
    ) ?? _selectedDate; // null ise _selectedDate i seç
    // setstate çağır
    // sadece güncelleme için boş  çalıştırıyoruz
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add New Record",
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Weight Card
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    FontAwesomeIcons.weightScale,
                    size: 40,
                  ),
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      NumberPicker(
                        itemCount: 5,
                        itemWidth: 50,
                        itemHeight: 60,
                        step: 1,
                        axis: Axis.horizontal,
                        minValue: 40,
                        maxValue: 130,
                        value: _selectedValue,
                        onChanged: (value) {
                          setState(() {
                            _selectedValue = value;
                          });
                        },
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Icon(
                        FontAwesomeIcons.chevronUp,
                        size: 16,
                        color: Colors.red.shade800,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          // Date Picker Card
          GestureDetector(
            onTap: (){
              pickDate(context);
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      FontAwesomeIcons.calendar,
                      size: 40,
                    ),
                    Expanded(
                      child: Text(
                        DateFormat("EEE, MMM d").format(_selectedDate),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text("Note Card"),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text("Save Record"),
          ),
        ],
      ),
    );
  }
}
