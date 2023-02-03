
# XiuMusic
![](https://img.shields.io/badge/Toolkit-Flutter-blue.svg)  ![](https://img.shields.io/badge/Language-Dart-orange.svg)  ![](https://img.shields.io/badge/license-MIT-green)  ![](https://img.shields.io/badge/Process-Developing-blueviolet.svg)

 基于播放个人NAS音乐的播放器，Navidrome服务器开发，理论上支持Subsonic服务器

 🇨🇳[简体中文](README-cn.md) | 🇺🇸[English](README.md)

## 简介

**Xiu**是我近期经常看的[一个音乐主播](https://www.douyu.com/7884070)，她名字里有个Xiu字，所以就叫**XiuMusic**了。

这是在[Navidrome](https://www.navidrome.org/)的服务器环境上基于[Subsonic的API](http://www.subsonic.org/pages/api.jsp)的接口开发调试的，所以理论上支持所有Subsonic api的服务器，过程中得到[Navidrome discord群](https://discord.gg/xh7j7yF)中多人的帮助，谢谢他们。

**注意**歌词是保存在APP文档的sqlite里的，目前没有做导出功能

MacOS的版本已经在[Appstore](https://apps.apple.com/cn/app/xiu-music/id1667473545)上架了，可以直接下载

**iOS锁屏后台播放**

![](https://s2.loli.net/2023/01/23/pWL4ia9mZCxuynG.jpg)

**Android锁屏后台播放**

![Screenshot_1675416868](https://s2.loli.net/2023/02/03/yVCebsOctxKRfzJ.png)

**歌词**

![](snapshot/lyric.png)

**iPad**

![](snapshot/snapshot/ios/12.9/Simulator%20Screen%20Shot%20-%20iPad%20Pro%20(12.9-inch)%20(6th%20generation)%20-%202023-02-01%20at%2017.28.00.png)

------------------------------

## 快速开始

1. Clone 项目

2. 删除ios、macos重新生成

3. 在项目目录中执行 `flutter create . `

4. 在项目目录中执行 `flutter packages get`

#### MacOS/IOS

下列文件添加
DebugProfile.entitlements
Release.entitlements

    <key>com.apple.security.network.client</key>
    <true/>

开启锁屏播放
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

#### 使用歌词搜索功能

需要设置网易云的api，根据这里设置[NeteaseCloudMusicApi](https://github.com/Binaryify/NeteaseCloudMusicApi)的说明在[vercel](https://vercel.com/)上配置一个之后，把api的域名保存在设置的歌词服务器里面就可以使用了。

![WechatIMG673](https://s2.loli.net/2023/01/18/GPbWiBRjT3LHl8K.png)

## 依赖

- [sqflite: ^2.2.25](https://pub.flutter-io.cn/packages/sqflite) 数据持久化。
- [path: ^1.8.2 ](https://pub.flutter-io.cn/packages/path) 给数据库找位置的，也可以用于图片缓存，但是还是base64香吧。
- [just_audio: ^0.9.31](https://pub.dev/packages/just_audio) 好评度99%的音乐播放工具。
- [just_audio_background: ^0.0.1-beta.9](https://pub.dev/packages/just_audio_background) 支持移动端后台播放及锁屏控制。  
- [dio: ^4.0.6](https://pub.dev/packages/dio) 及其简单的Restful请求工具。
- [crypto: ^3.0.2](https://pub.dev/packages/crypto) MD5等加密用的。
- [window_manager: ^0.2.8](https://pub.dev/packages/crypto) 限制窗体最小化以及隐藏titile栏用的。
- [flutter_staggered_grid_view: ^0.6.2](https://pub.dev/packages/flutter_staggered_grid_view) 实现瀑布流，使用简单。
- [cached_network_image: ^3.2.3](https://pub.dev/packages/cached_network_image) 实现图片缓存，使用简单。
- [flutter_lyric: ^2.0.4+6](https://pub.dev/packages/flutter_lyric) 整个pub上面独一份，使用简单。



## Todo List 

- [x] 调试过的: macOS iPhone iPad 安卓
- [ ] 还没调试的: Windows/Linux 理论上应该没问题
- [ ] 桌面快捷键   

