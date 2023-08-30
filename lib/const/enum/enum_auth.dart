import 'package:firebase_auth/firebase_auth.dart';

enum EnumMethodAuthID {
  google,
  apple,
  nenhum,
}

extension AuthIDExtension on EnumMethodAuthID {
  String get descricao {
    switch (this) {
      case EnumMethodAuthID.google:
        return googleAuthProviderID;
      case EnumMethodAuthID.apple:
        return appleAuthProviderID;
      default:
        return '';
    }
  }
}

const String googleAuthProviderID = 'google.com';
const String emailAuthProviderID = 'password';
const String twitterAuthProviderID = 'twitter.com';
const String phoneAuthProviderID = 'phone';
const String appleAuthProviderID = 'apple.com';
const String facebookAuthProviderID = 'facebook.com';
const String microsoftAuthProviderID = 'hotmail.com';
const String gitHubAuthProviderID = 'github.com';
const String yahooAuthProviderID = 'yahoo.com';

extension FirebaseUserAuth on UserInfo {
  EnumMethodAuthID get methodLogin {
    switch (providerId) {
      case googleAuthProviderID:
        return EnumMethodAuthID.google;
      case appleAuthProviderID:
        return EnumMethodAuthID.apple;
      default:
        return EnumMethodAuthID.nenhum;
    }
  }
}
