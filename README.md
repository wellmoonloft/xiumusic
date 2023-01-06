
# XiuMusic
![](https://img.shields.io/badge/Toolkit-Flutter-blue.svg)  ![](https://img.shields.io/badge/Language-Dart-orange.svg)  ![](https://img.shields.io/badge/license-MIT-green)  ![](https://img.shields.io/badge/Process-Developing-blueviolet.svg)

 基于播放个人NAS音乐的播放器，Navidrome服务器开发，理论上支持Subsonic服务器

## 简介

**Xiu**是我近期经常看的一个音乐主播，她名字里有个Xiu字，所以就叫**XiuMusic**了。

最近在NAS上搭了好多东西，其中音乐的服务器用了Navidrome，客户端选了很多，但只有[Sonixd](https://github.com/jeffvli/sonixd)感觉不错，但是没有移动端，而且有个世纪难题，不支持歌词（[issues](https://github.com/jeffvli/sonixd/issues/332)上作者说要来一个大计划飞跃到v1.0，并解决歌词的问题，而且目前的一些repo说支持了，但是我尝试好几次都不成功）

因此我需要一个这样的APP：
1. 支持歌词
2. 支持模糊查找（简体、繁体，这是很大的问题，比如你搜周杰伦和周杰倫）
3. 简洁（听歌就是听歌）
4. 桌面端和移动端UI统一风格

有了这四个需求，我决定自己撸一个APP给自己用

![image-20230105120444277](https://s2.loli.net/2023/01/05/j3GFa9JYrn1U8CK.png)

------------------------------

## 快速开始

1. Clone 项目

2. 在项目目录中执行 `flutter create . `

3. 在项目目录中执行 `flutter packages get`

#### MacOS

设置 Title Bar为穿透模式，不然很丑

1. open macos/Runner.xcworkspace with Xcode

2. Runner-Runner-Resources-MainMenu.xib

3. APP_NAME-Window

4. Transparent Title Bar && Full Size Content View




## 参考
- [Sonixd](https://github.com/jeffvli/sonixd) 模仿了Sonixd的桌面UI设计

## 依赖

- [shared_preferences: ^2.0.15](https://pub.flutter-io.cn/packages/shared_preferences) 数据持久化。
- [just_audio: ^0.9.31](https://pub.dev/packages/just_audio) 好评度99%的音乐播放工具，差1%就超过audioplayers了。
- [dio: ^4.0.6](https://pub.dev/packages/dio) 及其简单的Restful请求工具。
- [crypto: ^3.0.2](https://pub.dev/packages/crypto) MD5等加密用的。
- 

## 进度

距离完工还早，目前只实现了桌面端的部分功能


## Todo List 

- [ ] 
