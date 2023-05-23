class CampaignDetails {
  final String campaignID;
  final String campaignName;
  final String time;
  final String size;
  final String metaCampaignName;
  final String attempted;
  final String sent;
  final String delivered;
  final String failed;
  final String read;
  final String replied;
  final String sendOn;

  CampaignDetails({
    required this.campaignID,
    required this.campaignName,
    required this.time,
    required this.size,
    required this.metaCampaignName,
    required this.attempted,
    required this.sent,
    required this.delivered,
    required this.failed,
    required this.read,
    required this.replied,
    required this.sendOn,
  });
}
