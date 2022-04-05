import './storage.dart';

class StorageController{

  static String getUserType() {
    var user = StorageService.get('userType', StorageType.stringType);
    if (user != null) {
      return user;
    } else {
      return '';
    }
  }


  static bool isAccessTokenValid() {
    var expiredDate = StorageService.get('accessTokenExpiredDate', StorageType.stringType);
    return DateTime.parse(expiredDate).isAfter(DateTime.now());
  }

  static bool isRefreshTokenValid() {
    var expiredDate = StorageService.get('refreshTokenExpiredDate', StorageType.stringType);
    return DateTime.parse(expiredDate).isAfter(DateTime.now());
  }

  static bool isAuthenticate(){
    var token = StorageService.get('accessToken', StorageType.stringType);
    if (token != null) {
      return true;
    } else {
      return false;
    }
  }

  static String getAccessToken() {
    var token = StorageService.get('accessToken', StorageType.stringType);
    if (token != null) {
      return token;
    } else {
      return '';
    }
  }

  static String getRefreshToken() {
    var token = StorageService.get('refreshToken', StorageType.stringType);
    if (token != null) {
      return token;
    } else {
      return '';
    }
  }


  static List<String> getSearchList() {
    var searchList = StorageService.get('searchList', StorageType.listType);
    if (searchList != null) {
      return searchList;
    } else {
      return [];
    }
  }




  static void setUserType(token) {
    StorageService.set('userType', token, StorageType.stringType);
  }

  static void setAccessToken(token) {
    StorageService.set('accessToken', token, StorageType.stringType);
  }

  static void setAccessTokenExpiredDate(date) {
    StorageService.set('accessTokenExpiredDate', date, StorageType.stringType);
  }

  static void setRefreshTokenExpiredDate(date) {
    StorageService.set('refreshTokenExpiredDate', date, StorageType.stringType);
  }

  static void setRefreshToken(token) {
    StorageService.set('refreshToken', token, StorageType.stringType);
  }


  static void setSearchList(searchList) {
    StorageService.set('searchList', searchList, StorageType.listType);
  }




  static void removeUserType() {
    StorageService.delete('userType');
  }

  static void removeAccessToken() {
    StorageService.delete('accessToken');
  }

  static void removeAccessTokenExpiredDate() {
    StorageService.delete('accessTokenExpiredDate');
  }

  static void removeRefreshTokenExpiredDate() {
    StorageService.delete('refreshTokenExpiredDate');
  }

  static void removeRefreshToken() {
    StorageService.delete('refreshToken');
  }


  static void removeSearchList() {
    StorageService.delete('searchList');
  }
}