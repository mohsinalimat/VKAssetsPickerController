//
//  VKHeader.h
//  VKAssetsPickerController
//
//  Created by Vokie on 1/7/16.
//  Copyright © 2016 Vokie. All rights reserved.
//

#ifndef VKHeader_h
#define VKHeader_h

//屏幕物理宽、高
#define APP_SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define APP_SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height

#define ITEM_PADDING 1
#define ITEM_COLUMN 4

#define BOTTOM_VIEW_HEIGHT 44

#define BOTTOM_VIEW_Y (APP_SCREEN_HEIGHT-BOTTOM_VIEW_HEIGHT)

#define UIColorMake(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#endif /* VKHeader_h */
