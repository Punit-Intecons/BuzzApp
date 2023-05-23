import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/constant.dart';
import 'package:buzzapp/models/message_model.dart';

import '../controller/web_api.dart';
import '../models/campaign_detail_model.dart';
import '../models/campaign_model.dart';
import '../models/user_model.dart';

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
        for (int i = 0; i < list.length; i++) {
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
        }
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Widget campaignContainer(String campaignID, String campaignName, String time, String size, String metaCampaignName, String attempted, String sent, String delivered, String failed, String read, String replied, String ) {
  //   return Column(
  //     children: <Widget>[
  //       Container(
  //         alignment: Alignment.topLeft,
  //         child: Container(
  //           constraints: BoxConstraints(
  //             maxWidth: MediaQuery.of(context).size.width * 0.80,
  //           ),
  //           padding: const EdgeInsets.all(10),
  //           margin: const EdgeInsets.symmetric(vertical: 10),
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(10),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.grey.withOpacity(0.5),
  //                 spreadRadius: 2,
  //                 blurRadius: 5,
  //               ),
  //             ],
  //           ),
  //           child: Text(
  //             message.text,
  //             style: const TextStyle(
  //               color: Colors.black54,
  //             ),
  //           ),
  //         ),
  //       ),
  //       !isSameUser
  //           ? Row(
  //               children: <Widget>[
  //                 Container(
  //                   decoration: BoxDecoration(
  //                     shape: BoxShape.circle,
  //                     boxShadow: [
  //                       BoxShadow(
  //                         color: Colors.grey.withOpacity(0.5),
  //                         spreadRadius: 2,
  //                         blurRadius: 5,
  //                       ),
  //                     ],
  //                   ),
  //                   child: CircleAvatar(
  //                     radius: 15,
  //                     backgroundImage: AssetImage(message.sender.imageUrl),
  //                   ),
  //                 ),
  //                 const SizedBox(
  //                   width: 10,
  //                 ),
  //                 Text(
  //                   message.time,
  //                   style: const TextStyle(
  //                     fontSize: 12,
  //                     color: Colors.black45,
  //                   ),
  //                 ),
  //               ],
  //             )
  //           : Container(
  //               child: null,
  //             ),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    var drawer = myDrawer(context);
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
                                      ? const Center(
                                          child: Text("Campaign detail found."),
                                        )
                                      : const Center(
                                          child: Text("No campaign found."),
                                        ),
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

            // second half of page
          ],
        ),
      ),
    );
  }
}
