//
//  CreatePasswordViewController.swift
//  Decred Wallet
//
// Copyright (c) 2018, The Decred developers
// See LICENSE for details.
//

import UIKit
import MBProgressHUD
import IQKeyboardManager
import Mobilewallet

class CreatePasswordViewController: UIViewController, SeedCheckupProtocol, UITextFieldDelegate {
    var seedToVerify: String?
    var progressHud: MBProgressHUD?
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfVerifyPassword: UITextField!
    @IBOutlet weak var btnEncrypt: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         //IQKeyboardManager.shared().isEnabled = false
        progressHud = MBProgressHUD(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
        view.addSubview(progressHud!)
        tfPassword.delegate = self
        tfVerifyPassword.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        validatePassword()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        validatePassword()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func validatePassword(){
        btnEncrypt.isEnabled = (tfPassword.text == tfVerifyPassword.text) && !(tfPassword.text?.isEmpty)!
    }
    
    @IBAction func onEncrypt(_ sender: Any) {
        //self.progressHud?.show(animated: true)
       // self.progressHud?.label.text = "creating wallet..."
        print("creating")
        let seed = self.seedToVerify!
        let pass = self.tfPassword!.text
        DispatchQueue.global(qos: .userInitiated).async{
            do{
                let wallet = AppContext.instance.decrdConnection?.wallet
                try wallet?.createWallet(pass, seedMnemonic: seed)
                print("done")
            }catch let error{
                print("wallet error")
                    print(error)
                
            }
            
        }
    }
    
    func showError(error:Error){
        let alert = UIAlertController(title: "Warning", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alert.dismiss(animated: true, completion: {self.navigationController?.popToRootViewController(animated: true)})
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: {self.progressHud?.hide(animated: false)})
    }
    
}