//
//  CreateTrafficMessageInterfaceController.swift
//  RoadChatWatch Extension
//
//  Created by Malcolm Malam on 16.05.18.
//  Copyright © 2018 Niklas Sauer. All rights reserved.
//

import Foundation
import WatchKit
import RoadChatKitWatch
import WatchConnectivity

class CreateTrafficMessageInterfaceController: WKInterfaceController, WCSessionDelegate {
    
    // MARK: - Private Properties
    private var session: WCSession?

    // MARK: - Initialization
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        session = WCSession.default
        session?.delegate = self
        session?.activate()
        
        // Configure interface objects here.
    }
    
    // MARK: - Private Methods
    @IBAction private func jamButtonPressed() {
        sendTrafficMessage(type: .jam)
        self.pop()
    }
    
    @IBAction private func accidentButtonPressed() {
        sendTrafficMessage(type: .accident)
        self.pop()
    }
    
    @IBAction private func dangerButtonPressed() {
        sendTrafficMessage(type: .danger)
        self.pop()
    }
    
    @IBAction private func detourButtonPressed() {
        sendTrafficMessage(type: .detour)
        self.pop()
    }
    
    private func sendTrafficMessage(type: TrafficType) {
        session?.sendMessage(["type" : type.rawValue], replyHandler: { response in
            // handle response from iPhone
            print(response)
            if (response["type"] as? String == "success") {
                self.presentAlert(withTitle: "Success", message: "Trafficmessage was successfully posted", preferredStyle: .alert, actions: [WKAlertAction(title: "OK", style: .default){
                    //something after clicking OK
                    }])
            } else {
                self.presentAlert(withTitle: "Error", message: "Trafficmessage failed", preferredStyle: .alert, actions: [WKAlertAction(title: "OK", style: .default){
                    //something after clicking OK
                    }])
            }
        })
        print("sent message to iPhone: \(type.rawValue)")
    }
    
    // MARK: - WCSessionDelegate
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("session active")
    }
    
}
