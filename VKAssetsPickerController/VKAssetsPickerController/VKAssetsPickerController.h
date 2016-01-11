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

- (void)VKAssetsPicker:(VKAssetsPickerController *)picker didFinishAssetsPick:(NSArray *)assets;

- (void)VKAssetsPickerDidExceedMaximumImages:(VKAssetsPickerController *)picker;
@end

@interface VKAssetsPickerController : UIViewController

/* 给外界调用，初始化的属性*/
@property (nonatomic, assign) NSInteger maximumImagesLimit;
@property (nonatomic, retain) NSArray *selectedItems;
@property (nonatomic, assign) id<VKAssetsPickerDelegate> delegate;
@end
