//
//  VKAssetCell.h
//  VKAssetsPickerController
//
//  Created by Vokie on 1/7/16.
//  Copyright © 2016 Vokie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VKCellDelegate <NSObject>

- (void)cellCheckButtonClick:(id)sender;

@end

@interface VKAssetCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (nonatomic, assign) id<VKCellDelegate> vkDelegate;

@end
