<p align="center">
  <img src="https://github.com/mixpanel/mixpanel-android/blob/assets/mixpanel.png?raw=true" alt="Mixpanel Swift Library" height="150"/>
</p>


[![Build Status](https://travis-ci.org/mixpanel/mixpanel-swift.svg)](https://travis-ci.org/mixpanel/mixpanel-swift)
[![Average time to resolve an issue](http://isitmaintained.com/badge/resolution/mixpanel/mixpanel-swift.svg)](http://isitmaintained.com/project/mixpanel/mixpanel-swift "Average time to resolve an issue")
[![Percentage of issues still open](http://isitmaintained.com/badge/open/mixpanel/mixpanel-swift.svg)](http://isitmaintained.com/project/mixpanel/mixpanel-swift "Percentage of issues still open")
[![CocoaPods Compatible](http://img.shields.io/cocoapods/v/Mixpanel-swift.svg)](https://mixpanel.com)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)](https://github.com/Carthage/Carthage)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![Apache License](http://img.shields.io/cocoapods/l/Mixpanel-swift.svg)](https://mixpanel.com)
[![Documentation](https://mixpanel.github.io/mixpanel-swift/badge.svg)](https://mixpanel.github.io/mixpanel-swift)
# Table of Contents

<!-- MarkdownTOC -->

- [Introduction](#introduction)
    - [Current supported features](#current-supported-features)
- [Installation](#installation)
    - [CocoaPods](#cocoapods)
    - [Carthage](#carthage)
    - [Manual Installation](#manual-installation)
- [Initializing and Usage](#initializing-and-usage)
    - [Integrate](#integrate)
    - [Start tracking](#start-tracking)

<!-- /MarkdownTOC -->

<a name="introduction"></a>
# Introduction

Welcome to the official Mixpanel Swift Library

The Mixpanel Swift library for iOS is an open-source project, and we'd love to see your contributions! 
We'd also love for you to come and work with us! Check out **[Jobs](https://mixpanel.com/jobs/#openings)** for details.

If you are using Objective-C, we recommend using our **[Objective-C Library](https://github.com/mixpanel/mixpanel-iphone)**.

<a name="current-supported-features"></a>
## Current supported features

**Our master branch and our releases are now on Swift 5.**

**If you wish to use our Swift 4.2 implementation, please point to the v2.6.1 release. For Swift 4/4.1 implementation, please point to the v2.4.5 release. For Swift 3 implementation, please point to the v2.2.3 release. For Swift 2.3 implementation, please point to the v1.0.1 release.**

Our Swift library fully supports all of the Mixpanel features and has full parity with the [Objective-C Library](https://github.com/mixpanel/mixpanel-iphone).

<a name="installation"></a>
# Installation

On Jan 1, 2022, we’ll remove the [Messages & Experiments](https://mixpanel.com/blog/why-were-sunsetting-messaging-and-experiments/#:~:text=A%20year%20from%20now%2C%20on,offering%20discounts%20for%20getting%20started) feature from Mixpanel. For now, you can choose to opt in to our beta version without Messages & Experiments feature support. You can use **Swift Package Manager** to install the beta version:
1.  In Xcode, select File > Swift Packages > Add Package Dependency.
2.  Follow the prompts using the URL for this repository and point to the branch `3.0.0.beta`

## Swift Package Manager

**It requires Xcode 12+ and v2.8.0+ release**

**Important: It only supports for iOS, if you need integrations for other platforms(tvOS or macOS), please use other integration methods instead or use our beta version by pointing to the branch `3.0.0.beta`**

1. In Xcode, select File > Swift Packages > Add Package Dependency.
2. Follow the prompts using the URL for this repository and a minimum semantic version of v2.8.0

Check out our **[swift integration guide »](https://mixpanel.com/help/reference/swift)** for more info.

## CocoaPods

**Our current release only supports CocoaPods version 1.4.0+**

Mixpanel supports `CocoaPods` for easy installation.
To Install, see our **[swift integration guide »](https://mixpanel.com/help/reference/swift)**

For iOS, tvOS, macOS, and App Extension integrations:

`pod 'Mixpanel-swift'`

<a name="carthage"></a>
## Carthage

Mixpanel also supports `Carthage` to package your dependencies as a framework. Include the following dependency in your Cartfile:

`github "mixpanel/mixpanel-swift"`

Check out the **[Carthage docs »](https://github.com/Carthage/Carthage#if-youre-building-for-ios-tvos-or-watchos)** for more info. 

<a name="manual-installation"></a>
## Manual Installation

To help users stay up to date with the latest version of our Swift SDK, we always recommend integrating our SDK via CocoaPods, which simplifies version updates and dependency management. However, there are cases where users can't use CocoaPods. Not to worry, just follow these manual installation steps and you'll be all set.

### Step 1: Add as a Submodule

Add Mixpanel as a submodule to your local git repo like so:

```
git submodule add git@github.com:mixpanel/mixpanel-swift.git
```

Now the Mixpanel project and its files should be in your project folder! 

### Step 2: Drag Mixpanel to your project

Drag the Mixpanel.xcodeproj inside your sample project under the main sample project file:

![alt text](http://images.mxpnl.com/docs/2016-07-19%2023:34:02.724663-Screen%20Shot%202016-07-19%20at%204.33.34%20PM.png)

### Step 3: Embed the framework

Select your app .xcodeproj file. Under "General", add the Mixpanel framework as an embedded binary:

![alt text](http://images.mxpnl.com/docs/2016-07-19%2023:31:29.237158-add_framework.png)

<a name="initializing-and-usage"></a>
# Initializing and Usage

<a name="integrate"></a>
## Integrate

Import Mixpanel into AppDelegate.swift, and initialize Mixpanel within `application:didFinishLaunchingWithOptions:`
![alt text](http://images.mxpnl.com/docs/2016-07-19%2023:27:03.724972-Screen%20Shot%202016-07-18%20at%207.16.51%20PM.png)

```swift
func application(_ application: UIApplication,
                 didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    Mixpanel.initialize(token: "MIXPANEL_TOKEN")
}
```

You initialize your Mixpanel instance with the token provided to you on mixpanel.com.

<a name="start-tracking"></a>
## Start tracking

After installing the library into your iOS app, Mixpanel will <a href="https://mixpanel.com/help/questions/articles/which-common-mobile-events-can-mixpanel-collect-on-my-behalf-automatically" target="_blank">automatically collect common mobile events</a>. You can enable/ disable automatic collection through your <a href="https://mixpanel.com/help/questions/articles/how-do-i-enable-common-mobile-events-if-i-have-already-implemented-mixpanel" target="_blank">project settings</a>.

To interact with the instance and track additional events, you can either use the mixpanel instance given when initializing:
```swift
mixpanel.track(event: "Tracked Event!")
```
or you can directly fetch the instance and use it from the Mixpanel object:
```swift
Mixpanel.mainInstance().track(event: "Tracked Event!")
```

You're done! You've successfully integrated the Mixpanel Swift SDK into your app. To stay up to speed on important SDK releases and updates, star or watch our repository on [Github](https://github.com/mixpanel/mixpanel-swift).

Have any questions? Reach out to [support@mixpanel.com](mailto:support@mixpanel.com) to speak to someone smart, quickly.

## Using Mixpanel Push Notifications

First [enable Mixpanel push notifications in your app](https://developer.mixpanel.com/docs/ios-push-notifications). Then for Rich Push Notifications, you'll need to integrate your application with the MixpanelNotificationServiceExtension.

### Integrating the MixpanelNotificationServiceExtension

The Mixpanel SDK comes with a custom [Notification Service Extension](https://developer.apple.com/documentation/usernotifications/unnotificationserviceextension?language=swift) used to render rich media, custom action buttons, and track when push notifications are received. To enable these features, you will need to integrate it into your application.

#### 1. Create a new Notification Service Extension Target
<img width="660" alt="Screenshot 2020-02-13 14 45 23" src="https://user-images.githubusercontent.com/556882/74478474-0c224700-4e73-11ea-847c-b3f58ab16c4a.png">
<img width="738" alt="Screenshot 2020-02-13 14 44 38" src="https://user-images.githubusercontent.com/556882/74478475-0c224700-4e73-11ea-9f57-3b40b6fdbbcd.png">
<img width="739" alt="Screenshot 2020-02-13 14 46 53" src="https://user-images.githubusercontent.com/556882/74478559-3ecc3f80-4e73-11ea-926f-96659958936e.png">

#### 2. Add Mixpanel-swift as a dependency
Add the following to the end of your `Podfile`:
```Podspec
target 'NotificationService' do
  use_frameworks!
  
  pod 'Mixpanel-swift'
end
```
Then run `pod install`


#### 3. Extend your NotificationService from MixpanelNotificationServiceExtension
Replace the contents of your `NotificationService.swift` file with the following:
```NotificationService.swift
import Mixpanel

class NotificationService: MixpanelNotificationServiceExtension {}
```

#### 4. Delegate the handling of the notification response to the Mixpanel SDK
In your `AppDelegate.swift` file, you need to call `MixpanelPushNotifications.handleResponse` when a push notification response is received:
```swift
@available(iOS 10.0, *)
func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    if MixpanelPushNotifications.isMixpanelPushNotification(response.notification.request.content) {
        debugPrint("Handling Mixpanel push notification response...")
        MixpanelPushNotifications.handleResponse(response: response, withCompletionHandler: completionHandler)
    } else {
        // not a Mixpanel push notification
        debugPrint("Not a Mixpanel push notification.")
        completionHandler()
    }
}
```
This will make sure the tap actions are appropriately handled (open URL, deeplink, etc) as well as track whether a notification was tapped or dismissed.

#### 5. Run the app and send a test push notification from Mixpanel that includes an image or buttons

That's it! Your app should now be able to receive rich push notifications from Mixpanel.
