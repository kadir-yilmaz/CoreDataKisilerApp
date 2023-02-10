//
//  ViewController.swift
//  CoreDataKisilerApp
//
//  Created by Kadir Yılmaz on 5.12.2022.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as! AppDelegate

class ViewController: UIViewController {
    
    let context = appDelegate.persistentContainer.viewContext
    
    var kisilerListe = [Kisiler]()
    
    var aramaYapiliyorMu = false
    var aramaKelimesi: String?

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var kisilerTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kisilerTableView.delegate = self
        kisilerTableView.dataSource = self
        
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if aramaYapiliyorMu {
            aramaYap(kisiAd: aramaKelimesi!)
        }else{
            tumKisilerAl()
        }
        
        kisilerTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let indeks = sender as? Int
        
        if segue.identifier == "toDetay" {
            let gidilecekVC = segue.destination as! KisiDetayViewController
            gidilecekVC.kisi = kisilerListe[indeks!]
        }
        
        if segue.identifier == "toGuncelle" {
            let gidilecekVC = segue.destination as! KisiGuncelleViewController
            gidilecekVC.kisi = kisilerListe[indeks!]
        }
    }
    
    func tumKisilerAl(){
        do {
            kisilerListe = try context.fetch(Kisiler.fetchRequest())
        } catch {
            print(error)
        }
    }
    
    func aramaYap(kisiAd: String){
        
        let fetchRequest: NSFetchRequest<Kisiler> = Kisiler.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "kisi_ad CONTAINS[cd] %@", kisiAd)
        
        do {
            kisilerListe = try context.fetch(fetchRequest)
        } catch {
            print(error)
        }
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kisilerListe.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let kisi = kisilerListe[indexPath.row]
        
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = kisi.kisi_ad
        cell.contentConfiguration = content
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toDetay", sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let silAction = UIContextualAction(style: .destructive, title: "Sil", handler: {(contextualAction, view, boolValue) in
            
            let kisi = self.kisilerListe[indexPath.row]
            self.context.delete(kisi)
            appDelegate.saveContext()
            
            if self.aramaYapiliyorMu {
                self.aramaYap(kisiAd: self.aramaKelimesi!)
            }else{
                self.tumKisilerAl()
            }
            
            self.kisilerTableView.reloadData()
            
        })
        
        let guncelleAction = UIContextualAction(style: .normal, title: "Güncelle", handler: {(contextualAction, view, boolValue) in
            
            
            self.performSegue(withIdentifier: "toGuncelle", sender: indexPath.row)
        })
        
        return UISwipeActionsConfiguration(actions: [silAction,guncelleAction])
    }
}

extension ViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print("Arama sonucu: \(searchText)")
        
        aramaKelimesi = searchText.lowercased()
        
        if searchText == "" {
            aramaYapiliyorMu = false
            tumKisilerAl()
        }else{
            aramaYapiliyorMu = true
            aramaYap(kisiAd: aramaKelimesi!)
        }
        
        kisilerTableView.reloadData()
    }
}


