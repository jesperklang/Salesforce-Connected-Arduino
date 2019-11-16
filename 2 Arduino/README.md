# :rocket: Arduino instructions

## :unlock: Preperation

### 1. First we need to Download Arduino and set up the Boards [*more info*](https://github.com/esp8266/Arduino)
- Install the current upstream Arduino IDE at the 1.8.7 level or later. The current version is on the [Arduino website](https://www.arduino.cc/en/main/software).
- Start Arduino and open the Preferences window.
- Enter ```https://arduino.esp8266.com/stable/package_esp8266com_index.json``` into the *Additional Board Manager URLs* field. You can add multiple URLs, separating them with commas.
- Open Boards Manager from Tools > Board menu and install *esp8266* platform (and don't forget to select your ESP8266 board from Tools > Board menu after installation).

### 2. Install the ArduinoJson library [*more info*](https://arduinojson.org/)
- Search for ```ArduinoJson``` in Library Manager from Tools > Manage Libraries
- Install the latest version of **ArduinoJson** by **Benoit Blanchon**

### 3. Install the DHT sensor library [*more info*](https://github.com/adafruit/DHT-sensor-library)
- Search for ```DHT sensor library``` in Library Manager from Tools > Manage Libraries
- Install the latest version of **DHT sensor library** by **Adafruit**
- If prompted whether you also want to install other library dependencies, click **Install all**


## :computer: The code