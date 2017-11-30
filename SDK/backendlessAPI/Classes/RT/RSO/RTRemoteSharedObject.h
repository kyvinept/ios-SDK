//
//  RTRemoteSharedObject.h
//  backendlessAPI
/*
 * *********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 *  ********************************************************************************************************************
 *
 *  Copyright 2017 BACKENDLESS.COM. All Rights Reserved.
 *
 *  NOTICE: All information contained herein is, and remains the property of Backendless.com and its suppliers,
 *  if any. The intellectual and technical concepts contained herein are proprietary to Backendless.com and its
 *  suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret
 *  or copyright law. Dissemination of this information or reproduction of this material is strictly forbidden
 *  unless prior written permission is obtained from Backendless.com.
 *
 *  ********************************************************************************************************************
 */

#import <Foundation/Foundation.h>
#import "RTListener.h"
#import "Responder.h"
#import "RSOChangesObject.h"
#import "RSOClearedObject.h"
#import "CommandObject.h"
#import "UserStatusObject.h"
#import "InvokeObject.h"

@interface RTRemoteSharedObject : RTListener

@property (strong, nonatomic) id invocationTarget;

-(instancetype)initWithRSOName:(NSString *)rsoName;
-(void)connect:(void(^)(id))onSuccessfulConnect;

-(void)addErrorListener:(void(^)(Fault *))errorBlock;
-(void)removeErrorListener:(void(^)(Fault *))errorBlock;

-(void)addConnectListener:(BOOL)isConnected onConnect:(void(^)(void))onConnect;
-(void)removeConnectListener:(void(^)(void))onConnect;

-(void)addChangesListener:(void(^)(RSOChangesObject *))onChange;
-(void)removeChangesListener:(void(^)(RSOChangesObject *))onChange;

-(void)addClearListener:(void(^)(RSOClearedObject *))onClear;
-(void)removeClearListener:(void(^)(RSOClearedObject *))onClear;

-(void)addCommandListener:(void(^)(CommandObject *))onCommand;
-(void)removeCommandListener:(void(^)(CommandObject *))onCommand;

-(void)addUserStatusListener:(void(^)(UserStatusObject *))onUserStatus;
-(void)removeUserStatusListener:(void(^)(UserStatusObject *))onUserStatus;

-(void)addInvokeListener:(void(^)(InvokeObject *))onInvoke;
-(void)removeInvokeListener:(void(^)(InvokeObject *))onInvoke;

// commands
-(void)get:(NSString *)key onSuccess:(void(^)(id))onSuccess onError:(void(^)(Fault *))onError;
-(void)set:(NSString *)key data:(id)data onSuccess:(void(^)(id))onSuccess onError:(void(^)(Fault *))onError;
-(void)clear:(void(^)(id))onSuccess onError:(void(^)(Fault *))onError;
-(void)sendCommand:(NSString *)commandName data:(id)data onSuccess:(void(^)(id))onSuccess onError:(void(^)(Fault *))onError;
-(void)invoke:(NSString *)method targets:(NSArray *)targets args:(NSArray *)args onSuccess:(void(^)(id))onSuccess onError:(void(^)(Fault *))onError;

@end
