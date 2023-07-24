//
//  DetailViewController.swift
//  ContactsApp
//
//  Created by Seher Köse on 23.07.2023.
//

import UIKit

class DetailViewController: UIViewController {

    var name: String?
    var relation: String?
    var imageSelected: UIImage?
    var selectedRelations: [ContactModel] = [ContactModel]()

    @IBOutlet weak var selectedContactImage: UIImageView!
    @IBOutlet weak var selectedContactName: UILabel!
    @IBOutlet weak var selectedContactRelation: UILabel!
  
    @IBOutlet weak var contactCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ui:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = self.contactCollectionView.frame.size.width
        ui.minimumInteritemSpacing=5
        ui.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        contactCollectionView!.collectionViewLayout = ui
        ui.itemSize = CGSize(width: (width-30)/2, height: (width-30)/2)
        
        ui.scrollDirection = .horizontal
        
        contactCollectionView.dataSource=self
        contactCollectionView.delegate=self

        selectedContactName.text = name!
        selectedContactRelation.text = relation!
        selectedContactImage.image = imageSelected!
    }
    
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
       return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedRelations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = contactCollectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionViewCell
        
        let contact = selectedRelations[indexPath.item]
        cell.contactLabel1?.text = contact.titleName
        cell.contactLabel2?.text = contact.relationType.relationType
        cell.contactImageView?.image = UIImage(named: contact.gender.genderType)
   
        return cell
        
    }
}


 

