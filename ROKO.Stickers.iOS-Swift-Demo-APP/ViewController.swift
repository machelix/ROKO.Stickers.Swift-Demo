//
//  ViewController.swift
//  ROKOStickersSwiftDemo
//
//  Created by Maslov Sergey on 08.09.15.
//  Copyright (c) 2015 ROKOLabs. All rights reserved.
//

import UIKit

let kROKOStickersShareContentTypeKey = "_ROKO.ImageWithStickers"

class ViewController: UIViewController, RLPhotoComposerDelegate {
    var stickersScheme: ROKOStickersScheme?
    var dataSource: ROKOPortalStickersDataSource = ROKOPortalStickersDataSource.init(manager: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBarHidden = true
    }

    func loadStickersForController(controller : RLComposerWorkflowController!) {
        weak var composer = controller.composer
        dataSource.reloadStickersWithCompletionBlock { (_:AnyObject!, _:NSError!) -> Void in
            composer?.reloadData()
        }
    }

// MARK: Button Interaction
    
    @IBAction func choosePhotoButtonPressed(sender: AnyObject) {
        if let workflowController = RLComposerWorkflowController.buildComposerWorkflowWithType(RLComposerWorkflowType.PhotoPicker, useROKOCMS: false) {
            let photoComposer = workflowController.composer
            photoComposer!.delegate = self
            photoComposer!.dataSource = dataSource
            self.loadStickersForController(workflowController);
            self.presentViewController(workflowController, animated: true, completion: nil)
        }
    }
    
    @IBAction func takePhotoButtonPressed(sender: AnyObject) {
        if let workflowController = RLComposerWorkflowController.buildComposerWorkflowWithType(RLComposerWorkflowType.Camera, useROKOCMS: false) {
            workflowController.composer.dataSource = dataSource
            workflowController.composer.delegate = self
            loadStickersForController(workflowController)
            self.presentViewController(workflowController, animated: true, completion: nil)
        }
    }
    
    
// MARK: RLCameraViewController Delegate
    
    func composer(composer: RLPhotoComposerController!, didFinishWithPhoto photo: UIImage!){
        return
    }
    
    func composerDidCancel(composer: RLPhotoComposerController!) {
        return
    }
    
    func composer(composer: RLPhotoComposerController!, willAppearAnimated animated: Bool) {
        if (stickersScheme != nil) {
            composer.scheme = stickersScheme!
        }
    }
    
    func shareController(controller: RLPhotoComposerController!, willAppearAnimated animated: Bool) {
        return
    }
    
    func composer(composer: RLPhotoComposerController!, didPressShareButtonForImage image: UIImage!){
        if let controller = RSActivityViewController.buildController(){
            controller.image = image
            controller.displayMessage = "I made this for you on the ROKO Stickers app!"
            controller.contentId = composer.photoId.UUIDString
            controller.contentType = kROKOStickersShareContentTypeKey
            composer.navigationController!.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
            composer.navigationController!.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    func composer(composer: RLPhotoComposerController!, didAddSticker stickerInfo: RLStickerInfo!) {
        return
    }
    
    func composer(composer: RLPhotoComposerController!, didSwitchToStickerPackAtIndex packIndex: Int) {
        return
    }
    
    func composer(composer: RLPhotoComposerController!, didRemoveSticker stickerInfo: RLStickerInfo!) {
        return
    }

}

