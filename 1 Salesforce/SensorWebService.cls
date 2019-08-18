@RestResource(urlMapping='/Sensor/v1')
global with sharing class SensorWebService {
    @HttpPost
    global static String postReading(String deviceId, Decimal temp, Decimal humid) {
        IoT_Device__c device = new IoT_Device__c(
            Device_ID__c = deviceId,
            Temperature__c = temp,
            Humidity__c = humid);
        upsert device Device_ID__c;

        insert new IoT_Reading__c(
            IoT_Device__c = device.id,
            Temperature__c = temp,
            Humidity__c = humid,
            Reading_error__c = (temp == 0 || humid == 0));
        
        return 'Reading successful';
    }
}