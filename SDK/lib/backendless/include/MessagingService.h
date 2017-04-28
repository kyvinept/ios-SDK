//
//  MessagingService.h
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
#import "HashMap.h"
#import "DeviceRegistration.h"

#define _OLD_NOTIFICATION_ 0

#define MESSAGE_TAG @"message"

#define IOS_ALERT_TAG @"ios-alert"
#define IOS_BADGE_TAG @"ios-badge"
#define String IOS_SOUND_TAG @"ios-sound"

#define ANDROID_TICKER_TEXT_TAG @"android-ticker-text"
#define ANDROID_CONTENT_TITLE_TAG @"android-content-title"
#define ANDROID_CONTENT_TEXT_TAG @"android-content-text"
#define ANDROID_ACTION_TAG @"android-action"

#define WP_TYPE_TAG @"wp-type"
#define WP_TITLE_TAG @"wp-title"
#define WP_TOAST_SUBTITLE_TAG @"wp-subtitle"
#define WP_TOAST_PARAMETER_TAG @"wp-parameter"
#define WP_TILE_BACKGROUND_IMAGE @"wp-backgroundImage"
#define WP_TILE_COUNT @"wp-count"
#define WP_TILE_BACK_TITLE @"wp-backTitle"
#define WP_TILE_BACK_BACKGROUND_IMAGE @"wp-backImage"
#define WP_TILE_BACK_CONTENT @"wp-backContent"
#define WP_RAW_DATA @"wp-raw"

@class UIUserNotificationCategory;
@class MessageStatus, PublishOptions, DeliveryOptions, SubscriptionOptions, BESubscription, BodyParts, Message, Fault;

@protocol IResponder;

@interface MessagingService : NSObject
@property (nonatomic) uint pollingFrequencyMs;
@property (strong, nonatomic, readonly) HashMap *subscriptions;

#if _OLD_NOTIFICATION_
// USE UNUserNotificationCenter requestAuthorizationWithOptions: (iOS10) OR UIApplication registerUserNotificationSettings: (<iOS9) instead
@property NSUInteger notificationTypes;
@property (strong, nonatomic) NSSet<UIUserNotificationCategory*> *categories;
#endif

// sync methods with fault return (as exception)
- (NSString *)registerDevice:(NSData *)deviceToken;
- (NSString *)registerDevice:(NSData *)deviceToken channels:(NSArray<NSString *> *)channels;
- (NSString *)registerDevice:(NSData *)deviceToken expiration:(NSDate *)expiration;
- (NSString *)registerDevice:(NSData *)deviceToken channels:(NSArray<NSString *> *)channels expiration:(NSDate *)expiration;
-(DeviceRegistration *)getRegistration:(NSString *)deviceId;
-(id)unregisterDevice;
-(id)unregisterDevice:(NSString *)deviceId;
-(MessageStatus *)publish:(NSString *)channelName message:(id)message;
-(MessageStatus *)publish:(NSString *)channelName message:(id)message publishOptions:(PublishOptions *)publishOptions;
-(MessageStatus *)publish:(NSString *)channelName message:(id)message deliveryOptions:(DeliveryOptions *)deliveryOptions;
-(MessageStatus *)publish:(NSString *)channelName message:(id)message publishOptions:(PublishOptions *)publishOptions deliveryOptions:(DeliveryOptions *)deliveryOptions;
-(id)cancel:(NSString *)messageId;
-(BESubscription *)subscribe:(NSString *)channelName;
-(BESubscription *)subscribe:(NSString *)channelName subscriptionResponse:(void(^)(NSArray<Message*> *))subscriptionResponseBlock subscriptionError:(void(^)(Fault *))subscriptionErrorBlock;
-(BESubscription *)subscribe:(NSString *)channelName subscriptionResponse:(void(^)(NSArray<Message*> *))subscriptionResponseBlock subscriptionError:(void(^)(Fault *))subscriptionErrorBlock subscriptionOptions:(SubscriptionOptions *)subscriptionOptions;
//
-(id)sendTextEmail:(NSString *)subject body:(NSString *)messageBody to:(NSArray<NSString*> *)recipients;
-(id)sendHTMLEmail:(NSString *)subject body:(NSString *)messageBody to:(NSArray<NSString*> *)recipients;
-(id)sendEmail:(NSString *)subject body:(BodyParts *)bodyParts to:(NSArray<NSString*> *)recipients;
-(id)sendEmail:(NSString *)subject body:(BodyParts *)bodyParts to:(NSArray<NSString*> *)recipients attachment:(NSArray *)attachments;
-(MessageStatus*)getMessageStatus:(NSString*)messageId;

// async methods with block-based callbacks
-(void)registerDevice:(NSData *)deviceToken response:(void(^)(NSString *))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)registerDevice:(NSData *)deviceToken channels:(NSArray<NSString *> *)channels response:(void(^)(NSString *))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)registerDevice:(NSData *)deviceToken expiration:(NSDate *)expiration response:(void(^)(NSString *))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)registerDevice:(NSData *)deviceToken channels:(NSArray<NSString *> *)channels expiration:(NSDate *)expiration response:(void(^)(NSString *))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)getRegistration:(NSString *)deviceId response:(void(^)(DeviceRegistration *))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)unregisterDevice:(void(^)(id))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)unregisterDevice:(NSString *)deviceId response:(void(^)(id))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)publish:(NSString *)channelName message:(id)message response:(void(^)(MessageStatus *))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)publish:(NSString *)channelName message:(id)message publishOptions:(PublishOptions *)publishOptions response:(void(^)(MessageStatus *))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)publish:(NSString *)channelName message:(id)message deliveryOptions:(DeliveryOptions *)deliveryOptions response:(void(^)(MessageStatus *))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)publish:(NSString *)channelName message:(id)message publishOptions:(PublishOptions *)publishOptions deliveryOptions:(DeliveryOptions *)deliveryOptions response:(void(^)(MessageStatus *))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)cancel:(NSString *)messageId response:(void(^)(id))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)subscribe:(NSString *)channelName response:(void(^)(BESubscription *))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)subscribe:(NSString *)channelName subscriptionResponse:(void(^)(NSArray<Message*> *))subscriptionResponseBlock subscriptionError:(void(^)(Fault *))subscriptionErrorBlock response:(void(^)(BESubscription *))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)subscribe:(NSString *)channelName subscriptionResponse:(void(^)(NSArray<Message*> *))subscriptionResponseBlock subscriptionError:(void(^)(Fault *))subscriptionErrorBlock subscriptionOptions:(SubscriptionOptions *)subscriptionOptions response:(void(^)(BESubscription *))responseBlock error:(void(^)(Fault *))errorBlock;
//
-(void)sendTextEmail:(NSString *)subject body:(NSString *)messageBody to:(NSArray<NSString*> *)recipients response:(void(^)(id))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)sendHTMLEmail:(NSString *)subject body:(NSString *)messageBody to:(NSArray<NSString*> *)recipients response:(void(^)(id))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)sendEmail:(NSString *)subject body:(BodyParts *)bodyParts to:(NSArray<NSString*> *)recipients response:(void(^)(id))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)sendEmail:(NSString *)subject body:(BodyParts *)bodyParts to:(NSArray<NSString*> *)recipients attachment:(NSArray *)attachments response:(void(^)(id))responseBlock error:(void(^)(Fault *))errorBlock;
-(void)getMessageStatus:(NSString*)messageId response:(void(^)(MessageStatus*))responseBlock error:(void(^)(Fault *))errorBlock;

// utilites
-(DeviceRegistration *)currentDevice;
-(NSString *)deviceTokenAsString:(NSData *)token;

@end
