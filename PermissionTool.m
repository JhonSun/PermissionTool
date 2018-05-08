//
//  PermissionTool.m
//  THSS
//
//  Created by lianditech on 2018/5/8.
//  Copyright © 2018年 lianditech. All rights reserved.
//

#import "PermissionTool.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "Marco.h"

@implementation PermissionTool

+ (BOOL)checkCameraPermissionWithRequestAuthorizationBlock:(void (^)(void))requestSucessBlock {
    BOOL isCanUserCamera = NO;
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusAuthorized:
            MLog(@"用户允许使用摄像头");
            isCanUserCamera = YES;
            break;
        case AVAuthorizationStatusRestricted:
            MLog(@"用户未授权，但是不能改变");
            [self showAlertWithMessage:@"您没有授权使用摄像头，但是您也不能去授权，因为您可能处在家长控制环境中。" isToSetting:NO];
            break;
        case AVAuthorizationStatusDenied:
            MLog(@"用户禁止使用摄像头");
            [self showAlertWithMessage:@"您把摄像头权限关闭了，是否前去设置页面打开摄像头权限？" isToSetting:YES];
            break;
        case AVAuthorizationStatusNotDetermined: {
            MLog(@"用户未授权，提醒用户授权");
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if(granted){
                    if (requestSucessBlock) requestSucessBlock();
                }
            }];
        }
            break;
        default:
            break;
    }
    return isCanUserCamera;
}

+ (BOOL)checkPhotoLibPermissionWithRequestAuthorizationBlock:(void (^)(void))requestSucessBlock {
    BOOL isCanVisitPhotoLib = NO;
    PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
    switch (photoAuthorStatus) {
        case PHAuthorizationStatusAuthorized:
            MLog(@"用户允许访问相册");
            isCanVisitPhotoLib = YES;
            break;
        case PHAuthorizationStatusDenied:
            MLog(@"用户禁止访问相册");
            [self showAlertWithMessage:@"您把相册权限关闭了，是否前去设置页面打开相册权限？" isToSetting:YES];
            break;
        case PHAuthorizationStatusNotDetermined: {
            MLog(@"用户未授权，提醒用户授权");
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    if (requestSucessBlock) requestSucessBlock();
                }
            }];
        }
            break;
        case PHAuthorizationStatusRestricted:
            MLog(@"用户未授权，但是不能改变");
            [self showAlertWithMessage:@"您没有授权访问相册，但是您也不能去授权，因为您可能处在家长控制环境中。" isToSetting:NO];
            break;
        default:
            break;
    }
    return isCanVisitPhotoLib;
}

/**
 提示用户做相应操作

 @param message 提示信息
 @param isToSetting 是否跳转到设置页面
 */
+ (void)showAlertWithMessage:(NSString *)message isToSetting:(BOOL)isToSetting {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (isToSetting) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if (IOS10) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }];
    [alertC addAction:sureAction];
    if (isToSetting) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertC addAction:cancelAction];
    }
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertC animated:YES completion:nil];
}


@end
