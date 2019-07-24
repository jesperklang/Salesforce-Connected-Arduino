@isTest private class readingsNightlyProcessTest {
    @testSetup private static void setup() {
        List<IoT_Device__c> devices = new List<IoT_Device__c>();
        List<IoT_Reading__c> readings = new List<IoT_Reading__c>();
        devices.add(new IoT_Device__c(
            name='Device 1',
            Device_ID__c = 'ABC1'
        ));
        devices.add(new IoT_Device__c(
            name='Device 2',
            Device_ID__c = 'ABC2'
        ));
        insert devices;

        // Creating readings for Device 1
        for (Integer i = 0; i < 3; i++) {
            readings.add(new IoT_Reading__c(
                IoT_Device__c = devices[0].id,
                Humidity__c = (i + 1) * 2,
                Temperature__c = i + 1
            ));
        }
        // Creating readings for Device 2
        for (Integer i = 0; i < 3; i++) {
            readings.add(new IoT_Reading__c(
                IoT_Device__c = devices[1].id,
                Humidity__c = i + 1,
                Temperature__c = (i + 1) * 2
            ));
        }
        insert readings;
        for (IoT_Reading__c r : readings) {
            Test.setCreatedDate(r.id, DateTime.now() - 1);
        }
    }
    @isTest private static void test1() {
        Test.startTest();
        SchedulableContext sc = null;
        readingsNightlyProcess rNP = new readingsNightlyProcess();
        rNP.execute(sc);
        Test.stopTest();
        List<IoT_Daily_Summary__c> dailies = [SELECT IoT_Device__r.Name, Avg_Humidity__c, Avg_Temperature__c, Max_Humidity__c, Max_Temperature__c, Min_Humidity__c, Min_Temperature__c FROM IoT_Daily_Summary__c];
        System.assertEquals(2, dailies.size());
        for (IoT_Daily_Summary__c d : dailies) {
            if (d.IoT_Device__r.Name == 'Device 1') {
                System.assertEquals(d.Avg_Humidity__c, 4);
                System.assertEquals(d.Avg_Temperature__c, 2);
                System.assertEquals(d.Max_Humidity__c, 6);
                System.assertEquals(d.Max_Temperature__c, 3);
                System.assertEquals(d.Min_Humidity__c, 2);
                System.assertEquals(d.Min_Temperature__c, 1);
            } else if (d.IoT_Device__r.Name == 'Device 2') {
                System.assertEquals(d.Avg_Humidity__c, 2);
                System.assertEquals(d.Avg_Temperature__c, 4);
                System.assertEquals(d.Max_Humidity__c, 3);
                System.assertEquals(d.Max_Temperature__c, 6);
                System.assertEquals(d.Min_Humidity__c, 1);
                System.assertEquals(d.Min_Temperature__c, 2);
            }
        }
    }
}