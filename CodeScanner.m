//
//  CodeScanner.m
//  yibuyiqu
//
//  Created by Yazhi on 6/11/2014.
//  Copyright (c) 2014 yibuyiqu. All rights reserved.
//

#import "CodeScanner.h"

@implementation CodeScanner


- (instancetype)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        self.position = AVCaptureDevicePositionFront;
        self.detectTypes = [NSMutableArray arrayWithObjects:AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, nil];
    }
    return self;
}

- (void)initialize {
    NSError *error;
    
    for (AVCaptureDevice *device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if (device.position == self.position) {
            _captureDevice = device;
            break;
        }
    }
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:_captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    
    if ([_captureSession canAddInput:input]) {
        [_captureSession addInput:input];
    }
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:self.detectTypes];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:self.bounds];
    [self.layer addSublayer:_videoPreviewLayer];
    
}

- (void)startReading {
    [_captureSession startRunning];
}

- (void)stopReading {
    [_captureSession stopRunning];
}

- (void)codeDetected:(NSString *)codeString {
    [self.delegate codeDetected:codeString];
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            [self performSelectorOnMainThread:@selector(codeDetected:) withObject:[metadataObj stringValue] waitUntilDone:NO];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
