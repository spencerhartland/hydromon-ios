//
//  DeviceModelView.swift
//  Hydromon
//
//  Created by Spencer Hartland on 2/9/23.
//

import SwiftUI
import SceneKit

struct DeviceModelView: View {
    private let filename = "hydromon"
    private let fileType = "usdz"
    
    @State private var modelScene = SCNScene()
    
    @Binding var LCDColor: UIColor
    @Binding var LEDColor: UIColor
    
    var body: some View {
        GeometryReader { geo in
            SceneView(
                scene: modelScene,
                options: [.autoenablesDefaultLighting]
            )
            .onAppear {
                guard let modelURL = Bundle.main.url(forResource: filename, withExtension: fileType) else {
                    print("Unable to get 3D model from bundle.")
                    return
                }
                do {
                    self.modelScene = try SCNScene(url: modelURL)
                    self.modelScene.background.contents = UIImage(named: "SceneBackground")
                    
                    // Create camera
                    let coreNode = SCNNode()
                    coreNode.position = SCNVector3(x: 0.0, y: 125.0, z: 0.0)
                    let cameraNode = SCNNode()
                    let camera = SCNCamera()
                    camera.zFar = 1000
                    cameraNode.camera = camera
                    cameraNode.position = SCNVector3(x: -150.0, y: 125.0, z: 260)
                    let lookAtConstraint = SCNLookAtConstraint(target: coreNode)
                    lookAtConstraint.influenceFactor = 1.0
                    lookAtConstraint.isGimbalLockEnabled = false
                    cameraNode.constraints = [lookAtConstraint]
                    self.modelScene.rootNode.addChildNode(cameraNode)
                    
                    // Create highlight
                    let highlightNode = SCNNode()
                    highlightNode.light = SCNLight()
                    guard let highlight = highlightNode.light else {
                        print("Unable to unwrap SCNLight object.")
                        return
                    }
                    highlight.type = .directional
                    highlight.color = UIColor(Colors.primary)
                    highlight.intensity = 650
                    highlightNode.position = SCNVector3(x: 0, y: 0, z: 250)
                    highlightNode.rotation = SCNVector4(0, 0,50,15)
                    
                    // Add lights to scene
                    self.modelScene.rootNode.addChildNode(highlightNode)
                    
                    // Get materials
                    let children = modelScene.rootNode.childNodes
                    let more = children[0].childNodes
                    let evenMore = more[0].childNodes
                    let root = evenMore[0]
                    let nodes = root.childNodes[0].childNodes
                    for node in nodes {
                        guard let geo = node.geometry else {
                            print("Unable to get geometry from child node.")
                            continue
                        }
                        
                        let LEDGlowNode = SCNNode()
                        LEDGlowNode.light = SCNLight()
                        guard let LEDGlowLight = LEDGlowNode.light else {
                            print("Unable to unwrap SCNLight object.")
                            return
                        }
                        LEDGlowLight.type = .omni
                        LEDGlowLight.intensity = 1000
                        LEDGlowLight.color = LEDColor
                        LEDGlowNode.position = SCNVector3(x: 0, y: 0.8, z: 3.75)
                        node.addChildNode(LEDGlowNode)
                        
                        let LCDGlowNode = SCNNode()
                        LCDGlowNode.light = SCNLight()
                        guard let LCDGlowLight = LCDGlowNode.light else {
                            print("Unable to unwrap SCNLight object.")
                            return
                        }
                        LCDGlowLight.type = .omni
                        LCDGlowLight.intensity = 1000
                        LCDGlowLight.color = LCDColor
                        LCDGlowNode.position = SCNVector3(x: -10, y: 18, z: 0)
                        node.addChildNode(LCDGlowNode)
                        
                        if let LCDMaterial = geo.material(named: "LCD") {
                            LCDMaterial.emission.contents = LCDColor
                        }
                        if let LEDMaterial = geo.material(named: "LED") {
                            LEDMaterial.emission.contents = LEDColor
                        }
                    }
                } catch {
                    print("Unable to load scene from url.")
                }
            }
            .frame(height: geo.size.width)
        }
    }
}

struct DeviceModelView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceModelView(LCDColor: .constant(.red), LEDColor: .constant(.red))
    }
}
