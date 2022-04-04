import 'package:izmitbld_kariyer/model/member-experience-model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

class SharedPreferencesHelper {
  static final String _tokenKey = "tokenKey";
  static final String _refreshToken = "refreshToken";
  static final String _selectedMemberId = "selectedMemberId";
  static final String _staffTypeId = "staffTypeId";
  static final String _currentUserId = "currentUserId";
  static String _apiAddress = "https://careerapi.izmit.bel.tr/api/";
  static final String _categoryKey = "selectedCategory";
  static final int _selectedCategoryId = 0;
  static final String _selectedWantAdIdKey = "selectedWantAdId";
  //static String _apiAddress = "https://localhost:5001/api/";
  static final String _fullNameKey = "fullName";
  static final String _endDateKey = "endDate";
  static final String _memberExperienceModel = "memberExperienceModel";
  final bool login = false;

  static Future<bool> getIsLoginNonAsync() async{
    String tokenStr = await getTokenKey();
    if(tokenStr.trim().length > 0 ){
      return true;
    }else{
      return false;
    }
  }

  static Future<bool> getIsLogin() async{
    String tokenStr = await getTokenKey();
    if(tokenStr.trim().length > 0 ){
      return true;
    }else{
      return false;
    }
  }

  static Future setMemberExperienceModel(MemberExperienceModel memberExperienceModel) async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var experienceMap =  memberExperienceModel.toJson();
    _prefs.setString(_memberExperienceModel,  convert.jsonEncode(experienceMap)).then((bool success) {
      return success;
    });
  }

  static Future<MemberExperienceModel> getMemberExperience() async{
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    var strJson =  preferences.getString(_memberExperienceModel) ?? "";
    var mapFromStr = convert.json.decode(strJson);
    return MemberExperienceModel.fromJson(mapFromStr);
  }

  static Future<String> getFullName() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(_fullNameKey) ?? "";
  }

  static Future setFullName(String fullName) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString(_fullNameKey, fullName).then((bool success) {
      return success;
    });
  }

  static Future<DateTime> getEndDate() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return DateTime.parse(preferences.getString(_endDateKey) ?? "");
  }

  static Future setEndDate(String endDate) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString(_endDateKey, endDate).then((bool success) {
      return success;
    });
  }

  static Future<int> getSelectedCategoryId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_categoryKey) ?? 0;
  }

  static Future<int> getSelectedWantAdId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_selectedWantAdIdKey) ?? 0;
  }

  static Future setSelectedWantAdId(int? wantAdId) async {
    if (wantAdId != null) {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      preferences.setInt(_selectedWantAdIdKey, wantAdId).then((bool success) {
        return success;
      });
    } else {
      return false;
    }
  }

  static Future setSelectedCategoryId(int? categoryId) async {
    if (categoryId != null) {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      preferences.setInt(_categoryKey, categoryId).then((bool success) {
        return success;
      });
    } else {
      return false;
    }
  }

  static String getApiAddress() {
    return _apiAddress;
  }

  static Future<String> getTokenKey() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey) ?? "";
  }



  static Future<bool> removeTokenKey() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(_tokenKey).then((bool success) {
      return success;
    });
  }

  static Future setTokenKey(String tokenKey) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString(_tokenKey, tokenKey).then((bool success) {
      return success;
    });
  }

  static Future<int> getSelectedMemberId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getInt(_selectedMemberId) ?? 0;
  }

  static Future<bool> removeSelectedMemberId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(_selectedMemberId).then((bool success) {
      return success;
    });
  }

  static Future<int> getCurrentUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getInt(_currentUserId) ?? 0;
  }

  static Future<bool> removeCurrentUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(_currentUserId).then((bool success) {
      return success;
    });
  }

  static Future<int> getStaffTypeId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getInt(_staffTypeId) ?? 0;
  }

  static Future<bool> removeStaffTypeId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(_staffTypeId).then((bool success) {
      return success;
    });
  }

  static Future setSelectedMemberId(int memberId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt(_selectedMemberId, memberId).then((bool success) {
      return success;
    });
  }

  static Future setCurrentUserId(int userId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt(_currentUserId, userId).then((bool success) {
      return success;
    });
  }

  static Future setStaffTypeId(int staffTypeId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt(_staffTypeId, staffTypeId).then((bool success) {
      return success;
    });
  }

  static Future<String> getRefreshToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshToken) ?? "";
  }

  static Future setRefreshTokenKey(String refreshToken) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString(_refreshToken, refreshToken).then((bool success) {
      return success;
    });
  }

  static Future removeRefreshTokenKey() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.remove(_refreshToken).then((bool success) {
      return success;
    });
  }
}
