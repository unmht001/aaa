# aaa

我自己的小说阅读器


## Getting Started##

---

//当前版本:

     2.1.0

//现有功能:

    1 小说从网络加载,
    2 朗读
---
//预设功能: 

 + 1  版本1.0.0 功能 
 + 2  .开始构想 书本设置页  包括换源, 手动设置正则条件, 内容提取正则化. 要不要开发一个小工具, 用于设计正则语句?
 + 3  朗读TTS 不能调速, 后续要把 TTS的设置功能加入. 切记,TTS 开发不是主要任务,不能为了研究这个而耽误进度. 这个APP完成以后, 下一步是写一个 AI 训练的APP, 用于训练自己的TTS, 以及图像模拟功能
 + 4  后续要把IOS版开发出来. 以及用户注册功能,和,云端数据功能. //XX 不, 不开发IOS, 云端功能也暂后. 把本地储存功能完善.
---


//3.0.0:
+ 书源自定义功能
+ 正则文字提取训练小工具


---

//2.0.0:

+ 19.09.26 本版目标 todo
 1. 改BUG,
 2. 本地储存功能增加
 3. 结合本地储存功能 增加 设置面
 4. 增加查找书功能
 5. 增加不同书源




+ 19.09.26 todo
 1. 书本数据 JSON化 和 反JSON化  
 2. 本地存储 
 3. 从本地加载 
 4. 保存到本地 
 5. 章节内容的本地化 
 6. 书架页书本资料的刷新 

+ 19.10.05 ,三天内必须完成本日列出的项目!!!!
    1. 进度陷入了瓶颈:从内容面向前后翻了以后,返回到目录页,页面没有刷新, 今天自己写了一个queue 和 类似 condition 的roadSignal , 试试能不能用来解决这个问题.
    2. 啃文有防抓取的功能, 后来要再加几个书源.
    3. 本地化存取方向, 要考虑 用 assets 和 bundle 来具体实现功能.
    4. 加载前三后三这个功能, 要考虑一下了, 同时,内容和目录从本方读入, 加入下拉刷新功能.

+ 19.09.30 2.1.0 done 
    1. 小版本 增加了一个书源, 增加了几本新书.
    2. //todo: 给 chapter 增加一个功能 ,toChapter( ), 在数据层 和 表现层进一步分离.


+ 19.09.29 done 70%
    1. 写了一个正则测试页.为查找和添加新书功能做准备,
    2. TODO 要测试网站的查找的POST 并要对结果进行解析
    3. 对FLUTTER 的理解又深了一步. 一个页面, 分为数据页和表达页, 现在的方式是自己写一个对应的DATA 类, 考虑要不要做一个 mixinData, 内部做一个 dataMAP, 把 JSON化 和 加载/保存函数弄进去.
    

+ 19.09.28 done
    1. 写了一个书源和书本的信息的页面, 还不能自己改设置,也不能换源,这是下一步目标.
    2. 本地存储的基本函数已经实现,下一步是 书页章节的本地化
    3. TODO 要把查找和添加新书功能做进去了.

---
//1.0.0:
1. 小说从网络加载,
2. 朗读

+ 19.09.26 1.0.0 100% 第一版 
    1. DONE 精简了结构


+ 19.09.24 1.  60%
    1. DONE 三个面页都重构了,  正常的 书架页 目录页 内容页 已经架构结束, //前后加载 还没完成.

+ 19.09.23
    1. DONE 用 draggable_scrollbar 代替 自己的progress

+ 19.09.20 1.  30%
    1. DONE APP 分层       底层访问 -- 数据结构 --  界面显示    , 重写 APP架构以解决 19.09.19的问题.//完成一部分


+ 19.09.19 1.  00%
    1. DONE 一个页面阅读后,能转到下一个页面. 现在可以跳转,但在跳转的时候出了BUG,  现在做到了30% 
    2. DONE 自动加载前三后三共七页.这个功能还没开始做 //未做提前加载功能, 添加了 左右滑翻下页/上页的功能 19.09.26
---



This project is a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.io/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.io/docs/cookbook)


For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
