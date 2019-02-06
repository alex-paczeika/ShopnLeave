import UIKit
import AVFoundation
import FirebaseDatabase
import AudioToolbox
public var product = "NULL"
var j = 1
public var totalPrice = 0.0

class QRViewController: UIViewController , AVCaptureMetadataOutputObjectsDelegate {
    @IBOutlet weak var shoppingCartLabel: UILabel!
    @IBOutlet weak var square: UIImageView!
     @IBOutlet weak var longText: UITextView!
    var player: AVAudioPlayer?
    var player1: AVAudioPlayer?
    
    @IBAction func updateShopping(_ sender: UIButton) {
        
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        CoinSoundEffect()
        var price = 0.0
        let ref = Database.database().reference()
        if ( product == "NULL") {
            let alertController = UIAlertController(title: "Error", message:
                "I can't find the QR", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        else{
            
            ref.child("AllItems/\(product)").observeSingleEvent(of: .value) { (snapshot) in
                price = snapshot.value as! Double!
                self.longText.text = self.longText.text + "\(j).\(product)" + "-\(price)" + "\n--------------------------------- \n"
                
                self.shoppingCartLabel.text = String(j)
                j = j + 1
                //   ref.child("ShoppingList/\(product)").setValue(snapshot.value) //creaza  in firebase
                totalPrice = totalPrice + price
                myPrice.append(price)
                myProduct.append(product)
                sender.pulsate()
                
            }
        }
    }
    
    
   
    
    
    @IBOutlet weak var VideoImage: UIImageView!
    var video = AVCaptureVideoPreviewLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Creating session
        let session = AVCaptureSession()
        
        //Define capture devcie
        let captureDevice = AVCaptureDevice.default(for: AVMediaType(rawValue: convertFromAVMediaType(AVMediaType.video)))
        
        do
        {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        }
        catch
        {
            print ("ERROR")
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = VideoImage.layer.bounds
        VideoImage.layer.addSublayer(video)
        
        self.VideoImage.bringSubviewToFront(square)
        
        session.startRunning()
        
        
        
    }
    
    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection)  {
        if metadataObjects != nil && metadataObjects.count != 0
        {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
            {
                if object.type.rawValue == convertFromAVMetadataObjectObjectType(AVMetadataObject.ObjectType.qr)
                {
                    
                    
                    
                    product = object.stringValue!
                    
                    
                    
                    // performSegue(withIdentifier: "4", sender: nil)
                    
                    
                    
                    
                }
            }
        }
    }
    func CoinSoundEffect()
    {
        
        
        let path = Bundle.main.path(forResource: "ds", ofType: "mp3")
        let url = URL(fileURLWithPath: path ?? "")
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    func QRSoundEffect()
    {
        
        
        let path = Bundle.main.path(forResource: "ds", ofType: "mp3")
        let url = URL(fileURLWithPath: path ?? "")
        
        do {
            player1 = try AVAudioPlayer(contentsOf: url)
            player1?.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}
fileprivate func convertFromAVMediaType(_ input: AVMediaType) -> String {
    return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVMetadataObjectObjectType(_ input: AVMetadataObject.ObjectType) -> String {
    return input.rawValue
}
