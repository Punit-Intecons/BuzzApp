import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/constant.dart';
import '../controller/web_api.dart';
import '../models/campaign_detail_model.dart';

class CampaignDetail extends StatefulWidget {
  final String campaignId;

  const CampaignDetail({super.key, required this.campaignId});

  @override
  State<CampaignDetail> createState() => _CampaignDetailState();
}

class _CampaignDetailState extends State<CampaignDetail> {
  late List<CampaignDetails> campaignDetail = [];
  bool isLoading = true;
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

      getCampaignDetail(widget.campaignId);
    });
  }

  getCampaignDetail(campaignID) async {
    setState(() {
      isLoading = true;
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
          height: 10,
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
                        "Template send: $metaCampaignName",
                        style: const TextStyle(
                          fontSize: 14,
                          color: successColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Row(
                    children: <Widget>[
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
                        children: const [
                          Text(
                            'Your contact where: ',
                            style: TextStyle(
                                color: blackColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Row(
                        children: [
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
                    const SizedBox(
                      height: 10,
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
                                Text(
                                  'Name: $metaCampaignName',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                      color: greyColor),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
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
                                      child: const Text(
                                        'Tag Value',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300,
                                          color: whiteColor,
                                        ),
                                      ),
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
                                      child: const Text(
                                        'mobile number',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 14,
                                          color: whiteColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Text(
                                  'Preview:',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                      color: greyColor),
                                ),
                                Image.asset(
                                  'assets/ad_preview.png',
                                  height: 400,
                                  width: 200, // adjust as needed
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        centerTitle: true,
        title: RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            children: [
              TextSpan(
                  text: "Campaign Details",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  )),
            ],
          ),
        ),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: [
          IconButton(
            onPressed: () {},
            icon: PopupMenuButton<String>(
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
          ),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
      body: Column(
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
                        campaignDetail[0].metaCampaignName,
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
      ),
    );
  }
}
