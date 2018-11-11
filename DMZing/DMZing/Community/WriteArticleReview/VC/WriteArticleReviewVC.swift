//
//  WriteArticleReviewVC.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 9..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class WriteArticleReviewVC: UIViewController, APIService {
    
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var contentTxtView: UITextView!
    @IBOutlet weak var contentCntLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var doneBtn: UIButton!
    var day = 0
    let defaultTxtMsg = "내용을 입력하세요"
    var keyboardDismissGesture : UITapGestureRecognizer?
   // var imageData : [Data?] = []
    var imageArr : [String] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    var selectedPhotoIdx = 0
    
    let imagePicker : UIImagePickerController = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        setKeyboardSetting()
        collectionView.delegate = self
        collectionView.dataSource = self
        contentTxtView.delegate = self
        imageArr = ["","","","",""]
        titleTxt.addTarget(self, action: #selector(isValid), for: .editingChanged)
    }
}

extension WriteArticleReviewVC :  UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell: WriteArticleCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: WriteArticleCVCell.reuseIdentifier, for: indexPath) as? WriteArticleCVCell {
            guard imageArr.count > 0 else {return cell}
            cell.configure(data: imageArr[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPhotoIdx = indexPath.row
        openGallery()
    }
  
}

//MARK: - 키보드 대응
extension WriteArticleReviewVC {
    func setKeyboardSetting() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        adjustKeyboardDismissGesture(isKeyboardVisible: true)
        
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        adjustKeyboardDismissGesture(isKeyboardVisible: false)
    }
    
    func adjustKeyboardDismissGesture(isKeyboardVisible: Bool) {
        if isKeyboardVisible {
            if keyboardDismissGesture == nil {
                keyboardDismissGesture = UITapGestureRecognizer(target: self, action: #selector(tapBackground))
                view.addGestureRecognizer(keyboardDismissGesture!)
            }
        } else {
            if keyboardDismissGesture != nil {
                view.removeGestureRecognizer(keyboardDismissGesture!)
                keyboardDismissGesture = nil
            }
        }
    }
    
    @objc func tapBackground() {
        self.view.endEditing(true)
    }
}

//MARK: - TextView delegate
extension WriteArticleReviewVC : UITextViewDelegate{
    
    //텍스트뷰 플레이스 홀더처럼
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == defaultTxtMsg {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = defaultTxtMsg
            textView.textColor = #colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        isValid()
        if let text = textView.text {
            contentCntLbl.text = text.count.description
        } else {
            contentCntLbl.text = "0"
        }
        guard let contentTxt = textView.text else {return}
        if(contentTxt.count > 300) {
            self.simpleAlert(title: "오류", message: "3000글자 초과")
            contentTxtView.text = String(describing: contentTxt.prefix(299))
            contentCntLbl.text = contentTxtView.text.count.description
            isValid()
        }
    }
    
    @objc func isValid(){
        //완료 버튼 활성화
        if (!(titleTxt.text?.isEmpty)! && !(contentTxtView.text.isEmpty)) && contentTxtView.text != defaultTxtMsg {
            doneBtn.isEnabled = true
            doneBtn.backgroundColor = ColorChip.shared().middleBlue
        } else {
            doneBtn.isEnabled = false
            doneBtn.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
        }
    } //isValid
}

//MARK: - 앨범 열기 위함
extension WriteArticleReviewVC : UIImagePickerControllerDelegate,
UINavigationControllerDelegate  {
    
    // imagePickerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //사용자 취소
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
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.delegate = self
            //false 로 되어있으면 이미지 자르지 않고 오리지널로 들어감
            //이거 true로 하면 crop 가능
            self.imagePicker.allowsEditing = true
            
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
}

extension WriteArticleReviewVC {
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
                   self.imageArr[self.selectedPhotoIdx] = img
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




