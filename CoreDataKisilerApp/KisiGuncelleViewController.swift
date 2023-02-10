//
//  KisiGuncelleViewController.swift
//  CoreDataKisilerApp
//
//  Created by Kadir Yılmaz on 5.12.2022.
//

import UIKit

class KisiGuncelleViewController: UIViewController {
    
    let context = appDelegate.persistentContainer.viewContext
    
    @IBOutlet weak var kisiAdTextField: UITextField!
    @IBOutlet weak var kisiTelTextField: UITextField!
    
    var kisi: Kisiler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let k = kisi{
            kisiAdTextField.text = k.kisi_ad
            kisiTelTextField.text = k.kisi_tel
        }
    }
    
    @IBAction func guncelle(_ sender: Any) {
        
        if let k = kisi, let ad = kisiAdTextField.text, let tel = kisiTelTextField.text {
            
            k.kisi_ad = ad
            k.kisi_tel = tel
            
            appDelegate.saveContext()
            
            navigationController?.popViewController(animated: true)
        }
    }
    
}
