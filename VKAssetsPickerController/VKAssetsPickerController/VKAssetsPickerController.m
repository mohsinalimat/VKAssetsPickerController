//
//  VKAssetsPickerController.m
//  VKAssetsPickerController
//
//  Created by Vokie on 1/7/16.
//  Copyright © 2016 Vokie. All rights reserved.
//

#import "VKAssetsPickerController.h"
#import "ConstantHeader.h"
#import "VKAssetCell.h"
#import "VKPhotoPreview.h"
#import <Photos/Photos.h>

@interface VKAssetsPickerController () <PHPhotoLibraryChangeObserver, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) PHPhotoLibrary *photoLibrary;

@property (nonatomic, strong) UICollectionView *mCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) PHFetchResult *allPhotos;
@property (nonatomic, strong) PHCachingImageManager *imageManager;
@property (nonatomic, assign) CGSize thumbnailSize;
@property (nonatomic, strong) NSMutableArray *itemArray;
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
        _mCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT) collectionViewLayout:self.flowLayout];
        _mCollectionView.delegate = self;
        _mCollectionView.dataSource = self;
        _mCollectionView.backgroundColor = [UIColor whiteColor];
        _mCollectionView.scrollEnabled = YES;
        UINib *nib = [UINib nibWithNibName:@"VKAssetCell" bundle:nil];
        [_mCollectionView registerNib:nib forCellWithReuseIdentifier:identifier];
    }
    return _mCollectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    self.allPhotos = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
    
    self.itemArray = [NSMutableArray array];
    for (PHAsset *asset in self.allPhotos) {
        NSDictionary *tempDict = [NSDictionary dictionaryWithObjectsAndKeys:asset, @"asset", @0, @"selected", nil];
        [self.itemArray addObject:tempDict];
    }
    
    [self.view addSubview:self.mCollectionView];
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cellSize = ((UICollectionViewFlowLayout *)self.flowLayout).itemSize;
    self.thumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);
    NSLog(@">>>thumbnail>%@", NSStringFromCGSize(self.thumbnailSize));
    [self.photoLibrary registerChangeObserver:self];
    
}


#pragma mark - UICollectionView DataSource Delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VKAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    PHAsset *asset = self.itemArray[indexPath.item][@"asset"];
    
    // Request an image for the asset from the PHCachingImageManager.
    [self.imageManager requestImageForAsset:asset
                                 targetSize:self.thumbnailSize
                                contentMode:PHImageContentModeAspectFill
                                    options:nil
                              resultHandler:^(UIImage *result, NSDictionary *info) {
                                  cell.thumbnail.image = result;
                                  cell.selectButton.selected = self.itemArray[indexPath.item][@"selected"];
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
                                  VKPhotoPreview *preview = [[VKPhotoPreview alloc]initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT)];
                                  preview.photo.image = result;
                                  [self.view addSubview:preview];
                              }];
}

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    
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
