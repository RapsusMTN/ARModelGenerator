//
//  CustomARView.swift
//  ARModelGenerator
//
//  Created by Jorge Martin Reyero on 06/04/2019.
//

import UIKit
import ARKit

enum CustomARViewError : Error {
    case imageNotFound
    case imageConversion
}

@IBDesignable
public class CustomARView: UIView {

    
    
    //MARK: - Outlets
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet var labelInfo: UILabel!
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    @IBOutlet var sceneView: ARSCNView!
    
    
    //MARK: - Properties
    
    private var nodeName:String!// The names node into the SCNScene
    
    private var markerURL:URL!//The name  of the ARGroup what you have the markers
    
    private var model3d:SCNNode!
    
    private var textNode:SCNNode!
    
    private var sceneModel:SCNScene!
    
    private var bundleAssets:Bundle?// If you bundle assets isnt created by default override this param(Optional)
    
    private var imagen:UIImage!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
      
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        setDelegates()
        
    }
    
    
    public func setconfiguration() {
        let scene = SCNScene()
        self.sceneView.scene = scene
        let configuration = ARWorldTrackingConfiguration()
        let imagereferences = try? getResourcesWithURL()
        configuration.detectionImages = imagereferences
        self.sceneView.session.run(configuration, options: [])
    }
    
    
    public func setDelegates() {
        self.sceneView.delegate = self

    }
    
    
    //This func need called before the view will have instantiate
    public func getResourcesWithURL() throws -> Set<ARReferenceImage> {
        
        guard let data = try? Data(contentsOf: self.markerURL) else {
            let errorMsg = "No se ha encontrado la url del fichero"
            
            print(errorMsg)
            throw CustomARViewError.imageNotFound
        }
        
        //Obtenemos la imagen del data obtenido por URL
        guard let image:UIImage = UIImage(data: data),
            
            let imageToCIImage = CIImage(image: image),
            
            let cgImage = convertCIImageToCGImage(inputImage: imageToCIImage) else {
                throw CustomARViewError.imageConversion
        }
      
        self.imagen = image
        
        let arImage = ARReferenceImage(cgImage, orientation: CGImagePropertyOrientation.up, physicalWidth: 0.2)
        arImage.name = "glasgowMarker"
       
        return [arImage]
        
    }
    
    
    /// Converts A CIImage To A CGImage
    ///
    /// - Parameter inputImage: CIImage
    /// - Returns: CGImage
    func convertCIImageToCGImage(inputImage: CIImage) -> CGImage? {
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(inputImage, from: inputImage.extent) {
            return cgImage
        }
        return nil
    }
    
    
    //This func used to add the parameters to initialize the SceneView configurated (called before the view appears)
    public func configurateSceneView(inScene scene:SCNScene,withNameNode node:String,markerURL name:URL) {
        self.sceneModel = scene
        self.nodeName = node
        self.markerURL = name
        self.model3d = get3dModel()
        //seteo
        setconfiguration()
        
    }
    
    //Returns the node of the scene and the name entered by parameter
    private func get3dModel() -> SCNNode{
        
        guard let node = self.sceneModel.rootNode.childNode(withName: self.nodeName, recursively: true) else { fatalError("3D Model not found!!") }
        return node
        
    }
    
    
    @IBAction func segmentedChanged(_ sender: Any) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            self.labelInfo.text = "First"
        case 1:
            self.labelInfo.text = "Second"
        default:
            "No selection"
        }
        
        
        
    }
    
    public func getImage() -> UIImage {
        return self.imagen
    }
    
    
    //Returns the text node scaled and configured
    func createMeasureText() -> SCNNode {
        
        let text = SCNText(string: "55 X 40 X 20", extrusionDepth: 1.0)
        text.firstMaterial?.diffuse.contents = UIColor.white
        
        let textNode = SCNNode(geometry: text)
        
        return textNode
        
        
    }
    
    
    func setup()
    {
        contentView = loadViewFromNib()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(contentView)
        
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
    func loadViewFromNib() -> UIView!
    {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    
    
}

extension CustomARView: ARSCNViewDelegate {
    
    public func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        
        switch camera.trackingState {
        case .limited(let reason):
            self.labelInfo.isHidden = false
            switch reason {
            case .excessiveMotion:
                self.labelInfo.text = "Mueve el dispositivo mas despacio."
            case .initializing, .relocalizing:
                self.labelInfo.text = "ARKit no esta reconociendo la imagen correctamente, vuelve a colocar el dispositivo en la imagen"
            case .insufficientFeatures:
                self.labelInfo.text = "No se ha encontrado puntos suficientes ni luz.."
            }
        case .normal:
            self.labelInfo.text = "Apunta con la camara hacia la imagen indicada."
        case .notAvailable:
            self.labelInfo.isHidden = false
            self.labelInfo.text = "El seguimiento de la camara no esta disponible"
        }
        
    }
    
    
    //This function calls the renderer func of the ARSCNViewDelegate
    public func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if anchor is ARImageAnchor {
            
            self.textNode = createMeasureText()
            
            self.model3d.opacity = 0.6
            self.model3d.position = SCNVector3(anchor.transform.columns.3.x,anchor.transform.columns.3.y,anchor.transform.columns.3.z)
            self.textNode.position = SCNVector3(anchor.transform.columns.3.x - 0.2,anchor.transform.columns.3.y + 0.5,anchor.transform.columns.3.z)
            self.textNode.scale = SCNVector3(0.006, 0.006, 0.006)
            
            self.sceneView.scene.rootNode.addChildNode(self.model3d)
            self.sceneView.scene.rootNode.addChildNode(self.textNode)
            
        }
    }
   
    
    
    
    
    
    
    
}
