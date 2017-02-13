//
//  AtomicOperation.m
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

#import "AtomicCounters.h"
#import "Backendless.h"
#import "Invoker.h"
#import "AtomicCountersFactory.h"

#define FAULT_NO_NAME [Fault fault:@"Name is NULL" detail:@"Name is NULL" faultCode:@"8900"]

// SERVICE NAME
static NSString *SERVER_ATOMIC_OPERATION_SERVICE_PATH = @"com.backendless.services.redis.AtomicOperationService";
// METHOD NAMES
static NSString *METHOD_GET = @"get";
static NSString *METHOD_GET_AND_INCREMENT = @"getAndIncrement";
static NSString *METHOD_INCREMENT_AND_GET = @"incrementAndGet";
static NSString *METHOD_GET_AND_DECREMENT = @"getAndDecrement";
static NSString *METHOD_DECREMENT_AND_GET = @"decrementAndGet";
static NSString *METHOD_ADD_AND_GET = @"addAndGet";
static NSString *METHOD_GET_AND_ADD = @"getAndAdd";
static NSString *METHOD_COMPARE_AND_SET = @"compareAndSet";
static NSString *METHOD_RESET = @"reset";

@implementation AtomicCounters

-(id)init {
	if ( (self=[super init]) ) {
        
	}
	
	return self;
}

-(void)dealloc {
	
	[DebLog logN:@"DEALLOC AtomicCounters"];
	
	[super dealloc];
}

#pragma mark Public Methods

// sync methods with fault return (as exception)

-(NSNumber *)get:(NSString *)counterName {
    
    if (!counterName)
        return [backendless throwFault:FAULT_NO_NAME];
    
    NSArray *args = @[counterName];
    return [invoker invokeSync:SERVER_ATOMIC_OPERATION_SERVICE_PATH method:METHOD_GET args:args];
}

-(NSNumber *)getAndIncrement:(NSString *)counterName {
    
    if (!counterName)
        return [backendless throwFault:FAULT_NO_NAME];
    
    NSArray *args = @[counterName];
    return [invoker invokeSync:SERVER_ATOMIC_OPERATION_SERVICE_PATH method:METHOD_GET_AND_INCREMENT args:args];
}

-(NSNumber *)incrementAndGet:(NSString *)counterName {
    
    if (!counterName)
        return [backendless throwFault:FAULT_NO_NAME];
    
    NSArray *args = @[counterName];
    return [invoker invokeSync:SERVER_ATOMIC_OPERATION_SERVICE_PATH method:METHOD_INCREMENT_AND_GET args:args];
}

-(NSNumber *)getAndDecrement:(NSString *)counterName {
    
    if (!counterName)
        return [backendless throwFault:FAULT_NO_NAME];
    
    NSArray *args = @[counterName];
    return [invoker invokeSync:SERVER_ATOMIC_OPERATION_SERVICE_PATH method:METHOD_GET_AND_DECREMENT args:args];
}

-(NSNumber *)decrementAndGet:(NSString *)counterName {
    
    if (!counterName)
        return [backendless throwFault:FAULT_NO_NAME];
    
    NSArray *args = @[counterName];
    return [invoker invokeSync:SERVER_ATOMIC_OPERATION_SERVICE_PATH method:METHOD_DECREMENT_AND_GET args:args];
}

-(NSNumber *)addAndGet:(NSString *)counterName value:(long)value {
    
    if (!counterName)
        return [backendless throwFault:FAULT_NO_NAME];
    
    NSArray *args = @[counterName, [NSNumber numberWithLong:value]];
    return [invoker invokeSync:SERVER_ATOMIC_OPERATION_SERVICE_PATH method:METHOD_ADD_AND_GET args:args];
}

-(NSNumber *)getAndAdd:(NSString *)counterName value:(long)value {
    
    if (!counterName)
        return [backendless throwFault:FAULT_NO_NAME];
    
    NSArray *args = @[counterName, [NSNumber numberWithLong:value]];
    return [invoker invokeSync:SERVER_ATOMIC_OPERATION_SERVICE_PATH method:METHOD_GET_AND_ADD args:args];
}

-(NSNumber *)compareAndSet:(NSString *)counterName expected:(long)expected updated:(long)updated {
    
    if (!counterName)
        return [backendless throwFault:FAULT_NO_NAME];
    
    NSArray *args = @[counterName, [NSNumber numberWithLong:expected], [NSNumber numberWithLong:updated]];
    return [invoker invokeSync:SERVER_ATOMIC_OPERATION_SERVICE_PATH method:METHOD_COMPARE_AND_SET args:args];
}

-(id)reset:(NSString *)counterName  {
    
    if (!counterName)
        return [backendless throwFault:FAULT_NO_NAME];
    
    NSArray *args = @[counterName];
    return [invoker invokeSync:SERVER_ATOMIC_OPERATION_SERVICE_PATH method:METHOD_RESET args:args];
}

// async methods with responder

-(void)get:(NSString *)counterName responder:(id<IResponder>)responder {
    
    if (!counterName)
        return [responder errorHandler:FAULT_NO_NAME];
    
    NSArray *args = @[counterName];
    [invoker invokeAsync:SERVER_ATOMIC_OPERATION_SERVICE_PATH method:METHOD_GET args:args responder:responder];
}

-(void)getAndIncrement:(NSString *)counterName responder:(id<IResponder>)responder {
    
    if (!counterName)
        return [responder errorHandler:FAULT_NO_NAME];
    
    NSArray *args = @[counterName];
    [invoker invokeAsync:SERVER_ATOMIC_OPERATION_SERVICE_PATH method:METHOD_GET_AND_INCREMENT args:args responder:responder];
}

