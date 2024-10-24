// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

// Copyright 2024, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import Foundation
import PackageDescription


// TODO - find a way to update the firebase-ios-sdk version to latest
// enum ConfigurationError: Error {
//   case fileNotFound(String)
//   case parsingError(String)
//   case invalidFormat(String)
// }

// func loadFirebaseSDKVersion() throws -> String {

//   let packageDirectory = URL(fileURLWithPath: #file).deletingLastPathComponent()
//   let firebaseCoreScriptPath = packageDirectory.appendingPathComponent("packages/firebase_core/firebase_core/ios/firebase_sdk_version.rb").path

//   do {
//     let content = try String(contentsOfFile: firebaseCoreScriptPath, encoding: .utf8)
//     let pattern = #"def firebase_sdk_version!\(\)\n\s+'([^']+)'\nend"#
//     if let regex = try? NSRegularExpression(pattern: pattern, options: []),
//        let match = regex.firstMatch(
//          in: content,
//          range: NSRange(content.startIndex..., in: content)
//        ) {
//       if let versionRange = Range(match.range(at: 1), in: content) {
//         return String(content[versionRange])
//       } else {
//         throw ConfigurationError.invalidFormat("Invalid format in firebase_sdk_version.rb")
//       }
//     } else {
//       throw ConfigurationError.parsingError("No match found in firebase_sdk_version.rb")
//     }
//   } catch {
//     throw ConfigurationError
//       .fileNotFound("Error loading or parsing firebase_sdk_version.rb: \(error)")
//   }
// }

// let firebase_sdk_version_string: String

// do {
//   firebase_sdk_version_string = try loadFirebaseSDKVersion()
// } catch {
//   fatalError("Failed to load configuration: \(error)")
// }

// guard let firebase_sdk_version = Version(firebase_sdk_version_string) else {
//   fatalError("Invalid Firebase SDK version: \(firebase_sdk_version_string)")
// }

// Shared Swift package manager code for firebase core
let package = Package(
  name: "remote_firebase_core",
  platforms: [
    .iOS("13.0"),
    .macOS("10.15"),
  ],
  products: [
    .library(name: "firebase-core-shared", targets: ["firebase_core_shared"]),
  ],
  dependencies: [
    .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "11.0.0"),
  ],
  targets: [
    .target(
      name: "firebase_core_shared",
      dependencies: [
        .product(name: "FirebaseInstallations", package: "firebase-ios-sdk"),
      ],
      path: "Sources/firebase_core_shared",
      publicHeadersPath: "include"
    ),
  ]
)
