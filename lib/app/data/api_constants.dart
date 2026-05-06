class ApiConstants {
  static String baseUrl = 'https://interview.nuraemobility.co.in';
  static String socUrl = 'wss://interview.nuraemobility.co.in';

  static String healthCheckUrl = '/health';
  static String getMessageUrl = '/messages';
  static String resetMessageUrl = '/reset';
  static String socketUrl = '$socUrl/ws?token=${ApiConstants.token}';
  static String token = 'mercatllidog2fo8r78i';
}
