
# XiuMusic
![](https://img.shields.io/badge/Toolkit-Flutter-blue.svg)  ![](https://img.shields.io/badge/Language-Dart-orange.svg)  ![](https://img.shields.io/badge/license-MIT-green)  ![](https://img.shields.io/badge/Process-Developing-blueviolet.svg)

 基于播放个人NAS音乐的播放器，Navidrome服务器开发，理论上支持Subsonic服务器

 🇨🇳[简体中文](README-cn.md) | 🇺🇸[English](README.md)

## 简介

**Xiu**是我近期经常看的[一个音乐主播](https://www.douyu.com/7884070)，她名字里有个Xiu字，所以就叫**XiuMusic**了。

最近在NAS上搭了好多东西，其中音乐的服务器用了Navidrome，客户端选了很多，但只有[Sonixd](https://github.com/jeffvli/sonixd)感觉不错，但是没有移动端，而且有个世纪难题，不支持歌词（[issues](https://github.com/jeffvli/sonixd/issues/332)上作者说要来一个大计划飞跃到v1.0，并解决歌词的问题，而且目前的一些repo说支持了，但是我尝试好几次都不成功）

因此我需要一个这样的APP：
1. 支持歌词
2. 支持模糊查找（简体、繁体，这是很大的问题，比如你搜周杰伦和周杰倫）
3. 简洁（听歌就是听歌）
4. 桌面端和移动端UI统一风格

有了这四个需求，我决定自己撸一个APP给自己用

这是在[Navidrome](https://www.navidrome.org/)的服务器环境上基于[Subsonic的API](http://www.subsonic.org/pages/api.jsp)的接口开发调试的，所以理论上支持Subsonic、Navidrome和Airsonic，想玩的都可以下载了试一试，如果接口相同那应该问题不大（绝大部份的DIO请求没有抛错，建议网络环境好的时候食用，等做完了再回去补用户交互）

注意！！！下载了歌词是保存在APP文档的数据库里的，目前没有做导出功能，少玩一点，省的歌词找不出来怪我

[macOS的v0.4版本已经上架了，可以直接用](https://apps.apple.com/us/app/xiu-music/id1667473545)
这个版本有两个问题:
1. 在初始化的时候把UI锁住了，如果你的歌曲超过5000首，可能会锁死
2. 判断刷新是根据getScanStatus接口的两个数据判断，但是刚刚得知其中一个数据是Navidrome独有的，所以可能需要手动刷新
v0.4.1解决了这个问题，但是我不想频繁的提交appstore
请注意v0.5.0开始更新了表结构，请删除app重新安装，不要更新或者覆盖


![](https://s2.loli.net/2023/01/10/3Wj8w7QfbZJ9N4y.jpg)

锁屏播放

![](https://s2.loli.net/2023/01/23/pWL4ia9mZCxuynG.jpg)

## Todo List 

### 页面  
  
- [ ] 配置  
  - [x] 服务器配置：测试、连接、保存服务器及账号信息
  - [ ] 个性化：没想好做不做
  - [x] 多语言：做了英文、中文、简体中文和繁体中文，根据终端配置来加载，保存后根据保存的加载

### 基础  

- [ ] 用户体验  理论支持IOS/安卓/macOS/Windows/Linux
  - [x] 调试过的: macOS iOS 安卓
  - [ ] 还没调试的: Windows/Linux 理论上应该没问题
  - [ ] 后台抛错到前台
  - [ ] 桌面快捷键  
  - [ ] 分页    



![](https://s2.loli.net/2023/01/12/vMEGWZdzIblT9qx.jpg)

![](https://s2.loli.net/2023/01/10/BCPjVHlazr2mK1R.jpg)

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



v0.5.0
- 去掉大部分数据库，只保留服务器信息
- 修改进度条大小，不然手机上特别不好点
- 增加歌曲后缀名，排除掉ape
- 增加流派
