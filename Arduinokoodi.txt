#include <Arduino_MKRIoTCarrier.h>
#include <SPI.h>
#include <WiFiNINA.h>

MKRIoTCarrier carrier;

// Vaihda omat tiedot
char ssid[] = "ssid";
char pass[] = "salasana";

WiFiServer server(80);

const int sensorPin = A6;

char ipString[20];

void setup() {

  Serial.begin(9600);

  if (WiFi.status() == WL_NO_MODULE) {
    Serial.println("WiFi-moduulia ei löydy!");
    while (true);
  }


  while (WiFi.begin(ssid, pass) != WL_CONNECTED) {
  
    delay(5000);
  }

  // Hae IP-osoite
  IPAddress ip = WiFi.localIP();

  // Muodosta IP merkkijonoksi näyttöä varten
  sprintf(ipString, "%d.%d.%d.%d",
          ip[0],
          ip[1],
          ip[2],
          ip[3]);

  server.begin();

  carrier.begin();

  carrier.display.fillScreen(ST77XX_BLACK);
  carrier.display.setTextColor(ST77XX_WHITE);
  carrier.display.setTextSize(2);
}

void loop() {

  int raw = analogRead(sensorPin);

  int moisture = map(raw, 850, 350, 0, 100);
  moisture = constrain(moisture, 0, 100);

  float temperature = carrier.Env.readTemperature();


  int compost = 100;

  if (temperature < 30)
    compost = 30;
  else if (moisture < 50)
    compost = 60;

  carrier.display.fillScreen(ST77XX_BLACK);

  carrier.display.setTextColor(ST77XX_WHITE);
  carrier.display.setTextSize(2);

  carrier.display.setCursor(70,20);
  carrier.display.print("Komposti");

  carrier.display.setCursor(55,60);
  carrier.display.print("Lampo:");
  carrier.display.print(temperature,1);
  carrier.display.print(" C");

  carrier.display.setCursor(70,110);
  carrier.display.print("Kosteus:");
  carrier.display.print(moisture);
  carrier.display.print("%");

  carrier.display.setTextSize(2); //jos ip osoite ei näy kokonaan näytöllä, vaihda tekstin koko = 1
  carrier.display.setCursor(35,160); 
  carrier.display.print("IP:");
  carrier.display.print(ipString);

  // Web-palvelin

  WiFiClient client = server.available();

  if (client) {

    while (client.connected() && !client.available())
      delay(1);

    String request = client.readStringUntil('\r');
    client.flush();

    if (request.indexOf("GET /data") >= 0) {

      client.println("HTTP/1.1 200 OK");
      client.println("Content-Type: application/json");
      client.println("Access-Control-Allow-Origin: *");
      client.println("Connection: close");
      client.println();

      client.print("{");

      client.print("\"temperature\":");
      client.print(temperature,1);

      client.print(",");

      client.print("\"humidity\":");
      client.print(moisture);

      client.print(",");

      client.print("\"compost\":");
      client.print(compost);

      client.print("}");

    } else {

      client.println("HTTP/1.1 404 Not Found");
      client.println("Connection: close");
      client.println();
    }

    client.stop();
  }

  delay(1000);
}
