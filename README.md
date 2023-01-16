
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

这是在[Navidrome](https://www.navidrome.org/)的服务器环境上基于[Subsonic的API](http://www.subsonic.org/pages/api.jsp)的接口开发调试的，所以理论上支持Subsonic、Navidrome和Airsonic，想玩的都可以下载了试一试，如果接口相同那应该问题不大（绝大部份的DIO请求没有抛错，建议网络环境好的时候食用，等做完了再回去补用户交互）

![](https://s2.loli.net/2023/01/10/3Wj8w7QfbZJ9N4y.jpg)

歌词

![](https://s2.loli.net/2023/01/15/WCFZOToQYNlg47s.jpg)

## Todo List 

### 页面  

- [x] 首页 
  - [x] 随机专辑、最多播放歌曲、最近添加专辑...其他随便加
  
- [x] 正在播放  
  - [x] 正在播放页面，磨砂玻璃
  - [x] 歌词  

- [ ] 播放列表  （最没用的倒数第二）
  - [ ] 播放列表页面

- [ ] 收藏  （最没用的倒数第三）  
  - [ ] 收藏页面

- [ ] 搜索  
  - [x] 搜索页面
  - [x] 简体中文能搜到繁体中文的歌  
  - [ ] 顶部的搜索栏  

- [x] 专辑  
  - [x] 专辑列表
  - [x] 专辑详情
  
- [x] 歌手  
  - [x] 歌手列表
  - [x] 歌手主页
  - [x] 专辑详情
  
- [ ] 流派  
  - [x] 页面展示
  - [ ] 跳转到对应专辑和歌曲
  
- [ ] 配置  
  - [x] 服务器配置：测试、连接、保存服务器及账号信息
  - [ ] 个性化：没想好做不做
  - [ ] 多语言：没想好做不做

### 基础  

- [x] 播放  
  - [x] 流播放、播放控制、静音、单曲循环
  - [x] 播放列表、全部循环

- [ ] 网络  
  - [x] Restful请求、服务器连接等
  - [ ] 歌手照片和信息，以及，歌词，看是否通过网易云api去抓

- [ ] 数据库  
  - [x] 建表、增删改查、初始化(没做转转转)
  - [ ] 后台程序刷新数据 

- [ ] 自适应  
  - [x] 理论支持IOS/安卓/macOS/Windows/Linux
  - [ ] 目前用macOS开发，还未调试其他端

- [ ] 后台任务  
  - [ ] 监听服务器状态，未发生变化做update，发生变化做insert  

![](https://s2.loli.net/2023/01/12/vMEGWZdzIblT9qx.jpg)

![](https://s2.loli.net/2023/01/10/BCPjVHlazr2mK1R.jpg)

------------------------------

## 快速开始

1. Clone 项目

2. 删除ios、macos重新生成

3. 在项目目录中执行 `flutter create . `

4. 在项目目录中执行 `flutter packages get`

#### MacOS


添加苹果安全

macos-Runner-DebugProfile.entitlements
macos-Runner-Release.entitlements

    <key>com.apple.security.network.client</key>
    <true/>


## 依赖

- [sqflite: ^2.2.25](https://pub.flutter-io.cn/packages/sqflite) 数据持久化。
- [path: ^1.8.2 ](https://pub.flutter-io.cn/packages/path) 给数据库找位置的，也可以用于图片缓存，但是还是base64香吧。
- [just_audio: ^0.9.31](https://pub.dev/packages/just_audio) 好评度99%的音乐播放工具。
- [dio: ^4.0.6](https://pub.dev/packages/dio) 及其简单的Restful请求工具。
- [crypto: ^3.0.2](https://pub.dev/packages/crypto) MD5等加密用的。
- [window_manager: ^0.2.8](https://pub.dev/packages/crypto) 限制窗体最小化以及隐藏titile栏用的。
- [flutter_staggered_grid_view: ^0.6.2](https://pub.dev/packages/flutter_staggered_grid_view) 实现瀑布流，使用简单。
- [cached_network_image: ^3.2.3](https://pub.dev/packages/cached_network_image) 实现图片缓存，使用简单。
- [flutter_lyric: ^2.0.4+6](https://pub.dev/packages/flutter_lyric) 整个pub上面独一份，非常稳定
  