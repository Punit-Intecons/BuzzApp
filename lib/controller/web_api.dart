import 'dart:io';

import 'constant.dart';
import 'network.dart';

class WebConfig {
  static Future<dynamic> signUp(
      {required String firstNameString,
      required String lastNameString,
      required String emailString,
      required String passwordString}) async {
    Map<String, String> stringParams = {'csrf-token': crsfToken};
    Map<String, String> bodyParams = {
      'First_Name': firstNameString,
      'Email': emailString,
      'Last_Name': lastNameString,
      'Password': passwordString,
      'User_Device_Token': "test"
    };
    NetworkHelper networkHelper = NetworkHelper('$kBaseURL/form_register');
    var registrationData =
        await networkHelper.postHeaderBodyData(stringParams, bodyParams);
    return registrationData;
  }

  static Future<dynamic> verifyOTP(
      {required String otp,
      required String gcmID,
      required String emailAddress,
      required String screenType}) async {
    Map<String, String> stringParams = {'csrf-token': crsfToken};
    Map<String, String> bodyParams = {
      'OTP': otp,
      'GCMID': gcmID,
      'Email': emailAddress,
      'screenType': screenType,
    };
    NetworkHelper networkHelper = NetworkHelper('$kBaseURL/check_OTP');
    var data = await networkHelper.postHeaderBodyData(stringParams, bodyParams);
    return data;
  }

  static Future<dynamic> resendOTP({required String emailAddress}) async {
    Map<String, String> stringParams = {'csrf-token': crsfToken};
    Map<String, String> bodyParams = {
      'Email ': emailAddress,
    };
    NetworkHelper networkHelper = NetworkHelper('$kBaseURL/resendOTP');
    var loginData =
        await networkHelper.postHeaderBodyData(stringParams, bodyParams);
    return loginData;
  }

  static Future<dynamic> makeLogin(
      {required String emailString,
      required String passwordString,
      required String deviceToken}) async {
    Map<String, String> stringParams = {'csrf-token': crsfToken};
    Map<String, String> bodyParams = {
      'Email': emailString,
      'Password': passwordString,
      'Mode': 'Form',
      'User_Device_Token': deviceToken
    };

    NetworkHelper networkHelper = NetworkHelper('$kBaseURL/login');
    var loginData =
        await networkHelper.postHeaderBodyData(stringParams, bodyParams);
    return loginData;
  }

  static Future<dynamic> registerWithApple(
      {required String emailString,
      required String fullNameString,
      required String userIdentifier,
      required String deviceToken}) async {
    Map<String, String> stringParams = {'csrf-token': crsfToken};
    Map<String, String> bodyParams = {
      'Email': emailString,
      'Name': fullNameString,
      'Social_ProfileID': userIdentifier,
      'GCMID': userIdentifier,
      'User_Device_Token': deviceToken
    };

    NetworkHelper networkHelper = NetworkHelper('$kBaseURL/apple_register');
    var loginData =
        await networkHelper.postHeaderBodyData(stringParams, bodyParams);
    return loginData;
  }

  static Future<dynamic> socialSignIn({
    required String emailString,
    required String passwordString,
    required String deviceToken,
    required String socialType,
    required String firstName,
    required String lastName,
    required String imageLink,
    required String socialProfileID,
  }) async {
    Map<String, String> stringParams = {'csrf-token': crsfToken};
    Map<String, String> bodyParams = {
      'Email': emailString,
      'Password': passwordString,
      'Mode': socialType,
      'GCMID': deviceToken,
      'First_Name': firstName,
      'Last_Name': lastName,
      'Profile_Image': imageLink,
      'Social_ProfileID': socialProfileID,
      'User_Device_Token': deviceToken
    };

    NetworkHelper networkHelper = NetworkHelper('$kBaseURL/login');
    var loginData =
        await networkHelper.postHeaderBodyData(stringParams, bodyParams);
    return loginData;
  }

  static Future<dynamic> signInWithApple({
    required String userIdentifier,
    required String deviceToken,
  }) async {
    Map<String, String> stringParams = {'csrf-token': crsfToken};
    Map<String, String> bodyParams = {
      'Social_ProfileID': userIdentifier,
      'Mode': 'Apple',
      'GCMID': userIdentifier,
      'User_Device_Token': deviceToken
    };
    NetworkHelper networkHelper = NetworkHelper('$kBaseURL/login');
    var loginData =
        await networkHelper.postHeaderBodyData(stringParams, bodyParams);
    return loginData;
  }

  static Future<dynamic> forgotPassword({required String emailString}) async {
    Map<String, String> stringParams = {'csrf-token': crsfToken};
    Map<String, String> bodyParams = {
      'Email': emailString,
    };
    NetworkHelper networkHelper = NetworkHelper('$kBaseURL/forgotPassword');
    var loginData =
        await networkHelper.postHeaderBodyData(stringParams, bodyParams);
    return loginData;
  }

  static Future<dynamic> resetPassword(
      {required String emailString,
      required String otp,
      required String password}) async {
    Map<String, String> stringParams = {'csrf-token': crsfToken};
    Map<String, String> bodyParams = {
      'Email': emailString,
      'OTP': otp,
      'Password': password,
    };
    NetworkHelper networkHelper = NetworkHelper('$kBaseURL/resetPassword');
    var loginData =
        await networkHelper.postHeaderBodyData(stringParams, bodyParams);
    return loginData;
  }

