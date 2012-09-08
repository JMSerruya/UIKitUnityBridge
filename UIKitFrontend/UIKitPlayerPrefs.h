//
//  FBPlayerPrefs.h
//  Unity-iPhone
//
//  Created by Juan Manuel Serruya on 8/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
//	Objective-C interface to the Unity PlayerPrefs file


#define DEFAULT_PREFS_FILE @"DefaultPlayerPrefs.plist"

@interface UIKitPlayerPrefs : NSObject
{
}

+ (void)setInt:(int)value withKey:(NSString *)key;
+ (void)setFloat:(float)value withKey:(NSString *)key;
+ (void)setString:(NSString *)value withKey:(NSString *)key;

+ (int)getInt:(NSString *)key orDefault:(int)value;
+ (float)getFloat:(NSString *)key orDefault:(float)value;
+ (NSString *)getString:(NSString *)key orDefault:(NSString *)value;

+ (BOOL)hasKey:(NSString *)key;
+ (void)deleteKey:(NSString *)key;

+ (void)readPrefsFile;
+ (void)saveAndUnload;
@end
