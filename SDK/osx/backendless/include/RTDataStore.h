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
#import "RTListener.h"
#import "Responder.h"
#import "BulkResultObject.h"

typedef enum {
    MAPDRIVENDATASTORE = 0,
    DATASTOREFACTORY = 1
} DataStoreTypeEnum;

@interface RTDataStore : RTListener

-(instancetype)initWithTableName:(NSString *)tableName withEntity:(Class)tableEntity dataStoreType:(UInt32)dataStoreType;
-(Class)getTableEntity;
-(UInt32)getType;

-(void)addCreateListener:(void(^)(id))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)addCreateListener:(NSString *)whereClause response:(void(^)(id))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)removeCreateListeners:(NSString *)whereClause response:(void(^)(id))responseBlock;
-(void)removeCreateListenersWithCallback:(void(^)(id))responseBlock;
-(void)removeCreateListenersWithWhereClause:(NSString *)whereClause;
-(void)removeCreateListeners;

-(void)addUpdateListener:(void(^)(id))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)addUpdateListener:(NSString *)whereClause response:(void(^)(id))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)removeUpdateListeners:(NSString *)whereClause response:(void(^)(id))responseBlock;
-(void)removeUpdateListenersWithCallback:(void(^)(id))responseBlock;
-(void)removeUpdateListenersWithWhereClause:(NSString *)whereClause;
-(void)removeUpdateListeners;

-(void)addDeleteListener:(void(^)(id))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)addDeleteListener:(NSString *)whereClause response:(void(^)(id))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)removeDeleteListeners:(NSString *)whereClause response:(void(^)(id))responseBlock;
-(void)removeDeleteListenersWithCallback:(void(^)(id))responseBlock;
-(void)removeDeleteListenersWithWhereClause:(NSString *)whereClause;
-(void)removeDeleteListeners;

-(void)addBulkUpdateListener:(void(^)(BulkResultObject *))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)removeBulkUpdateListeners:(void(^)(BulkResultObject *))responseBlock;
-(void)removeBulkUpdateListeners;

-(void)addBulkDeleteListener:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock;;
-(void)removeBulkDeleteListeners:(void(^)(NSNumber *))responseBlock;
-(void)removeBulkDeleteListeners;

-(void)removeAllListeners;

@end

