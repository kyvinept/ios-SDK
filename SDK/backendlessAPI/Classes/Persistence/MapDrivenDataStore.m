//
//  MapDrivenDataStore.m
//  backendlessAPI
/*
 * *********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 *  ********************************************************************************************************************
 *
 *  Copyright 2016 BACKENDLESS.COM. All Rights Reserved.
 *
 *  NOTICE: All information contained herein is, and remains the property of Backendless.com and its suppliers,
 *  if any. The intellectual and technical concepts contained herein are proprietary to Backendless.com and its
 *  suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret
 *  or copyright law. Dissemination of this information or reproduction of this material is strictly forbidden
 *  unless prior written permission is obtained from Backendless.com.
 *
 *  ********************************************************************************************************************
 */

#import "MapDrivenDataStore.h"
#include "Backendless.h"
#import "Invoker.h"
#include "Responder.h"
#import "ObjectProperty.h"
#import "ClassCastException.h"
#import "ObjectSerializer.h"

#define FAULT_NO_ENTITY [Fault fault:@"Entity is missing or null" detail:@"Entity is missing or null" faultCode:@"1900"]
#define FAULT_OBJECT_ID_IS_NOT_EXIST [Fault fault:@"objectId is missing or null" detail:@"objectId is missing or null" faultCode:@"1901"]
#define FAULT_NAME_IS_NULL [Fault fault:@"Name is missing or null" detail:@"Name is missing or null" faultCode:@"1902"]


// SERVICE NAME
static NSString *_SERVER_PERSISTENCE_SERVICE_PATH = @"com.backendless.services.persistence.PersistenceService";

@implementation MapDrivenDataStore

-(id)init {
    if (self = [super init]) {
        _tableName = nil;
        [self setClassMapping];
    }
    return self;
}

-(id)init:(NSString *)tableName {
    if (self = [super init]) {
        _tableName = [tableName retain];
        [self setClassMapping];
    }
    return self;
}

+(id)createDataStore:(NSString *)tableName {
    return [[MapDrivenDataStore alloc] init:tableName];
}

-(void)dealloc {
    [DebLog logN:@"DEALLOC MapDrivenDataStore"];
    [_tableName release];
    [super dealloc];
}

#pragma mark Private Methods

-(void)setClassMapping {
    if (backendless.data) {
        return;
    }
    [[Types sharedInstance] addClientClassMapping:@"com.backendless.services.persistence.NSArray" mapped:[NSArray class]];
    [[Types sharedInstance] addClientClassMapping:@"com.backendless.services.persistence.ObjectProperty" mapped:[ObjectProperty class]];
    [[Types sharedInstance] addClientClassMapping:@"com.backendless.geo.model.GeoPoint" mapped:[GeoPoint class]];
    [[Types sharedInstance] addClientClassMapping:@"java.lang.ClassCastException" mapped:[ClassCastException class]];
}

-(NSArray *)fixClassCollection:(NSArray *)bc {
    if (bc.count && ![bc[0] isKindOfClass:NSDictionary.class]) {
        NSMutableArray *data = [NSMutableArray array];
        for (id item in bc) {
            [data addObject:[Types propertyDictionary:item]];
        }
        bc = [NSArray arrayWithArray:data];
    }
    return bc;
}

#pragma mark Public Methods

// sync methods with fault return (as exception)
-(id)save:(id)entity {
    if (!entity) {
        return [backendless throwFault:FAULT_NO_ENTITY];
    }
    NSArray *args = @[_tableName, entity];
    id result = [invoker invokeSync:_SERVER_PERSISTENCE_SERVICE_PATH method:@"save" args:args];
    return [result isKindOfClass:NSDictionary.class]?result:[Types propertyDictionary:result];
}

-(NSNumber *)remove:(NSDictionary<NSString*,id> *)entity {
    if (!entity) {
        return [backendless throwFault:FAULT_NO_ENTITY];
    }
    NSArray *args = @[_tableName, entity];
    return [invoker invokeSync:_SERVER_PERSISTENCE_SERVICE_PATH method:@"remove" args:args];
}

-(NSArray *)find {
    NSArray *args = @[_tableName, [DataQueryBuilder new]];
    return [invoker invokeSync:_SERVER_PERSISTENCE_SERVICE_PATH method:@"find" args:args];
}

