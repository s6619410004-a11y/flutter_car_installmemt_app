import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CarInstallmentUi extends StatefulWidget {
  const CarInstallmentUi({super.key});

  @override
  State<CarInstallmentUi> createState() => _CarInstallmentUiState();
}

class _CarInstallmentUiState extends State<CarInstallmentUi> {
  int downPayment = 10;
  String month = '24 เดือน';

  TextEditingController cCtrl = TextEditingController();
  TextEditingController interestCtrl = TextEditingController();

  double result = 0.00;

  int getMonthValue() {
    return int.parse(month.split(' ')[0]);
  }

  void calculate() {
    if (cCtrl.text.isEmpty || interestCtrl.text.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("แจ้งเตือน"),
          content: Text("กรุณากรอกราคารถและอัตราดอกเบี้ย"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("ตกลง"),
            )
          ],
        ),
      );
      return;
    }

    double price = double.parse(cCtrl.text);
    double interest = double.parse(interestCtrl.text);
    int m = getMonthValue();

    /// สูตรตามโจทย์ (สำคัญ!)
    double loan = price - (price * downPayment / 100);
    double totalInterest = (loan * interest / 100) * (m / 12);
    double monthly = (loan + totalInterest) / m;

    setState(() {
      result = monthly;
    });
  }

  void reset() {
    setState(() {
      cCtrl.clear();
      interestCtrl.clear();
      downPayment = 10;
      month = '24 เดือน';
      result = 0.00;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'CI Calculator',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 20),

              Text(
                'คำนวณค่างวดรถยนต์',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 20),

              Image.network(
                'https://file.chobrod.com/2021/02/03/iO9DezGG/--5af0.jpeg',
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.height * 0.2,
              ),

              SizedBox(height: 20),

              /// ราคารถ
              Align(
                alignment: Alignment.centerLeft,
                child: Text('ราคารถ (บาท)'),
              ),
              TextField(
                controller: cCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '0.00',
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 10),

              /// เงินดาวน์
              Align(
                alignment: Alignment.centerLeft,
                child: Text('จำนวนเงินดาวน์ (%)'),
              ),
              Row(
                children: [10, 20, 30, 40].map((e) {
                  return Row(
                    children: [
                      Radio(
                        value: e,
                        groupValue: downPayment,
                        onChanged: (value) {
                          setState(() {
                            downPayment = value!;
                          });
                        },
                      ),
                      Text('$e'),
                    ],
                  );
                }).toList(),
              ),

              /// ระยะเวลา
              Align(
                alignment: Alignment.centerLeft,
                child: Text('ระยะเวลาผ่อน (เดือน)'),
              ),
              DropdownButton<String>(
                value: month,
                isExpanded: true,
                items: [
                  '24 เดือน',
                  '36 เดือน',
                  '48 เดือน',
                  '60 เดือน',
                  '72 เดือน'
                ].map((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    month = value!;
                  });
                },
              ),

              SizedBox(height: 10),

              /// ดอกเบี้ย
              Align(
                alignment: Alignment.centerLeft,
                child: Text('อัตราดอกเบี้ย (%/ปี)'),
              ),
              TextField(
                controller: interestCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '0.00',
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 10),

              /// ปุ่ม
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: calculate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[800],
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.zero,
                        ),
                      ),
                      child: Text('คำนวณ'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: reset,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[800],
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.zero,
                        ),
                      ),
                      child: Text('ยกเลิก'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              /// ผลลัพธ์
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(),
                  color: Colors.grey[200],
                ),
                child: Column(
                  children: [
                    Text(
                      'ค่างวดรถต่อเดือนเป็นเงิน',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      NumberFormat('#,##0.00').format(result),
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      'บาทต่อเดือน',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
