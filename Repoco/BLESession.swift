import Foundation
import CoreBluetooth

class BLESession: NSObject, ObservableObject {
    
    // Internal State Variables
    private let serviceUUID = CBUUID(string: "EBC0FCC1-2FC3-44B7-94A8-A08D0A0A5079")
    private let rxCharacteristicUUID = CBUUID(string: "C1AB2C55-7914-4140-B85B-879C5E252FE5")
    private let txCharacteristicUUID = CBUUID(string: "643954A4-A6CC-455C-825C-499190CE7DB0")
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral?
    private var lastDiscoveredPeripheral: CBPeripheral?
    private var rxCharacteristic: CBCharacteristic?
    private var txCharacteristic: CBCharacteristic?
    private var wantedToWrite: String? = nil
    private var discovering = true
    private var localName: String?
    private let rediscoveringDuration = 1
    
    @Published var peripheralConnected = false
    @Published var watts: String?
    
    override init() {
        super.init()
        
        // Start Bluetooth Interface of the Phone
        centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
    }
    
    deinit {
        centralManager.stopScan()
    }
}

// Implementation of CBCentralManagerDelegate
extension BLESession: CBCentralManagerDelegate {
    
    // Handles main State Changes of the Bluetooth Interface
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        // Start Scanning as soon as Bluetooth Interface is powered on
        switch central.state {
        case .poweredOn:
            scanForPeripherals()
        case .poweredOff:
            return
        case .resetting:
            return
        case .unauthorized:
            return
        case .unknown:
            return
        case .unsupported:
            return
        @unknown default:
            return
        }
    }
    
    // Handles discovered Peripherals
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        
        // Do not trigger for the same Peripheral twice
        if discovering && peripheral != lastDiscoveredPeripheral {
            lastDiscoveredPeripheral = peripheral
            
            // Connect to peripheral and (re)set State Variables if peripheralDiscovered() evaluates to true
            if let localName = ((advertisementData as NSDictionary).value(forKey: "kCBAdvDataLocalName")) as? String {
                self.localName = localName
                discovering = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.discovering = true
                }
                centralManager.connect(peripheral, options: nil)
            
            // Reset State Variables after a while, to accomodate for the local Name being sometimes discovered later
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(rediscoveringDuration)) {
                    self.lastDiscoveredPeripheral = nil
                }
            }
        }
    }
    
    // Handles connected Peripheral
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        // Stop scanning and reset State Variables
        centralManager.stopScan()
        lastDiscoveredPeripheral = nil
        
        // Set local Reference to peripheral and initate Service Discovery and RSSI Retrieval
        self.peripheral = peripheral
        self.peripheral!.delegate = self
        self.peripheral!.discoverServices([serviceUUID])
        
        peripheralConnected = true
    }
    
    // Handles failed Connection Attempt
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        
        // Reset State Variables
        localName = nil
        cleanup(peripheral)
    }
    
    // Handles disconnected Peripheral
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
        // Update State Variables and output Disconnect-Event
        self.peripheral = nil
        peripheralConnected = false
        watts = nil
        localName = nil
        
        scanForPeripherals()
    }
}

// Implementation of CBPeripheralDelegate
extension BLESession: CBPeripheralDelegate {
    
    // Handles invalidated Services
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        
        // Try to rediscover the invalidates Services
        for service in invalidatedServices where service.uuid == serviceUUID {
            peripheral.discoverServices([serviceUUID])
        }
    }
    
    // Handles discovered Services
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if error != nil {
            cleanup(peripheral)
            return
        }
        
        // Discover Charachteristics for discovered Services
        guard let peripheralServices = peripheral.services else { return }
        for service in peripheralServices {
            peripheral.discoverCharacteristics([rxCharacteristicUUID, txCharacteristicUUID], for: service)
        }
    }
    
    // Handles discovered Characteristics
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?)  {
        if error != nil {
            cleanup(peripheral)
            return
        }
        
        // Create local References and Notification Events for discovered Services
        guard let serviceCharacteristics = service.characteristics else { return }
        for characteristic in serviceCharacteristics where characteristic.uuid == rxCharacteristicUUID {
            rxCharacteristic = characteristic
            peripheral.setNotifyValue(true, for: characteristic)
        }
        for characteristic in serviceCharacteristics where characteristic.uuid == txCharacteristicUUID {
            txCharacteristic = characteristic
            peripheral.setNotifyValue(true, for: characteristic)
        }
        
        // Retry sending Data if it failed before
        if let wantedToWrite = wantedToWrite {
            sendData(wantedToWrite)
            self.wantedToWrite = nil
        }
    }
    
    // Handles Notification for updated Charachteristic-Value
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            cleanup(peripheral)
            return
        }
        
        // Retreive Value and convert to String
        guard let value = characteristic.value else { return }
        let stringValue = String(decoding: value, as: UTF8.self)
        
        watts = stringValue
    }
    
    // Handles new Notification State of a Characteristic
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            return
        }
        
        // Call cleanup() if a Characteristic stops notifying
        if !characteristic.isNotifying {
            cleanup(peripheral)
        }
    }
}

// Helper and Interaction Functions
extension BLESession {
    
    // Starts the Scan for Peripherals
    private func scanForPeripherals() {
        
        // Restrict Scan to the given ServiceUUID
        let _: [CBPeripheral] = (centralManager.retrieveConnectedPeripherals(withServices: [serviceUUID]))
        
        // Start Scan
        centralManager.scanForPeripherals(withServices: [serviceUUID],
                                          options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
    }
    
    // Sends String to Peripheral
    func sendData(_ data: String) {
        
        // Do not send Data, if no Peripheral is connected or no Characteristic is discovered
        guard let peripheral = peripheral, let rxCharacteristic = rxCharacteristic else {
            wantedToWrite = data
            return
        }
        
        // Encode given String using UTF8 and send it via rxCharacteristic
        let packetData = (data as NSString).data(using: String.Encoding.utf8.rawValue)
        peripheral.writeValue(packetData!, for: rxCharacteristic, type: .withResponse)
    }
    
    // Ends Connection to the Peripheral
    private func cleanup(_ peripheral: CBPeripheral) {
        guard case .connected = peripheral.state else { return }
        
        // Go through every Characteristic of every Service and stop Notifications
        for service in (peripheral.services ?? [] as [CBService]) {
            for characteristic in (service.characteristics ?? [] as [CBCharacteristic]) {
                if characteristic.uuid == rxCharacteristicUUID && characteristic.isNotifying {
                    peripheral.setNotifyValue(false, for: characteristic)
                }
            }
        }
        
        // Disconnect from the Peripheral
        centralManager.cancelPeripheralConnection(peripheral)
    }
    
    // Stops the entire Bluetooth Interface
    func stop() {
        centralManager.stopScan()
    }
}
