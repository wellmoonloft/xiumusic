My Apple developer certificate has expired, so you need to build by yourself. Because it has been more than a year, I have just upgraded all the dependencies to ensure that it can run on IOS14+ and MAC OS13+. I have not tested other platforms (2024.10.8)
Although the lyrics can be displayed, the method of obtaining the lyrics is still difficult to use. If all your music is standard, then there is no problem, but many of the songs I listen to are recorded by streaming, which will result in the inability to automatically identify and need to be manually selected. (2024.10.8)

# XiuMusic
![](https://img.shields.io/badge/Toolkit-Flutter-blue.svg)  ![](https://img.shields.io/badge/Language-Dart-orange.svg)  ![](https://img.shields.io/badge/license-MIT-green)  ![](https://img.shields.io/badge/Process-Developing-blueviolet.svg)

Based on the personal NAS music player, Navidrome server development, theoretically supports Subsonic server

 🇨🇳[简体中文](README-cn.md) | 🇺🇸[English](README.md)

## Introduction

**Xiu** is [a music anchor](https://www.douyu.com/7884070) that I often watch recently. There is a word Xiu in her name, so she is called **XiuMusic**.

This is developed and debugged on the server environment of [Navidrome](https://www.navidrome.org/) based on the interface of [Subsonic API](http://www.subsonic.org/pages/api.jsp) , so all Subsonic api servers are supported. In the process, I got help from many people in the [Navidrome discord group](https://discord.gg/xh7j7yF), thank them.

**Notice** The lyrics are saved in the sqlite at document. Currently, there is no export function. 

The MacOS version is already on the [Appstore](https://apps.apple.com/cn/app/xiu-music/id1667473545), you can download it directly

**iOS**

![](https://s2.loli.net/2023/01/23/pWL4ia9mZCxuynG.jpg)

**Android**

![Screenshot_1675416868](https://s2.loli.net/2023/02/03/yVCebsOctxKRfzJ.png)

**Lyric**

![](snapshot/lyric.png)

**iPad**

![](snapshot/snapshot/ios/12.9/Simulator%20Screen%20Shot%20-%20iPad%20Pro%20(12.9-inch)%20(6th%20generation)%20-%202023-02-01%20at%2017.28.00.png)


------------------------------

## Quick start

1. Clone project

2. Delete ios and macos to regenerate

3. Execute `flutter create .` in the project directory

4. Execute `flutter packages get` in the project directory

#### MacOS/IOS

The following files are added
DebugProfile.entitlements
Release.entitlements

    <key>com.apple.security.network.client</key>
    <true/>

Turn on lock screen playback
#### IOS
Info.plist
```
<key>UIBackgroundModes</key>
	<array>
		<string>audio</string>
	</array>
```
AndroidManifest.xml

```
<manifest xmlns:tools="http://schemas.android.com/tools" ...>
  <!-- ADD THESE TWO PERMISSIONS -->
  <uses-permission android:name="android.permission.WAKE_LOCK"/>
  <uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
  
  <application ...>
    
    ...
    
    <!-- EDIT THE android:name ATTRIBUTE IN YOUR EXISTING "ACTIVITY" ELEMENT -->
    <activity android:name="com.ryanheise.audioservice.AudioServiceActivity" ...>
      ...
    </activity>
    
    <!-- ADD THIS "SERVICE" element -->
    <service android:name="com.ryanheise.audioservice.AudioService"
        android:foregroundServiceType="mediaPlayback"
        android:exported="true" tools:ignore="Instantiatable">
      <intent-filter>
        <action android:name="android.media.browse.MediaBrowserService" />
      </intent-filter>
    </service>

    <!-- ADD THIS "RECEIVER" element -->
    <receiver android:name="com.ryanheise.audioservice.MediaButtonReceiver"
        android:exported="true" tools:ignore="Instantiatable">
      <intent-filter>
        <action android:name="android.intent.action.MEDIA_BUTTON" />
      </intent-filter>
    </receiver> 
  </application>
</manifest>
```

#### Use the lyrics search function

You need to set the api of Netease Cloud. According to the instructions of setting [NeteaseCloudMusicApi](https://github.com/Binaryify/NeteaseCloudMusicApi) here, after configuring one on [vercel](https://vercel.com/), set the api The domain name can be used after it is saved in the set lyrics server.

![WechatIMG673](https://s2.loli.net/2023/01/18/GPbWiBRjT3LHl8K.png)

## Dependencies

- [sqflite: ^2.2.25](https://pub.flutter-io.cn/packages/sqflite) data persistence.
- [path: ^1.8.2 ](https://pub.flutter-io.cn/packages/path) Find the location for the database, and it can also be used for image caching, but base64 is still good.
- [just_audio: ^0.9.31](https://pub.dev/packages/just_audio) Music playback tool with 99% praise.
- [just_audio_background: ^0.0.1-beta.9](https://pub.dev/packages/just_audio_background) supports mobile background playback and lock screen control.
- [dio: ^4.0.6](https://pub.dev/packages/dio) and its simple Restful request tool.
- [crypto: ^3.0.2](https://pub.dev/packages/crypto) Used for encryption such as MD5.
- [window_manager: ^0.2.8](https://pub.dev/packages/crypto) It is used to limit the minimization of the form and hide the title bar.
- [flutter_staggered_grid_view: ^0.6.2](https://pub.dev/packages/flutter_staggered_grid_view) Realize waterfall flow, easy to use.
- [cached_network_image: ^3.2.3](https://pub.dev/packages/cached_network_image) implements image caching, easy to use.
- [flutter_lyric: ^2.0.4+6](https://pub.dev/packages/flutter_lyric) There is only one copy on the entire pub, which is easy to use.
- [share_plus: ^6.3.0](https://pub.dev/packages/share_plus) share，suport all platform, which is easy to use.


## Todo List 

- [x] Debugged: macOS iPhone iPad Android
- [ ] Not yet: Windows/Linux should be fine?
- [ ] desktop shortcut key
