//
//  ViewController.swift
//  ARModelGenerator
//
//  Created by RapsusMTN on 04/09/2019.
//  Copyright (c) 2019 RapsusMTN. All rights reserved.
//

import UIKit
import ARModelGenerator
import ARKit

class ViewController: UIViewController {

    
    @IBOutlet weak var customView: CustomARView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = SCNScene(named: "Assets3d.scnassets/finalMaleta.scn")
        let url = Bundle.main.url(forResource: "glasgow", withExtension: "jpg")
        self.customView.configurateSceneView(inScene: scene!, withNameNode: "maleta", markerURL: url!, debugLabel: false)
    
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

