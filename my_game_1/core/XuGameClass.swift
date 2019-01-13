//
//  XuGameClass.swift
//  my_game_1
//
//  Created by xuhua on 2019/1/7.
//  Copyright © 2019 xuhua. All rights reserved.
//
//  这个是一个实验的自己的游戏相关func库

import Foundation
import SpriteKit
import GameplayKit
import SwiftyJSON

class XuGame: SKScene {
    
    //画线用的一些数据
    var drawPath: SKShapeNode!
    var lineArry: [SKShapeNode] = []
    var startPoint: CGPoint?
    var playerCamera = SKCameraNode()
    

    
    func initClass(cam: SKCameraNode){
        playerCamera = cam
    }
 
    
    //------------------------func区------------------------------------------------------------
    //------------------------------------------------------------------------------------------
    
    //伏羲演八卦
    func calcGua(num: Int) -> [[Int]] {
        if num < 0 {
            print("必须大于0")
        }
        if num == 0{
            return [[0]]
        } else if num == 1 {
            return [[1],[-1]]
            
        } else {
            let preGua: [[Int]] = calcGua(num: num - 1)
            var newGua: [[Int]] = []
            for gua in preGua {
                newGua.append([1] + gua)
                newGua.append([-1] + gua)
            }
            return newGua
        }
    }
    
    //画单一的阴
    func drawYin(point: CGPoint, scene: SKScene) {
        let y1 = SKShapeNode.init(rectOf: CGSize.init(width: 20, height: 10))
        let y2 = SKShapeNode.init(rectOf: CGSize.init(width: 20, height: 10))
        
        y1.fillColor = UIColor.black
        y1.strokeColor = UIColor.black
        y1.position = CGPoint(x: point.x, y: point.y)
        
        y2.fillColor = UIColor.black
        y2.strokeColor = UIColor.black
        y2.position = CGPoint(x: point.x + 30, y: point.y)
        
        scene.addChild(y1)
        scene.addChild(y2)
        
    }
    //画单一的阳
    func drawYang(point: CGPoint, scene: SKScene) {
        
        let yangGua = SKShapeNode.init(rectOf: CGSize.init(width: 50, height: 10))//这个是画一个方块
        yangGua.strokeColor = UIColor.black
        yangGua.fillColor = UIColor.black
        yangGua.position = CGPoint(x: point.x, y: point.y)
        scene.addChild(yangGua)
    }
    
    //画一个完整的3爻卦
    func drawGua(point: CGPoint, gua: [Int], scene: SKScene) {
        if gua[0] == 1 {
            //
            drawYang(point: point, scene: scene)
        } else if gua[0] == -1 {
            //
            drawYin(point: CGPoint(x: point.x - 15, y: point.y), scene: scene)
        }
        
        if gua[1] == 1 {
            drawYang(point: CGPoint(x: point.x, y: point.y + 15), scene: scene)
        } else if gua[1] == -1 {
            drawYin(point: CGPoint(x: point.x - 15, y: point.y + 15), scene: scene)
        }
        
        if gua[2] == 1 {
            drawYang(point: CGPoint(x: point.x, y: point.y + 30), scene: scene)
        } else if gua[2] == -1 {
            drawYin(point: CGPoint(x: point.x - 15, y: point.y + 30), scene: scene)
        }
        
        
    }
    //根据输入画任意多的卦
    func drawNGua( point: CGPoint, scene: SKScene) {
        
        let count : Int = calcGua(num: 6).count
        let onegua : [[Int]] = calcGua(num: 6)
        var newx : CGFloat = point.x

        for c in 0...count-1 {
            newx = newx + 60
            drawGua(point: CGPoint(x: newx, y: point.y), gua: onegua[c], scene: scene )
        }
    
    }
    
