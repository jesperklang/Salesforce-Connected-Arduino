public class readingsNightlyProcess implements Schedulable {
    public void execute(SchedulableContext ctx) {
        // Converts all yesterdays IoT Readings into a Daily Summary
        readingsHandler.createDailySummaries();
        // Deletes all Daily Summaries older than 90 days
        readingsHandler.deleteOldSummaries();
    }
}