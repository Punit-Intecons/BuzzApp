import 'dart:convert';

import 'package:http/http.dart' as http;

class NetworkHelper {
  NetworkHelper(this.url);

  final String url;

  Future getData({required Map<String, String> body}) async {
    http.Response response = await http.get(Uri.parse(url), headers: body);
    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    }
  }

  Future getProfileData({required Map<String, String> body}) async {
    http.Response response = await http.get(Uri.parse(url), headers: body);
    String data = response.body;
    return jsonDecode(data);
  }

  Future getProfileDatas({required Map<String, String> body}) async {
    http.Response response = await http.get(Uri.parse(url), headers: body);
    return response.body;
  }

  Future updateProfileData({required Map<String, String> head, body}) async {
    http.Response response =
        await http.post(Uri.parse(url), headers: head, body: body);
    String data = response.body;
    return jsonDecode(data);
  }

  Future putData({required Map<String, String> head, body}) async {
    http.Response response =
        await http.put(Uri.parse(url), headers: head, body: body);
    String data = response.body;
    return jsonDecode(data);
  }

  Future putBodyData({required Map<String, String> head}) async {
    http.Response response = await http.put(Uri.parse(url), headers: head);
    String data = response.body;
    return jsonDecode(data);
  }

  Future putBodyWithData(
      {required Map<String, String> head, var bodyData}) async {
    http.Response response =
        await http.put(Uri.parse(url), headers: head, body: bodyData);
    String data = response.body;
    return jsonDecode(data);
  }

  Future postData({required Map<String, String> body}) async {
    http.Response response = await http.post(Uri.parse(url), headers: body);
    String data = response.body;
    return jsonDecode(data);
  }

  Future postHeaderData({required Map<String, String> headers}) async {
    http.Response response = await http.post(Uri.parse(url), headers: headers);
    String data = response.body;
    return jsonDecode(data);
  }

  Future postHeaderBodyData(headers, body) async {
    http.Response response =
        await http.post(Uri.parse(url), headers: headers, body: body);
    String data = response.body;
    print(body);
    print(data);
    return jsonDecode(data);
  }

  Future counterDeleteData({required Map<String, String> headers, body}) async {
    http.Response response =
        await http.delete(Uri.parse(url), headers: headers, body: body);
    String data = response.body;
    return jsonDecode(data);
  }

  Future counterGetData({required Map<String, String> headers, body}) async {
    http.Response response = await http.get(Uri.parse(url), headers: headers);
    String data = response.body;
    return jsonDecode(data);
  }

  Future uploadFileData(String filePath, Map<String, String> bodyParams,
      Map<String, String> headers) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll(bodyParams);
    request.files
        .add(await http.MultipartFile.fromPath('Profile_Image', filePath));
    request.headers.addAll(headers);
    var res = await request.send();
    final respStr = await res.stream.bytesToString();
    return jsonDecode(respStr);
  }
}
