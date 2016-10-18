//
//  ScanViewController.m
//  scanCode
//
//  Created by 李锐 on 16/9/18.
//  Copyright © 2016年 lirui. All rights reserved.
//

#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "QRCodeView.h"
#import "LineView.h"

@interface ScanViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic,strong) AVCaptureSession * session;
@property (nonatomic,strong) LineView * line;

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫一扫";
    self.view.backgroundColor = [UIColor whiteColor];
    
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    output.rectOfInterest = CGRectMake(0.5, 0, 0.5, 1);
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    self.session = [[AVCaptureSession alloc]init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([self.session canAddInput:input]) {
        [self.session addInput:input];
    }
    
    if ([self.session canAddOutput:output]) {
        [self.session addOutput:output];
    }
    
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    AVCaptureVideoPreviewLayer * layer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    
    
    UIView * scanView = [[UIView alloc] initWithFrame:self.view.frame];
//    scanView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.4];
    [self.view addSubview:scanView];
    
    QRCodeView * qrcodeView = [[QRCodeView alloc]init];
    qrcodeView.translatesAutoresizingMaskIntoConstraints = NO;
    [scanView addSubview:qrcodeView];
    qrcodeView.backgroundColor = [UIColor clearColor];
    
    CGFloat side = 200.0;
    [scanView addConstraint:[NSLayoutConstraint constraintWithItem:qrcodeView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:scanView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [scanView addConstraint:[NSLayoutConstraint constraintWithItem:qrcodeView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:scanView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [scanView addConstraint:[NSLayoutConstraint constraintWithItem:qrcodeView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:kNilOptions multiplier:1 constant:side]];
    [scanView addConstraint:[NSLayoutConstraint constraintWithItem:qrcodeView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:kNilOptions multiplier:1 constant:side]];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGRect scanRect = CGRectMake((screenWidth-side)/2, (screenHeight-side)/2, side, side);
    [output setRectOfInterest:CGRectMake(scanRect.origin.y/screenHeight, scanRect.origin.x/screenWidth, side/screenHeight, side/screenWidth)];
    
    self.line = [[LineView alloc]initWithFrame:CGRectMake(10, 10, 180, 1)];
    [qrcodeView addSubview:self.line];
    
    CAKeyframeAnimation * keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    NSValue * value1 = [NSValue valueWithCGPoint:self.line.layer.position];
    NSValue * value2 = [NSValue valueWithCGPoint:CGPointMake(100, 100)];
    NSValue * value3 = [NSValue valueWithCGPoint:CGPointMake(100, 190)];
    NSValue * value4 = [NSValue valueWithCGPoint:CGPointMake(100, 100)];
    NSValue * value5 = [NSValue valueWithCGPoint:CGPointMake(100, 10)];
    NSArray * values=@[value1,value2,value3,value4,value5];
    keyframeAnimation.values = values;
    keyframeAnimation.duration = 2.0;
    keyframeAnimation.repeatCount = MAXFLOAT;
    [self.line.layer addAnimation:keyframeAnimation forKey:@"KCKeyframeAnimation_Position"];
    
    [self.session startRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    [self.session stopRunning];
    //NSLog(@"%@",metadataObjects);
    
    if (metadataObjects.count>0) {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        NSString * result = metadataObject.stringValue;
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"扫描结果" message:result preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.session startRunning];
        }]];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    if (self.session) {
        [self.session startRunning];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [self.line.layer removeAllAnimations];
    if (self.session) {
        [self.session stopRunning];
    }
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
