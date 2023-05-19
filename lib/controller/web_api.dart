import 'constant.dart';
import 'network.dart';

class WebConfig {
  static Future<dynamic> signUp(
      {required String firstNameString,
      required String lastNameString,
      required String emailString,
      required String passwordString}) async {
    Map<String, String> stringParams = {'csrf-token': '3MUZqCyosJx8sALQ'};
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
      required String emailAddress}) async {
    Map<String, String> stringParams = {'csrf-token': '3MUZqCyosJx8sALQ'};
    Map<String, String> bodyParams = {
      'OTP': otp,
      'GCMID': gcmID,
      'Email': emailAddress,
    };
    NetworkHelper networkHelper = NetworkHelper('$kBaseURL/check_OTP');
    var data = await networkHelper.postHeaderBodyData(stringParams, bodyParams);
    return data;
  }

  static Future<dynamic> resendOTP({required String emailAddress}) async {
    Map<String, String> stringParams = {'csrf-token': '3MUZqCyosJx8sALQ'};
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
    Map<String, String> stringParams = {'csrf-token': '3MUZqCyosJx8sALQ'};
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
    Map<String, String> stringParams = {'csrf-token': '3MUZqCyosJx8sALQ'};
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
    Map<String, String> stringParams = {'csrf-token': '3MUZqCyosJx8sALQ'};
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
    Map<String, String> stringParams = {'csrf-token': '3MUZqCyosJx8sALQ'};
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
    Map<String, String> stringParams = {'csrf-token': '3MUZqCyosJx8sALQ'};
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
    Map<String, String> stringParams = {'csrf-token': '3MUZqCyosJx8sALQ'};
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

  static Future<dynamic> getMessages(
      {required String userID, required String userName}) async {
    Map<String, String> stringParams = {
      'csrf-token': '3MUZqCyosJx8sALQ',
    };
    Map<String, String> bodyParams = {
      'userID': userID,
      'userName': userName,
    };
    NetworkHelper networkHelper = NetworkHelper('$kBaseURL/getMessages');
    var loginData =
        await networkHelper.postHeaderBodyData(stringParams, bodyParams);
    return loginData;
  }
}
