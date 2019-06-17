//
//  CardView.swift
//  dealing
//
//  Created by T  on 2019-06-09.
//  Copyright © 2019 T . All rights reserved.
//

import UIKit

class CardView: UIButton {
    var isFaceUp = false { didSet{ setNeedsDisplay()}}
    var cardContent : SetGameCard? = nil { didSet{ setNeedsDisplay()}}
    convenience init(frame: CGRect, content: SetGameCard) {
        self.init()
        cardContent = content
        self.frame = frame
    }
    
    override func draw(_ rect: CGRect) {
        //        print("draw")
        let roundedRect = UIBezierPath(rect: bounds)
        if (isFaceUp == true) {
            // print("CardView.isFaceUp")
            UIColor.white.setFill()
            roundedRect.fill()
            drawEachCard(card: cardContent!)
        } else {
            UIColor.purple.setFill()
            roundedRect.fill()
        }
    }
    
    /* Old code */
    // draw pattern of each card
    private func drawEachCard(card: SetGameCard) {
        assert(!self.frame.isEmpty)
        self.backgroundColor = UIColor.white
        // round the card
        let roundedRect = UIBezierPath(rect: bounds)
        UIColor.gray.setStroke()
        roundedRect.lineWidth = 4.0
        roundedRect.stroke()
        drawPattern(card: card, innerBound: bounds.zoom(by: CGFloat(SizeRatio.patternToCardRectRatio)))
        drawStatus()
    }
    
    // Highlight for different status: selected, match, unselected, nomatch
    func drawStatus() {
        // print(self.cardContent?.description as Any)
        let highlightPath = UIBezierPath(rect: bounds)
        highlightPath.lineWidth = bounds.width * 0.1
        switch self.cardContent!.status {
        case .unselected: break
        case .selected:
            UIColor.yellow.setStroke()
            highlightPath.stroke()
        case .match:
            UIColor.green.setStroke()
            highlightPath.stroke()
        case .notMatch:
            UIColor.red.setStroke()
            highlightPath.stroke()
        case .inDeck:
            assertionFailure(description)
        }
    }
    
    // draw setGame patterns of card within innerFrame
    private func drawPattern(card: SetGameCard, innerBound : CGRect) {
        let ranges = getRangeForEachSign(num : card.ofNumber, bound: innerBound)
        let pathes = drawSymbol(of: card.ofSymbol, in : ranges)
        var pathToRange : [UIBezierPath: CGRect] = [:]
        assert(ranges.count == pathes.count)
        for item in 0..<pathes.count {
            pathToRange[pathes[item]] = ranges[item]
        }
        pathes.forEach{drawColorStroke(of: card.ofColor, on: $0, withWidth: 3.0)}
        pathes.forEach{applyShading(of: card.ofShading, with: card.ofColor, in: $0, within: pathToRange[$0]! )}
    }
    
    private func applyShading(of shading: SetGameCard.SetShading, with color : SetGameCard.SetColor, in path : UIBezierPath, within block: CGRect) {
        switch shading {
        case .open:
            break
        case .solid:
            fillColor(in: path, with: color)
        case .striped:
            if let context = UIGraphicsGetCurrentContext() {
                context.saveGState()
                path.addClip()
                drawColorStriped(with: color, withIn: block)
                context.restoreGState()
            }
        }
    }
    
    private func drawColorStriped(with color: SetGameCard.SetColor, withIn block: CGRect) {
        let path = UIBezierPath()
        let deltaY = block.height/10
        var pointY = block.minY + deltaY
        var pointX1 = block.maxX
        var pointX2 = block.minX
        path.move(to: CGPoint(x: pointX2, y: pointY))
        path.addLine(to: CGPoint(x: pointX1, y: pointY))     // --- (->)
        while pointY < block.maxY {
            pointY += deltaY
            path.addLine(to: CGPoint(x: pointX1, y: pointY)) //    |
            path.addLine(to: CGPoint(x: pointX2, y: pointY)) // --- (<--)
            swap(&pointX1, &pointX2)
        }
        drawColorStroke(of: color, on: path, withWidth: 2.0)
    }
    
    private let greenColor = UIColor.init(red:0, green:0.6, blue:0, alpha:1)
    private let redColor = UIColor.init(red:0.8, green:0, blue:0, alpha:0.9)
    
    private func fillColor(in path: UIBezierPath, with color: SetGameCard.SetColor) {
        switch color {
        case .green:
            greenColor.setFill()
        case .purple:
            UIColor.purple.setFill()
        case .red:
            redColor.setFill()
        }
        path.fill()
    }
    
