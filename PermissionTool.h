//
//  PermissionTool.h
//  THSS
//
//  Created by lianditech on 2018/5/8.
//  Copyright © 2018年 lianditech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PermissionTool : NSObject

/**
 检查相机权限，如果用户没有授权，提示去授权

 @param requestSucessBlock 授权成功回调
 @return 是否拥有权限
 */
+ (BOOL)checkCameraPermissionWithRequestAuthorizationBlock:(void (^) (void))requestSucessBlock;

/**
 检查相册权限，如果用户没有授权，提示去授权

 @param requestSucessBlock 授权成功回调
 @return 是否拥有权限
 */
+ (BOOL)checkPhotoLibPermissionWithRequestAuthorizationBlock:(void (^) (void))requestSucessBlock;

@end