-(NSArray *)find:(DataQueryBuilder *)queryBuilder {
    NSArray *args = @[_tableName, [queryBuilder build]];
    id result = [invoker invokeSync:_SERVER_PERSISTENCE_SERVICE_PATH method:@"find" args:args];
    if ([result isKindOfClass:[Fault class]]) {
        return result;
    }
    NSArray *bc = (NSArray *)result;
    return [self fixClassCollection:bc];
}

-(id)findFirst {
    NSArray *args = @[_tableName];
    id result = [invoker invokeSync:_SERVER_PERSISTENCE_SERVICE_PATH method:@"first" args:args];
    return [result isKindOfClass:NSDictionary.class]?result:[Types propertyDictionary:result];
}

-(id)findFirst:(DataQueryBuilder *)queryBuilder {
    NSArray *args = @[_tableName, [queryBuilder getRelated]?[queryBuilder getRelated]:@[], @([queryBuilder getRelationsDepth]), [queryBuilder getProperties]];
    id result = [invoker invokeSync:_SERVER_PERSISTENCE_SERVICE_PATH method:@"first" args:args];
    return [result isKindOfClass:NSDictionary.class]?result:[Types propertyDictionary:result];
}

-(id)findLast {
    NSArray *args = @[_tableName];
    id result = [invoker invokeSync:_SERVER_PERSISTENCE_SERVICE_PATH method:@"last" args:args];
    return [result isKindOfClass:NSDictionary.class]?result:[Types propertyDictionary:result];
}

-(id)findLast:(DataQueryBuilder *)queryBuilder {
    NSArray *args = @[_tableName, [queryBuilder getRelated]?[queryBuilder getRelated]:@[], @([queryBuilder getRelationsDepth]), [queryBuilder getProperties]];
    id result = [invoker invokeSync:_SERVER_PERSISTENCE_SERVICE_PATH method:@"last" args:args];
    return [result isKindOfClass:NSDictionary.class]?result:[Types propertyDictionary:result];
}

-(id)findById:(id)objectId {
    if ([objectId isKindOfClass:[NSString class]]) {
        return [backendless.persistenceService findById:_tableName objectId:objectId];
    }
    else if ([objectId isKindOfClass:[NSDictionary class]]) {
        return [backendless.persistenceService findByObject:_tableName keys:objectId];
    }
    else {
        return [backendless.persistenceService findByObject:objectId];
    }
}

-(id)findById:(id)objectId queryBuilder:(DataQueryBuilder *)queryBuilder {
    
    if ([objectId isKindOfClass:[NSString class]]) {
        return [backendless.persistenceService findById:_tableName objectId:objectId queryBuilder:queryBuilder];
    }
    else if ([objectId isKindOfClass:[NSDictionary class]]) {
        return [backendless.persistenceService findByObject:_tableName keys:objectId queryBuilder:queryBuilder];
    }
    else {
        return [backendless.persistenceService findByObject:objectId queryBuilder:queryBuilder];
    }
}

-(NSNumber *)getObjectCount {
    NSArray *args = @[_tableName];
    return [invoker invokeSync:_SERVER_PERSISTENCE_SERVICE_PATH method:@"count" args:args];
}

-(NSNumber *)getObjectCount:(DataQueryBuilder *)dataQuery{
    NSArray *args = @[_tableName, [dataQuery build]];
    return [invoker invokeSync:_SERVER_PERSISTENCE_SERVICE_PATH method:@"count" args:args];
}

-(NSNumber *)setRelation:(NSString *)columnName parentObjectId:(NSString *)parentObjectId childObjects:(NSArray *)childObjects {
    return [backendless.persistenceService setRelation:_tableName columnName:columnName parentObjectId:parentObjectId childObjects:childObjects];
}

-(NSNumber *)setRelation:(NSString *)columnName parentObjectId:(NSString *)parentObjectId whereClause:(NSString *)whereClause{
    return [backendless.persistenceService setRelation:_tableName columnName:columnName parentObjectId:parentObjectId whereClause:whereClause];
}

-(NSNumber *)addRelation:(NSString *)columnName parentObjectId:(NSString *)parentObjectId childObjects:(NSArray *)childObjects{
    return [backendless.persistenceService addRelation:_tableName columnName:columnName parentObjectId:parentObjectId childObjects:childObjects];
}

-(NSNumber *)addRelation:(NSString *)columnName parentObjectId:(NSString *)parentObjectId whereClause:(NSString *)whereClause{
    return [backendless.persistenceService addRelation:_tableName columnName:columnName parentObjectId:parentObjectId whereClause:whereClause];
}

