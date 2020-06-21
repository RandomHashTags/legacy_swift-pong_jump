//
//  ViewSelector.swift
//  Pong Jump
//
//  Created by Evan Anderson on 6/11/20.
//  Copyright © 2020 Evan Anderson. All rights reserved.
//

import Foundation
import SceneKit

class ViewSelector : UIView, GestureRecognizers, ConstraintsAPI {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.lightGray
        isUserInteractionEnabled = true
        
        addGestureRecognizer(getTapGesture(target: self, action: #selector(viewShop(_:)), numberOfTapsRequired: 1, numberOfTouchesRequired: 1))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    public func viewShop(_ gesture: UITapGestureRecognizer) {
        let controller:ShopController = ShopController.sharedInstance
        GAME_CONTROLLER.present(controller, animated: true, completion: nil)
    }
}

class ShopController : UIViewController, SCNSceneRendererDelegate, ConstraintsAPI, GestureRecognizers {
    
    internal static var sharedInstance:ShopController = ShopController()
    internal var scene:ShopScene!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        GAME_CONTROLLER.scene.isPaused = true
        view = SCNView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        view.backgroundColor = .white
        viewShop()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func viewShop() {
        let scnView:SCNView = self.view as! SCNView
        scnView.delegate = self
        scene = ShopScene()
        scnView.scene = scene
        scnView.allowsCameraControl = false
        scnView.showsStatistics = false
        scnView.backgroundColor = UIColor.black
        
        addInteractiveView()
        //scnView.addGestureRecognizer(getTapGesture(target: self, action: #selector(handleTap(_:)), numberOfTapsRequired: 1, numberOfTouchesRequired: 1))
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("ShopController;viewDidDisappear")
        GAME_CONTROLLER.scene.isPaused = false
        gameSettings.setPongBallTexture(scene.getPongBallTexture())
    }
    @objc
    private func handleTap(_ gesture: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    private func addInteractiveView() {
        let scrollView:UIScrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentSize = CGSize(width: SCREEN_WIDTH, height: 700)
        scrollView.backgroundColor = .brown
        
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 20
        //layout.headerReferenceSize = CGSize(width: 100, height: 50)
        let collection:ShopCollectionView = ShopCollectionView(frame: CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height), collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.register(ShopCollectionViewCell.self, forCellWithReuseIdentifier: "shopCollectionViewCell")
        collection.delegate = collection
        collection.dataSource = collection
        scrollView.addSubview(collection)
        view.addSubview(scrollView)
        view.addConstraints([
            getConstraint(item: scrollView, .left, toItem: view),
            getConstraint(item: scrollView, .right, toItem: view),
            getConstraint(item: scrollView, .width, toItem: view),
            getConstraint(item: scrollView, .height, toItem: nil, .notAnAttribute, multiplier: 1, constant: 200),
            getConstraint(item: scrollView, .bottom, toItem: view),
        ])
    }
    
    internal func getTargetArray(section: Int) -> [PongBallTexture] {
        switch section {
        case 0: return PongBallTexture.getAllCases()
        case 1: return PongBallTexture.getGeometry()
        case 2: return PongBallTexture.getColors()
        default: return []
        }
    }
}

private class ShopCollectionView : UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ShopController.sharedInstance.getTargetArray(section: section).count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItemAt;" + indexPath.description)
        let shop:ShopController = ShopController.sharedInstance
        shop.scene.setPongBallTexture(shop.getTargetArray(section: indexPath.section)[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ShopCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "shopCollectionViewCell", for: indexPath) as! ShopCollectionViewCell
        cell.setValues(section: indexPath.section, row: indexPath.row)
        return cell
    }
}

private class ShopCollectionViewCell : UICollectionViewCell, Randomable, ConstraintsAPI {
    
    private var label:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = getRandomUIColor()
        
        clipsToBounds = true
        layer.masksToBounds = true
        layer.cornerRadius = 5
        
        label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        addConstraints([
            getConstraint(item: label!, .top, toItem: contentView),
            getConstraint(item: label!, .bottom, toItem: contentView),
            getConstraint(item: label!, .left, toItem: contentView),
            getConstraint(item: label!, .right, toItem: contentView),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setValues(section: Int, row: Int) {
        label.text = ShopController.sharedInstance.getTargetArray(section: section)[row].getName()
    }
}
