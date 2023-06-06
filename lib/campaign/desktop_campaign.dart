import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/my_data_table_source.dart';
import '../controller/constant.dart';

import '../controller/web_api.dart';
import '../models/campaign_detail_model.dart';
import '../models/campaign_model.dart';
import '../models/template_model.dart';

class DesktopCampaign extends StatefulWidget {
  const DesktopCampaign({Key? key}) : super(key: key);

  @override
  State<DesktopCampaign> createState() => _DesktopCampaignState();
}

class _DesktopCampaignState extends State<DesktopCampaign> {
  late List<CampaignDetails> campaignDetail = [];
  late List<Campaign> userCampaigns = [];
  late List<Template> metaTemplates = [];
  String? selectedLanguage;
  late List<TemplateLang> dropdownItems = [];
  late List<String> searchedData = [];
  List<String> headers = [];
  List<List<String>> data = [];
  bool isLoading = true;
  bool isCampaignLoading = true;
  bool isloadingFirstTime = true;
  bool isCreateCampaign = false;
  final TextEditingController _inputController = TextEditingController();
  late SharedPreferences sharedPreferences;
  late String userID = "";
  late String userName = "";
  late String metaKey = "";
  String inputValue = '';
  bool isdataLoading = true;
  List<String> tagData = [];
  @override
  void initState() {
    getSharedData();
    super.initState();
  }

  getSharedData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userID = sharedPreferences.getString('userID')!;
      userName = sharedPreferences.getString('first_name')!;
      metaKey = sharedPreferences.getString('Meta_Key')!;

