import 'package:buzzapp/campaign/campaign_detail.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/constant.dart';
import '../controller/web_api.dart';
import '../models/campaign_model.dart';

class TabletCampaign extends StatefulWidget {
  const TabletCampaign({Key? key}) : super(key: key);

  @override
  State<TabletCampaign> createState() => _TabletCampaignState();
}

class _TabletCampaignState extends State<TabletCampaign> {
  DateTime? backPressedTime;
  late List<Campaign> userCampaigns = [];
  bool isCampaignLoading = true;
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

  Future<bool> _onWillPop() async {
    if (backPressedTime == null ||
        DateTime.now().difference(backPressedTime!) >
            const Duration(seconds: 2)) {
      // prompt the user to confirm exit
      backPressedTime = DateTime.now();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Press again to exit'),
        ),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var drawer = myDrawer(context, 'campaign');
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: secondaryBackgroundColor,
        appBar: AppBar(
          backgroundColor: appBarColor,
          elevation: 0,
          centerTitle: true,
          title: RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              children: [
                TextSpan(
                    text: "Campaign",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    )),
              ],
            ),
          ),
        ),
        drawer: drawer,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // list of previous days
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
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final Campaign campaigns =
                                        userCampaigns[index];
                                    return InkWell(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => CampaignDetail(
                                              campaignId: campaigns.campaignID),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 4.0, top: 10),
                                        child: ListTile(
                                          title: Text(
                                            campaigns.campaignName,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  "Size:${campaigns.size}",
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: successColor,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  campaigns.metaCampaignName,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: successColor,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ],
                                            ),
                                          ),
                                          trailing: Text(
                                            campaigns.time,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w300,
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
                            child: Text("No Chats found."),
                          ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          tooltip: 'New',
          backgroundColor: primaryColor,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
