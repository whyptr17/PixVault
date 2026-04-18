class AppConfig {
  static const String imgbbApiKey = String.fromEnvironment('IMGBB_API_KEY', defaultValue: 'fc29833618c280bea1eb6898d7b45488');
  static const String appName = 'PixVault';
  
  // ImgBB endpoints
  static const String imgbbUploadEndpoint = 'https://api.imgbb.com/1/upload';
}