    //随机一个范围的整数,但是4.2有这个功能了
    func random_Custom(min: Int, max: Int) -> Int {
        let y = arc4random() % UInt32(max) + UInt32(min)
        return Int(y)
    }
    
    
    //两点画线
    func drawLineBoth(startPoint: CGPoint, endPoint: CGPoint, scence: SKScene){
        
        let path = CGMutablePath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        
        if let lastLine = lineArry.last {
            lastLine.removeFromParent()
            lineArry.dropLast()
        }
        
        drawPath = SKShapeNode()
        drawPath.path = path
        drawPath.strokeColor = UIColor.black
        drawPath.lineWidth = 1
        scence.addChild(drawPath)
        lineArry.append(drawPath)
        drawPath = nil
        
    }
    //单独画线
    func plotLine(atPoint start: CGPoint, toPoint end: CGPoint) {
        let path = CGMutablePath()
        path.move(to: start)
        path.addLine(to: end)
        
        drawPath.path = path
    }
    //删除线
    func deleteLastLine() {
        if let lastLine = lineArry.last {
            lastLine.removeFromParent()
            lineArry.dropLast()
        }
    }
    
    //读取json
    func readJson(jsonFile: String) -> JSON {
        
        guard let fileURL = Bundle.main.url(forResource: jsonFile, withExtension: nil),
            let data = try? Data.init(contentsOf: fileURL) else{
                fatalError("`JSON File Fetch Failed`")
        }
        
        
        let json = try? JSON(data: data)
        return json!
        
    }
    
    func pinandPan(touch: Set<UITouch>, cam: SKCameraNode) {
        
        
        if let t = touch.first{
            let touchLocation = t.location(in: self)
            //let touchWhere = nodes(at: touchLocation)
            
            let previousLocation = t.previousLocation(in: self)
            let deltaLocaiton = self.pointSubtract(touchLocation, previousLocation)
            playerCamera.position = self.pointSubtract(playerCamera.position, deltaLocaiton)
            //print("touch")
        }
    }
    
    @objc func handlePinchFrom(_ sender: UIPinchGestureRecognizer) {
        
        if sender.numberOfTouches == 2 {
            print("2hand")
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
    
    
    
}


class App {
    
    let appName : String!
    let appScene : SKScene!
    let appIcone : SKTexture!
    
    init(appName: String, appScene: SKScene, appIcone: SKTexture) {
        self.appName = appName
        self.appScene = appScene
        self.appIcone = appIcone
    }
    
    func buildSP(scene: SKScene, appPositon: CGPoint) {
        let appSprite = SKSpriteNode.init(texture: appIcone, size: CGSize(width: 70, height: 70))
        appSprite.position = appPositon
        scene.addChild(appSprite)
        appSprite.name = appName
        
        let appNameDraw = SKLabelNode(text: appName)
        appNameDraw.color = UIColor.white
        appNameDraw.position.x = appSprite.position.x
        appNameDraw.position.y = appSprite.position.y - 55
        appNameDraw.fontSize = 17
        scene.addChild(appNameDraw)
    }
    
    
}

class AppButton: SKNode {
    var appName : String!
    var imageNamed: String!
    var appScene: SKScene!
    var appButton: SKSpriteNode!
    var buttonMove = false
    var mainScene : SKScene!
    var placeAt : CGPoint!
    var appLable : SKLabelNode!
    
    init(appName: String, imageNamed: String, appScene: SKScene, mainScene: SKScene, placeAt: CGPoint){
        
        self.appName = appName
        self.imageNamed = imageNamed
        self.appScene = appScene
        self.mainScene = mainScene
        self.placeAt = placeAt
        appButton = SKSpriteNode(imageNamed: imageNamed)//在这里创建button
        appButton.position = placeAt
        appButton.size = CGSize(width: 70, height: 70)
        mainScene.addChild(appButton)
        
        appLable = SKLabelNode(text: appName)
        appLable.color = UIColor.white
        appLable.position.x = appButton.position.x
        appLable.position.y = appButton.position.y - 55
        appLable.fontSize = 17
        mainScene.addChild(appLable)
        
        
        
        
        
        super.init()//这个要在最后面
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
 
    
}
