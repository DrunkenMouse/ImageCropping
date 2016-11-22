//
//  UIImage+Rotation.h
//  图像裁剪
//
//  Created by 王奥东 on 16/11/18.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Rotation)

-(UIImage *)imageRotatedByRadians:(CGFloat)radians;
-(UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

@end
