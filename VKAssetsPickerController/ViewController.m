//
//  ViewController.m
//  VKAssetsPickerController
//
//  Created by Vokie on 1/7/16.
//  Copyright © 2016 Vokie. All rights reserved.
//

#import "ViewController.h"
#import "VKAssetsPickerController.h"

@interface ViewController () <VKAssetsPickerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.selectedItems = [NSMutableArray array];
}

- (IBAction)pickImage:(id)sender {
    VKAssetsPickerController *vc = [[VKAssetsPickerController alloc]init];
    vc.navigationItem.title = @"选择照片";
    vc.maximumImagesLimit = 5; //-1表示选取无限张图片
    vc.selectedItems = self.selectedItems;
    vc.delegate = self;
    
    [self.navigationController pushViewController:vc animated:YES];
//    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - VKAssetsPickerDelegate
- (void)VKAssetsPicker:(VKAssetsPickerController *)picker didFinishAssetsPick:(NSArray *)assets {
    [picker.navigationController popViewControllerAnimated:YES];
    [self.selectedItems removeAllObjects];
    for (PHAsset *asset in assets) {
        NSLog(@"*** %@", asset);
        [self.selectedItems addObject:asset];
    }
}

- (void)VKAssetsPickerDidExceedMaximumImages:(VKAssetsPickerController *)picker {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"Maximum Images Selected" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
