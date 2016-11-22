//
//  Cropper.m
//  图像裁剪
//
//  Created by 王奥东 on 16/11/18.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "Cropper.h"

float _lastTransX = 0.0, _lastTransY = 0.0;
float _lastScale = 1.0;
float _lastRotation = 0.0;

@implementation Cropper{
    CGSize _originalImageViewSize;
}

-(void)setup {
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.imageView.userInteractionEnabled = YES;
    [self addSubview:self.imageView];
    
    
    UIRotationGestureRecognizer *rotateGes = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateImage:)];
    [self.imageView addGestureRecognizer:rotateGes];
    
    UIPinchGestureRecognizer *scaleGes = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scaleImage:)];
    [self.imageView addGestureRecognizer:scaleGes];
    
    UIPanGestureRecognizer *moveGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveImage:)];
    [moveGes setMinimumNumberOfTouches:1];
    [moveGes setMaximumNumberOfTouches:1];
    [self.imageView addGestureRecognizer:moveGes];
    
}

-(instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.frame = frame;
        [self setup];
    }
    return self;
}


//移动
-(void)moveImage:(UIPanGestureRecognizer *)sender {
    
    //translationInView 相对于自身的偏移量
    //locationInView 点击时相对的坐标点
    CGPoint translatedPoint = [sender translationInView:self];
  
    CGAffineTransform trans = CGAffineTransformMakeTranslation(translatedPoint.x - _lastTransX, translatedPoint.y - _lastTransY);
    CGAffineTransform newTransform = CGAffineTransformConcat(self.imageView.transform, trans);
    _lastTransX = translatedPoint.x;
    _lastTransY = translatedPoint.y;
    
    self.imageView.transform =  newTransform;
    
}

//缩放
-(void)scaleImage:(UIPinchGestureRecognizer *)sender {
 
    CGFloat scale = [sender scale]/_lastScale;
    
    CGAffineTransform currentTransform = self.imageView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    [self.imageView setTransform:newTransform];
    
    //每次缩放完都要保存上一次的缩放倍数
    _lastScale = [sender scale];
    
}

//旋转
-(void)rotateImage:(UIRotationGestureRecognizer *)sender {
   
    CGFloat rotation = -_lastRotation + [sender rotation];
    
    CGAffineTransform currentTransform = self.imageView.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, rotation);
    [self.imageView setTransform:newTransform];
    
    _lastRotation = [sender rotation];
}

//imageView的size要根据image的改变而改变
-(void)setImage:(UIImage *)image {
    
    if (_image != image) {
        _image = image;
    }
    
    float imageScale = self.frame.size.width / image.size.width;
    
    self.imageView.frame = CGRectMake(0, 0, image.size.width * imageScale, image.size.height * imageScale);
    
    _originalImageViewSize = CGSizeMake(image.size.width * imageScale, image.size.height * imageScale);
    self.imageView.image = image;
    self.imageView.center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
    
}


//点击Crop
-(void)finishCropping {
    float zoomScale = [[self.imageView.layer valueForKeyPath:@"transform.scale.x"] floatValue];
    float rotate = [[self.imageView.layer valueForKeyPath:@"transform.rotation.z"] floatValue];
    
    float imageScale = _image.size.width / _originalImageViewSize.width;
    
    CGSize cropSize = CGSizeMake(self.frame.size.width / zoomScale, self.frame.size.height / zoomScale);
    CGPoint cropperViewOrigin = CGPointMake((0 - self.imageView.frame.origin.x)/zoomScale, (0 - self.imageView.frame.origin.y)/zoomScale);
    
    if ((NSInteger)cropSize.width %2 == 1) {
        cropSize.width = ceil(cropSize.width);
    }
    if ((NSInteger)cropSize.height %2 == 1) {
        cropSize.height = ceil(cropSize.height);
    }
    
    //创建裁剪的矩形区域
    CGRect CropRectinImage = CGRectMake((NSInteger)(cropperViewOrigin.x * imageScale), (NSInteger)(cropperViewOrigin.y * imageScale), (NSInteger)(cropSize.width * imageScale), (NSInteger)(cropSize.height * imageScale));
    
    //获取绘制后的图片
    UIImage *rotInputImage = [self.image imageRotatedByRadians:rotate];
    
    //实现裁剪
    CGImageRef tmp = CGImageCreateWithImageInRect([rotInputImage CGImage], CropRectinImage);
    self.croppedImage = [UIImage imageWithCGImage:tmp scale:self.image.scale orientation:self.image.imageOrientation];
    CGImageRelease(tmp);
    
}
//点击Back
-(void)reset {
    self.imageView.transform = CGAffineTransformIdentity;
}


@end
