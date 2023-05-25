import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/constant.dart';

import '../controller/web_api.dart';
import '../models/campaign_detail_model.dart';
import '../models/campaign_model.dart';

class DesktopCampaign extends StatefulWidget {
  const DesktopCampaign({Key? key}) : super(key: key);

  @override
  State<DesktopCampaign> createState() => _DesktopCampaignState();
}

class _DesktopCampaignState extends State<DesktopCampaign> {
  late List<CampaignDetails> campaignDetail = [];
  late List<Campaign> userCampaigns = [];
  bool isLoading = true;
  bool isCampaignLoading = true;
  bool isloadingFirstTime = true;
  bool isCreateCampaign = false;
  late SharedPreferences sharedPreferences;
  late String userID;
  late String userName;
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

      isloadingFirstTime = true;
      getCampaignListing();
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
    } else {
      setState(() {
        isCampaignLoading = false;
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

  Widget createCampaign() {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Row(
                        children: const <Widget>[
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
                      height: 10,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Row(
                        children: const <Widget>[
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
      children: <Widget>[
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    campaignName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 24.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "Size: $size,",
                            style: const TextStyle(
                              fontSize: 14,
                              color: successColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "Template send: $metaCampaignName,",
                        style: const TextStyle(
                          fontSize: 14,
                          color: successColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "Sent on: $sendOn",
                        style: const TextStyle(
                          fontSize: 14,
                          color: successColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ],
              ),
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
                      child: Row(
                        children: const <Widget>[
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
                                  Row(
                                    children: const [
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
                                  Row(
                                    children: const [
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
                                  Row(
                                    children: const [
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
                                  Row(
                                    children: const [
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
                                  Row(
                                    children: const [
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
                                  Row(
                                    children: const [
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Row(
                        children: const <Widget>[
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
  Widget build(BuildContext context) {
    var drawer = myDrawer(context, 'campaign');
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
            Expanded(
              flex: 1,
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 3,
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
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 30, 0, 0),
                          child: ElevatedButton(
                            onPressed: () {
                              // Add your onPressed code here!
                              setState(() {
                                print("new clicked");
                                isCreateCampaign = true;
                                isloadingFirstTime = false;
                              });
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
                            child: const Text('New'),
                          ),
                        ),
                      ],
                    ),

                    // search bar with icon
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 30, 0, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[200],
                        ),
                        child: Row(
                          children: const [
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
                              ? ListView.builder(
                                  itemCount: userCampaigns.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final Campaign campaigns =
                                        userCampaigns[index];
                                    return Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 10, 10, 10),
                                      child: GestureDetector(
                                        onTap: (() {
                                          setState(() {
                                            isCreateCampaign = false;
                                            isLoading = true;
                                            getCampaignDetail(
                                                campaigns.campaignID);
                                          });
                                        }),
                                        child: Container(
                                          width: 10,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            // add this line
                                            color: whiteColor, // add this line
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            children: <Widget>[
                                              SizedBox(
                                                width: ((MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        3) *
                                                    2.1.sp),
                                                child: Column(
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Row(
                                                          children: <Widget>[
                                                            Text(
                                                              campaigns
                                                                  .campaignName,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 2,
                                                            ),
                                                          ],
                                                        ),
                                                        Text(
                                                          campaigns.time,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        Row(
                                                          children: <Widget>[
                                                            Text(
                                                              "Size:${campaigns.size}",
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 12,
                                                                color:
                                                                    successColor,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        Text(
                                                          campaigns
                                                              .metaCampaignName,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 12,
                                                            color: successColor,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : const Center(
                                  child: Text("No Campaign found."),
                                ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
