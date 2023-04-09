//
//  CreateViewController.swift
//  memeCreator
//
//  Created by may on 4/9/23.
//

import UIKit

class CreateViewController: UIViewController {

	@IBOutlet var doneBtn: UIButton!
	@IBOutlet var addTextBtn: UIButton!
	@IBOutlet var imageView: UIImageView!
	
	private lazy var picker: UIImagePickerController = {
		let picker = UIImagePickerController()
		picker.allowsEditing = true
		picker.delegate = self
		
		return picker
	}()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		title = "Make a Meme!"
		initStates()
		
		
    }
	
	private func initStates(){
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapImageView))
		imageView.addGestureRecognizer(tapGesture)
		imageView.layer.cornerRadius = 10
		
		imageView.isUserInteractionEnabled = true
		addTextBtn.isUserInteractionEnabled = false
		doneBtn.isUserInteractionEnabled = false
		
	}

	@objc private func didTapImageView(){
		//alert if take a photo or select one from gallery
		let alert = UIAlertController(title: "Take or Select a Photo", message: nil, preferredStyle: .actionSheet)
		
		var action: [UIAlertAction] = []
		action.append(UIAlertAction(title: "Capture Photo", style: .default, handler:{ (_) in
			self.openCamera()}))
		action.append(UIAlertAction(title: "Select Photo", style: .default, handler: { (_) in
			self.present(self.picker, animated: true) }))
		action.append(UIAlertAction(title: "Cancel", style: .cancel))
		
		_ = action.map{ alert.addAction($0) }
		
		
		present(alert, animated: true)
	}
	
	private func openCamera(){
		if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
			picker.sourceType = UIImagePickerController.SourceType.camera
		}
		else{
			let alert = UIAlertController(title: "Warning", message: "You don't have a camera", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	@IBAction func didTapShare(_ sender: Any) {
		guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
			print("No Image found")
			return
		}
		
		let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
		vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
		present(vc, animated: true)
	}
	
	@IBAction func didTapDelete(_ sender: Any) {
		print("delete")
	}
	
	@IBAction func didTapAddText(_ sender: Any) {
		print("add text")
		let ac = UIAlertController(title: "Add Top and Bottom Text", message: nil, preferredStyle: .alert)
		
		ac.addTextField { topTextfield in
			topTextfield.placeholder = "Add Header Here..."
		}
		
		ac.addTextField { bottomTextfield in
			bottomTextfield.placeholder = "Add Footer Here..."
		}
		
		var action: [UIAlertAction] = [UIAlertAction(title: "Cancel", style: .cancel)]
		let doneAction = UIAlertAction(title: "Done", style: .default) { [weak self, weak ac] _ in
			let header = ac?.textFields?[0].text ?? ""
			let footer = ac?.textFields?[1].text ?? ""
			self?.addTextsToImage(header: header, footer: footer)
		}
		action.insert(doneAction, at: 0)
		
		// add all actions in alert
		_ = action.map{ ac.addAction($0) }
		
		present(ac, animated: true)
	}
	
	private func addTextsToImage(header: String, footer: String){
		let renderer = UIGraphicsImageRenderer(size: imageView.frame.size)

		let image = renderer.image { ctx in
			
			let stormImage = imageView.image
			stormImage?.draw(in: CGRect(x: 0, y: 0, width: imageView.frame.size.width, height: imageView.frame.size.height))
			
			let paragraphStyle = NSMutableParagraphStyle()
			paragraphStyle.alignment = .center
			
			let attrs: [NSAttributedString.Key: Any] = [
				.font : UIFont(name: "Helvetica", size: 40)!,
				.foregroundColor : UIColor.white,
				.strokeWidth : -3.0,
				.strokeColor: UIColor.black,
				.paragraphStyle: paragraphStyle
			]
			
			let headAttributedString = NSAttributedString(string: header.uppercased(), attributes: attrs)
			
			headAttributedString.draw(with: CGRect(x: 0, y: 20, width: imageView.frame.size.width, height: 40), options: .usesLineFragmentOrigin, context: nil)
			
			let footerAttributedString = NSAttributedString(string: footer.uppercased(), attributes: attrs)
			footerAttributedString.draw(with: CGRect(x: 0, y: imageView.frame.size.height - 60, width: imageView.frame.size.width, height: 40), options: .usesLineFragmentOrigin, context: nil)
		}
		
		imageView.image = image
	}
	
}

extension CreateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		
		// have to ensure that the file is a UIImage so we typecast it first
		guard let image = info[.editedImage] as? UIImage else { return }
		
		imageView.image = image
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		
		imageView.isUserInteractionEnabled = false
		addTextBtn.isUserInteractionEnabled = true
		doneBtn.isUserInteractionEnabled = true
		
		dismiss(animated: true)
	}
}
