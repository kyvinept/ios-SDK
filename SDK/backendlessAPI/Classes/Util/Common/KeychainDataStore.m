//
//  KeychainDataStore.m
//  backendlessAPI
/*
 * *********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 *  ********************************************************************************************************************
 *
 *  Copyright 2018 BACKENDLESS.COM. All Rights Reserved.
 *
 *  NOTICE: All information contained herein is, and remains the property of Backendless.com and its suppliers,
 *  if any. The intellectual and technical concepts contained herein are proprietary to Backendless.com and its
 *  suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret
 *  or copyright law. Dissemination of this information or reproduction of this material is strictly forbidden
 *  unless prior written permission is obtained from Backendless.com.
 *
 *  ********************************************************************************************************************
 */


#import <Security/Security.h>
#import "KeychainDataStore.h"
#import "DEBUG.h"

@implementation KeychainDataStore

-(id)initWithService:(NSString *)service withGroup:(NSString *)group {
    if (self = [super init]) {
        _service = service?[[NSString alloc] initWithString:service]:nil;
        _group = group?[[NSString alloc] initWithString:group]:nil;
    }
    return  self;
}

-(void)dealloc {
    [DebLog logN:@"DEALLOC KeychainDataStore"];
    [_service release];
    [_group release];
    [super dealloc];
}

-(NSMutableDictionary *)prepareDict:(NSString *)key {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    NSData *encodedKey = [key dataUsingEncoding:NSUTF8StringEncoding];
    [dict setObject:encodedKey forKey:(id)kSecAttrGeneric];
    [dict setObject:encodedKey forKey:(id)kSecAttrAccount];
    [dict setObject:_service forKey:(id)kSecAttrService];
    [dict setObject:(id)kSecAttrAccessibleAlwaysThisDeviceOnly forKey:(id)kSecAttrAccessible];
    if (_group) {
        [dict setObject:_group forKey:(id)kSecAttrAccessGroup];
    }
    return  dict;
}

-(BOOL)save:(NSString *)key data:(NSData *)data {
    NSMutableDictionary *dict =[self prepareDict:key];
    [dict setObject:data forKey:(id)kSecValueData];
    OSStatus status = SecItemAdd((CFDictionaryRef)dict, NULL);
    if (errSecSuccess != status) {
        [DebLog log:@"KeychainDataStore -> save: (ERROR) key:%@ error:%ld", key, status];
    }
    return (errSecSuccess == status);
}

-(NSData *)get:(NSString*)key {
    NSMutableDictionary *dict = [self prepareDict:key];
    [dict setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    [dict setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    CFTypeRef result = NULL;
    OSStatus status = SecItemCopyMatching((CFDictionaryRef)dict,&result);
    if (status != errSecSuccess) {
        [DebLog log:@"KeychainDataStore -> get: (ERROR) key:%@ error:%ld", key, status];
        return nil;
    }
    return (NSData *)result;
}

-(BOOL)update:(NSString *)key data:(NSData *)data {
    NSMutableDictionary * dictKey =[self prepareDict:key];
    NSMutableDictionary * dictUpdate =[[NSMutableDictionary alloc] init];
    [dictUpdate setObject:data forKey:(id)kSecValueData];
    OSStatus status = SecItemUpdate((CFDictionaryRef)dictKey, (CFDictionaryRef)dictUpdate);
    if (errSecSuccess != status) {
        [DebLog log:@"KeychainDataStore -> update: (ERROR) key:%@ error:%ld", key, status];
    }
    return (errSecSuccess == status);
}

-(BOOL)remove:(NSString *)key {
    NSMutableDictionary *dict = [self prepareDict:key];    
    OSStatus status = SecItemDelete((CFDictionaryRef)dict);
    if ( status != errSecSuccess) {
        [DebLog log:@"KeychainDataStore -> remove: (ERROR) key:%@ error:%ld", key, status];
    }
    return (errSecSuccess == status);
}

@end
