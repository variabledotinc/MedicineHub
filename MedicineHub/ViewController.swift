//
//  ViewController.swift
//  MedicineHub
//
//  Created by Alessandro on 13/07/2018.
//  Copyright © 2018 Alessandro Fan. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var planes = [ARImageAnchor: SCNNode]()
    
    var planeNode : SCNNode? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let images = ["monalisa" : ImageInformation(name: "Mona Lisa", description: "The Mona Lisa is a half-length portrait painting by the Italian Renaissance artist Leonardo da Vinci that has been described as 'the best known, the most visited, the most written about, the most sung about, the most parodied work of art in the world'.", image: UIImage(named: "monalisa")!)]

        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/MainScene.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
//        let configuration = ARWorldTrackingConfiguration()
        
        let configuration = ARImageTrackingConfiguration()
        
        configuration.maximumNumberOfTrackedImages = 1
        
        guard let referenceImage = ARReferenceImage.referenceImages(inGroupNamed: "Medicines", bundle: nil) else{
            fatalError("did not find the referenceImage group")
        }
        
        configuration.trackingImages = referenceImage
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    

    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor{
            
            let referenceImage = imageAnchor.referenceImage
            
            
            
            //Defining plane sizes
            let topPlane = SCNPlane(width: referenceImage.physicalSize.width, height: referenceImage.physicalSize.height * 0.2)
            let firstRightPlane = SCNPlane(width: referenceImage.physicalSize.width * 0.8, height: referenceImage.physicalSize.height * 0.2)

            
            
            //Appearance of the plane
            firstRightPlane.cornerRadius = firstRightPlane.width / 8
            topPlane.cornerRadius = topPlane.width / 8
            
            
            
            // Content of the Planes
            let topSpriteKitScene = SKScene(fileNamed: "TopProductInfo")
            let firstRightSpriteKitScene = SKScene(fileNamed: "firstRowProductInfo")
            
            topPlane.firstMaterial?.diffuse.contents = topSpriteKitScene
            topPlane.firstMaterial?.isDoubleSided = true
            topPlane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
            
            firstRightPlane.firstMaterial?.diffuse.contents = firstRightSpriteKitScene
            firstRightPlane.firstMaterial?.isDoubleSided = true
            firstRightPlane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
            
            
            
            //Defining nodes and orientation of plane
            let topPlaneNode = SCNNode(geometry: topPlane)
            topPlaneNode.eulerAngles.x = -.pi / 2
            
            let firstRightPlaneNode = SCNNode(geometry: firstRightPlane)
            firstRightPlaneNode.eulerAngles.x = -.pi / 2

            
            
            //Poisition of the nodes
            topPlaneNode.position = SCNVector3Make(0.0, 0.0, (-Float(referenceImage.physicalSize.height/2+topPlane.height/2+0.01)))
            
            firstRightPlaneNode.position = SCNVector3Make(Float(referenceImage.physicalSize.width+0.01), 0, 0)
            
            planes[imageAnchor] = topPlaneNode
            
            self.planeNode = topPlaneNode
            
            node.addChildNode(topPlaneNode)
            node.addChildNode(firstRightPlaneNode)
            
        }
    
        return node
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first as! UITouch

        if touch.view == self.sceneView{
            print("touch working")
            let viewTouchLocation:CGPoint = touch.location(in: sceneView)
            guard let result = sceneView.hitTest(viewTouchLocation, options: nil).first else {return}
            if let planeNode = self.planeNode, planeNode == result.node {
                
            }
            
        }
    }
    
    
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    
}
