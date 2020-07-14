//
//  ContentView.swift
//  CoreHapticSample
//
//  Created by momosuke on 2020/07/14.
//  Copyright © 2020 momosuke. All rights reserved.
//

import SwiftUI
import CoreHaptics

struct ContentView: View {
    @State private var engine: CHHapticEngine?
        var body: some View {
            
            VStack {
                Text("Feel Haptic Feedback")
                    .onAppear(perform: prepareHaptics)
                    .onTapGesture(perform: complexSuccess)
            }
        }
        
        func HapticPlayer() {
            let engine = try! CHHapticEngine()
            try! engine.start()
            
            let audioEvent = CHHapticEvent(eventType: .audioContinuous, parameters: [
            CHHapticEventParameter(parameterID: .audioPitch, value: -0.15),
            CHHapticEventParameter(parameterID: .audioVolume, value: 1),
            CHHapticEventParameter(parameterID: .decayTime, value: 1),
            CHHapticEventParameter(parameterID: .sustained, value: 0)
            ], relativeTime: 0)
            let hapticEvent = CHHapticEvent(eventType: .hapticTransient, parameters: [
            CHHapticEventParameter(parameterID: .hapticSharpness, value: 1),
            CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
            ], relativeTime: 0)
            
            let pattern =
            try! CHHapticPattern(events: [audioEvent, hapticEvent], parameters: [])
            
            let player = try! engine.makePlayer(with: pattern)
            
            try! player.start(atTime: 0)
        }
        
        
        func simpleSuccess() {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
        
        func prepareHaptics() {

            // 接続デバイスで触覚フィードバックをサポートしているかチェック
            guard  CHHapticEngine.capabilitiesForHardware()
                .supportsHaptics else { print("no support"); return; }
            do {
                // 触覚フィードバックスタート
                self.engine = try! CHHapticEngine()
                try engine!.start()
            } catch {
                print("There was an error creating the engine: \(error.localizedDescription).")
            }
            print("a")

        }
        
        func complexSuccess() {
            guard CHHapticEngine.capabilitiesForHardware()
                .supportsHaptics  else { print("no support"); return; }
    //        var events = [CHHapticEvent]() // CHHapticEvent: 1つの触覚またはオーディオイベントオブジェクト
    //
    //        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
    //        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
    //        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
    //        events.append(event)
            
            let audioEvent = CHHapticEvent(eventType: .audioContinuous, parameters: [
            CHHapticEventParameter(parameterID: .audioPitch, value: -0.15),
            CHHapticEventParameter(parameterID: .audioVolume, value: 1),
            CHHapticEventParameter(parameterID: .decayTime, value: 1),
            CHHapticEventParameter(parameterID: .sustained, value: 0)
            ], relativeTime: 0)
            let hapticEvent = CHHapticEvent(eventType: .hapticTransient, parameters: [
            CHHapticEventParameter(parameterID: .hapticSharpness, value: 1),
            CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
            ], relativeTime: 0)
            
            do {
                let pattern = try! CHHapticPattern(events: [audioEvent, hapticEvent], parameters: [])
                //let pattern = try CHHapticPattern(events: events, parameters: []) // CHHapticPattern: イベントを束ねるオブジェクト
                let player = try engine?.makePlayer(with: pattern) // makePlayer: パターンからプレイヤーをsakusei
                try player?.start(atTime: CHHapticTimeImmediate)
            } catch {
                print("Failed to play pattern: \(error.localizedDescription).")
            }
            print("b")
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
    }
}
