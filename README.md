# aaa

我自己的小说阅读器


## Getting Started


现有功能:

1 小说从网络加载,
2 朗读





DONE: 内容页 的点击高亮和朗读还未实装. 之前使用的一些全局变量未清理. 下次要把这些完成.
DONE: 1  一个页面阅读后,能转到下一个页面. 现在可以跳转,但在跳转的时候出了BUG,  现在做到了30% //重构
TODO: 2  .开始构想 书本设置页  包括换源, 手动设置正则条件, 内容提取正则化. 要不要开发一个小工具, 用于设计正则语句?
TODO: 3  朗读TTS 不能调速, 后续要把 TTS的设置功能加入. 切记,TTS 开发不是主要任务,不能为了研究这个而耽误进度. 
        这个APP完成以后, 下一步是写一个 AI 训练的APP, 用于训练自己的TTS, 以及图像模拟功能
TODO: 4  后续要把IOS版开发出来. 以及用户注册功能,和,云端数据功能. //XX 不, 不开发IOS, 云端功能也暂后. 把本地储存功能完善.
-------------------------------------------------------------------------------


19.09.26
TODO 本版目标
 1 改BUG,
 2 本地储存功能增加
 3 结合本地储存功能 增加 设置面
 4 增加查找书功能
 5 增加不同书源






--------------------2.00-----------------------------------------------------------


19.09.26 1.0.0 100% 第一版 
DONE


19.09.24 1.  60%
DONE: 三个面页都重构了,  正常的 书架页 目录页 内容页 已经架构结束, //前后加载 还没完成.

19.09.23
DONE: 用 draggable_scrollbar 代替 自己的progress

19.09.20 1.  30%
TODO: APP 分层       底层访问 -- 数据结构 --  界面显示    , 重写 APP架构以解决 19.09.19的问题.


19.09.19 1.  00%
DONE: 一个页面阅读后,能转到下一个页面. 现在可以跳转,但在跳转的时候出了BUG,  现在做到了30% 
DONE: 自动加载前三后三共七页.这个功能还没开始做 //未做提前加载功能, 添加了 左右滑翻下页/上页的功能 19.09.26
--------------------1.00-----------------------------------------------------------















This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.io/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.io/docs/cookbook)








For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
