#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>

#define sensorIn 34
#define mVperAmp 90                                    // this the 5A version of the ACS712 -use 100 for 20A Module and 66 for 30A Module

#define SETUP_NAME "Repoco Sensor"
#define SERVICE_UUID "EBC0FCC1-2FC3-44B7-94A8-A08D0A0A5079"
#define CHARACTERISTIC_UUID_RX "C1AB2C55-7914-4140-B85B-879C5E252FE5"
#define CHARACTERISTIC_UUID_TX "643954A4-A6CC-455C-825C-499190CE7DB0"

BLEServer *pServer = NULL;
BLECharacteristic *pTxCharacteristic;

void setup() {
  // put your setup code here, to run once:
  setupBLE(SERVICE_UUID);

  Serial.begin (115200); 
  Serial.println("ACS712 current sensor"); 
  pinMode(sensorIn, INPUT);
}

void loop() {
  double Voltage = getVPP();
  double VRMS = (Voltage/2.0) *0.707;
  double AmpsRMS = ((VRMS * 1000)/mVperAmp)-0.7; //0.3 is the error I got for my sensor
  /*
  if (AmpsRMS < 0.2) {
    AmpsRMS = 0;
  }
  */
  int Watt = (AmpsRMS*240/1.2); // note: 1.2 is my own empirically established calibration factor, as the voltage measured at D34 depends on the length of the OUT-to-D34 wire 240 is the main AC power voltage – this parameter changes locally

  Serial.println (""); 
  Serial.print(AmpsRMS);
  Serial.print(" Amps RMS  ---  ");
  Serial.print(Watt);
  Serial.println(" Watts");
  sendData(String(Watt));
  delay(100);
}
