两天时间，用 Flutter 写出一个股票分析客户端
====

# 为什么要用 Flutter
__用户体验与原生一致__：2017 年 Google 发布 [Flutter](https://flutter.cn) 到今天已经 3 年多了。它与其他跨平台框架最大的不同是可以直接编译成原生应用。这使得应用的体积接近原生应用，性能也几乎与原生应用一致。 

__缩短开发时间__：随着 3 年多的发展，Flutter 生态日趋完善，并已在__淘宝__，__闲鱼__和__知乎__等大型客户端上使用。随着 2.0 版本发布，Flutter 已经可以满足__电商，社交，直播，企业办公__等众多商业场景的业务需要。同时，一次开发多端发布，提升了研发效率，使__业务功能可以在 Android 和 iOS 平台同时上线__。

__面向未来支持全平台__：除了 Android 和 iOS 之外，Flutter 也可以在 MacOS，Linux 和 Windows 上运行。面向 5G 时代，Google 开源的物联网操作系统  [Fuchsia](https://fuchsia.dev/)  也默认支持 Flutter 应用。未来搭载 Fuchsia 系统的__智能穿戴，智能家居，智能园区，车载系统__等物联网设备上都可以直接运行Flutter应用。

时至今日，Flutter 已经具备了诸多优势，并可以__帮助企业快速将服务交付给用户__。 

基于以上原因，我选择了 Flutter 作为客户端技术。用一个__小而全__的应用来梳理 Flutter 在移动应用开发中的优势和不足。

# 一个小而全的客户端
验证一项技术最直接的方法就是用它做一个原型项目。对于前端应用来说需要优先验证以下几个方面：
- UI / UX 绘制的方式和效率
- 数据，业务逻辑和 UI 组件的解耦方式
- UI 组件库的定制化程度
- 架构模式
- 性能，兼容性，稳定性
- 单元测试
- 开发工具成熟度
- 可调试性
- 线上日志采集方式

股票分析客户端主要从后台服务获取数据，进行处理并在页面中绘制图表。功能不多，但可以验证以上需要验证的方面。

## 客户端主要包括以下功能：
投资模型列表（数据加载）：
![分析模型列表](https://upload-images.jianshu.io/upload_images/3265839-becac646b9f6ada0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/340)

投资模型模拟投资（Flutter 图表）：
![模拟投资](https://upload-images.jianshu.io/upload_images/3265839-c9113b51740d5ded.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/340)

投资模型模拟投资（Web 图表）：
![DeMark](https://upload-images.jianshu.io/upload_images/3265839-65e5650df41bc610.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/340)

股票详情（Web 网页）：
![详情展示](https://upload-images.jianshu.io/upload_images/3265839-33bfe9afd8112432.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/340)

# 优势与不足
## 优势
### UI / UX 绘制的方式和效率
__[声明式 UI 描述](https://flutter.cn/docs/get-started/flutter-for/declarative)效率高__：熟悉 Web 开发或 Swift 开发的工程师可以很容易上手。同时因为 UI 绘制完全有 Flutter 自身完成，不依赖于平台组件，可以做到 __Android 和 iOS 一致__。我在开发时使用 iPhone 模拟器，打包发布到 Android 手机上界面与 iPhone 模拟器效果完全一样，极大的__节省了双平台调试和适配的时间__。
 
### 数据，业务逻辑和 UI 组件的解耦
__原生支持解耦__ ：StatelessWidget 与 StatusfulWidget 的概念，可以很好的解耦 UI 组件与业务组件。同时 Class 为一等公民的概念，使应用开发面向对象，可以做到__高内聚低耦合__。

### UI 组件库的定制化程度
__原生组件持平__：Material 组件库提供了主题定制能力，同时 UI 组件的可配置参数也非常丰富。可以从主题的纬度，组件的纬度进行定制。

### 性能，兼容性，稳定性
__发布包体积小__：APP 打包后体积仅 18MB，这让我非常惊喜。相对于 RN 动辄 30MB+ 起步的体积，确实有很大提升。
__性能逼近原生__：100多数据的列表加载无延迟；1500+节点的图表动画切换平滑无卡顿。从用户体验角度，性能已接近原生水平。业界评测机构给出的结果：相对于原生 Flutter 性能消耗为1.2倍，而 RN 是15倍。
__UI / UX 兼容性良好__：iPhone 模拟器环境开发后可以直接发布到 Android 手机进行测试。组件自适应不同屏幕尺寸无需开发时适配。

### 开发工具成熟度
__开发工具完备__：Flutter 提供的命令行工具和 IDE 插件可以完整支撑 APP 开发的全生命周期。同时，编辑器插件可以帮助开发人员快速重构代码，提升代码质量。

## 不足
### 架构模式
__缺少标准架构模式__：像 RN 和 Vue 等UI框架一样，作为一款主要针对 UI 的框架，在业务逻辑和数据层管理层面没有提出明确方案。目前业界主流的__单向数据流模型__，__响应式模型__都相应的 Flutter 版本，但缺少一套完善的 Framework 来保证项目长期开发过程中架构不会腐化。这__需要 Flutter 项目的架构师在启动项目之前，定义好合适的模型，制定项目开发规范，与开发团队达成共识，并将代码质量检查机制落实到流水线和质量门禁工具中__。

### 一些原生开源 UI 组件未适配
__缺少开源 UI 组件__：在开发股票图表时，主流的开源图表库均未适配 Flutter 平台。建议在__项目开始前，由架构师充分评估需要用到的UI组件__。对于没有相应开源组件的功能，做好充分的评估，并预留足够的开发时间。

### 可调试性如何
__错误提示不够明确__：Flutter 的热重载功能给开发带来极大的效率提升。这个特性对 Web 工程师来说早已习惯，并没有太多惊喜。反而是含糊的类型错误提示，有时让人不知所措。 

__声明式 UI 嵌套过深造成语法错误__：在 RN 中，声明式 UI 使用的是类似 HTML 的方式，tag 标签方式可以快速定位未闭合元素。而 Flutter 使用 “（）”方式进行闭包，导致一旦出现未匹配情况，很难快速定位，往往需要花很长时间进行调整。 

### 线上日志采集
目前业界缺少健全的日志收集方式。__架构师应在项目启动阶段根据项目定义采集纬度和指标，确保线上运行情况可感知__。

## 待验证项目
时间原因，单元测试没有在本次开发中验证，待验证后补充。

# 总结
Flutter 作为跨平台 UI 框架，不仅可以在 Android ，iOS， Web 和 PC 上使用，更面向为未来 5G 时代的 IoT 设备设计。可以解决 5G 时代企业临的__在“多尺寸屏幕”和“低性能”的 IoT 设备上研发应用__的问题。

同时，__一次开发多平台发布的特性__也极大的提升了交付效率。这使企业可以用__更短的时间将服务提供终端用户，提升企业自身的行业竞争力__。

无论现在还是未来，__都建议企业研发团队引入 Flutter__ 作为移动端开发技术，来提升业务交付效率。 

# 后记：两天时间都做了些什么工作
## 第一天
__3小时__：根据 [Flutter 中文网说明安装环境](https://flutter.cn/docs/get-started/install)。因为网络问题，无法直接使用官网服务。大多数时间用来寻找和配置国内网络镜像。这里推荐[清华大学的镜像源](https://mirrors.tuna.tsinghua.edu.cn/flutter)。排除网络问题后，顺利安装并初始化项目。Flutter 提供的命令行工具包括__初始化，包管理，调试运行，构建__等应用全生命周期支持，熟悉命令行工具的工程师可以非常高效的通过命令行完成应用开发所需要的工作。
 
__30分钟__：初始化 Flutter 项目，并在 GitHub 创建[代码仓](https://github.com/yanqiw/flutter-pilot)。与[后端](https://github.com/moneyice/hope2)约定使用 GitHub Issue 功能进行 bug 修复和新功能开发等简单项目管理工作。

__1小时__：通过 [Learn Dart in Y mins](https://learnxinyminutes.com/docs/dart/) 学习 Dart。因为我本身对 Javascript 和 Typescript 有所了解，所以没有太多认知上的障碍，一边看一边写就好了。 

__1小时__：了解 Flutter 的组件基本概念和 StatefulWidget 和 StatelessWidget 的用途。简单的说：纯 UI 组件用 StatelessWidget；有业务逻辑的用 StatefulWidget。这是内置的 UI 与业务解耦的约定。这个设计很有优势，从框架级别就划分好 UI 组件与业务组件，从根源避免 UI 与业务耦合。

__4 小时__：开发业务功能，大部分时间都用来在熟悉 Material 的组件接口和在社区搜索相应的组件。其中用到最多的是[布局组件](https://flutter.cn/docs/development/ui/layout)和[列表组件](https://api.flutter-io.cn/flutter/widgets/ListView-class.html)。Flutter 的__热重载__技术可以在代码修改后，直接在模拟器中看到效果，避免像原生应用开发那样再次编译。这个特性极大的提高了开发效率和体验。但 Flutter 的错误提示稍有不足，特别是类型错误时，只提示类型不兼容，让人不知所措。

__1小时__：根据[官方文档](https://flutter.cn/docs/deployment/android)打包发布。主要时间花费在为 Android 创建和配置密钥，以及修改包名。打包好后通过[蒲公英测试平台](https://www.pgyer.com/0VFM)发布。注：蒲公英被微信屏蔽，需要在浏览器内打开。

## 第二天
__4 小时__：寻找合适的图表组件。遇到 Flutter 生态不完善的老问题，像 Web 端和 Native 端的知名图表库 EChart 或者 HighChart 都没有对应的 Flutter 版本。这里有三个替代方案：
1. 使用基础 Flutter UI 组件开发
2. 使用简单的图表组件满足最小业务需要
3. 使用 WebView 嵌入 EChart 或 HighChart

在我的应用中，在“模型模拟”页面分别尝试了“使用简单组件满足最小业务需求”和“ WebView 嵌入”两种方式。
- “简单组件”使用 Flutter 的方式绘制原生界面，交互更平滑，性能更高。这种方式可以做到毫秒级绘制1500+节点到图表，动画无卡顿。
- “WebView 嵌入”方式加载慢，但功能强大。一次开发 Web 与 APP 都可以使用，后期通过直接嵌入本地静态 H5 资源，只加载数据的方式，可以提升明显加载速度。

__2 小时__：调整其他页面接口，抽象UI组件。 这里要介绍一下 VSCode 的 [Flutter 插件](https://flutter.cn/docs/development/tools/vs-code)，提供了丰富的重构功能。它可以快速的将混在 StatefulWidget 中的通用 UI 组件抽象成 StatelessWidget ，极大提升了重构效率。
 ![image.png](https://upload-images.jianshu.io/upload_images/3265839-c0fa7ceac3eb09d3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/640)

__6 小时__：整理这篇文章。
