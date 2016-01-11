//
//  VKPhotoPreview.m
//  VKAssetsPickerController
//
//  Created by Vokie on 1/7/16.
//  Copyright © 2016 Vokie. All rights reserved.
//

#import "VKPhotoPreview.h"
#import "VKHeader.h"

@interface VKPhotoPreview ()

@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, assign) CGFloat scrollViewCenterX;
@property (nonatomic, assign) CGFloat scrollViewCenterY;
@end

@implementation VKPhotoPreview

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.photo = [[UIImageView alloc]initWithFrame:frame];
        self.photo.contentMode = UIViewContentModeScaleAspectFit;
        
        self.containScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        [self.containScrollView addSubview:self.photo];
        self.containScrollView.contentSize = self.photo.frame.size;
        self.containScrollView.delegate = self;
        self.containScrollView.maximumZoomScale = 2.0f;
        self.containScrollView.minimumZoomScale = 1.0f;
        [self addSubview:self.containScrollView];
        
        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.closeButton.frame = CGRectMake(10, 10, 40, 30);
        [self.closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.closeButton setTitleColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.7] forState:UIControlStateHighlighted];
        [self.closeButton setTitle:@"退出" forState:UIControlStateNormal];
        [self.closeButton addTarget:self action:@selector(closePreview) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.closeButton];
        
        
        self.contentView = [self.containScrollView.subviews firstObject];
        self.scrollViewCenterX = self.containScrollView.frame.size.width / 2.0;
        self.scrollViewCenterY = self.containScrollView.frame.size.height / 2.0;
        
    }
    return self;
}


- (void)closePreview {
    self.navBlock();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.photo;

}

//keep image in center when image is zooming
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat midWidth = scrollView.contentSize.width * 0.5;
    CGFloat midHeight = scrollView.contentSize.height * 0.5;
    
    CGFloat offsetX = MAX((self.scrollViewCenterX - midWidth), 0.0);
    CGFloat offsetY = MAX((self.scrollViewCenterY - midHeight), 0.0);
    
    self.contentView.center = CGPointMake(midWidth + offsetX, midHeight + offsetY);
}

@end