      isloadingFirstTime = true;
      getCampaignListing();
      getMetaCampaigns();
    });
  }

  getCampaignListing() async {
    setState(() {
      isCampaignLoading = true;
      userCampaigns.clear();
    });
    var getData = await WebConfig.getCampaignListing(
      userID: userID,
      userName: userName,
    );
    if (getData['status'] == true) {
      var list = getData['campaignDetail'];
      if (mounted) {
        setState(() {
          for (int i = 0; i < list.length; i++) {
            userCampaigns.add(Campaign(
              campaignID: list[i]['campaignID'],
              campaignName: list[i]['campaignName'],
              time: list[i]['time'],
              size: list[i]['size'],
              metaCampaignName: list[i]['metaCampaignName'],
            ));
          }
          isCampaignLoading = false;
        });
      }
    } else {
      setState(() {
        isCampaignLoading = false;
      });
    }
  }

  getMetaCampaigns() async {
    setState(() {
      metaTemplates.clear();
    });
    var getData = await WebConfig.getMetaTemplates(
      userID: userID,
    );
    if (getData['status'] == true) {
      var list = getData['Templates'];
      if (mounted) {
        setState(() {
          for (int i = 0; i < list.length; i++) {
            metaTemplates.add(Template(
              templateName: list[i]['templateName'],
            ));
          }
        });
      }
    }
  }

  void getMetaTemplateLanguage(String selectedTemplate) async {
    setState(() {
      dropdownItems.clear();
    });

    var getData = await WebConfig.getMetaTemplateLanguage(
      userID: userID,
      metaKey: metaKey,
      selectedTemplate: selectedTemplate,
    );

    if (getData['status'] == true) {
      var templateLanguageList = getData['templateLanguage'] as List<dynamic>;
      if (mounted) {
        setState(() {
          // Create dropdown items from the template language data
          for (int i = 0; i < templateLanguageList.length; i++) {
            dropdownItems.add(TemplateLang(
              langCode: templateLanguageList[i]['LangCode'],
              langName: templateLanguageList[i]['LangName'],
            ));
          }
        });
      }
      print(dropdownItems);
    }
  }

  fetchSearchedValue(searchedVal) async {
    setState(() {
      searchedData = [];
    });
    var getData = await WebConfig.getCampaignSearchedValue(
      searchedValue: searchedVal,
      userID: userID,
    );
    if (getData['status'] == true) {
      if (mounted) {
        setState(() {
          searchedData = List<String>.from(getData['searchedValue']);
          tagData = List<String>.from(searchedData);
        });
      }
    } else {
      setState(() {
        searchedData = [];
      });
    }
  }

  void filterData(String searchValue) {
    if (searchValue.isNotEmpty) {
      tagData =
          searchedData.where((value) => value.contains(searchValue)).toList();
    } else {
      tagData = List<String>.from(searchedData);
    }
  }

  filterSearchedValue(filterData) async {
    setState(() {
      isdataLoading = true;
      headers = [];
      data = [];
    });
    var getData = await WebConfig.getFilterSearchedValue(
      filterData: filterData,
      userID: userID,
    );
    if (getData['status'] == true) {
      var list = getData['filteredData'];
      if (list != null && list.isNotEmpty) {
        var column = list[0];
        headers = column.keys.toList(); // Extract column names
        setState(() {
          for (int i = 0; i < list.length; i++) {
            List<String> rowData = [];
            for (var columnName in headers) {
              rowData.add(list[i][columnName]);
            }
            data.add(rowData);
          }
          isdataLoading = false;
        });
      }
    } else {
      setState(() {
        isdataLoading = false;
        headers = [];
        data = [];
      });
    }
  }

  getCampaignDetail(campaignID) async {
    setState(() {
      isLoading = true;
      isloadingFirstTime = false;

      campaignDetail.clear();
    });
    var getData = await WebConfig.getCampaignDetails(
        userID: userID, userName: userName, campaignID: campaignID);
    if (getData['status'] == true) {
      var list = getData['campaignDetail'];
      setState(() {
        campaignDetail.add(CampaignDetails(
          campaignID: list['campaignID'],
          campaignName: list['campaignName'],
          time: list['time'],
          size: list['size'],
          metaCampaignName: list['metaCampaignName'],
          attempted: list['attempted'],
          sent: list['sent'],
          delivered: list['delivered'],
          failed: list['failed'],
          read: list['read'],
          replied: list['replied'],
          sendOn: list['sendOn'],
        ));

        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void onBoxTap(String value) {
    List<String> symbolsToRemove = ['+', '/'];
    final updatedText =
        '${_inputController.text.trim()} $value'; // Append the selected value with a space
    String result = updatedText;
    for (var symbol in symbolsToRemove) {
      result = result.replaceAll(symbol, ''); // Remove the specified symbols
    }
    _inputController.text = result.trim();
  }

  void onTextChanged(String value) {
    setState(() {
      List<String> symbols = ['+', '/']; // Add more symbols if needed
      int symbolIndex = -1;

      for (var symbol in symbols) {
        int index = value.indexOf(symbol);
        if (index != -1) {
          symbolIndex = index;
          break;
        }
      }

      if (symbolIndex != -1) {
        // Remove any characters before the symbol
        value = value.substring(symbolIndex);
      }

      inputValue = value.trim();
      fetchSearchedValue(
          inputValue); // Call the API with the modified search text
      filterData(value.replaceAll("+", ''));
    });
  }

  Widget buildPaginatedDataTable() {
    if (data.isEmpty) {
      return const Center(
        child: Text('No records found'),
      );
    }

    return PaginatedDataTable(
      header: const Text('Table'),
      columns: [
        for (var columnName in headers) DataColumn(label: Text(columnName)),
      ],
      source: MyDataTableSource(data),
      rowsPerPage: (data.length < 10
          ? data.length
          : 10), // Number of rows to display per page
    );
  }

  Widget searchedBox() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _inputController,
                  maxLines: null,
                  onChanged: onTextChanged,
                  decoration: const InputDecoration(
                    labelText: 'Type here',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(
                  width: 10), // Spacing between text field and button
              ElevatedButton(
                onPressed: () {
                  filterSearchedValue(_inputController.text);
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(primaryColor),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(17.0),
                  child: Text(
                    'Filter',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (searchedData.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: searchedData.map((value) {
                return GestureDetector(
                  onTap: () => onBoxTap(value),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      border: null,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      value,
                      style: const TextStyle(
                        color: whiteColor,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: buildPaginatedDataTable(),
            ),
          ),
        ),
      ],
    );
  }

  Widget createCampaign() {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 30,
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Create a new campaign",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 24.0,
                    ),
                  ),
                  SizedBox(height: 8.0),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: Container(
                decoration: const BoxDecoration(
                  color: secondaryBackgroundColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            "Campaign Name",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(height: 10.0),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  hintText: 'Type a campaign name',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter campaign name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Filter",
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 16.0,
                                color: greyColor),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Audience",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    searchedBox(),
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Template",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.grey,
                              ),
                            ),
                            child: DropdownButtonFormField<String>(
                              value: "Template Name",
                              onChanged: (String? newValue) {
                                getMetaTemplateLanguage(newValue!);
                              },
                              isExpanded: true,
                              // ignore: unnecessary_null_comparison
                              items: metaTemplates != null &&
                                      metaTemplates.isNotEmpty
                                  ? metaTemplates.map<DropdownMenuItem<String>>(
                                      (Template template) {
                                      return DropdownMenuItem<String>(
                                        value: template.templateName,
                                        child: Text(template.templateName,
                                            overflow: TextOverflow.ellipsis),
                                      );
                                    }).toList()
                                  : [
                                      const DropdownMenuItem<String>(
                                        value: "Template Name",
                                        child: Text("Template Name",
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ],
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.grey,
                              ),
                            ),
                            child: DropdownButtonFormField<String>(
                              value: "Template Language",
                              onChanged: (String? newValue) {
                                getMetaTemplateLanguage(newValue!);
                              },
                              isExpanded: true,
                              // ignore: unnecessary_null_comparison
                              items: dropdownItems != null &&
                                      dropdownItems.isNotEmpty
                                  ? dropdownItems.map<DropdownMenuItem<String>>(
                                      (TemplateLang templateLang) {
                                      return DropdownMenuItem<String>(
                                        value: templateLang.langCode,
                                        child: Text(templateLang.langName,
                                            overflow: TextOverflow.ellipsis),
                                      );
                                    }).toList()
                                  : [
                                      const DropdownMenuItem<String>(
                                        value: "Template Language",
                                        child: Text("Template Language",
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ],
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget campaignContainer(
    String campaignID,
    String campaignName,
    String time,
    String size,
    String metaCampaignName,
    String attempted,
    String sent,
    String delivered,
    String failed,
    String read,
    String replied,
    String sendOn,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                campaignName,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 24.0,
                ),
              ),
              Row(
                children: [
                  PopupMenuButton<String>(
                    onSelected: (choice) {
                      // Handle the different options here
                    },
                    itemBuilder: (BuildContext context) {
                      return const <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'edit',
                          child: Text('Edit'),
                        ),
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ];
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: Text(
              "Size: $size, Template send: $metaCampaignName, Sent on: $sendOn",
              style: const TextStyle(
                fontSize: 14,
                color: successColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: Container(
                decoration: const BoxDecoration(
                  color: secondaryBackgroundColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Performance",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        attempted,
                                        style: const TextStyle(
                                            color: blackColor, fontSize: 18.0),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8.0),
                                  const Row(
                                    children: [
                                      Text(
                                        'Attempted',
                                        style: TextStyle(
                                            color: greyColor, fontSize: 14.0),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(width: 8.0),
                              Container(
                                height: 30.0,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    right: BorderSide(
                                      color: greyColor,
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        sent,
                                        style: const TextStyle(
                                            color: blackColor, fontSize: 18.0),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8.0),
                                  const Row(
                                    children: [
                                      Text(
                                        'Send',
                                        style: TextStyle(
                                            color: primaryColor,
                                            fontSize: 14.0),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(width: 8.0),
                              Container(
                                height: 30.0,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    right: BorderSide(
                                      color: greyColor,
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        delivered,
                                        style: const TextStyle(
                                            color: blackColor, fontSize: 18.0),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8.0),
                                  const Row(
                                    children: [
                                      Text(
                                        'Delivered',
                                        style: TextStyle(
                                            color: primaryColor,
                                            fontSize: 14.0),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(width: 8.0),
                              Container(
                                height: 30.0,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    right: BorderSide(
                                      color: greyColor,
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        read,
                                        style: const TextStyle(
                                            color: blackColor, fontSize: 18.0),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8.0),
                                  const Row(
                                    children: [
                                      Text(
                                        'Read',
                                        style: TextStyle(
                                            color: successColor,
                                            fontSize: 14.0),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(width: 8.0),
                              Container(
                                height: 30.0,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    right: BorderSide(
                                      color: greyColor,
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        replied,
                                        style: const TextStyle(
                                            color: blackColor, fontSize: 18.0),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8.0),
                                  const Row(
                                    children: [
                                      Text(
                                        'Replied',
                                        style: TextStyle(
                                            color: successColor,
                                            fontSize: 14.0),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(width: 8.0),
                              Container(
                                height: 30.0,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    right: BorderSide(
                                      color: greyColor,
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        failed,
                                        style: const TextStyle(
                                            color: blackColor, fontSize: 18.0),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8.0),
                                  const Row(
                                    children: [
                                      Text(
                                        'Failed',
                                        style: TextStyle(
                                            color: errorColor, fontSize: 14.0),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Audience",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Row(
                        children: [
                          const Text(
                            'Your contact where: ',
                            style: TextStyle(
                                color: blackColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(width: 10.0),
                          ElevatedButton(
                            onPressed: () {
                              // Add your onPressed code here!
                            },
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all<Size>(
                                const Size(110, 45),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  primaryColor),
                              foregroundColor:
                                  MaterialStateProperty.all<Color>(whiteColor),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )),
                            ),
                            child: const Text('Tag is tester'),
                          ),
                          const SizedBox(width: 10.0),
                          const Text(
                            'and',
                            style: TextStyle(color: errorColor, fontSize: 14.0),
                          ),
                          const SizedBox(width: 10.0),
                          ElevatedButton(
                            onPressed: () {
                              // Add your onPressed code here!
                            },
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all<Size>(
                                const Size(110, 45),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  primaryColor),
                              foregroundColor:
                                  MaterialStateProperty.all<Color>(whiteColor),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )),
                            ),
                            child: const Text('Tag is intecons'),
                          ),
                          const SizedBox(width: 10.0),
                          const Text(
                            'or',
                            style: TextStyle(color: errorColor, fontSize: 14.0),
                          ),
                          const SizedBox(width: 10.0),
                          ElevatedButton(
                            onPressed: () {
                              // Add your onPressed code here!
                            },
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all<Size>(
                                const Size(110, 45),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  primaryColor),
                              foregroundColor:
                                  MaterialStateProperty.all<Color>(whiteColor),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )),
                            ),
                            child: const Text('Tag is developer'),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Set size: $size",
                            style: const TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 14.0,
                                color: greyColor),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Template',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text('Name: $metaCampaignName'),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text('Preview:'),
                                const SizedBox(
                                  height: 10,
                                ),
                                Image.asset(
                                  'assets/ad_preview.png',
                                  height: 400, // adjust as needed
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Dynamic Values',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'Body Name:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 14,
                                          color: greyColor),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Add your onPressed code here!
                                      },
                                      style: ButtonStyle(
                                        minimumSize:
                                            MaterialStateProperty.all<Size>(
                                          const Size(110, 45),
                                        ),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                          primaryColor,
                                        ),
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                          whiteColor,
                                        ),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      ),
                                      child: const Text('Tag Value'),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Tag value:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 14,
                                          color: greyColor),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Add your onPressed code here!
                                      },
                                      style: ButtonStyle(
                                        minimumSize:
                                            MaterialStateProperty.all<Size>(
                                          const Size(110, 45),
                                        ),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                          primaryColor,
                                        ),
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                          whiteColor,
                                        ),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      ),
                                      child: const Text('mobile number'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    // Cancel any ongoing asynchronous operations here if necessary
    getSharedData();
    getMetaCampaigns();

    isdataLoading = false;
    headers = [];
    data = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var drawer = myDrawer(context, 'campaign', userName);
    return Scaffold(
      backgroundColor: secondaryBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // open drawer
            drawer,

            // first half of page
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: whiteColor,
                ),
                width: MediaQuery.of(context).size.width / 5,
                child: Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      // message text
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(16, 30, 0, 0),
                            child: Text(
                              'Campaigns',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: primaryColor,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 30, 10, 0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Add your onPressed code here!
                                    setState(() {
                                      isCreateCampaign = true;
                                      isloadingFirstTime = false;
                                      // getMetaCampaigns();
                                    });
                                  },
                                  style: ButtonStyle(
                                    minimumSize:
                                        MaterialStateProperty.all<Size>(
                                      const Size(45, 45),
                                    ),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            primaryColor),
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            whiteColor),
                                    shape: MaterialStateProperty.all<
                                        OutlinedBorder>(
                                      const CircleBorder(),
                                    ),
                                  ),
                                  child: const Text('+'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // search bar with icon
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 30, 16, 0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: searchColor,
                          ),
                          child: const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 8.0), // added left padding
                                child: Icon(Icons.search),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          8.0), // added horizontal padding
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Search',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // list of previous days

                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 20, 0, 0),
                        child: Text(
                          'Recent Campaigns',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: greyColor,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Expanded(
                        child: isCampaignLoading == true
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: primaryColor,
                                ),
                              )
                            : userCampaigns.isNotEmpty
                                ? Column(
                                    children: [
                                      Expanded(
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: userCampaigns.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            final Campaign campaigns =
                                                userCampaigns[index];
                                            return InkWell(
                                              onTap: (() {
                                                setState(() {
                                                  isCreateCampaign = false;
                                                  isLoading = true;
                                                  getCampaignDetail(
                                                      campaigns.campaignID);
                                                });
                                              }),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 4.0, top: 10),
                                                child: ListTile(
                                                  title: Text(
                                                    campaigns.campaignName,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  subtitle: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5),
                                                    child: Text(
                                                      "Size:${campaigns.size}, ${campaigns.metaCampaignName}",
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color: successColor,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                    ),
                                                  ),
                                                  trailing: Text(
                                                    campaigns.time,
                                                    style: const TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                : const Center(
                                    child: Text("No Campaign found."),
                                  ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: whiteColor,
                  ),
                  child: isloadingFirstTime == false
                      ? isCreateCampaign == false
                          ? Column(
                              children: <Widget>[
                                Expanded(
                                  child: isLoading == true
                                      ? const Center(
                                          child: CircularProgressIndicator(
                                            color: primaryColor,
                                          ),
                                        )
                                      : campaignDetail.isNotEmpty
                                          ? campaignContainer(
                                              campaignDetail[0].campaignID,
                                              campaignDetail[0].campaignName,
                                              campaignDetail[0].time,
                                              campaignDetail[0].size,
                                              campaignDetail[0]
                                                  .metaCampaignName,
                                              campaignDetail[0].attempted,
                                              campaignDetail[0].sent,
                                              campaignDetail[0].delivered,
                                              campaignDetail[0].failed,
                                              campaignDetail[0].read,
                                              campaignDetail[0].replied,
                                              campaignDetail[0].sendOn)
                                          : const Center(
                                              child: Text("No campaign found."),
                                            ),
                                ),
                              ],
                            )
                          : Column(
                              children: <Widget>[
                                Expanded(
                                  child: createCampaign(),
                                ),
                              ],
                            )
                      : const Center(
                          child:
                              Text("Please select a campaign from left window"),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