    private func drawColorStroke(of color: SetGameCard.SetColor, on path : UIBezierPath, withWidth width: CGFloat) {
        switch color {
        case .green:
            greenColor.setStroke()
        case .purple:
            UIColor.purple.setStroke()
        case .red:
            redColor.setStroke()
        }
        path.lineWidth = width
        path.stroke()
    }
    
    
    private func drawSymbol(of symbol: SetGameCard.SetSymbol, in area: [CGRect]) -> [UIBezierPath] {
        var pathes : [UIBezierPath] = []
        switch symbol {
        case .diamond:
            pathes.append(contentsOf: area.map{ drawDiamond(in: $0)})
        case .oval:
            pathes.append(contentsOf: area.map{ drawOval(in: $0)})
        case .squiggle:
            pathes.append(contentsOf: area.map{ drawSquiggle(in: $0)})
        }
        return pathes
    }
    
    private func getRangeForEachSign(num: SetGameCard.SetNumber, bound: CGRect) -> [CGRect] {
        let newWidth = bound.width/4
        var result : [CGRect] = []
        switch num {
        case .One:
            result.append(CGRect(x: bound.midX - newWidth/2, y: bound.minY, width: newWidth, height: bound.height))
        case .two:
            result.append(CGRect(x: bound.width/4 + bound.minX - newWidth/2, y: bound.minY, width: newWidth, height: bound.height))
            result.append(CGRect(x: 3 * bound.width/4 + bound.minX - newWidth/2, y: bound.minY, width: newWidth, height: bound.height))
        case .three:
            result.append(CGRect(x: bound.minX, y: bound.minY, width: newWidth, height: bound.height))
            result.append(CGRect(x: bound.midX - newWidth/2, y: bound.minY, width: newWidth, height: bound.height))
            result.append(CGRect(x: bound.maxX - newWidth, y: bound.minY, width: newWidth, height: bound.height))
        }
        return result
    }
    
    private func drawDiamond(in area : CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: area.midX, y: area.minY)) // starting
        path.addLine(to: CGPoint(x: area.minX, y:area.midY)) // left end
        path.addLine(to: CGPoint(x: area.midX, y:area.maxY)) // down point
        path.addLine(to: CGPoint(x: area.maxX, y:area.midY)) // right end
        path.close()
        return path
    }
    
    private func drawOval(in area : CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: area.minX, y: area.minY+area.width/2)) // starting
        path.addArc(withCenter: CGPoint(x:area.midX, y:area.minY+area.width/2), radius: area.width/2, startAngle: CGFloat.pi, endAngle: 0.0, clockwise: true)
        path.addLine(to: CGPoint(x: area.maxX, y:area.maxY-area.width/2))
        path.addArc(withCenter: CGPoint(x:area.midX, y:area.maxY-area.width/2), radius: area.width/2, startAngle: 0.0, endAngle: CGFloat.pi, clockwise: true)
        path.close()
        return path
    }
    
    private func drawSquiggle(in area : CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: area.minX+area.width*0.15, y: area.minY+area.width/4)) // starting
        path.addQuadCurve(to: CGPoint(x:area.maxX-area.width/4, y:area.midY+area.width/5), controlPoint: CGPoint(x:area.maxX, y:area.minY+area.height/5))
        path.addQuadCurve(to: CGPoint(x:area.maxX, y:area.maxY-area.width/8), controlPoint: CGPoint(x:area.midX, y:area.minY+3*area.height/4))
        path.addQuadCurve(to: CGPoint(x:area.minX, y:area.maxY-2*area.width/5), controlPoint: CGPoint(x:area.minX+area.width/3, y:area.maxY+area.height/10))
        path.addQuadCurve(to: CGPoint(x:area.minX+area.width/4, y:area.minY+0.5*area.height), controlPoint: CGPoint(x:area.minX, y:area.maxY-area.height/3))
        path.addQuadCurve(to: CGPoint(x:area.minX, y:area.minY+area.height*0.2), controlPoint: CGPoint(x:area.midX-area.width*0.3, y:area.minY+area.height*0.3))
        path.addQuadCurve(to: CGPoint(x: area.minX+area.width*0.15, y: area.minY+area.width/4), controlPoint: CGPoint(x:area.minX-area.width*0.35, y: area.minY))
        
        path.close()
        return path
    }
    
    
}
extension CGRect {
    func zoom(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return CGRect(x: self.minX+(width-newWidth)/2, y: self.minY+(height-newHeight)/2, width: newWidth, height: newHeight)
    }
}

extension CardView {
    private struct SizeRatio {
        static let patternToCardRectRatio = 0.75
    }
}