-(NSNumber *)deleteRelation:(NSString *)columnName parentObjectId:(NSString *)parentObjectId childObjects:(NSArray *)childObjects{
    return [backendless.persistenceService deleteRelation:_tableName columnName:columnName parentObjectId:parentObjectId childObjects:childObjects];
}

-(NSNumber *)deleteRelation:(NSString *)columnName parentObjectId:(NSString *)parentObjectId whereClause:(NSString *)whereClause{
    return [backendless.persistenceService deleteRelation:_tableName columnName:columnName parentObjectId:parentObjectId whereClause:whereClause];
}

-(NSArray*)loadRelations:(NSString *)objectId queryBuilder:(LoadRelationsQueryBuilder *)queryBuilder {
    return [backendless.persistenceService loadRelations:_tableName objectId:(NSString *)objectId  queryBuilder:(LoadRelationsQueryBuilder *)queryBuilder];
}

// async methods with block-based callbacks

-(void)save:(id)entity response:(void(^)(id))responseBlock error:(void(^)(Fault *))errorBlock {
    Responder *chainedResponder = [ResponderBlocksContext responderBlocksContext:responseBlock error:errorBlock];
    NSArray *args = @[_tableName, entity];
    [invoker invokeAsync:_SERVER_PERSISTENCE_SERVICE_PATH method:@"save" args:args responder:chainedResponder];
}

-(void)remove:(NSDictionary<NSString*,id> *)entity response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock {
    Responder *chainedResponder = [ResponderBlocksContext responderBlocksContext:responseBlock error:errorBlock];
    NSArray *args = @[_tableName, entity];
    [invoker invokeAsync:_SERVER_PERSISTENCE_SERVICE_PATH method:@"remove" args:args responder:chainedResponder];
}

-(void)find:(void(^)(NSArray *))responseBlock error:(void(^)(Fault *))errorBlock {
    Responder *chainedResponder = [ResponderBlocksContext responderBlocksContext:responseBlock error:errorBlock];
    NSArray *args = @[_tableName, [DataQueryBuilder new]];
    [invoker invokeAsync:_SERVER_PERSISTENCE_SERVICE_PATH method:@"find" args:args responder:chainedResponder];
}

-(void)find:(DataQueryBuilder *)queryBuilder response:(void(^)(NSArray *))responseBlock error:(void(^)(Fault *))errorBlock {
    Responder *chainedResponder = [ResponderBlocksContext responderBlocksContext:responseBlock error:errorBlock];
    NSArray *args = @[_tableName, [queryBuilder build]];
    [invoker invokeAsync:_SERVER_PERSISTENCE_SERVICE_PATH method:@"find" args:args responder:chainedResponder];
}

-(void)findFirst:(void(^)(id))responseBlock error:(void(^)(Fault *))errorBlock {
    Responder *chainedResponder = [ResponderBlocksContext responderBlocksContext:responseBlock error:errorBlock];
    NSArray *args = @[_tableName];
    [invoker invokeAsync:_SERVER_PERSISTENCE_SERVICE_PATH method:@"first" args:args responder:chainedResponder];
}

-(void)findFirst:(DataQueryBuilder *)queryBuilder response:(void(^)(id))responseBlock error:(void(^)(Fault *))errorBlock {
    Responder *chainedResponder = [ResponderBlocksContext responderBlocksContext:responseBlock error:errorBlock];
    NSArray *args = @[_tableName, [queryBuilder getRelated]?[queryBuilder getRelated]:@[], @([queryBuilder getRelationsDepth]), [queryBuilder getProperties]];
    [invoker invokeAsync:_SERVER_PERSISTENCE_SERVICE_PATH method:@"first" args:args responder:chainedResponder];
}

-(void)findLast:(void(^)(id))responseBlock error:(void(^)(Fault *))errorBlock {
    Responder *chainedResponder = [ResponderBlocksContext responderBlocksContext:responseBlock error:errorBlock];
    NSArray *args = @[_tableName];
    [invoker invokeAsync:_SERVER_PERSISTENCE_SERVICE_PATH method:@"last" args:args responder:chainedResponder];
}

-(void)findLast:(DataQueryBuilder *)queryBuilder response:(void(^)(id))responseBlock error:(void(^)(Fault *))errorBlock {
    Responder *chainedResponder = [ResponderBlocksContext responderBlocksContext:responseBlock error:errorBlock];
    NSArray *args = @[_tableName, [queryBuilder getRelated]?[queryBuilder getRelated]:@[], @([queryBuilder getRelationsDepth]), [queryBuilder getProperties]];
    [invoker invokeAsync:_SERVER_PERSISTENCE_SERVICE_PATH method:@"last" args:args responder:chainedResponder];
}

