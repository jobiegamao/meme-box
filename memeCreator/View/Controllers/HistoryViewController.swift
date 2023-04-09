//
//  HistoryViewController.swift
//  memeCreator
//
//  Created by may on 4/9/23.
//

import UIKit

class HistoryViewController: UIViewController {
	
	
	@IBOutlet var historyCV: UICollectionView!
	let reuseIdentifier = "Cell"
	var memes: [Meme] = []
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		historyCV.dataSource = self
		
		loadData()
		
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		loadData()
		print(memes.count)
	}
	
	func loadData(){
		let defaults = UserDefaults.standard

		if let savedData = defaults.object(forKey: "data") as? Data {
			let jsonDecoder = JSONDecoder()

			do {
				memes = try jsonDecoder.decode([Meme].self, from: savedData)
				print(memes.count, "reloaded")
				historyCV.reloadData()
			} catch {
				print("Failed to load data")
			}
		}
	}

}

extension HistoryViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		memes.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
		
		if let cellImageView = cell.viewWithTag(50) as? UIImageView{
			let meme = memes[indexPath.item]
			let path = getDocumentsDirectory().appending(component: meme.image)
			
			cellImageView.image = UIImage(contentsOfFile: path.relativePath)
			cellImageView.clipsToBounds = true
			print("cellImageView")
		}
		
		return cell
	}
	
	func getDocumentsDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return paths[0]
	}
	
	
	
}

// not needed, for notes
extension HistoryViewController: CreateViewControllerDelegate {
	func didSaveNewItem() {
		historyCV.reloadData()
	}
}

