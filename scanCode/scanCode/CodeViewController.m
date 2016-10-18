//
//  CodeViewController.m
//  scanCode
//
//  Created by 李锐 on 16/9/18.
//  Copyright © 2016年 lirui. All rights reserved.
//

#import "CodeViewController.h"

@interface CodeViewController ()

@property (nonatomic,strong) UITextField * codeTextField;
@property (nonatomic,strong) UIImageView * codeImageView;
@property (nonatomic,strong) UIButton * codeBtn;

@end

@implementation CodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"生成二维码";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.codeTextField = [[UITextField alloc]init];
    self.codeTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.codeTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.codeTextField];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[textField]-20-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:@{@"textField":self.codeTextField}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[textField(40)]" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:@{@"textField":self.codeTextField}]];
    
    self.codeImageView = [[UIImageView alloc]init];
    self.codeImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.codeImageView.userInteractionEnabled = YES;
    self.codeImageView.layer.borderColor = [UIColor grayColor].CGColor;
    self.codeImageView.layer.borderWidth = 1;
    [self.view addSubview: self.codeImageView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.codeImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.codeImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.codeImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:kNilOptions multiplier:1 constant:300]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.codeImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:kNilOptions multiplier:1 constant:300]];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popSheet:)];
    [self.codeImageView addGestureRecognizer:tap];
    
    
    self.codeBtn = [[UIButton alloc]init];
    self.codeBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.codeBtn setTitle:@"生成二维码" forState:UIControlStateNormal];
    //[self.codeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    [self.codeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    self.codeBtn.layer.borderColor = [UIColor blackColor].CGColor;
//    self.codeBtn.layer.borderWidth = 1;
//    self.codeBtn.layer.masksToBounds = YES;
//    self.codeBtn.layer.cornerRadius = 5;
    [self.codeBtn addTarget:self action:@selector(createQRCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.codeBtn];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.codeBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[button(40)]-40-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:@{@"button":self.codeBtn}]];

}

- (void)popSheet:(UIGestureRecognizer *)gestureRecognizer{
    UIAlertController * sheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [sheet addAction:[UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [sheet addAction:[UIAlertAction actionWithTitle:@"保存到相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.codeImageView.image != nil){
            [self saveImageToAlbum:self.codeImageView.image];
        }
        else{
            [self showAlertWithTitle:@"提示" Message:@"未找到图片"];
        }
    }]];
    [sheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:sheet animated:YES completion:^{
        
    }];
    
}

- (void)saveImageToAlbum:(UIImage *)saveIamge{
    UIImageWriteToSavedPhotosAlbum(saveIamge, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSLog(@"%@",error);
    
    NSString * tip = @"";
    if (error != nil) {
        tip = @"保存失败";
    }
    else{
        tip = @"保存成功";
    }
    [self showAlertWithTitle:@"提示" Message:tip];
}

- (void)showAlertWithTitle:(NSString *)title Message:(NSString *)message{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

- (void)createQRCode{
    CIFilter * filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    
    NSString * info = self.codeTextField.text;
    if (info != nil && info.length > 0) {
        NSData * data = [info dataUsingEncoding:NSUTF8StringEncoding];
        [filter setValue:data forKey:@"inputMessage"];
        CIImage * outputImage = [filter outputImage];
        self.codeImageView.image = [self createNonInterpolatedUIIamgeFormCIImage:outputImage withSize:100.0];
        
        self.codeTextField.text = @"";
        
//        self.codeImageView.layer.shadowOffset = CGSizeMake(0, 0.5);
//        self.codeImageView.layer.shadowRadius = 1;
//        self.codeImageView.layer.shadowColor = [UIColor blackColor].CGColor;
//        self.codeImageView.layer.shadowOpacity = 0.3;
        
    }
}

- (UIImage *)createNonInterpolatedUIIamgeFormCIImage:(CIImage *)image withSize:(CGFloat)size{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    //创建bitmap
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, kCGImageAlphaNone);
    CIContext * context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
