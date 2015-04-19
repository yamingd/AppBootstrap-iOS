//
//  UIViewController+ImagePicker.h
//  k12
//
//  Created by Yaming on 3/13/15.
//  Copyright (c) 2015 jiaxiaobang.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImagePickerDelegate <NSObject>

-(void)imagePickerDidSelecteImages:(NSArray*)images;

@end

@interface UIViewController(ImagePicker) <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>

-(void)openImageSelectViews;

- (BOOL)isHasCamera;

- (NSData *)compressImageToDefaultFormat:(UIImage *)image;

@end
