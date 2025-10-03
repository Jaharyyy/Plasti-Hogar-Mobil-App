class ServicesConfig {
String method;
Map<String, String>? headers;
String? authToken;
Map<String, dynamic>? body;

ServicesConfig({
this.method = 'GET',
this.headers,
this.authToken,
this.body,
}) {
  headers ??= {
    'Content-Type': 'application/json; charset=utf-8',
    'Accept': 'application/json',};
if (authToken != null) {
headers!['Authorization'] ='Bearer $authToken';
}
}
}