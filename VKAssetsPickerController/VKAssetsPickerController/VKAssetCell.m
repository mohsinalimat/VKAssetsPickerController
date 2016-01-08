//
//  VKAssetCell.m
//  VKAssetsPickerController
//
//  Created by Vokie on 1/7/16.
//  Copyright © 2016 Vokie. All rights reserved.
//

#import "VKAssetCell.h"



@implementation VKAssetCell

- (void)awakeFromNib {
    // Initialization code
}

- (IBAction)checkClick:(id)sender {
    if ([self.vkDelegate respondsToSelector:@selector(cellCheckButtonClick:)]) {
        [self.vkDelegate cellCheckButtonClick:sender];
    }
    
}

@end
