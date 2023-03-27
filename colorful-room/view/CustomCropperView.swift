//
//  CropperViewController.swift
//  colorful-room
//
//  Created by Ping9 on 26/11/2020.
//  Copyright © 2020 PingAK9. All rights reserved.
//

import Foundation
import SwiftUI
import QCropper
import PixelEnginePackage


struct CustomCropperView: UIViewControllerRepresentable {
    
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var shared:PECtl
    
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CustomCropperView>) -> CropperViewController {
        //shared.originUIBeforeCrop = shared.editState.makeRenderer().render(resolution: .full)
        let picker = CropperViewController(originalImage: shared.originUI ?? UIImage(), initialState: shared.cropperCtrl.state)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: CropperViewController, context: UIViewControllerRepresentableContext<CustomCropperView>) {
        
    }
    
    func makeCoordinator() -> CropperViewCoordinator {
        CropperViewCoordinator(self)
    }
}

class CropperViewCoordinator: NSObject, UINavigationControllerDelegate, CropperViewControllerDelegate{
    
    let parent: CustomCropperView
    
    init(_ parent:CustomCropperView) {
        self.parent = parent
    }
    
    func cropperDidConfirm(_ cropper: CropperViewController, state: CropperState?) {
        PECtl.shared.cropperCtrl.setState(state)
        
        let editState: EditingStack = EditingStack.init(
            source: StaticImageSource(source: cropper.originalImage),
            // todo: need more code to caculator adjust with scale image
            previewSize: CGSize(width: 512, height: 512 * cropper.originalImage.size.width / cropper.originalImage.size.height)
            // previewSize: CGSize(width: self.originUI.size.width, height: self.originUI.size.height)
        )
        let originRender = cropper.originalImage.cropped(withCropperState: state!)
        let source = StaticImageSource(source: convertUItoCI(from: originRender!))
         
        PECtl.shared.previewImage = editState.makeCustomRenderer(source: source)
            .render(resolution: .full)
        PECtl.shared.editState.setCropImage(adjustmentImage: convertUItoCI(from: editState.makeCustomRenderer(source: source)
            .render(resolution: .full)))
//        PECtl.shared.setImage(image: editState.makeCustomRenderer(source: source)
//            .render(resolution: .full))
        PECtl.shared.setLutsAndRecipes(image: editState.makeCustomRenderer(source: source)
            .render(resolution: .full))
        parent.presentationMode.wrappedValue.dismiss()
    }
    
    func cropperDidCancel(_ cropper: CropperViewController) {
        parent.presentationMode.wrappedValue.dismiss()
    }
}
