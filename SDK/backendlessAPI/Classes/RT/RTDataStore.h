//
//  RTDataStore.h
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
#import "RTError.h"
#import "RTListener.h"

typedef enum {
    MAPDRIVENDATASTORE = 0,
    DATASTOREFACTORY = 1
} DataStoreTypeEnum;

@interface RTDataStore : RTListener

-(RTDataStore *)initWithTableName:(NSString *)tableName withEntity:(Class)tableEntity dataStoreType:(UInt32)dataStoreType;

-(void)addErrorListener:(void(^)(RTError *))onError;
-(void)removeErrorListener:(void(^)(RTError *))onError;
-(void)removeErrorListener;

-(void)addCreateListener:(void(^)(id))onCreate;
-(void)addCreateListener:(NSString *)whereClause onCreate:(void(^)(id))onCreate;
-(void)removeCreateListener:(NSString *)whereClause onCreate:(void(^)(id))onCreate;
-(void)removeCreateListenerWithCallback:(void(^)(id))onCreate;
-(void)removeCreateListenerWithWhereClause:(NSString *)whereClause;
-(void)removeCreateListener;

@end
