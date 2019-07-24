#ifndef CREDENTIALS_H
#define CREDENTIALS_H

//**********!!!OBS KEEP THIS FILE SECURE!!!**********

// Salesforce credentials
String consumerSecret = "CHANGE THIS"; // Consumer Secret from the Connected App in Salesforce
String consumerKey = "CHANGE THIS"; // Consumer Key from the Connected App in Salesforce
String userUsername = "CHANGE THIS"; // Username of the integration user in Salesforce
String userPassword = "CHANGE THIS"; // Password of the integration user in Salesforce
String securityToken = "CHANGE THIS"; // Security Token of the integration user in Salesforce
// Wi-Fi credentials
const char* ssid = "CHANGE THIS"; // Your WiFi name
const char* password = "CHANGE THIS"; // Your WiFi password
// SHA1 fingerprint of the certificate
const char fingerprint[] PROGMEM = "CHANGE THIS"; // Fingerprint of login.salesforce.com
const char myfingerprint[] PROGMEM = "CHANGE THIS"; // Fingerprint of your Salesforce domain

//**********!!!OBS KEEP THIS FILE SECURE!!!**********

#endif