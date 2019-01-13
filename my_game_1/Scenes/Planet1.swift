
import Foundation
import SpriteKit
import GameplayKit

//let Xu = XuGame()


class Test2: SKScene {
    
    var playerCamera: SKCameraNode!
    var box: SKSpriteNode!
    let p1 = PlanetGenerator.generateTexture(side: 64)
    
    override func didMove(to view: SKView) {
        self.size = CGSize(width: view.frame.width, height: view.frame.height)
        self.scaleMode = .aspectFill
        
        self.backgroundColor = UIColor.white
        
        playerCamera = SKCameraNode()
        
        
        self.camera = playerCamera
    
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchFrom(_:)))
        
        self.view?.addGestureRecognizer(pinchGesture)
        
        let swipe = UIScreenEdgePanGestureRecognizer(target:self,
                                                     action:#selector(swipe(_:)))
        swipe.edges = UIRectEdge.left //从左边缘开始滑动
        self.view?.addGestureRecognizer(swipe)
        
        
        
        box = SKSpriteNode.init(texture: p1)
        box.position = CGPoint(x: 100, y: 100)
        self.addChild(box)
        
    }
    
    @objc func swipe(_ recognizer:UIScreenEdgePanGestureRecognizer){
        
        self.view?.presentScene(StartScene())
    }
    
    @objc func handlePinchFrom(_ sender: UIPinchGestureRecognizer) {
        
        if sender.numberOfTouches == 2 {
            //print("2hand")
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

