//
//  WritePhotoReviewVC.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 11..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class WritePhotoReviewVC: UIViewController, APIService {
    let datePickerView = UIDatePicker()
    @IBOutlet weak var dateTxt: UITextField!
    
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    @IBAction func touchImgAction(_ sender: Any) {
        self.openGallery()
    }
    @IBOutlet weak var myImgView: UIImageView!
    
    @IBOutlet weak var doneBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        initDatePicker()
        // Do any additional setup after loading the view.
    }
    
    
}
//MARK: - 앨범 열기 위함
extension WritePhotoReviewVC : UIImagePickerControllerDelegate,
UINavigationControllerDelegate  {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //크롭한 이미지
        if let editedImage: UIImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            let image = UIImageJPEGRepresentation(editedImage, 0.1)
            addImage(url: url("reviews/images"), image: image)
        } else if let originalImage: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            let image = UIImageJPEGRepresentation(originalImage, 0.1)
            addImage(url: url("reviews/images"), image: image)
            
        }
        self.dismiss(animated: true)
    }
    
    // Method
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker : UIImagePickerController = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}

extension WritePhotoReviewVC {
    func initDatePicker(){
        datePickerView.datePickerMode = .date
        let loc = Locale(identifier: "ko_KR")
        self.datePickerView.locale = loc
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy.MM.dd"
        let date = dateformatter.string(from: Date())
        dateTxt.text = date
        datePickerView.maximumDate = Date()
        
        setTextfieldView(textField: dateTxt, selector: #selector(selectedDatePicker(sender:)), inputView: datePickerView)
    }
    
    func setTextfieldView(textField:UITextField, selector : Selector, inputView : Any){
        let bar = UIToolbar()
        bar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "확인", style: .done
            , target: self, action: selector)
        let flexibleButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        bar.setItems([flexibleButton, doneButton], animated: true)
        textField.inputAccessoryView = bar
        textField.inputView = inputView as? UIControl
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.borderWidth = 1.0
    }
    
    @objc func selectedDatePicker(sender : UIBarButtonItem){
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy.MM.dd"
        let date = dateformatter.string(from: datePickerView.date)
        dateTxt.text = date
        view.endEditing(true)
    }
}

//통신
extension WritePhotoReviewVC {
    func addImage(url : String, image : Data?){
        let params : [String : Any] = [:]
        var images : [String : Data]?
        
        if let image_ = image {
            images = [
                "data" : image_
            ]
        }
        
        PostImageService.shareInstance.addPhoto(url: url, params: params, image: images, completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(let data):
                let data = data as? PostImageVO
                if let img = data?.image {
                    self.myImgView.setImgWithKF(url: img, defaultImg: #imageLiteral(resourceName: "ccc"))
                    self.doneBtn.isEnabled = true
                    self.doneBtn.backgroundColor = ColorChip.shared().middleBlue
                }
                break
            case .networkFail :
                self.networkSimpleAlert()
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    }
}
