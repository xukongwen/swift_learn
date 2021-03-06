

import SpriteKit
import GameplayKit
import SwiftyJSON

let randomText = ["阿彌陀佛","佛","藥師琉璃光如來","觀世音菩薩"]
//可以直接读自己写的在另外文件的class，不需要import，太好了
let xu = XuGame()

class GameScene: SKScene,SKPhysicsContactDelegate {
   
    //-------------------------------------------instance create---------------------------------------
    
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    
    var redbox : SKSpriteNode!
    var originalRedboxPos : CGPoint!
    
    var brain : SKSpriteNode!
    let texture1 = SKTexture(imageNamed: "brain")
    var man_white = SKTexture(imageNamed: "man_white")
    
    var text1 : SKLabelNode!
    var text2 : SKLabelNode!
    var text_random : SKLabelNode!
    var cam1 : SKCameraNode!
    
    var shJson : JSON = []
    var fuxi = xu.calcGua(num: 3)
 

    var hasGone = false
    
    var playerNode:SKNode {
        return self.childNode(withName: "playerNode")!
    }
    
    var playerCamera: SKCameraNode {
        return self.playerNode.childNode(withName: "cam1") as! SKCameraNode
    }
    
    
    
 
   
//---------------------------------
    
    
    
    
    func pathDrawCircle() {
        let path = CGMutablePath()
        let path1 = UIBezierPath()
        
        path.addEllipse(in: CGRect(x: 0, y: 0, width: 200, height: 200))
       
        let drawpath = SKShapeNode()
        path.move(to: CGPoint(x: 0, y: 0))
        drawpath.path = path
        drawpath.strokeColor = UIColor.black
        self.addChild(drawpath)
        
        path1.addArc(withCenter: CGPoint(x: 0, y: 0), radius: 200, startAngle: 0, endAngle: 90, clockwise: true)
        let move = SKAction.follow(path1.cgPath, speed: 1000)
        drawpath.run(move)
      
        
    }
    
    
    //按照名字找到一个方子
    func find(){
        
        for (index,subJson):(String, JSON) in shJson {
            // Do something you want
            //                print(index)
            //                print("fang name:",subJson["名"].stringValue)
            //                print(subJson["方"].dictionaryValue)
            
            if subJson["名"].stringValue == "四逆汤" {
                print(subJson["方"].dictionaryValue)
            }
        }
        
    }
    //随机出一个方子来并显示
    func findRandomFang(){
        let selectNum = xu.random_Custom(min: 0, max: 151)
        let slelctName = shJson[selectNum]["名"].stringValue
        text_random.text = slelctName
        
    }
    
  
  
    
    
