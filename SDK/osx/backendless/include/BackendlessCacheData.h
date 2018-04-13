//
//  BackendlessCacheData.h
//  backendlessAPI
/*
 * *********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 *  ********************************************************************************************************************
 *
 *  Copyright 2014 BACKENDLESS.COM. All Rights Reserved.
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

typedef void(^BackendlessCacheDataSaveCompletion)(BOOL done);

@interface BackendlessCacheData : NSObject

@property (strong, nonatomic) id data;
@property (strong, nonatomic) NSNumber *timeToLive;
@property (strong, nonatomic) NSNumber *priority;
@property (strong, nonatomic, readonly) NSString *file;

-(void)increasePriority;
-(void)decreasePriority;
-(NSInteger)valPriority;
-(void)saveOnDiscCompletion:(BackendlessCacheDataSaveCompletion)block;
-(id)dataFromDisc;
-(id)initWithCache:(BackendlessCacheData *)cache;
-(void)remove;
-(void)removeFromDisc;

@end
