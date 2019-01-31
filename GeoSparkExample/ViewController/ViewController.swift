//
//  ViewController.swift
//  GeoSpark iOS Example
//


import UIKit
import GeoSpark
import CoreLocation

class ViewController: UIViewController, UITextFieldDelegate {
    
    
    
    @IBOutlet weak var startSessionButton: UIButton!
    @IBOutlet weak var createUserButton: UIButton!
    @IBOutlet weak var stopMonitoringButton: UIButton!
    @IBOutlet weak var startMonitoringButton: UIButton!
    @IBOutlet weak var tripButton: UIButton!
    @IBOutlet weak var geofenceButton: UIButton!

    @IBOutlet weak var requestLocationButton: UIButton!
    @IBOutlet weak var requestMotionButton: UIButton!

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var desctextField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupIntialStateForButtons()
        logInIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createUser() {
        showHud()
        var descString:String = ""
        if desctextField.text?.isEmpty == false {
            descString = desctextField.text!
        }
        
        GeoSpark.createUser(descString, { (user) in
            DispatchQueue.main.async {
                if user.userId.isEmpty == false{
                    self.dismissHud()
                    self.textField.text = user.userId
                    self.enableLocationTracking()
                }
                self.dismissHud()
            }

        }, onFailure: { (error) in
            self.dismissHud()
        })        
    }
    
    @IBAction func clearSession() {
        GeoSpark.logout({ (userId) in            
            DispatchQueue.main.async {
                self.textField.text = ""
                self.enableLocationTracking()
                self.setupIntialStateForButtons()
                Utils.resetDefaults()
            }

        }, onFailure: {(error) in
            print(error)
        })
    }
    
    func logInIfNeeded() {
        showHud()
        GeoSpark.startSessionIfNeeded({ (user) in
            DispatchQueue.main.async {

            if user.userId.isEmpty == false{
                self.textField.text = user.userId
                self.enableLocationTracking()
            }
            self.dismissHud()
            }
        }, onFailure: { (error) in
            self.dismissHud()
        })
    }
    
    @IBAction func startSession() {
        if textField.text != "" {
            let userID = textField.text!
            showHud()
            GeoSpark.getUser(userID, { (user) in
                if user.userId.isEmpty {
                    self.enableLocationTracking()
                    self.textField.text = user.userId
                }
            }, onFailure: { (error) in
                self.dismissHud()
            })
        }else{
            let alertController = UIAlertController(title: "Error", message: "Please enter User Id", preferredStyle: .alert)
            let destructionButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(destructionButton)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func enableLocationTracking() {
        createUserButton.isEnabled = false
        startSessionButton.isEnabled = false
        startMonitoringButton.isEnabled = true
        if GeoSpark.isLocationEnabled(){
            requestLocationButton.isEnabled = false
        }
        if GeoSpark.isMotionEnabled() {
            requestMotionButton.isEnabled = false
        }
        if UserDefaults.standard.bool(forKey: "isGeoSparkTrackingEnabled") {
            startLocationTracking()
        }
    }
    
    func setupIntialStateForButtons() {
        let buttonArray : [UIButton] = [startSessionButton, createUserButton, stopMonitoringButton, startMonitoringButton]
        for button in buttonArray {
            button.isEnabled = false
        }
        startSessionButton.isEnabled = true
        createUserButton.isEnabled = true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func trackedLocation(){
        let vc = MapViewController.viewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func startLocationTracking() {
        GeoSpark.startTracking()
        startMonitoringButton.isEnabled = false
        stopMonitoringButton.isEnabled = true
    }
    
    @IBAction func stopLocationTracking() {
        GeoSpark.stopTracking()
        startMonitoringButton.isEnabled = true
        stopMonitoringButton.isEnabled = false
    }
    
    @IBAction func trips() {
        let vc = TripViewController.viewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func geofence() {
        let vc = GeoFenceViewController.viewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func requestLocation() {
        GeoSpark.requestLocation()
        requestLocationButton.isEnabled = false
    }
    
    @IBAction func requestMotion() {
        GeoSpark.requestMotion()
        requestMotionButton.isEnabled = false

    }
    
    func logDetails() -> [[String : String]] {
        if let dataArray = UserDefaults.standard.array(forKey: "GeoSparkKeyForLogsInfo"){
            return dataArray as! [[String : String]]
        }
        return []
    }
    
    @IBAction func setDesciption() {
        
        if (desctextField.text?.isEmpty)! {
            let alertController = UIAlertController(title: "Error", message: "Please enter User Id", preferredStyle: .alert)
            let destructionButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(destructionButton)
            present(alertController, animated: true, completion: nil)

        }else {
            showHud()

            GeoSpark.setDescription(desctextField.text!, { (user) in
                
                    DispatchQueue.main.async {
                        self.dismissHud()
                }
            }, onFailure:  { (erorr) in
                print(erorr)
                DispatchQueue.main.async {
                    self.dismissHud()
                }

            })

        }
    }

    @IBAction func settingBtn(){
        let vc = SettingViewController.viewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func showCurrent() {
        let vc = GetCurrentLocationViewController.viewController()
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension Notification.Name {
    static let locationUpdated = Notification.Name("locationUpdated")
}