import SpriteKit
import GameplayKit


class StartScene: SKScene {
    
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    private var lastUpdateTime : TimeInterval = 0
    
    var playerCamera: SKCameraNode!
    
    var app1 : App!
    var app2 : App!
    
    var handMoiving = false
    
    var app3 : AppButton!
    var touchPoint : CGPoint!
    
    
    //===================================主程序运行区=================================================
    override func didMove(to view: SKView) {
        self.size = CGSize(width: view.frame.width, height: view.frame.height)
        self.scaleMode = .aspectFill
        
        
        self.backgroundColor = UIColor.gray
        self.lastUpdateTime = 0
        playerCamera = SKCameraNode()
        playerCamera.position = CGPoint(x: 0, y: 0)
        self.camera = playerCamera
        
        
//        let tempscene = SKScene(fileNamed: "GameScene")!
//        let temTexture = SKTexture(imageNamed: "appIcon")
//
//        app1 = App(appName: "第一个实验", appScene: tempscene, appIcone: temTexture)
//
//        app1.buildSP(scene: self, appPositon: CGPoint(x: 100, y: 600))
//
//        let tempscene1 = Test2()
//
//        app2 = App(appName: "第二", appScene: tempscene1, appIcone: temTexture)
//        app2.buildSP(scene: self, appPositon: CGPoint(x: 200, y: 600))
        
        app3 = AppButton(appName: "game3", imageNamed: "appIcon", appScene: Test1(), mainScene: self, placeAt: CGPoint(x: 0, y: 0))
        
        
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchFrom(_:)))
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        
        self.view?.addGestureRecognizer(pinchGesture)
//        self.view?.addGestureRecognizer(tap)
        
        let tapSingle=UITapGestureRecognizer(target:self,action:#selector(tapSingleDid))
        tapSingle.numberOfTapsRequired = 1
        tapSingle.numberOfTouchesRequired = 1
        self.view?.addGestureRecognizer(tapSingle)
        
    }
    
    
    //这里是让无论如何拖动都可以准确按键打开程序
    @objc func tapSingleDid(){
        //print("单击了")
        //handMoiving = false
        if app3.appButton.contains(touchPoint) {
            print("run")
            self.view?.presentScene(app3.appScene)
        }
    }
    
    func pathDrawCircle() {
        let path = CGMutablePath()
        let path1 = UIBezierPath()
        
        path.addEllipse(in: CGRect(x: 0, y: 0, width: 200, height: 200))
        
        let drawpath = SKShapeNode()
        path.move(to: CGPoint(x: 0, y: 0))
        drawpath.path = path
        drawpath.strokeColor = UIColor.white
        self.addChild(drawpath)
        
        path1.addArc(withCenter: CGPoint(x: 0, y: 0), radius: 200, startAngle: 0, endAngle: 90, clockwise: true)
        let move = SKAction.follow(path1.cgPath, speed: 1000)
        drawpath.run(move)
        
        
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
    
    
    //===================================操控区==========================================================
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      
        //
        handMoiving = false
    
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        
        if let touch = touches.first{
         
            
            let touchLocation = touch.location(in: self)
            let touchWhere = nodes(at: touchLocation)
            touchPoint = touchLocation
            
            //这里是移动地图
            let previousLocation = touch.previousLocation(in: self)
            let deltaLocaiton = self.pointSubtract(touchLocation, previousLocation)
            self.playerCamera.position = self.pointSubtract(self.playerCamera.position, deltaLocaiton)
        }
        
    
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    
     //
        
    }
    
    
    
   
    
    
    
    //======================================update=======================================================
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    
        
    }
   
}
