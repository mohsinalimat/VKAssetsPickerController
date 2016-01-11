//
//  VKAssetsPickerController.h
//  VKAssetsPickerController
//
//  Created by Vokie on 1/7/16.
//  Copyright © 2016 Vokie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@class VKAssetsPickerController;
@protocol VKAssetsPickerDelegate <NSObject>

- (void)VKAssetsPicker:(VKAssetsPickerController *)pickerViewController didFinishAssetsPick:(NSArray *)assets;

@end

@interface VKAssetsPickerController : UIViewController

@property (nonatomic, assign) id<VKAssetsPickerDelegate> delegate;
@property (nonatomic, retain) NSArray *selectedItems;
@end
