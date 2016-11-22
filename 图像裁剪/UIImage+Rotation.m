//
//  UIImage+Rotation.m
//  图像裁剪
//
//  Created by 王奥东 on 16/11/18.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "UIImage+Rotation.h"

@implementation UIImage (Rotation)

//Radians弧度
//Degrees角度

//弧度转为角度
CGFloat DegreesToRadians(CGFloat degress){
    
    return degress * M_PI / 180;
}
//角度转为弧度
CGFloat RadiansToDegrees(CGFloat radians){
    return radians * 180 / M_PI;
}

//图片通过角度旋转
-(UIImage *)imageRotatedByRadians:(CGFloat)radians {
    
    return [self imageRotatedByDegrees:RadiansToDegrees(radians)];
}

//点击crop之后，通过此方法绘制图片。图片通过弧度旋转。
-(UIImage *)imageRotatedByDegrees:(CGFloat)degrees {
    
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.size.width, self.size.height)];
  
    
    CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    
    /**
        先获取一个与image同大小的View，而后让View旋转设置的角度。
     
     */
    
    //view旋转角度t
    rotatedViewBox.transform = t;
    
    //获取旋转后的size，会时时变动的
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    //开始编辑图形上下文
    UIGraphicsBeginImageContext(rotatedSize);
    
    //获取当前图形
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    //x,y偏移
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //旋转角度
    CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
    
    
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    
    //绘制位图
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width/2, -self.size.height/2, self.size.width, self.size.height), [self CGImage]);
    
    //赋值给UIImage
    UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //结束绘制
    UIGraphicsEndImageContext();
    
    return resImage;
}



@end
