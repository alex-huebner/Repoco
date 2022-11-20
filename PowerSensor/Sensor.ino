float getVPP() {
  float result;
  int readValue;                // value read from the sensor
  int maxValue = 0;             // store max value here
  int minValue = 4096;          // store min value here ESP32 ADC resolution
  
  unsigned long start_time = millis();
  while ((millis() - start_time) < 1000) {
    readValue = analogRead(sensorIn);
    //Serial.print("Raw Value: ");
    //Serial.println(readValue);
    if (readValue > maxValue) {
      maxValue = readValue;
    }
    if (readValue < minValue) {
      minValue = readValue;
    }
  }
   
   result = ((maxValue - minValue) * 3.3)/4096.0; //ESP32 ADC resolution 4096
      
   return result;
}