-(void)incrementAndGet:(NSString *)counterName responder:(id<IResponder>)responder {
    
    if (!counterName)
        return [responder errorHandler:FAULT_NO_NAME];
    
    NSArray *args = @[counterName];
    [invoker invokeAsync:SERVER_ATOMIC_OPERATION_SERVICE_PATH method:METHOD_INCREMENT_AND_GET args:args responder:responder];
}

-(void)getAndDecrement:(NSString *)counterName responder:(id<IResponder>)responder {
    
    if (!counterName)
        return [responder errorHandler:FAULT_NO_NAME];
    
    NSArray *args = @[counterName];
    [invoker invokeAsync:SERVER_ATOMIC_OPERATION_SERVICE_PATH method:METHOD_GET_AND_DECREMENT args:args responder:responder];
}

-(void)decrementAndGet:(NSString *)counterName responder:(id<IResponder>)responder {
    
    if (!counterName)
        return [responder errorHandler:FAULT_NO_NAME];
    
    NSArray *args = @[counterName];
    [invoker invokeAsync:SERVER_ATOMIC_OPERATION_SERVICE_PATH method:METHOD_DECREMENT_AND_GET args:args responder:responder];
}

-(void)addAndGet:(NSString *)counterName value:(long)value responder:(id<IResponder>)responder {
    
    if (!counterName)
        return [responder errorHandler:FAULT_NO_NAME];
    
    NSArray *args = @[counterName, [NSNumber numberWithLong:value]];
    [invoker invokeAsync:SERVER_ATOMIC_OPERATION_SERVICE_PATH method:METHOD_ADD_AND_GET args:args responder:responder];
}

-(void)getAndAdd:(NSString *)counterName value:(long)value responder:(id<IResponder>)responder {
    
    if (!counterName)
        return [responder errorHandler:FAULT_NO_NAME];
    
    NSArray *args = @[counterName, [NSNumber numberWithLong:value]];
    [invoker invokeAsync:SERVER_ATOMIC_OPERATION_SERVICE_PATH method:METHOD_GET_AND_ADD args:args responder:responder];
}

-(void)compareAndSet:(NSString *)counterName expected:(long)expected updated:(long)updated responder:(id<IResponder>)responder {
    
    if (!counterName)
        return [responder errorHandler:FAULT_NO_NAME];
    
    NSArray *args = @[counterName, [NSNumber numberWithLong:expected], [NSNumber numberWithLong:updated]];
    [invoker invokeAsync:SERVER_ATOMIC_OPERATION_SERVICE_PATH method:METHOD_COMPARE_AND_SET args:args responder:responder];
}

-(void)reset:(NSString *)counterName responder:(id<IResponder>)responder {
    
    if (!counterName)
        return [responder errorHandler:FAULT_NO_NAME];
    
    NSArray *args = @[counterName];
    [invoker invokeAsync:SERVER_ATOMIC_OPERATION_SERVICE_PATH method:METHOD_RESET args:args responder:responder];
}

// async methods with block-based callbacks

-(void)get:(NSString *)counterName response:(void (^)(NSNumber *))responseBlock error:(void (^)(Fault *))errorBlock {
    [self get:counterName responder:[ResponderBlocksContext responderBlocksContext:responseBlock error:errorBlock]];
}

-(void)getAndIncrement:(NSString *)counterName response:(void (^)(NSNumber *))responseBlock error:(void (^)(Fault *))errorBlock {
    [self getAndIncrement:counterName responder:[ResponderBlocksContext responderBlocksContext:responseBlock error:errorBlock]];
}

-(void)incrementAndGet:(NSString *)counterName response:(void (^)(NSNumber *))responseBlock error:(void (^)(Fault *))errorBlock {
    [self incrementAndGet:counterName responder:[ResponderBlocksContext responderBlocksContext:responseBlock error:errorBlock]];
}

-(void)getAndDecrement:(NSString *)counterName response:(void (^)(NSNumber *))responseBlock error:(void (^)(Fault *))errorBlock {
    [self getAndDecrement:counterName responder:[ResponderBlocksContext responderBlocksContext:responseBlock error:errorBlock]];
}

-(void)decrementAndGet:(NSString *)counterName response:(void (^)(NSNumber *))responseBlock error:(void (^)(Fault *))errorBlock {
    [self decrementAndGet:counterName responder:[ResponderBlocksContext responderBlocksContext:responseBlock error:errorBlock]];
}

-(void)addAndGet:(NSString *)counterName value:(long)value response:(void (^)(NSNumber *))responseBlock error:(void (^)(Fault *))errorBlock {
    [self addAndGet:counterName value:value responder:[ResponderBlocksContext responderBlocksContext:responseBlock error:errorBlock]];
}

-(void)getAndAdd:(NSString *)counterName value:(long)value response:(void (^)(NSNumber *))responseBlock error:(void (^)(Fault *))errorBlock {
    [self getAndAdd:counterName value:value responder:[ResponderBlocksContext responderBlocksContext:responseBlock error:errorBlock]];
}

-(void)compareAndSet:(NSString *)counterName expected:(long)expected updated:(long)updated response:(void (^)(NSNumber *))responseBlock error:(void (^)(Fault *))errorBlock {
    [self compareAndSet:counterName expected:expected updated:updated responder:[ResponderBlocksContext responderBlocksContext:responseBlock error:errorBlock]];
}

-(void)reset:(NSString *)counterName response:(void (^)(id))responseBlock error:(void (^)(Fault *))errorBlock {
    [self reset:counterName responder:[ResponderBlocksContext responderBlocksContext:responseBlock error:errorBlock]];
}

// IAtomicCounters factory
-(id <IAtomic>)of:(NSString *)counterName {
    return [AtomicCountersFactory create:counterName];
}

@end