-(void)findById:(id)objectId response:(void(^)(id))responseBlock error:(void(^)(Fault *))errorBlock {
    if ([objectId isKindOfClass:[NSString class]]) {
        [backendless.persistenceService findById:_tableName objectId:objectId response:responseBlock error:errorBlock];
    }
    else if ([objectId isKindOfClass:[NSDictionary class]]) {
        [backendless.persistenceService findByObject:_tableName keys:objectId response:responseBlock error:errorBlock];
    }
    else {
        [backendless.persistenceService findByObject:objectId response:responseBlock error:errorBlock];
    }
}

-(void)findById:(id)objectId queryBuilder:(DataQueryBuilder *)queryBuilder response:(void(^)(id))responseBlock error:(void(^)(Fault *))errorBlock {
    if ([objectId isKindOfClass:[NSString class]]) {
        [backendless.persistenceService findById:_tableName objectId:objectId queryBuilder:queryBuilder response:responseBlock error:errorBlock];
    }
    else if ([objectId isKindOfClass:[NSDictionary class]]) {
        [backendless.persistenceService findByObject:_tableName keys:objectId queryBuilder:queryBuilder response:responseBlock error:errorBlock];
    }
    else {
        [backendless.persistenceService findByObject:objectId queryBuilder:queryBuilder response:responseBlock error:errorBlock];
    }
}

-(void)getObjectCount:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock {
    Responder *chainedResponder = [ResponderBlocksContext responderBlocksContext:responseBlock error:errorBlock];
    NSArray *args = @[_tableName];
    [invoker invokeAsync:_SERVER_PERSISTENCE_SERVICE_PATH method:@"count" args:args responder:chainedResponder];
}

-(void)getObjectCount:(DataQueryBuilder *)dataQuery response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock {
    Responder *chainedResponder = [ResponderBlocksContext responderBlocksContext:responseBlock error:errorBlock];
    NSArray *args = @[_tableName, [dataQuery build]];
    [invoker invokeAsync:_SERVER_PERSISTENCE_SERVICE_PATH method:@"count" args:args responder:chainedResponder];
}

-(void)setRelation:(NSString *)columnName parentObjectId:(NSString *)parentObjectId childObjects:(NSArray *)childObjects response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.persistenceService setRelation:(_tableName) columnName:columnName parentObjectId:parentObjectId childObjects:childObjects response:responseBlock error:errorBlock];
}

-(void)setRelation:(NSString *)columnName parentObjectId:(NSString *)parentObjectId whereClause:(NSString *)whereClause response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.persistenceService setRelation:(_tableName) columnName:columnName parentObjectId:parentObjectId whereClause:whereClause response:responseBlock error:errorBlock];
}

-(void)addRelation:(NSString *)columnName parentObjectId:(NSString *)parentObjectId childObjects:(NSArray *)childObjects response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.persistenceService addRelation:(_tableName) columnName:columnName parentObjectId:parentObjectId childObjects:childObjects response:responseBlock error:errorBlock];
}

-(void)addRelation:(NSString *)columnName parentObjectId:(NSString *)parentObjectId whereClause:(NSString *)whereClause response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.persistenceService addRelation:(_tableName) columnName:columnName parentObjectId:parentObjectId whereClause:whereClause response:responseBlock error:errorBlock];
}

-(void)deleteRelation:(NSString *)columnName parentObjectId:(NSString *)parentObjectId childObjects:(NSArray *)childObjects response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.persistenceService deleteRelation:(_tableName) columnName:columnName parentObjectId:parentObjectId childObjects:childObjects response:responseBlock error:errorBlock];
}

-(void)deleteRelation:(NSString *)columnName parentObjectId:(NSString *)parentObjectId whereClause:(NSString *)whereClause response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.persistenceService deleteRelation:(_tableName) columnName:columnName parentObjectId:parentObjectId whereClause:whereClause response:responseBlock error:errorBlock];
}

-(void)loadRelations:(NSString *)objectId queryBuilder:(LoadRelationsQueryBuilder *)queryBuilder response:(void(^)(NSArray *))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.persistenceService loadRelations:(_tableName) objectId:(NSString *)objectId  queryBuilder:(LoadRelationsQueryBuilder *)queryBuilder response:responseBlock error:errorBlock];
}

@end
