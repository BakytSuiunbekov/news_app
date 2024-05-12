class ApiConst {
  static const String apiKey = '6a5af969bcad4a789016b3be82928d16';
  static const String api =
      'https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey';
  static String searchApi(String title) {
    return 'https://newsapi.org/v2/everything?q=$title&apiKey=$apiKey';
  }
}
