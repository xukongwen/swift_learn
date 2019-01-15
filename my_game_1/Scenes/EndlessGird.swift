

import Foundation
import SpriteKit
import GameplayKit

class EndlessGrid: SKScene {
    
    var playerCamera: SKCameraNode!
    var drawPath : SKShapeNode!
    var drawSmallPath : SKShapeNode!
    var girdLine : SKShapeNode!
    var girdLineArry : [CGPath] = []
    var girdArry : [SKShapeNode] = []
    var gridSmallArry : [SKShapeNode] = []
    var zoomout = true
    var gridNumber: Int!
    var box: SKSpriteNode!
    var boxArry: [SKSpriteNode] = []
    var moveDriction: CGFloat = 0
    var touchPoint: CGPoint!
    var textBox: SKShapeNode!
    var touchNodes: [SKNode] = []
    //var whenSeleted: SKSpriteNode!
    
    
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
        
        let tapSingle=UITapGestureRecognizer(target:self,action:#selector(tapSingleDid))
        tapSingle.numberOfTapsRequired = 1
        tapSingle.numberOfTouchesRequired = 1
        self.view?.addGestureRecognizer(tapSingle)
        
        //========================================================================================
        
        drawGrid(startX: 0, startY: 0)
        drawGrid(startX: -900, startY: 0)
        drawGrid(startX: 0, startY: -900)
        drawGrid(startX: -900, startY: -900)
        drawGrid(startX: 900, startY: 900)
        drawGrid(startX: -900, startY: 900)
        drawGrid(startX: 0, startY: 900)
        drawGrid(startX: 900, startY: 0)
        drawGrid(startX: 900, startY: -900)
        drawSmallGrid()
        
        for l in girdArry {
            self.addChild(l)
            //print(l)
        }
        
//        for l in gridSmallArry {
//            self.addChild(l)
//        }
        
        
        makeBoxeGrid(makex: -200, makey: -500)
        
        
        
    }
    
    func textBoxfun(){
        let t = SKLabelNode.init(text: "hi")
        textBox = SKShapeNode.init(rect: CGRect(x: -600, y: -600, width: 300, height: 200))
        t.position.x = textBox.position.x + 150
        t.position.y = textBox.position.y + 100
        t.color = UIColor.white
        textBox.fillColor = UIColor.red
    }
    
    @objc func tapSingleDid(){
        
        //实验选择一个物体并且标注
        for t in touchNodes {
            if t.contains(touchPoint){
                let path = CGMutablePath()
                var selectedBox : [SKNode]=[]
                
                path.addRect(CGRect(x: t.position.x - t.frame.width/2, y: t.position.y - t.frame.height/2, width: t.frame.width, height: t.frame.height))
                
                let whenSeleted: SKShapeNode!
                let followBox = SKShapeNode.init(rectOf: CGSize(width: 10, height: 10))
                followBox.fillColor = UIColor.blue
                whenSeleted = SKShapeNode()
                whenSeleted.path = path
                whenSeleted.strokeColor = UIColor.green
                whenSeleted.glowWidth = 2
                selectedBox.append(whenSeleted)
                self.addChild(whenSeleted)
                self.addChild(followBox)
                let move = SKAction.follow(path, speed: 1000)
            
                followBox.run(move)
                
            }
        }
        
        
        for box in boxArry {
            if box.contains(touchPoint) {
                //print("box:",box)
                box.color = UIColor.red
            }
        }
    }
    
    func makeBoxeGrid(makex: CGFloat, makey: CGFloat){
        
        for j in 0...10 {
            for i in 0...6 {
                makeBox(makex: CGFloat(i*110)+makex, makey: CGFloat(j*110)+makey)
            }
        }
        
        
        
        
        
    }
    
    func makeBox(makex: CGFloat, makey: CGFloat) {
        box = SKSpriteNode.init(color: UIColor.gray, size: CGSize(width: 100, height: 100))
        box.position = CGPoint(x: makex, y: makey)
        boxArry.append(box)
        self.addChild(box)
      
    }
    
    func drawGrid(startX: Int, startY: Int) {
    
        for i in 0...9 {
            plotLine(atPoint: CGPoint(x: startX + i*100, y: startY), toPoint: CGPoint(x: startX + i*100, y: startY + 900),lineWidth: 3)
            plotLine(atPoint: CGPoint(x: startX, y: startY + i*100), toPoint: CGPoint(x: startX + 900, y: startY + i*100),lineWidth: 3)
            
            
        }
    }
    
    func drawSmallGrid() {
        for i in 0...36 {
            plotLineSmall(atPoint: CGPoint(x: i*20, y: 0), toPoint: CGPoint(x: i*20, y: 900), lineWidth: 1)
            plotLineSmall(atPoint: CGPoint(x: 0, y: i*20), toPoint: CGPoint(x: 900, y: i*20), lineWidth: 1)
        }
    }
    
    
    
    func plotLine(atPoint start: CGPoint, toPoint end: CGPoint, lineWidth: CGFloat) {
        drawPath = SKShapeNode()
        let path = CGMutablePath()
        
        path.move(to: start)
        path.addLine(to: end)
        drawPath.path = path
        drawPath.strokeColor = UIColor.gray
        drawPath.lineWidth = lineWidth
        drawPath.alpha = 0.5
        drawPath.zPosition = -2
        girdArry.append(drawPath)
        
    }
    
    func plotLineSmall(atPoint start: CGPoint, toPoint end: CGPoint, lineWidth: CGFloat) {
        drawSmallPath = SKShapeNode()
        let path = CGMutablePath()
        
        path.move(to: start)
        path.addLine(to: end)
        drawSmallPath.path = path
        drawSmallPath.strokeColor = UIColor.gray
        drawSmallPath.lineWidth = lineWidth
        drawSmallPath.alpha = 0.7
        gridSmallArry.append(drawSmallPath)

    }
    
    
    
    @objc func swipe(_ recognizer:UIScreenEdgePanGestureRecognizer){
        
        self.view?.presentScene(StartScene())
    }
    
    @objc func handlePinchFrom(_ sender: UIPinchGestureRecognizer) {
        
        
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
                let newViewPoint: CGFloat =  endPoint.x - zeroPoint.x //就是永远参考0-100换算过来的值
                print(newViewPoint)
                
                if newViewPoint <= 45 {
                    //print(girdArry)
                    self.removeChildren(in: girdArry)
                    zoomout = false
                    
                }
                if newViewPoint >= 200 {
                    self.removeChildren(in: girdArry)
                    zoomout = false
        
                }
                
                if zoomout == false {
                    if newViewPoint > 45 && newViewPoint < 200 {
                        for l in girdArry {
                            self.addChild(l)
                            print("add")
                            zoomout = true
                        }
                    }
                }
                
    
                
                
                
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
            touchNodes = nodes(at: touchLocation)
            
            touchPoint = touchLocation
            
            //这里是移动地图
            let previousLocation = touch.previousLocation(in: self)
            let deltaLocaiton = self.pointSubtract(touchLocation, previousLocation)
            self.playerCamera.position = self.pointSubtract(self.playerCamera.position, deltaLocaiton)
            moveDriction = deltaLocaiton.y
            //print("d:",deltaLocaiton)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
//        if moveDriction > 20 {
//            for box in boxArry {
//                box.position.y -= 100
//            }
//
//        }
//        if moveDriction < -20 {
//            for box in boxArry {
//                box.position.y += 100
//            }
//        }
    }
}
