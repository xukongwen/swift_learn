//
//  StartViewController.swift
//  my_game_1
//
//  Created by xuhua on 2019/1/11.
//  Copyright © 2019 xuhua. All rights reserved.
//


import UIKit
import SpriteKit
import GameplayKit

class StartViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        let scene = StartScene()
        scene.size = CGSize(width: view.frame.width, height: view.frame.height)
        scene.scaleMode = .aspectFill
        print(scene.size)
        
        if let view = self.view as! SKView? {
            
            //print("skyview:",view.frame)
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
        
    
        
        
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
}