     //-------main----------------------------------------------------------------
    override func didMove(to view: SKView) {
        
        self.camera = playerCamera //这个很重要！必须要设定场景的camera为哪个cam！
        pathDrawCircle()
        drawGird()
        
        shJson = xu.readJson(jsonFile: "SH_ty2.json")
        
        //xu.drawNGua(point: CGPoint(x: -300, y: -300),scene: self,count: 6)
        
        self.physicsWorld.contactDelegate = self
        
        //physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        let border = SKPhysicsBody(edgeLoopFrom: (view.scene?.frame)!)
        border.friction = 0
        self.physicsBody = border
        self.physicsBody?.contactTestBitMask = 2
        self.physicsBody?.collisionBitMask = 2
        self.physicsBody?.categoryBitMask = 1
      
        redbox = (childNode(withName: "redbox") as! SKSpriteNode)
        redbox.texture = man_white
        
       
        redbox.physicsBody?.categoryBitMask = 2
   
        brain = (childNode(withName: "brain") as! SKSpriteNode)
        brain.texture = texture1
        
    
        text1 = (childNode(withName: "pos") as! SKLabelNode)
        text2 = (childNode(withName: "pos1") as! SKLabelNode)
        text_random = (childNode(withName: "random") as! SKLabelNode)

        originalRedboxPos = redbox.position
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchFrom(_:)))
        
        self.view?.addGestureRecognizer(pinchGesture)
        print(pinchGesture)

        
        self.lastUpdateTime = 0
 
        
    }
   
   
    func changeText(){
       text_random.text = randomText[xu.random_Custom(min: 0, max: 3)]
     
        
    }
    
    func drawGird() {
        let boxWidth = 100
        
        for j in 0...5 {
            for i in 0...5 {
                let box = SKShapeNode.init(rect: CGRect(x: i*boxWidth - 300, y: j*boxWidth, width: boxWidth, height: boxWidth))
                box.strokeColor = UIColor.black
                box.fillColor = UIColor.white
                box.zPosition = -10
                self.addChild(box)
            }
        }
        
       
    }

    
    //--------------手指交互------------
    
 
    //这个是手指放大和移动
    @objc func handlePinchFrom(_ sender: UIPinchGestureRecognizer) {
        if sender.numberOfTouches == 2 {
            let locationInView = sender.location(in: self.view)
            let location = self.convertPoint(fromView: locationInView)
            if sender.state == .changed {
                let deltaScale = (sender.scale - 1.0)*2
                let convertedScale = sender.scale - deltaScale
                let newScale = self.playerCamera.xScale*convertedScale
                self.playerCamera.setScale(newScale)
                
                let locationAfterScale = self.convertPoint(fromView: locationInView)
                let locationDelta = pointSubtract(location, locationAfterScale)
                let newPoint = pointAdd(self.playerCamera.position, locationDelta)
                
                self.playerCamera.position = newPoint
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
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
       
        
        if !hasGone{
            //self.deleteLastLine()
           
        
            if let touch = touches.first{
                let touchLocation = touch.location(in: self)
                let touchWhere = nodes(at: touchLocation)
                //print(touchLocation)
                
//                startPoint = touch.location(in: self)
//                drawPath = SKShapeNode()
//                drawPath.strokeColor = UIColor.white
//                drawPath.lineWidth = 2
//                self.addChild(drawPath)
                
                if !touchWhere.isEmpty{
                    for node in touchWhere{
                        if let sprite = node as? SKSpriteNode{
                            print(sprite)
                            if sprite == redbox {
                                
                                redbox.position = touchLocation
                                
                                //let impules = CGVector(dx: 0, dy: 0)
                                redbox.physicsBody?.isDynamic = false
                                //redbox.physicsBody?.applyAngularImpulse(0)
                                
                                //
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !hasGone{
        
            if let touch = touches.first{
                let touchLocation = touch.location(in: self)
                let touchWhere = nodes(at: touchLocation)
                
                //这里是移动地图
                let previousLocation = touch.previousLocation(in: self)
                let deltaLocaiton = self.pointSubtract(touchLocation, previousLocation)
                self.playerCamera.position = self.pointSubtract(self.playerCamera.position, deltaLocaiton)
                
//                plotLine(atPoint: startPoint!, toPoint: touch.location(in: self))
                
                if !touchWhere.isEmpty{
                    for node in touchWhere{
                        if let sprite = node as? SKSpriteNode{
                            //print(sprite)
                            if sprite == redbox {
                                
                                redbox.position = touchLocation
                                
                                //let impules = CGVector(dx: 0, dy: 0)
                                redbox.physicsBody?.isDynamic = false
                                //redbox.physicsBody?.applyAngularImpulse(0)
                                
                                
                    
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !hasGone{
            
//            lineArry.append(drawPath)
//            drawPath = nil
            //print(lineArry)
            
            if let touch = touches.first{
                let touchLocation = touch.location(in: self)
                let touchWhere = nodes(at: touchLocation)
                
                if !touchWhere.isEmpty{
                    for node in touchWhere{
                        if let sprite = node as? SKSpriteNode{
                            //print(sprite)
                            if sprite == redbox {
                                
                                let dx = touchLocation.x - originalRedboxPos.x
                                let dy = touchLocation.y - originalRedboxPos.y
                                let impulse = CGVector(dx: dx, dy: dy)
                                
                                let im_t_x = String(format: "%.1f", impulse.dx)
                                let im_t_y = String(format: "%.1f", impulse.dy)
                                
                                
                                text1.text = "x:\(im_t_x) " + "y:\(im_t_y)"
                                
                                redbox.physicsBody?.isDynamic = true
                                redbox.physicsBody?.applyImpulse(impulse)
                                redbox.physicsBody?.applyAngularImpulse(0.1)
                                redbox.physicsBody?.affectedByGravity = true
                                
                                //hasGone = true
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !hasGone{
            if let touch = touches.first{
                let touchLocation = touch.location(in: self)
                let touchWhere = nodes(at: touchLocation)
                
                if !touchWhere.isEmpty{
                    for node in touchWhere{
                        if let sprite = node as? SKSpriteNode{
                            //print(sprite)
                            if sprite == redbox {
                                
                                let dx = touchLocation.x - originalRedboxPos.x
                                let dy = touchLocation.y - originalRedboxPos.y
                                let impulse = CGVector(dx: dx, dy: dy)
                                
                                let im_t_x = String(format: "%.1f", impulse.dx)
                                let im_t_y = String(format: "%.1f", impulse.dy)
                                
                                
                                text1.text = "x:\(im_t_x) " + "y:\(im_t_y)"
                                
                                redbox.physicsBody?.isDynamic = true
                                redbox.physicsBody?.applyImpulse(impulse)
                                redbox.physicsBody?.applyAngularImpulse(0.1)
                                redbox.physicsBody?.affectedByGravity = true
                                
                                //hasGone = true
                            }
                        }
                        
                    }
                }
            }
        }
    }
   
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA.node?.name
        let secondBody = contact.bodyB.node?.name
        
        text1.text = secondBody
        text2.text = firstBody
        
        // add bin bin
        let bin = SKSpriteNode(imageNamed: "bin_bin")
        bin.position = redbox.position
        bin.setScale(0.3)
        self.addChild(bin)
        
        let fadein_bin = SKAction.fadeOut(withDuration: 0.3)
        let remove_bin = SKAction.removeFromParent()
        let bin_sq = SKAction.sequence([fadein_bin,remove_bin])
        bin.run(bin_sq)
        
        //changeText()
        findRandomFang()
        //drawLineBoth()
        
        
        if firstBody == "redbox" && secondBody == "brain" || firstBody == "brain" && secondBody == "redbox"{
           //
        }
    }
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
       
        xu.drawLineBoth(startPoint: brain.position, endPoint: redbox.position, scence: self)
        
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
        text_random.position.y = brain.position.y + 100
        text_random.position.x = brain.position.x
        
        
        
    }
    
}
