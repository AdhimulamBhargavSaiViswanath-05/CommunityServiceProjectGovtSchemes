// SECURITY WARNING: In production, move these API keys to environment variables or secure storage
// Never commit API keys to version control. Use dart-define or .env files instead.
const String baseUrl = "https://api.myscheme.gov.in/schemes/v5/public/schemes";
const String apiKey = "tYTy5eEhlu9rFjyxuCr7ra7ACp4dv1RH8gWuHTDc";

const String weatherApiKey = "57e4c3580b0b4c31dfe89f2bb19e194a";
const String geminiApiKey = "AIzaSyB5PBt_MzNx1A9THDK90wW3XRogmZshsiM";

const String weatherBaseUrl =
    "https://api.openweathermap.org/data/2.5/weather?";

const List<String> corsProxies = [
  "https://api.allorigins.win/raw?url=",
  "https://corsproxy.io/?",
  "https://proxy.cors.sh/",
  "", // Direct connection
];

Map<String, String> getHeaders(int proxyIndex) {
  if (proxyIndex == 2) {
    return {
      "x-cors-api-key": "temp_0b999eb0a2c7c86d9c7d5d8c5e4f5c0a",
      "accept": "application/json",
    };
  }
  return {
    "accept": "application/json, text/plain, */*",
    "x-api-key": apiKey,
    "origin": "https://www.myscheme.gov.in",
  };
}
