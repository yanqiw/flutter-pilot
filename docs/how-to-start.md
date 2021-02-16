构建一个可以线上运营的 Flutter 应用
====

# 为什么已可以线上运营为目标
当我们决定在项目中采用一项技术时，我们最关心的是这项技术能不能在真正的给商业活动带来价值。

初步调研时，可以做一个可以跑起来的应用，来验证关键目标的可行性。正如我在[两天时间，用 Flutter 写出一个股票分析客户端](https://zhuanlan.zhihu.com/p/341584103)所做的，验证技术本身的开发效率，跨平台兼容性等。

经过初步调研，我们决定使用这项技术。这时，目标就从`实验室验证`，变为已实现商业价值为目标的`线上运营`。这时，我们要考虑的是如何从“开发”，“运行” 和 “运维” 的领域来补充核心技术之外的能力。

# 用什么模型来思考
通常情况下，当我们要解决一个问题，或者完成一项任务时，都不是从0开始的。我们会去参考前辈的经验，沉淀的经验，总结的经验。并已此为起点，对新的问题进行思考和制定方案。

对于移动应用开发，我使用`埃森哲架构魔方(Accenture technology cubes)`为基础，围绕着 Flutter 技术对“开发”，“运行” 和 “运维”三个领域进行能力构建，和技术选型。
![Accenture technology cubes](https://s3.ax1x.com/2021/02/15/y6lYpq.png)

# 技术选择
## 开发
### 工具
选择 VScode 作为开发工具，并安装 flutter 官方开发插件。

### 依赖管理
选择 Flutter 自带包管理工具。（PS：也没有别的好选择的。。。）同时，使用[清华大学的镜像源](https://link.zhihu.com/?target=https%3A//mirrors.tuna.tsinghua.edu.cn/flutter)解决网络慢的问题。

### 测试
对于业务型APP，建议对交互无关的核心模块进行单元测试。
单元测试参考[单元测试介绍](https://flutter.cn/docs/cookbook/testing/unit/introduction)进行。目前，测试用例有待补充。

## 运行
运行架构借鉴 RN 项目中经典的[“presentation”和“containers”模式(Dan的博客有详细阐述，需要解决网络问题)](https://medium.com/@dan_abramov/smart-and-dumb-components-7ca2f9a7c7d0)，同时抽象出服务层和模型层。
具体可以参考[项目源代码](https://github.com/yanqiw/hope2)

## 运维
### 持续部署
因为移动应用的特殊性，iOS 构建需要使用 macOS 环境。使用云提供的 macOS 镜像成本过高。这里仅使用本地构建方式。选择使用 [festlane](https://docs.fastlane.tools/) 进行本地自动化构建，同时参考[Flutter 里的持续部署](https://flutter.cn/docs/deployment/cd)，进行配置。 

### 监控
选择使用[阿里云移动分析](https://www.aliyun.com/product/mobilepaas/mobile-analysis)。目前尚未集成。

# 先 Android 后 iOS 
因为 Android 发布相对简单，如不需要上架软件商店，找地方托管 APK 就可以发布。所以，先发布 [Android 版本](http://hope2-download.qianyitian.com/release/index.html)。

经过了两个小版本的快速迭代后，在苹果商店申请上架。期间，因为功能过于简单被拒绝过一次。之后，又经过一次优化，将UI优化，并将之前直接加载的网页进行静态资源离线打包只加载数据的优化，最终通过了苹果审核。[iOS 版本](https://apps.apple.com/cn/app/hope2/id1548733763)。

# 后记
目前项目已经可以通过使用命令行进行一键打包发布。同时，完成上架软件商店，且出售了几份（个位数）。
项目源码可：https://github.com/yanqiw/hope2

本项目的Web版本：https://hope2.qianyitian.com





