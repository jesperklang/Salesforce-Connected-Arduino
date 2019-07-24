@isTest private class SensorWebServiceTest {
    @testSetup private static void setup() {
        IoT_Device__c device = new IoT_Device__c(
            Device_ID__c = 'TEST123',
            Temperature__c = 23,
            Humidity__c = 20);
        insert device;
    }
    
    @isTest private static void testGoodData() {
        Test.startTest();
        String textResult = SensorWebService.postReading('TEST123', 24, 21);
        Test.stopTest();
        IoT_Device__c result = [SELECT Temperature__c, Humidity__c, (SELECT Reading_error__c FROM IoT_Readings__r) FROM IoT_Device__c];
        System.assertEquals('Reading successful', textResult);
        System.assertEquals(24, result.Temperature__c);
        System.assertEquals(21, result.Humidity__c);
        System.assertEquals(false, result.IoT_Readings__r[0].Reading_error__c);
    }
    @isTest private static void testBadData1() {
        Test.startTest();
        String textResult = SensorWebService.postReading('TEST123', 0, 21);
        Test.stopTest();
        IoT_Device__c result = [SELECT Temperature__c, Humidity__c, (SELECT Reading_error__c FROM IoT_Readings__r) FROM IoT_Device__c];
        System.assertEquals('Reading successful', textResult);
        System.assertEquals(0, result.Temperature__c);
        System.assertEquals(21, result.Humidity__c);
        System.assertEquals(true, result.IoT_Readings__r[0].Reading_error__c);
    }
    @isTest private static void testBadData2() {
        Test.startTest();
        String textResult = SensorWebService.postReading('TEST123', 24, 0);
        Test.stopTest();
        IoT_Device__c result = [SELECT Temperature__c, Humidity__c, (SELECT Reading_error__c FROM IoT_Readings__r) FROM IoT_Device__c];
        System.assertEquals('Reading successful', textResult);
        System.assertEquals(24, result.Temperature__c);
        System.assertEquals(0, result.Humidity__c);
        System.assertEquals(true, result.IoT_Readings__r[0].Reading_error__c);
    }
    @isTest private static void testBadData3() {
        Test.startTest();
        String textResult = SensorWebService.postReading('TEST123', 0, 0);
        Test.stopTest();
        IoT_Device__c result = [SELECT Temperature__c, Humidity__c, (SELECT Reading_error__c FROM IoT_Readings__r) FROM IoT_Device__c];
        System.assertEquals('Reading successful', textResult);
        System.assertEquals(0, result.Temperature__c);
        System.assertEquals(0, result.Humidity__c);
        System.assertEquals(true, result.IoT_Readings__r[0].Reading_error__c);
    }
}