//
//  ViewController.m
//  图像裁剪
//
//  Created by 王奥东 on 16/11/18.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "ViewController.h"
#import "Cropper.h"

@interface ViewController ()

@end

@implementation ViewController {
    
    IBOutlet Cropper *_cropper;
    
    IBOutlet UIImageView *_result;
    
    IBOutlet UIButton *_cropperButton;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _cropper.layer.borderWidth = 1.0;
    _cropper.layer.borderColor = [UIColor blueColor].CGColor;
    [_cropper setup];
    _cropper.image = [UIImage imageNamed:@"1"];
    
}

- (IBAction)clickCropperButton:(id)sender {
    
    if ([_cropperButton.currentTitle isEqualToString:@"Crop"]) {
        [_cropper finishCropping];
        _result.image = _cropper.croppedImage;
        _cropper.hidden = YES;
        [_cropperButton setTitle:@"Back" forState:UIControlStateNormal];
        [_cropperButton setTitle:@"Back" forState:UIControlStateHighlighted];
    }else {
        [_cropper reset];
        _cropper.hidden = NO;
        [_cropperButton setTitle:@"Crop" forState:UIControlStateNormal];
        [_cropperButton setTitle:@"Crop" forState:UIControlStateHighlighted];
        _result.image = nil;
    }
    
}



@end
