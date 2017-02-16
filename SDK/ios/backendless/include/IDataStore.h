//
//  IDataStore.h
//  backendlessAPI
/*
 * *********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 *  ********************************************************************************************************************
 *
 *  Copyright 2012 BACKENDLESS.COM. All Rights Reserved.
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
#import "LoadRelationsQueryBuilder.h"
#import "DataQueryBuilder.h"

@class QueryOptions, BackendlessDataQuery, Fault, ObjectProperty;
@protocol IResponder;

@protocol IDataStore <NSObject>

// sync methods with fault return (as exception)
//-(id)save:(id)entity;
-(NSNumber *)remove:(id)entity;
-(NSNumber *)removeID:(NSString *)objectID;
-(NSArray *)find;
-(NSArray *)find:(DataQueryBuilder *)dataQuery;
-(NSArray<ObjectProperty*> *)describe;
-(id)findFirst;
-(id)findFirst:(int)relationsDepth;
-(id)findFirstWithRelations:(NSArray<NSString*> *)relations;
-(id)findFirst:(NSArray<NSString*> *)relations relationsDepth:(int)relationsDepth;
-(id)findLast;
-(id)findLast:(int)relationsDepth;
-(id)findLastWithRelations:(NSArray<NSString*> *)relations;
-(id)findLast:(NSArray<NSString*> *)relations relationsDepth:(int)relationsDepth;
-(id)findID:(id)objectID;
-(id)findID:(id)objectID relationsDepth:(int)relationsDepth;
-(id)findID:(id)objectID relations:(NSArray<NSString*> *)relations;
-(id)findID:(id)objectID relations:(NSArray<NSString*> *)relations relationsDepth:(int)relationsDepth;
-(NSNumber *)getObjectCount;
-(NSNumber *)getObjectCount:(DataQueryBuilder *)dataQuery;
//
-(NSNumber *)setRelation:(NSString *)columnName parentObjectId:(NSString *)parentObjectId childObjects:(NSArray *)childObjects;
-(NSNumber *)setRelation:(NSString *)columnName parentObjectId:(NSString *)parentObjectId whereClause:(NSString *)whereClause;
-(NSNumber *)addRelation:(NSString *)columnName parentObjectId:(NSString *)parentObjectId childObjects:(NSArray *)childObjects;
-(NSNumber *)addRelation:(NSString *)columnName parentObjectId:(NSString *)parentObjectId whereClause:(NSString *)whereClause;
-(NSNumber *)deleteRelation:(NSString *)columnName parentObjectId:(NSString *)parentObjectId childObjects:(NSArray *)childObjects;
-(NSNumber *)deleteRelation:(NSString *)columnName parentObjectId:(NSString *)parentObjectId whereClause:(NSString *)whereClause;

-(NSArray*)loadRelations:(NSString *)objectID queryBuilder:(LoadRelationsQueryBuilder *)queryBuilder;

// async methods with block-based callbacks
-(void)save:(id)entity response:(void(^)(id))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)remove:(id)entity response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)removeID:(NSString *)objectID response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)find:(void(^)(NSArray *))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)find:(DataQueryBuilder *)dataQuery response:(void(^)(NSArray *))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)findFirst:(void(^)(id))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)findFirst:(int)relationsDepth response:(void(^)(id))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)findFirstWithRelations:(NSArray<NSString*> *)relations response:(void(^)(id))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)findFirst:(NSArray<NSString*> *)relations relationsDepth:(int)relationsDepth response:(void(^)(id))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)findLast:(void(^)(id))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)findLast:(int)relationsDepth response:(void(^)(id))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)findLastWithRelations:(NSArray<NSString*> *)relations response:(void(^)(id))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)findLast:(NSArray<NSString*> *)relations relationsDepth:(int)relationsDepth response:(void(^)(id))responseBlock error:(void(^)(Fault *))errorBlock;

-(void)describeResponse:(void(^)(NSArray<ObjectProperty*> *))responseBlock error:(void(^)(Fault *))errorBlock;

-(void)findID:(id)objectID response:(void(^)(id))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)findID:(id)objectID relationsDepth:(int)relationsDepth response:(void(^)(id))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)findID:(id)objectID relations:(NSArray<NSString*> *)relations response:(void(^)(id))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)findID:(NSString *)objectID relations:(NSArray<NSString*> *)relations relationsDepth:(int)relationsDepth response:(void(^)(id))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)getObjectCount:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)getObjectCount:(DataQueryBuilder *)dataQuery response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock;
//
-(void)setRelation:(NSString *)columnName parentObjectId:(NSString *)parentObjectId childObjects:(NSArray *)childObjects response:(void(^)(id))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)setRelation:(NSString *)columnName parentObjectId:(NSString *)parentObjectId whereClause:(NSString *)whereClause response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)addRelation:(NSString *)columnName parentObjectId:(NSString *)parentObjectId childObjects:(NSArray *)childObjects response:(void(^)(id))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)addRelation:(NSString *)columnName parentObjectId:(NSString *)parentObjectId whereClause:(NSString *)whereClause response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)deleteRelation:(NSString *)columnName parentObjectId:(NSString *)parentObjectId childObjects:(NSArray *)childObjects response:(void(^)(id))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)deleteRelation:(NSString *)columnName parentObjectId:(NSString *)parentObjectId whereClause:(NSString *)whereClause response:(void(^)(NSArray *))responseBlock error:(void(^)(Fault *))errorBlock;

-(void)loadRelations:(NSString *)objectID queryBuilder:(LoadRelationsQueryBuilder *)queryBuilder response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock;
@end
