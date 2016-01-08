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
}

- (IBAction)pickImage:(id)sender {
    VKAssetsPickerController *vc = [[VKAssetsPickerController alloc]init];
    vc.delegate = self;
//    [self.navigationController pushViewController:vc animated:YES];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)VKAssetsPicker:(VKAssetsPickerController *)pickerViewController didFinishAssetsPick:(NSArray *)assets {
    [pickerViewController.navigationController popViewControllerAnimated:YES];
    
    for (PHAsset *asset in assets) {
        NSLog(@"*** %@", asset);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
