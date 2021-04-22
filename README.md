# SDSCircularProgressView

![macOS iOS](https://img.shields.io/badge/platform-iOS-lightgrey)
![iOS](https://img.shields.io/badge/iOS-v14_orLater-blue)
![package manager](https://img.shields.io/badge/SPM-Supported-orange)
![license](https://img.shields.io/badge/license-MIT-lightgrey)

<!--
comment
-->

## Feature

SDSCircularProgressView shows progress along circle

## At a glance

![glance](https://user-images.githubusercontent.com/6419800/113278345-ca758980-931c-11eb-9bf4-48cb3f7c8b6f.mp4)


## Code Example
```
//
//  ContentView.swift
//
//  Created by : Tomoaki Yagishita on 2021/03/29
//  © 2021  SmallDeskSoftware
//

import Combine
import SwiftUI
import SDSCircularProgressView

struct ContentView: View {
    let valueMax: CGFloat = 60 * 5
    let valueMin: CGFloat = 0
    let labelStep: CGFloat = 60
    @State private var progress: Double = 0.5
    var timer = Timer.publish(every: 0.5, on: .main, in: .default).autoconnect()
    
    var body: some View {
        VStack {
            SDSCircularProgressView(progress, valueMin, valueMax, labelStep,
                                    25,
                                    centerLabelFormatter:  { progress in
                self.remainSecondsAsText(progress)
            }, circleLabelFormatter: { value -> String in
                self.stringForCircularLabel(value)
            })
            .frame(width: 200, height: 200)
            .padding()
            Slider(value: $progress, in: 0...1, step: 0.02)
            Text("progress \(progress)")
        }
        .padding()
        .onReceive(self.timer) { date in
            withAnimation {
                progress += 0.002
                if progress > 1.0 {
                    progress = 0.0
                }
            }
        }
    }
    
    func stringForCircularLabel(_ value: CGFloat) -> String {
        let (min, sec) = minSecFromSec(Double(value))
        return String(format: "%2d:%02d", min, sec)
    }
    
    func minSecFromSec(_ totalSec:Double) -> (min: Int, sec:Int) {
        let min = Int(totalSec / 60)
        let sec = Int(totalSec.truncatingRemainder(dividingBy: 60))
        return (min, sec)
    }
    
    func remainSecondsAsText(_ value:Double) -> String {
        let remainSec = Double(valueMax) * value
        let (min, sec) = minSecFromSec(remainSec)
        return String(format: "%02d:%02d", min, sec)
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
```

## Installation
Swift Package Manager: URL: https://github.com/tyagishi/SDSCircularProgressView

## Requirements
iOS14 or later

## Note
