//
//  ContentView.swift
//  CoreHapticSample
//
//  Created by momosuke on 2020/07/14.
//  Copyright © 2020 momosuke. All rights reserved.
//

import SwiftUI
import CoreHaptics
import Speech
import AVFoundation

struct ContentView: View {
    @State private var engine: CHHapticEngine?
    @ObservedObject private var speechRecorder = SpeechRecorder()
    @State var showingAlert = false
    
        var body: some View {
            
            VStack {
                Text("Feel Haptic Feedback")
                    .onAppear(perform: prepareHaptics)
                    .onTapGesture(perform: playHaptics)
                    .padding()
                Text("Feel Haptic Feedback2")
                    .onTapGesture(perform: playHaptics2)
                    .padding()
                HStack() {
                    Spacer()
                    Button(action: {
                        if(AVCaptureDevice.authorizationStatus(for: AVMediaType.audio) == .authorized &&
                            SFSpeechRecognizer.authorizationStatus() == .authorized){
                            self.showingAlert = false
                            self.speechRecorder.toggleRecording()
                            if !self.speechRecorder.audioRunning {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                    
                                }
                            }
                        }
                        else{
                            self.showingAlert = true
                        }
                    })
                    {
                        if !self.speechRecorder.audioRunning {
                            Text("スピーチ開始")
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.blue, lineWidth: 1))
                        } else {
                            Text("スピーチ終了")
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.red, lineWidth: 1))
                        }
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("マイクの使用または音声の認識が許可されていません"))
                    }
                    Spacer()
                }
                Text(self.speechRecorder.audioText)
            }
            .onAppear() {
                
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
        
        func playHaptics() {
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
    
        func playHaptics2() {
                guard CHHapticEngine.capabilitiesForHardware()
                    .supportsHaptics  else { print("no support"); return; }
        //        var events = [CHHapticEvent]() // CHHapticEvent: 1つの触覚またはオーディオイベントオブジェクト
        //
        //        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        //        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        //        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        //        events.append(event)
                
                let audioEvent = CHHapticEvent(eventType: .audioContinuous, parameters: [
                    CHHapticEventParameter(parameterID: .audioPitch, value: 1.0),
                CHHapticEventParameter(parameterID: .audioVolume, value: 1),
                CHHapticEventParameter(parameterID: .decayTime, value: 1),
                CHHapticEventParameter(parameterID: .sustained, value: 0)
                ], relativeTime: 0)
                let hapticEvent = CHHapticEvent(eventType: .hapticContinuous, parameters: [
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 1),
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
                ], relativeTime: 0, duration: 5)
                
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
