public class readingsHandler {
    public static void createDailySummaries() {
        // Converts all yesterdays IoT Readings into a Daily Summary
        List<IoT_Daily_Summary__c> toInsert = new List<IoT_Daily_Summary__c>();
        List<IoT_Reading__c> toBeDeleted = new List<IoT_Reading__c>();
        for (IoT_Device__c d :[SELECT Id, (SELECT Humidity__c, Temperature__c, Reading_error__c FROM IoT_Readings__r WHERE CreatedDate = YESTERDAY) FROM IoT_Device__c]) {
            // Adds all Readings to this list. Used for deletion
            List<IoT_Reading__c> tempReadings = new List<IoT_Reading__c>();
            Decimal maxTemp = 0, minTemp = 100, avgTemp = 0, maxHumid = 0, minHumid = 100, avgHumid = 0;
            // Counts only Readings without a Reading error, so we can calculate a correct average humidity and temperature
            Integer readingsCount = 0;
            for (IoT_Reading__c r : d.IoT_Readings__r) {
                tempReadings.add(r);
                if (!r.Reading_error__c) {
                    maxTemp = math.max(maxTemp, r.Temperature__c);
                    minTemp = math.min(minTemp, r.Temperature__c);
                    // To be devided with number of readings wo Reading Error
                    avgTemp += r.Temperature__c;
                    maxHumid = math.max(maxHumid, r.Humidity__c);
                    minHumid = math.min(minHumid, r.Humidity__c);
                    // To be devided with number of readings wo Reading Error
                    avgHumid += r.Humidity__c;
                    readingsCount++;
                }
            }
            // Only create a Daily Summary it there are any readings wo an error
            if (readingsCount > 0) {
                // Divides with number of readings wo a Reading Error
                avgTemp = avgTemp / readingsCount;
                avgHumid = avgHumid / readingsCount;
                
                IoT_Daily_Summary__c tempDaily = new IoT_Daily_Summary__c(
                    IoT_Device__c = d.Id,
                    Date__c = Date.today() - 1,
                    Avg_Humidity__c = avgHumid,
                    Avg_Temperature__c = avgTemp,
                    Max_Humidity__c = maxHumid,
                    Max_Temperature__c = maxTemp,
                    Min_Humidity__c = minHumid,
                    Min_Temperature__c = minTemp
                );
                toInsert.add(tempDaily);
            }
            toBeDeleted.addAll(tempReadings);
        }
        if (!toInsert.isEmpty()) {
            insert toInsert;
        }
        if (!toBeDeleted.isEmpty()) {
            delete toBeDeleted;
        }
    }
    // Deletes all Daily Summaries older than 90 days
    public static void deleteOldSummaries() {
        List<IoT_Daily_Summary__c> toDelete = [SELECT Id, Date__c FROM IoT_Daily_Summary__c WHERE Date__c < LAST_N_DAYS:90];
        if (!toDelete.isEmpty()) {
            delete toDelete;
        }
    }
}