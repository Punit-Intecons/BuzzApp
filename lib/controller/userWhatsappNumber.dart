import 'package:buzzapp/controller/web_api.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserWhatsappNumber extends StatefulWidget {

  const UserWhatsappNumber({Key? key}) : super(key: key);

  @override
  _UserWhatsappNumberState createState() => _UserWhatsappNumberState();
}

class _UserWhatsappNumberState extends State<UserWhatsappNumber> {
  late String defaultWaNum = '';
  List<DropdownMenuItem<String>> whatsappnumItems = [];
  bool isnumberLoaded = false;
  late String userID='';
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    getSharedData();
  }
  
  @override
  void dispose() {
    // Cancel any ongoing asynchronous operations here if necessary
    super.dispose();
  }

  getSharedData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userID = sharedPreferences.getString('userID')!;
    });
    if (!isnumberLoaded) {
      getSelectedWhatsappNumber();
    }
  }

  getSelectedWhatsappNumber() async {
    var getData = await WebConfig.getWhatsappNumber(userID: userID);
    if (mounted) {
      if (getData['status'] == true) {
        var numbers = getData['numberList'] as List<dynamic>;
        setState(() {
          whatsappnumItems = numbers.map<DropdownMenuItem<String>>((number) {
            if (number['Default_Number'] == 'Yes') defaultWaNum = number['Whatsapp_Number'];
            return DropdownMenuItem<String>(
              value: number['Whatsapp_Number'],
              child: Text(number["Whatsapp_Number"], overflow: TextOverflow.ellipsis),
            );
          }).toList();
          isnumberLoaded = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey,
        ),
      ),
      child: DropdownButtonFormField<String>(
        value: defaultWaNum,
        onChanged: (String? newValue) {
          setState(() {
            defaultWaNum = defaultWaNum!;
          });
        },
        isExpanded: true,
        items: whatsappnumItems,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(8),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
