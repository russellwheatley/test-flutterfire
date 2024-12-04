// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

// Copyright 2024, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import Foundation
import PackageDescription

enum ConfigurationError: Error {
  case fileNotFound(String)
  case parsingError(String)
  case invalidFormat(String)
}

func loadPubspecVersion() throws -> String {
  let pubspecPath = NSString.path(withComponents: [
    "packages",
    "firebase_core",
    "firebase_core",
    "pubspec.yaml",
  ])
  do {
    let yamlString = try String(contentsOfFile: pubspecPath, encoding: .utf8)
    if let versionLine = yamlString.split(separator: "\n")
      .first(where: { $0.starts(with: "version:") }) {
      let version = versionLine.split(separator: ":")[1].trimmingCharacters(in: .whitespaces)
      return version.replacingOccurrences(of: "+", with: "-")
    } else {
      throw ConfigurationError.invalidFormat("No version line found in pubspec.yaml")
    }
  } catch {
    throw ConfigurationError.fileNotFound("Error loading or parsing pubspec.yaml: \(error)")
  }
}

let library_version_string: String

do {
  library_version_string = try loadPubspecVersion()
} catch {
  fatalError("Failed to load configuration: \(error)")
}

// Shared Swift package manager code for firebase core
let package = Package(
  name: "remote_firebase_core",
  platforms: [
    .iOS("13.0"),
    .macOS("10.15"),
  ],
  products: [
    .library(name: "firebase-core-shared", targets: ["firebase_core_shared"])
  ],
  dependencies: [
    // TODO: this is fine for now, but will require a way of retrieving the firebase-ios-sdk
    // likely create a script that runs in preCommit hook of melos
    .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "11.0.0")
  ],
  targets: [
    .target(
      name: "firebase_core_shared",
      dependencies: [
        .product(name: "FirebaseInstallations", package: "firebase-ios-sdk")
      ],
      path: "Sources/firebase_core_shared",
      publicHeadersPath: "include",
      cSettings: [
        .headerSearchPath("include/firebase_core"),
        .define("LIBRARY_VERSION", to: "\"\(library_version_string)\""),
        .define("LIBRARY_NAME", to: "\"flutter-fire-core\"")
      ]
    )
  ]
)
