//
//  SelectCategoriesViewController.swift
//  SwiggyTest
//
//  Created by Ganesh Patro on 8/3/18.
//  Copyright © 2018 Ganesh Patro. All rights reserved.
//

import UIKit

class SelectCategoriesViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var txtFieldSelectCategory: UITextField!
    @IBOutlet weak var tbleViewVariations: UITableView!
    
    private var dataPicker: DataPicker<Group>?
    private var categoryResponse : GroupsAPIResponse? {
        didSet {
            dataPicker = DataPicker(withTitle: "Select Category", withArray: (categoryResponse?.arrGroups)!, withSelectedDataCallback: { [weak self] (group) in
                self?.txtFieldSelectCategory.text = group.name
                self?.arrVariants = group.variants //(self?.filterBasedOnExclusiveList(group))!
            }, withRowTitleCallback: { (group) -> String in
                return group.name
            }, withTextField: txtFieldSelectCategory)
        }
    }
    
    private var arrVariants = [Variant]() {
        didSet {
            //Filter based on exclude list
            tbleViewVariations.reloadData()
        }
    }
    
    private var arrSelectedExclusionIds: [String] = [String]()
    
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customiseUI()
        getGroupsData()
    }
}

//MARK:- Base View Controller Protocol Methods
extension SelectCategoriesViewController: BaseViewControllerProtocol {
    func customiseUI() {
        tbleViewVariations.delegate = self
        tbleViewVariations.dataSource = self
        tbleViewVariations.configureForSelfSizingCell(withEstimatedHeight: 100)
        tbleViewVariations.registerNib(withNibName: VariationCell.cellNibName(), withCellIdentifier: VariationCell.cellIdentifier())
        tbleViewVariations.tableFooterView = UIView()
        
        //Textfield - Dropdown
        let arrow = UIImageView(image: #imageLiteral(resourceName: "down"))
        if let size = arrow.image?.size {
            arrow.frame = CGRect(x: 0.0, y: 0.0, width: size.width + 10.0, height: size.height)
        }
        arrow.contentMode = UIViewContentMode.scaleAspectFit
        txtFieldSelectCategory.rightView = arrow
        txtFieldSelectCategory.rightViewMode = UITextFieldViewMode.always
    }
}

//MARK:- Private Methods
extension SelectCategoriesViewController {
    private func getGroupsData() {
        GroupsProvider.getAllGroups { [weak self] (result) in
            switch(result) {
            case .success(let response):
                print("All Groups are - \(response.arrGroups)")
                DispatchQueue.main.async {
                    self?.categoryResponse = response
                }
            case .error(let error):
                print("Handle Error \(error)")
            }
        }
    }
    
    private func checkForExclusions(_ exclusionId: String) {
        for exclusionList in (categoryResponse?.arrExludeList)! {
            for exclusionModel in exclusionList.arrExclusions {
                
            }
        }
    }
    
    /*
    func filterBasedOnExclusiveList(_ group: Group) -> [Variant] {
        if let exclusiveList = categoryResponse?.arrExludeList {
            for exclusiveModel in exclusiveList {
                if group.group_id == exclusiveModel.group_id {
                    //Then remove the variant from group
                    //Find the variant using filtered
                    let variants = group.variants.filter {
                        $0.id != exclusiveModel.variantion_id
                    }
                    return variants
                }
            }
        }
        
        return group.variants
    }*/
}

//MARK:- UITableview Delegate & Datasource methods
extension SelectCategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrVariants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let variationCell = tbleViewVariations.dequeueReusableCell(withIdentifier: VariationCell.cellIdentifier(), for: indexPath) as? VariationCell else {
            return UITableViewCell()
        }
        
        variationCell.configureCell(withData: arrVariants[indexPath.row], atIndexPath: indexPath as NSIndexPath)
        
        return variationCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let variant = arrVariants[indexPath.row]
        arrSelectedExclusionIds.append(variant.id)
    }
}


