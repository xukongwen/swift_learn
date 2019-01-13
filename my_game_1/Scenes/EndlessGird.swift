

import Foundation
import SpriteKit
import GameplayKit

class EndlessGrid: SKScene {
    
    var playerCamera: SKCameraNode!
    var drawPath : SKShapeNode!
    var girdLine : SKShapeNode!
    var girdLineArry : [CGPath] = []
    var girdArry : [SKShapeNode] = []
    
    
    override func didMove(to view: SKView) {
        self.size = CGSize(width: view.frame.width, height: view.frame.height)
        self.scaleMode = .aspectFill
        
        self.backgroundColor = UIColor.white
        
        playerCamera = SKCameraNode()
        playerCamera.position = CGPoint(x: 0, y: 0)
        self.camera = playerCamera
        
        
        
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchFrom(_:)))
        
        self.view?.addGestureRecognizer(pinchGesture)
        
        let swipe = UIScreenEdgePanGestureRecognizer(target:self,
                                                     action:#selector(swipe(_:)))
        swipe.edges = UIRectEdge.left //从左边缘开始滑动
        self.view?.addGestureRecognizer(swipe)
        
        //========================================================================================
        
        drawGrid()
        
        for l in girdArry {
            self.addChild(l)
            print(l)
        }
        
    }
    
    func drawGrid() {
        
        for i in 0...5 {
            plotLine(atPoint: CGPoint(x: i*100, y: 0), toPoint: CGPoint(x: i*100, y: 500))
            plotLine(atPoint: CGPoint(x: 0, y: i*100), toPoint: CGPoint(x: 500, y: i*100))
            
        }
    }
    
    func plotLine(atPoint start: CGPoint, toPoint end: CGPoint) {
        drawPath = SKShapeNode()
        let path = CGMutablePath()
        
        path.move(to: start)
        path.addLine(to: end)
        drawPath.path = path
        drawPath.strokeColor = UIColor.black
        drawPath.lineWidth = 1
        girdArry.append(drawPath)
        // girdLineArry.append(path)
        
    }
    
    @objc func swipe(_ recognizer:UIScreenEdgePanGestureRecognizer){
        
        self.view?.presentScene(StartScene())
    }
    
    @objc func handlePinchFrom(_ sender: UIPinchGestureRecognizer) {
        var zoomout = true
        
        if sender.numberOfTouches == 2 {
            
            let locationInView = sender.location(in: self.view)
            let location = self.convertPoint(fromView: locationInView)
            if sender.state == .changed {
                let deltaScale = (sender.scale - 1.0)*2
                let convertedScale = sender.scale - deltaScale
                let newScale = playerCamera.xScale*convertedScale
                playerCamera.setScale(newScale)
                
                let locationAfterScale = self.convertPoint(fromView: locationInView)
                let locationDelta = pointSubtract(location, locationAfterScale)
                let newPoint = pointAdd(playerCamera.position, locationDelta)
                
                playerCamera.position = newPoint
                sender.scale = 1.0
                
                //这里是把scene的坐标根据放大缩小转化成view的坐标，然后就可以根据这个view坐标的参数来实现grid的画线k显示和不显示的控制
                let endPoint = convertPoint(toView: CGPoint(x: 100, y: 0))
                let zeroPoint = convertPoint(toView: CGPoint(x: 0, y: 0))
                let newViewPoint: CGFloat =  endPoint.x - zeroPoint.x
                print(newViewPoint)
                
                //                if newViewPoint <= 100 {
                //                    print(girdArry)
                //                    self.removeChildren(in: girdArry)
                //                    zoomout = false
                //                }
                //                if newViewPoint >= 100 {
                //                    if zoomout == false{
                //                        for l in girdArry {
                //                            self.addChild(l)
                //                        }
                //
                //                    }
                //                }
                
            }
        }
    }
    
    func pointSubtract( _ a: CGPoint, _ b: CGPoint) -> CGPoint {
        let xD = a.x - b.x
        let yD = a.y - b.y
        return CGPoint(x: xD, y: yD)
    }
    
    func pointAdd( _ a: CGPoint, _ b: CGPoint) -> CGPoint {
        let xD = a.x + b.x
        let yD = a.y + b.y
        return CGPoint(x: xD, y: yD)
    }
    
    
    
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let touchLocation = touch.location(in: self)
            let touchWhere = nodes(at: touchLocation)
            
            //这里是移动地图
            let previousLocation = touch.previousLocation(in: self)
            let deltaLocaiton = self.pointSubtract(touchLocation, previousLocation)
            self.playerCamera.position = self.pointSubtract(self.playerCamera.position, deltaLocaiton)
        }
    }
}
