//
//  ViewController.m
//  NFCDemo
//
//  Created by TP on 2018/4/17.
//  Copyright © 2018年 TP. All rights reserved.
//

#import "ViewController.h"
#import <CoreNFC/CoreNFC.h>

@interface ViewController () <NFCNDEFReaderSessionDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *nfcButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGFloat nfcButtonHeight = 50.0;
    CGFloat nfcSpaceX = 40.0;
    nfcButton.frame = CGRectMake(nfcSpaceX, (CGRectGetHeight(self.view.frame) - nfcButtonHeight) / 2 , CGRectGetWidth(self.view.frame) - nfcSpaceX * 2, nfcButtonHeight);
    [nfcButton setBackgroundColor:[UIColor colorWithRed:0.83 green:0.83 blue:0.86 alpha:1.00]];
    nfcButton.clipsToBounds = YES;
    nfcButton.layer.cornerRadius = 10.0;
    [nfcButton setTitle:@"NFC 读取" forState:UIControlStateNormal];
    nfcButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [nfcButton setTintColor:[UIColor blackColor]];
    [nfcButton addTarget:self action:@selector(startNFCScan) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nfcButton];
}

- (void)startNFCScan
{
    NFCNDEFReaderSession *nfcSession = [[NFCNDEFReaderSession alloc] initWithDelegate:self queue:nil invalidateAfterFirstRead:YES];
    [nfcSession beginSession];
}

#pragma mark - NFCNDEFReaderSessionDelegate
- (void)readerSession:(NFCNDEFReaderSession *)session didInvalidateWithError:(NSError *)error
{
    //回调回来的是在子线程的
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"NFC Error Information" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

- (void)readerSession:(NFCNDEFReaderSession *)session didDetectNDEFs:(NSArray<NFCNDEFMessage *> *)messages
{
    //回调回来的是在子线程的
    //NFC 卡信息
    
    /*
     messages: (
     "(\n    \"TNF=2, Payload Type=<6170706c 69636174 696f6e2f 766e642e 626c7565 746f6f74 682e6570 2e6f6f62>, Payload ID=<30>, Payload=<1000af11 116711ab 07094942 452d3031>\"\n)"
     )
     */
    NSLog(@"messages: %@", messages);
    [messages enumerateObjectsUsingBlock:^(NFCNDEFMessage * _Nonnull message, NSUInteger idx, BOOL * _Nonnull stop) {
        [message.records enumerateObjectsUsingBlock:^(NFCNDEFPayload * _Nonnull payload, NSUInteger idx, BOOL * _Nonnull stop) {
            /*
             typedef NS_ENUM(uint8_t, NFCTypeNameFormat) {
             NFCTypeNameFormatEmpty             = 0x00,
             NFCTypeNameFormatNFCWellKnown      = 0x01,
             NFCTypeNameFormatMedia             = 0x02,
             NFCTypeNameFormatAbsoluteURI       = 0x03,
             NFCTypeNameFormatNFCExternal       = 0x04,
             NFCTypeNameFormatUnknown           = 0x05,
             NFCTypeNameFormatUnchanged         = 0x06
             };
             */
            switch (payload.typeNameFormat)
            {
                case NFCTypeNameFormatEmpty:
                    NSLog(@"payload.typeNameFormat: NFCTypeNameFormatEmpty");
                    break;
                    
                case NFCTypeNameFormatNFCWellKnown:
                    NSLog(@"payload.typeNameFormat: NFCTypeNameFormatNFCWellKnown");
                    break;
                    
                case NFCTypeNameFormatMedia:
                    NSLog(@"payload.typeNameFormat: NFCTypeNameFormatMedia");
                    break;
                    
                case NFCTypeNameFormatAbsoluteURI:
                    NSLog(@"payload.typeNameFormat: NFCTypeNameFormatAbsoluteURI");
                    break;
                    
                case NFCTypeNameFormatNFCExternal:
                    NSLog(@"payload.typeNameFormat: NFCTypeNameFormatNFCExternal");
                    break;
                    
                case NFCTypeNameFormatUnknown:
                    NSLog(@"payload.typeNameFormat: NFCTypeNameFormatUnknown");
                    break;
                    
                case NFCTypeNameFormatUnchanged:
                    NSLog(@"payload.typeNameFormat: NFCTypeNameFormatUnchanged");
                    break;
                    
                default:
                    NSLog(@"payload.typeNameFormat: NFCTypeNameFormatEmpty");
                    break;
            }
            NSLog(@"payload.type: %@, payload.identifier: %@, payload.payload: %@", payload.type, payload.identifier, payload.payload);
        }];
    }];
}

@end
