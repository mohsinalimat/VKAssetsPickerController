//
//  VKAssetsPickerController.m
//  VKAssetsPickerController
//
//  Created by Vokie on 1/7/16.
//  Copyright © 2016 Vokie. All rights reserved.
//

#import "VKAssetsPickerController.h"
#import "VKConstantHeader.h"
#import "VKAssetCell.h"
#import "VKPhotoPreview.h"


@interface VKAssetsPickerController () <PHPhotoLibraryChangeObserver, UICollectionViewDataSource, UICollectionViewDelegate, VKCellDelegate>

@property (nonatomic, strong) PHPhotoLibrary *photoLibrary;

@property (nonatomic, strong) UICollectionView *mCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) PHFetchResult *allPhotos;
@property (nonatomic, strong) PHCachingImageManager *imageManager;
@property (nonatomic, assign) CGSize thumbnailSize;
@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, assign) NSInteger selectedImageNums;
@end

@implementation VKAssetsPickerController

static NSString *identifier = @"VKAssetCellIdentifier";
#pragma mark - 懒加载

- (PHPhotoLibrary *)photoLibrary {
    return _photoLibrary = [PHPhotoLibrary sharedPhotoLibrary];
}

- (PHCachingImageManager *)imageManager {
    if (!_imageManager) {
        _imageManager = [[PHCachingImageManager alloc] init];
    }
    return _imageManager;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.minimumLineSpacing = 1.0f;
        _flowLayout.minimumInteritemSpacing = 0.0f;
        CGFloat sizeLength = (APP_SCREEN_WIDTH - (ITEM_COLUMN + 1) * ITEM_PADDING) / (ITEM_COLUMN * 1.0f);
        _flowLayout.itemSize = CGSizeMake(sizeLength, sizeLength);
    }
    return _flowLayout;
}

- (UICollectionView *)mCollectionView {
    if (!_mCollectionView) {
        _mCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - BOTTOM_VIEW_HEIGHT) collectionViewLayout:self.flowLayout];
        _mCollectionView.delegate = self;
        _mCollectionView.dataSource = self;
        _mCollectionView.backgroundColor = [UIColor whiteColor];
        _mCollectionView.scrollEnabled = YES;
        UINib *nib = [UINib nibWithNibName:@"VKAssetCell" bundle:nil];
        [_mCollectionView registerNib:nib forCellWithReuseIdentifier:identifier];
    }
    return _mCollectionView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, BOTTOM_VIEW_Y, APP_SCREEN_WIDTH, BOTTOM_VIEW_HEIGHT)];
        NSLog(@"%@", NSStringFromCGRect(_bottomView.frame));
        
//        _bottomView.backgroundColor = [UIColor grayColor];
        CGFloat buttonWidth = 55;
        CGFloat buttonHeight = 24;
        self.doneButton = [[UIButton alloc]initWithFrame:CGRectMake(_bottomView.frame.size.width - buttonWidth - 15, (BOTTOM_VIEW_HEIGHT - buttonHeight) / 2, buttonWidth, buttonHeight)];
        self.doneButton.titleLabel.font = [UIFont systemFontOfSize:12];
        self.doneButton.layer.cornerRadius = 3;
        self.doneButton.layer.masksToBounds = YES;
        
        [self.doneButton setTitle:@"确定(0)" forState:UIControlStateNormal];
        self.doneButton.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.95 alpha:1];
        
        [self.doneButton addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        [_bottomView addSubview:self.doneButton];
    }
    
    return _bottomView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.selectedImageNums = 0;
    
    PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    self.allPhotos = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
    
    self.itemArray = [NSMutableArray array];
    for (PHAsset *asset in self.allPhotos) {
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:asset, @"asset", @0, @"selected", nil];
        [self.itemArray addObject:tempDict];
    }
    
    [self.view addSubview:self.mCollectionView];
    [self.view addSubview:self.bottomView];
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cellSize = ((UICollectionViewFlowLayout *)self.flowLayout).itemSize;
    self.thumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);
    NSLog(@">>>thumbnail>%@", NSStringFromCGSize(self.thumbnailSize));
    [self.photoLibrary registerChangeObserver:self];
    
}


#pragma mark - UICollectionView DataSource Delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VKAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (!cell.vkDelegate) {
        cell.vkDelegate = self;
    }
    
    
    PHAsset *asset = self.itemArray[indexPath.item][@"asset"];
    
    // Request an image for the asset from the PHCachingImageManager.
    [self.imageManager requestImageForAsset:asset
                                 targetSize:self.thumbnailSize
                                contentMode:PHImageContentModeAspectFill
                                    options:nil
                              resultHandler:^(UIImage *result, NSDictionary *info) {
                                  cell.thumbnail.image = result;
                                  cell.selectButton.selected = [self.itemArray[indexPath.item][@"selected"] integerValue];
                              }];
    return cell;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.allPhotos.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PHAsset *asset = self.allPhotos[indexPath.item];
    PHImageRequestOptions *option = [PHImageRequestOptions new];
    option.synchronous = YES;
    [self.imageManager requestImageForAsset:asset
                                 targetSize:self.thumbnailSize
                                contentMode:PHImageContentModeAspectFill
                                    options:option
                              resultHandler:^(UIImage *result, NSDictionary *info) {
                                  VKPhotoPreview *preview = [[VKPhotoPreview alloc]initWithFrame:self.view.frame];
                                  __weak typeof(self) weakSelf = self;
                                  preview.navBlock = ^(){
                                      [weakSelf.navigationController setNavigationBarHidden:NO animated:YES];
                                  };
                                  preview.photo.image = result;
                                  [self.navigationController setNavigationBarHidden:YES animated:YES];
                                  [self.view addSubview:preview];
                              }];
}

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    NSLog(@"change");
}

- (void)cellCheckButtonClick:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.mCollectionView];
    NSIndexPath *indexPath = [self.mCollectionView indexPathForItemAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        NSLog(@">>>%ld", indexPath.row);
        NSLog(@">>>%ld", indexPath.item);
        NSLog(@">>>%ld", indexPath.section);
        VKAssetCell *cell = (VKAssetCell *)[self.mCollectionView cellForItemAtIndexPath:indexPath];
        if (cell.selectButton.isSelected) {
            self.itemArray[indexPath.item][@"selected"] = @0;
            cell.selectButton.selected = NO;
            self.selectedImageNums--;
            NSString *buttonTitle = [NSString stringWithFormat:@"确定(%ld)", self.selectedImageNums];
            [self.doneButton setTitle:buttonTitle forState:UIControlStateNormal];
        }else{
            self.itemArray[indexPath.item][@"selected"] = @1;
            cell.selectButton.selected = YES;
            self.selectedImageNums++;
            NSString *buttonTitle = [NSString stringWithFormat:@"确定(%ld)", self.selectedImageNums];
            [self.doneButton setTitle:buttonTitle forState:UIControlStateNormal];

        }
    }

}

- (void)doneButtonClick{
    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:self.itemArray.count];
    for (NSMutableDictionary *temp in self.itemArray) {
        if ([temp[@"selected"] integerValue] == 1) {
            [assets addObject:temp[@"asset"]];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(VKAssetsPicker:didFinishAssetsPick:)]) {
        [self.delegate VKAssetsPicker:self didFinishAssetsPick:assets];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
