//
//  Cropper.h
//  图像裁剪
//
//  Created by 王奥东 on 16/11/18.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Rotation.h"

@class Cropper;

@protocol CropperDelegate <NSObject>

-(void)imageCropper:(Cropper *)cropper didFinishCroppingWithImage:(UIImage *)image;

@end

@interface Cropper : UIView

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *croppedImage;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) id<CropperDelegate> delegate;

-(void)setup;
-(void)finishCropping;
-(void)reset;

@end

