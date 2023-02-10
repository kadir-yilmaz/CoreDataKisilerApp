//
//  KisiEkleViewController.swift
//  CoreDataKisilerApp
//
//  Created by Kadir Yılmaz on 5.12.2022.
//

import UIKit

class KisiEkleViewController: UIViewController {
    
    let context = appDelegate.persistentContainer.viewContext
    
    @IBOutlet weak var kisiAdTextField: UITextField!
    @IBOutlet weak var kisiTelTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func ekle(_ sender: Any) {
        
        let kisi = Kisiler(context: context)
        kisi.kisi_ad = kisiAdTextField.text
        kisi.kisi_tel = kisiTelTextField.text
                
        appDelegate.saveContext()
        
        navigationController?.popViewController(animated: true)
        
    }
    
}
