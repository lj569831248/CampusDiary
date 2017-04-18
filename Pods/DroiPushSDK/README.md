# 消息推送
## 简介

卓易推送（DroiPush）SDK是面向iOS开发者提供的一种消息推送服务模块，应用开发者可以通过第三方服务器或者卓易推送管理后台向集成SDK的应用推送消息，减少开发者集成APNs需要的工作量，并降低开发复杂度，同时还能统计推送的各项数据。

![推送结构框图][1]

## 安装
### 快速入门
由于DroiPush SDK依赖于DroiCore SDK，所以请在安装DroiPush SDK之前仔细阅读[快速入门](http://baastest.droi.cn/Index/docStart.html) ，完成DroiCore SDK的安装。

### 项目配置
为了更好的支持SDK推送，需要配置后台运行权限：推送唤醒（静默推送，Silent Remote Notifications）如下图：

![项目配置图][2]
 

### 使用CocoaPods方式安装（推荐）

DroiPush SDK使用CocoaPods作为函数库的管理工具。我们推荐您使用CocoaPods这种方式来安装SDK，这样可以大大简化安装DroiPush SDK的流程。如果您未安装CocoaPods，请参考[《CocoaPods安装和使用教程》](http://www.jianshu.com/p/b7bbf7f6af54)完成安装。CocoaPods安装完成后，请在项目根目录下创建一个Podfile文件，并添加如下内容（如果已有直接添加即可）：

```
pod 'DroiCoreSDK'
post_install do |installer|
    require './Pods/DroiCoreSDK/scripts/postInstall.rb'
    DroiCoreParser.installParser()
end
pod  'DroiPushSDK'
```
由于DroiPush SDK需依赖于DroiCore SDK，以上命令会安装DroiCore SDK并安装DroiPush SDK。如果之前已经安装过DroiCore SDK只需要添加

```
pod  'DroiPushSDK'

```
之后在控制台中cd到Podfile文件所在目录，执行如下命令完成安装。

```
pod  install
```
### 手动安装

将SDK包解压，在XCode中选择”Add files to 'Your project name’…”，将解压后的libs文件夹中的`DroiPush.framework`添加到你的工程目录中。

## 使用
### 代码中集成 DroiPush SDK
 在使用DroiPush SDK之前需要先初始化DroiPush SDK 请在Applegate.m中添加如下代码，完成初始化。
```
#import <DroiPush.h>    //导入DroiPush.h

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>     //iOS 10支持
#endif
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	//初始化DroiPush SDK并注册远程推送服务
	[DroiPush registerForRemoteNotifications];
	
	//iOS10 支持必须加下面这段代码。
    if (IOS_VERSION >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
    UNAuthorizationOptions types=UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    center requestAuthorizationWithOptions:types completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        }
        else{
            //点击不允许
            //这里可以添加一些自己的逻辑
         }
    }];
#endif

	return YES;
}
//APNs注册成功上报deviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
	[DroiPush registerDeviceToken:deviceToken];
}
```
 对远程推送的消息进行接收
 
```
#pragma mark iOS 10新增UNUserNotificationCenterDelegate 代理方法

/// 处理前台收到通知的代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
     NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
    }else{
        //应用处于前台时的本地推送接受
    }
    //前台状态下收到通知显示标题
    completionHandler(UNNotificationPresentationOptionAlert);
}

// iOS 10系统在点击状态栏进入app 
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
 NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //点击远程通知
    }else{
        //点击本地通知
    }
    completionHandler();
}

//iOS 10以下收到远程推送和点击远程推送回调
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler
{
	[DroiPush handleRemoteNotification:userInfo];//DroiPush 处理通知代码，必须添加
	completionHandler(UIBackgroundFetchResultNewData);
}
```
### 标签功能
开发者可以通过SDK提供的接口为应用设置标签，便于按照标签分组推送。需要注意的是SDK提供的设置标签接口每次调用的时候都会覆盖上一次的标签。

* 过滤标签

过滤掉无效的 tags， tag值不能重复，且只能以字母（区分大小写）、数字、下划线、汉字组成如果tags数量超过限制数量， 则返回靠前的有效的tags。建议设置tags前用此接口校验。SDK内部也会基于此接口来做过滤。

```
NSSet *tags = [[NSSet alloc] initWithObjects:@"tag1",@"tag_2",@"标签3",@"tag!4",@"", nil];
NSSet *validTags = [DroiPush filterValidTags:tags];
```
* 设置标签 

```
NSSet *tags = [[NSSet alloc] initWithObjects:@"DroiPush",@"iOS",nil];
[DroiPush setTags:tags];
```
* 清空标签

```
[DroiPush resetTags];
```
**注意：设置标签为[NSSet set]空集合，表示为清空当前设置，也可以调用resetTags接口清空标签。应用tag数量最多限制为1024个，每个长度最多为256字符。** 

### 设置角标
badge（角标）是iOS用来标记应用程序状态的一个数字，出现在程序图标右上角。DroiPush SDK封装了badge的管理功能，允许应用上传badge值至DroiPush服务器，由DroiPush后台帮助开发者管理每个用户所对应的推送badge值，简化了设置推送badge的操作。实际应用中，开发者只需将变化后的badge值通过setBadge接口同步DroiPush服务器，无需自己维护用户与badge值之间的对应关系，方便运营维护。

```
[DroiPush setBadge:0];
```
###  接收长消息与文件
DroiPush SDK 提供了接收长消息和文件通知的功能。

- 长消息通知

由于苹果官方规定APNs推送payload的大小最大为4K，当开发者需要推送的payload超过4K大小时，DroiPush SDK会自动将消息转换为长消息类型供开发者使用；

- 文件推送

DroiPush支持开发者上传自定义文件,或者使用外部文件（文件url），通过通知推送到应用。  

- `kDroiPushReceiveLongMessageNotification` ：收到长消息通知
- `kDroiPushReceiveFileNotification`        ：收到文件通知
- `kDroiPushReceiveSilentNotification`      ：收到透传消息通知

开发者可以通过通知中心监听通知，根据需求对接收到的消息进行处理。

```
//添加监听
[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLongMessage:)
                                                 name:kDroiPushReceiveLongMessageNotification
                                               object:nil];
```
```
- (void)receiveLongMessage:(NSNotification *)notification
{
    NSLog(@"receiveLongMessage:%@",notification);
}
```
###  Log功能开关
建议开发者在发布应用前关闭DroiPush的Log功能，节省系统资源。

```
//关闭Log功能,默认为开启
[DroiPush setLogOFF:YES];
```
## FAQ
### DroiPush 的作用与特点？
* 降低开发成本

iOS 平台上，只有 APNs 这个官方的推送通道，是可以随时送达的。一般开发者都是自己部署应用服务器向 APNs Server 推送。DroiPush只需开发者做一些简单的SDK移植接入工作，就可在短期内使应用具有接收推送消息的功能，免去了开发者额外投入大量人力、服务器资源，将主要精力投入在核心业务的开发上。

* 丰富的消息类型

DroiPush提供了多种消息类型推送，包含有普通通知、静默通知、长消息通知、以及文件推送，满足用户消息推送的多样化需求。

* 精准的用户分群

DroiPush提供了标签绑定功能，开发者可以根据业务需求为用户绑定多种标签，细分用户分群，使得运营更加简单、直观。

### DroiPush 支持哪些通知类型？
DroiPush提供了普通通知、透传消息、长消息通知、以及文件推送。

* 普通通知

最基础的通知类型，当应用不在前台状态时会在通知栏或者锁屏页面显示；

* 透传消息

应用收到透传消息系统不会有任何提示，开发者可以使用它后台刷新数据(需要先配置Background Modes)；

* 长消息通知

由于苹果官方规定APNs推送payload的大小最大为4K，当开发者需要推送的payload超过4K大小时，DroiPush SDK会自动将消息转换为长消息类型供开发者使用；

* 文件推送

DroiPush支持开发者上传自定义文件，或者使用外部文件(文件url)，通过通知推送到应用。

### DroiPush可以对推送的数据进行统计吗？
开发者可以在推送平台上查看推送统计数据，对推送的数据进行分析。以下是推送数据统计的指标：

* 已推送消息数：单播消息、组播消息和群发消息数；
* 送达消息数：已经接收到消息的数量(iOS由于系统封闭，只能统计消息送达APNs的数量)；
* 通知点击数：用户通过通知栏中通知点击打开应用的次数；

### DroiPush 支持哪些推送方式？
DroiPush支持单播、列播、组播、群播的方法选择推送目标。

* 单播

推送平台可以通过deviceId指定单个目标进行推送；

* 列播

推送平台可以通过deviceId列表指定多个目标进行推送；


* 组播

SDK提供接口给应用打标签，推送时开发者选定推送目标为对应标签，推送服务器则向该标签的分组用户推送消息；

* 群播

推送服务器向该应用的所有用户推送消息。

### DroiPush的推送性能如何？
为了保证推送服务的质量，我们在实验环境下对服务器进行压力测试，得到的性能参数如下：

* 同时连接数：同时链接数支持超过1000万；
* 并发推送数：同时并发推送数支持超过100万；
* 及时性：100万条数据同时推送出去延时不超过30S；
* 连接稳定性：连接成功率超过99%（排除网络原因）。


[1]: http://baastest.droi.cn/Uploads/DocFile/5767a6d983ce9.jpeg
[2]: http://baastest.droi.cn/Uploads/DocFile/5767a6d394a2a.jpeg