// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
#import <TargetConditionals.h>

#if TARGET_OS_OSX
#import <FlutterMacOS/FlutterMacOS.h>
#else
#import <Flutter/Flutter.h>
#endif

#import "FLTFirebasePlugin.h"
#if __has_include("include/messages.g.h")
#import "include/messages.g.h"
#elif __has_include("include/firebase_core/messages.g.h")
#import "include/firebase_core/messages.g.h"
#elif __has_include("firebase_core/include/firebase_core/messages.g.h")
#import "firebase_core/include/firebase_core/messages.g.h"
#else
@import firebase_core_shared;
#endif

@interface FLTFirebaseCorePlugin
    : FLTFirebasePlugin <FlutterPlugin, FLTFirebasePlugin, FirebaseCoreHostApi, FirebaseAppHostApi>

+ (NSString *)getCustomDomain:(NSString *)appName;

@end
