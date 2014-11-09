//
//  CodeScanner.h
//  yibuyiqu
//
//  Created by Yazhi on 6/11/2014.
//  Copyright (c) 2014 yibuyiqu. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AVFoundation;

@protocol CodeScannerDelegate <NSObject>

- (void)codeDetected:(NSString *)codeString;

@end

@interface CodeScanner : UIView <AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVCaptureDevice *captureDevice;
@property (nonatomic, weak) id<CodeScannerDelegate> delegate;
@property (nonatomic, assign) AVCaptureDevicePosition position;
@property (nonatomic, strong) NSMutableArray *detectTypes;
- (void)initialize;
- (void)startReading;
- (void)stopReading;
@end
