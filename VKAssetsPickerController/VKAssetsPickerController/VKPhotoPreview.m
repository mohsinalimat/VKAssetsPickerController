//
//  VKPhotoPreview.m
//  VKAssetsPickerController
//
//  Created by Vokie on 1/7/16.
//  Copyright © 2016 Vokie. All rights reserved.
//

#import "VKPhotoPreview.h"
#import "ConstantHeader.h"
@implementation VKPhotoPreview

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        self.photo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT)];
        
        self.containScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        [self.containScrollView addSubview:self.photo];
        self.containScrollView.contentSize = self.photo.frame.size;
        self.containScrollView.delegate = self;
        self.containScrollView.maximumZoomScale = 2.0f;
        self.containScrollView.minimumZoomScale = 0.5f;
        [self addSubview:self.containScrollView];
        
        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.closeButton.frame = CGRectMake(10, 10, 40, 30);
        [self.closeButton setTitle:@"退出" forState:UIControlStateNormal];
        [self.closeButton setTitle:@"松开退出" forState:UIControlStateHighlighted];
        [self.closeButton addTarget:self action:@selector(closePreview) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.closeButton];
        
        
    }
    return self;
}

- (void)closePreview {
    [self removeFromSuperview];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.photo;

}
@end
