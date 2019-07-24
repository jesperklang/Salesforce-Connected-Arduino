#include <Adafruit_Sensor.h>
#include <DHT.h>
#include <DHT_U.h>

#include "credentials.h"

#include <ESP8266WiFi.h>
#include <WiFiClientSecure.h>

#include <ArduinoJson.h>

#define DHTPIN 2
#define DHTTYPE    DHT21

const char* authHost = "login.salesforce.com";
const int httpsPort = 443;

DHT_Unified dht(DHTPIN, DHTTYPE);

int delayMS = 300000;
String deviceId = "SEN00001"; // If you have multiple devives, this needs to be different for each one
String token;
String instance;

void setup() {
  Serial.begin(115200); // Initialize device.
  dht.begin(); // Initialize sensors
  Serial.println();
  Serial.printf("Connecting to %s", ssid);
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password); // Connect to Wifi
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println(" WiFi connected!");
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());
  auth();
}

void loop() {
  float temp;
  float humid;
  sensors_event_t event;
  // Get temperature event and print its value.
  dht.temperature().getEvent(&event);
  if (isnan(event.temperature)) {
    Serial.println("Error reading temperature!");
  } else {
    temp = event.temperature;
  }
  // Get humidity event and print its value.
  dht.humidity().getEvent(&event);
  if (isnan(event.relative_humidity)) {
    Serial.println(F("Error reading humidity!"));
  } else {
    humid = event.relative_humidity;
  }
  if (token) {
    sendReading(temp, humid);
  } else {
    Serial.println("No token! Re-authenticating in 5 min");
    delay(delayMS);
    auth();
  }
  
  // Delay between measurements.
  delay(delayMS);
}

void sendReading(float temp, float humid) {
  WiFiClientSecure client;
  String requestBody;
  
  Serial.print("Connecting to ");
  Serial.print(instance);
  Serial.print("... ");

  client.setFingerprint(myfingerprint);
  
  if (!client.connect(instance, httpsPort)) {
    Serial.println("Connection failed... check the fingerprint.");
    return;
  } else {
    Serial.println("Connected!");
  }

  //Create json and store it in requestBody
  StaticJsonDocument<200> doc;
  doc["deviceId"] = deviceId;
  doc["temp"] = temp;
  doc["humid"] = humid;
  serializeJson(doc, requestBody);
  
  client.println("POST /services/apexrest/Sensor/v1 HTTP/1.1");
  client.print("Host: ");
  client.println(instance);
  client.println("Content-Type: application/json");
  client.print("Authorization: Bearer ");
  client.println(token);
  client.print("Content-Length: ");
  client.println(requestBody.length());
  client.println();
  client.println(requestBody);

  Serial.print("Reading sent: ");
  Serial.println(requestBody);
  Serial.print("Waiting for result... ");

  while (client.connected()) {
    String line = client.readStringUntil('\n');
    if (line == "\r") {
      break;
    }
  }
  String line = client.readString();
  if (line.indexOf("Reading successful") != -1) {
    Serial.println("Success!");
    client.stop();
  } else {
    Serial.println("Failed!!");
    Serial.println("Re-authenticating");
    client.stop();
    auth();
  }
}

void auth() {
  WiFiClientSecure client;
  String requestBody = "grant_type=password&client_id=" + consumerKey + "&client_secret=" + consumerSecret + "&username=" + userUsername + "&password=" + userPassword + ;
  Serial.printf("Connecting to %s... ", authHost);
  client.setFingerprint(fingerprint);
  
  if (!client.connect(authHost, httpsPort)) {
    Serial.println("Connection failed...");
    return;
  } else {
    Serial.println("Connected!");
  }

  client.println("POST /services/oauth2/token HTTP/1.1");
  client.println("Host: login.salesforce.com");
  client.println("Content-Type: application/x-www-form-urlencoded");
  client.print("Content-Length: ");
  client.println(requestBody.length());
  client.println();
  client.println(requestBody);

  Serial.print("Authentication request sent. Waiting for result... ");
  while (client.connected()) {
    String line = client.readStringUntil('\n');
    if (line == "\r") {
      break;
    }
  }
  String line = client.readString();
  if (line.indexOf("\"access_token\":\"") != -1) {
    Serial.println("Success!");
    token = line.substring(line.indexOf("\"access_token\":\"") + 16, line.indexOf("\",\"instance_url\""));
    instance = line.substring(line.indexOf("\"instance_url\":\"") + 16 + 8, line.indexOf("\",\"id\""));
    Serial.println("Token and Instance stored!");
  } else {
    Serial.println("Failed!!");
  }

  client.stop();
}