  static Future<dynamic> getChats(
      {required String userID, required String userName}) async {
    Map<String, String> stringParams = {
      'csrf-token': crsfToken,
    };
    Map<String, String> bodyParams = {
      'userID': userID,
      'userName': userName,
    };
    NetworkHelper networkHelper = NetworkHelper('$kBaseURL/getChats');
    var existingChatData =
        await networkHelper.postHeaderBodyData(stringParams, bodyParams);
    return existingChatData;
  }

  static Future<dynamic> getMessages(
      {required String userID, required String userName}) async {
    Map<String, String> stringParams = {
      'csrf-token': crsfToken,
    };
    Map<String, String> bodyParams = {
      'userID': userID,
      'userName': userName,
    };
    NetworkHelper networkHelper = NetworkHelper('$kBaseURL/getMessages');
    var messagesData =
        await networkHelper.postHeaderBodyData(stringParams, bodyParams);
    return messagesData;
  }

  static Future<dynamic> getCampaignListing(
      {required String userID, required String userName}) async {
    Map<String, String> stringParams = {
      'csrf-token': crsfToken,
    };
    Map<String, String> bodyParams = {
      'userID': userID,
      'userName': userName,
    };
    NetworkHelper networkHelper = NetworkHelper('$kBaseURL/getCampaignListing');
    var existingCamapignData =
        await networkHelper.postHeaderBodyData(stringParams, bodyParams);
    return existingCamapignData;
  }

  static Future<dynamic> getCampaignDetails(
      {required String userID,
      required String userName,
      required String campaignID}) async {
    Map<String, String> stringParams = {
      'csrf-token': crsfToken,
    };
    Map<String, String> bodyParams = {
      'userID': userID,
      'userName': userName,
      'campaignID': campaignID,
    };
    NetworkHelper networkHelper = NetworkHelper('$kBaseURL/getCampaignDetails');
    var camapignDetailData =
        await networkHelper.postHeaderBodyData(stringParams, bodyParams);
    return camapignDetailData;
  }

  static Future<dynamic> saveMetaDetails(
      {required String metaKey,
      required String WABA_ID,
      required String userID,
      required String userName}) async {
    Map<String, String> stringParams = {
      'csrf-token': crsfToken,
    };
    Map<String, String> bodyParams = {
      'userName': userName,
      'userID': userID,
      'metaKey': metaKey,
      'wabaId': WABA_ID,
    };
    NetworkHelper networkHelper = NetworkHelper('$kBaseURL/addMetaKeys');
    var metaResponse =
        await networkHelper.postHeaderBodyData(stringParams, bodyParams);
    return metaResponse;
  }

  static Future<dynamic> getCountryCode() async {
    Map<String, String> stringParams = {
      'csrf-token': crsfToken,
    };
    Map<String, String> bodyParams = {};
    NetworkHelper networkHelper = NetworkHelper('$kBaseURL/countryCodes');
    var response =
        await networkHelper.postHeaderBodyData(stringParams, bodyParams);
    return response;
  }

  static Future<dynamic> updateProfile(
      {required String firstName,
      required String lastName,
      required String email,
      required String userID,
      required String mobileNumber,
      required String countryCode,
      File? profileImage}) async {
    Map<String, String> stringParams = {
      'csrf-token': crsfToken,
    };
    Map<String, String> bodyParams;
    var profile = '';
    if (profileImage != null) {
      profile = profileImage.path;
    }
    bodyParams = {
      'Email': email,
      'firstName': firstName,
      'lastName': lastName,
      'userID': userID,
      'mobileNumber': mobileNumber,
      'countryCode': countryCode
    };

    NetworkHelper networkHelper =
        NetworkHelper('$kBaseURL/updateProfileDetails');
    var metaResponse =
        await networkHelper.uploadFileData(profile, bodyParams, stringParams);
    return metaResponse;
  }

  static Future<dynamic> updatePassword(
      {required String currentPassword,
      required String newPassword,
      required String confirmPassword,
      required String userID}) async {
    Map<String, String> stringParams = {
      'csrf-token': crsfToken,
    };
    Map<String, String> bodyParams = {
      "currentPassword": currentPassword,
      "newPassword": newPassword,
      "confirmPassword": confirmPassword,
      "userID": userID,
    };
    NetworkHelper networkHelper = NetworkHelper('$kBaseURL/updatePassword');
    var metaResponse =
        await networkHelper.postHeaderBodyData(stringParams, bodyParams);
    return metaResponse;
  }

  static Future<dynamic> getWhatsappNumber({required String userID}) async {
    Map<String, String> stringParams = {
      'csrf-token': crsfToken,
    };
    Map<String, String> bodyParams = {
      "userID": userID,
    };
    NetworkHelper networkHelper = NetworkHelper('$kBaseURL/getWhatsappNumber');
    var metaResponse =
        await networkHelper.postHeaderBodyData(stringParams, bodyParams);
    return metaResponse;
  }
}
