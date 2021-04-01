//
//  SDSCircularProgressView.swift
//
//  Created by : Tomoaki Yagishita on 2021/03/30
//  © 2021  SmallDeskSoftware
//

import SwiftUI
import SDSCGExtension

// this circular progress start from 300 degree till 0 degree (on clock face start from 10 to 12 with counter-clockwise direction)
public struct SDSCircularProgressView: View {
    let progress: Double
    let labelValueMin: CGFloat
    let labelValueMax: CGFloat
    let labelValueStep: CGFloat
    let strokeWidth: CGFloat
    let centerLabelFormatter: ((Double) -> String)?
    let circleLabelFormatter: ((CGFloat) -> String)?


    public init(_ progress: Double,_ labelValueMin: CGFloat,_ labelValueMax: CGFloat,_ labelValueStep: CGFloat,
                _ strokeWidth: CGFloat = 40,
                centerLabelFormatter: ((Double) -> String)? = nil,
                circleLabelFormatter: ((CGFloat) -> String)? = nil) {
        self.progress = max(min(progress, 1.0), 0.0)
        self.labelValueMin = labelValueMin
        self.labelValueMax = labelValueMax
        self.labelValueStep = labelValueStep
        self.strokeWidth = strokeWidth
        self.centerLabelFormatter = centerLabelFormatter
        self.circleLabelFormatter = circleLabelFormatter
    }
    
    var start: Angle {
        return Angle(degrees: 210 - 300 * progress)
    }
    var end: Angle {
        Angle(degrees: -90.0)
    }
    public var body: some View {
        GeometryReader { geom in
            ZStack {
                // base circle + label
                Path { path in
                    path.addArc(center: geom.size.center(), radius: geom.size.width / 2 - strokeWidth/2 - 2,
                                startAngle: Angle(degrees: 210), endAngle: Angle(degrees: -90), clockwise: true)
                }
                .strokedPath(StrokeStyle(lineWidth: strokeWidth-2, lineCap: .round, lineJoin: .round)).foregroundColor(.gray)
                if let circleLabelFormatter = circleLabelFormatter {
                    Labels(labelValueMin, labelValueMax, labelValueStep,
                           labelRadius: geom.size.width / 2 - strokeWidth - 10,
                           labelFormatter: circleLabelFormatter)
                }

                // progress
                Path { path in
                    path.addArc(center: geom.size.center(), radius: geom.size.width/2 - strokeWidth/2,
                                startAngle: self.start, endAngle: self.end, clockwise: true)
                }
                .strokedPath(StrokeStyle(lineWidth: strokeWidth, lineCap: .round, lineJoin: .round)).foregroundColor(.blue)
                if let formatter = centerLabelFormatter {
                    Text(formatter(progress))
                }
            }
        }
    }
}

// labels along circle
struct Labels: View {
    let labelValueMin: CGFloat
    let labelValueMax: CGFloat
    let labelValueStep: CGFloat
    let labelRadius: CGFloat
    let labelFormatter: ((CGFloat) -> String)

    let indexStart:Int
    let indexEnd:Int
    
    init(_ labelValueMin: CGFloat,_ labelValueMax: CGFloat,_ labelValueStep: CGFloat, labelRadius: CGFloat,
         labelFormatter: @escaping ((CGFloat) -> String)) {
        self.labelValueMin = labelValueMin
        self.labelValueMax = labelValueMax
        self.labelRadius = labelRadius
        self.labelValueStep = labelValueStep
        self.labelFormatter = labelFormatter
        
        self.indexStart = 0
        self.indexEnd = Int((labelValueMax - labelValueMin) / labelValueStep)
    }

    var body: some View {
        GeometryReader { geom in
            ForEach(0..<(indexEnd+1)) { index in
                Text(self.formattedValueString(CGFloat(index)*labelValueStep + labelValueMin))
                    .position(self.labelPos(index, geom.size.center(), labelRadius))
                    .font(.footnote)
            }
        }
    }
    
    func formattedValueString(_ value:CGFloat) -> String {
        return labelFormatter(value)
    }
    
    func labelPos(_ index: Int,_ center:CGPoint, _ radius:CGFloat) -> CGPoint {
        let angle = CGFloat.pi / -2  + CGFloat.pi * 2 * (300.0 / 360.0) * CGFloat(index) / CGFloat(indexEnd)
        let x = cos(angle) * radius + center.x
        let y = sin(angle) * radius + center.y
        return CGPoint(x: x, y: y)
    }
}
struct CircularProgressView_Previews: PreviewProvider {
    static var previews: some View {
        SDSCircularProgressView(0.4, 0, 25, 5, centerLabelFormatter: nil)
    }
}
