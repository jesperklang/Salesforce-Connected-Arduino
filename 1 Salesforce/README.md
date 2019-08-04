# :cloud: Salesforce instructions

## Installation

### 1. Intall the package
Install [this package](https://login.salesforce.com/packaging/installPackage.apexp?p0=04t4H000000CfLE), which contains all the code, objects, fields etc.
> Note that this is an unmanaged package and has not gone through Salesforce's security review. You shouldn't install packages from people you don't trust.

### 2. Create a Connected App
You need to create a Connected App that the IoT device will use when logging in.
1. Search for **App Manager** in Setup (Lightning)
2. Click the **New Connected App** button
3. Populate/check the fields seen on the **picture below**
4. Write down the **Consumer Key** and **Consumer Secret**. You will need them for the code in your Iot device
> Note that it will take 5-10 min until the Connected App can be used
<img src="https://www.jesperklang.com/visuals/1_Microcontroller_to_Salesforce/Connected_App.png"/>

### 3. Create a Scheduled Job
You will need to activate the Scheduled Apex yourself, and to do so, you simply:
1. Search for **Apex Classes** in Quick Find
2. Click the **Schedule Apex** button
3. Give it a **name**, select the **readingsNightlyProcess** class in the **Apex Class** field, and select all the days of the week. Set the preferred time to 12:00 AM, and before saving, be sure to set an End date that is far ahead in the future.
4. Hit **Save**, and you're done!

## Schema
<img src="https://www.jesperklang.com/visuals/1_Microcontroller_to_Salesforce/Schema_Builder.png"/>

### IoT Device
A record of this object is created for every device you have. Every device needs to have an unique External ID, that is sent to your org for every reading.

### IoT Reading
A record is created everytime a reading is sent up to Salesforce from the device. A IoT Device is always the parent. You can set up each device to create the reading in Salesforce with the interval that you want. All IoT Readings are deleted each night, and is replaced with a IoT Daily Summary to save on data storage.

### IoT Daily Summary
The Scheduled Job you created above, runs some code every night that looks at all the IoT Reading from the previous day and creates a IoT Daily Summary record with minimum, average and maximum values for both the humidity and temperature. After the IoT Daily Summary record has been created for every device, all the readings is deleted, to save on data storage.