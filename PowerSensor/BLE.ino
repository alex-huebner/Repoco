class MyServerCallbacks : public BLEServerCallbacks {
  void onConnect(BLEServer *pServer) {
    BLEDevice::startAdvertising();
  }

  void onDisconnect(BLEServer *pServer) { }
};

class MyCallbacks : public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic *pCharacteristic) {

    // Retreive received String
    std::string rxValue = pCharacteristic->getValue();
    String payload = "";
    if (rxValue.length() > 0) {
      for (int i = 0; i < rxValue.length(); i++) {
        payload += rxValue[i];
      }
      Serial.println("Received via BLE: " + payload);
      receivedData(payload);
    }
  }
};

void setupBLE(String serviceUUID) {

  // Convert Strings to Char Arrays
  char serviceUUIDChar[serviceUUID.length() + 1] = {0};
  serviceUUID.toCharArray(serviceUUIDChar, serviceUUID.length() +1);

  // Create BLE Device and Service
  BLEDevice::init(SETUP_NAME);
  pServer = BLEDevice::createServer();
  BLEService *pService = pServer->createService(serviceUUIDChar);

  // Create Characteristics
  pTxCharacteristic = pService->createCharacteristic(CHARACTERISTIC_UUID_TX, BLECharacteristic::PROPERTY_NOTIFY);
  BLECharacteristic *pRxCharacteristic = pService->createCharacteristic(CHARACTERISTIC_UUID_RX, BLECharacteristic::PROPERTY_WRITE);

  // Set Callbacks
  pServer->setCallbacks(new MyServerCallbacks());
  pRxCharacteristic->setCallbacks(new MyCallbacks());

  // Start Advertisment
  pService->start();
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(serviceUUIDChar);
  pAdvertising->setScanResponse(true);
  pAdvertising->setMinPreferred(0x06);
  pAdvertising->setMinPreferred(0x12);
  BLEDevice::startAdvertising();
}

void sendData(String content) {
  Serial.println("Send via BLE: " + content);
  pTxCharacteristic->setValue(content.c_str());
  pTxCharacteristic->notify();
}

void receivedData(String payload) {
  
}
