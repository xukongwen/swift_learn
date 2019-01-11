import SpriteKit
import GameplayKit




class StartScene: SKScene {
    
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    private var lastUpdateTime : TimeInterval = 0
    var app1 : App!
    
    
    //===================================主程序运行区=================================================
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor.gray
        self.lastUpdateTime = 0
        
        let tempscene = SKScene(fileNamed: "GameScene")!
        let temTexture = SKTexture(imageNamed: "appIcon")
        
        app1 = App(appName: "第一个实验", appScene: tempscene, appIcone: temTexture)
    
        app1.buildSP(scene: self)
       
        //pathDrawCircle()
        
        
        
    }
    
    
    
   //==================================func区=========================================================
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
    
    
    //===================================操控区==========================================================
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      
        if let touch = touches.first{
            let touchLocation = touch.location(in: self)
            let touchWhat = nodes(at: touchLocation)
            
            print(touchLocation)
            print(touchWhat)
            
            if !touchWhat.isEmpty {
                for node in touchWhat {
                    print(node.parent!)
    
                    if let sprite = node as? SKSpriteNode {
                        self.view?.presentScene(app1.appScene)

                    }
                }
            }
     }
    
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
