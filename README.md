# 涂鸦智能 UI 业务包 - HarmonyOS 示例工程

## 环境准备

1. 在[涂鸦开放平台](https://www.tuya.com/)注册账号并创建应用
2. 获取 `AppKey` 和 `AppSecret`
3. 下载加密图片 `t_s.bmp`
4. 获取安全组件 `TSmartSecurity.har`，放到 `entry/src/main/libs/` 目录下

## 配置步骤

### 1. 配置应用密钥和加密图片

#### 1.1 复制配置模板

```bash
cp entry/src/main/ets/config/ThingCustomConfig.template.ets entry/src/main/ets/config/ThingCustomConfig.ets
cp build-profile.template.json5 build-profile.json5
```

#### 1.2 填入应用密钥

编辑 `entry/src/main/ets/config/ThingCustomConfig.ets`：

```typescript
export class ThingCustomConfig {
  static readonly APP_KEY = "你的AppKey";
  static readonly APP_SECRET = "你的AppSecret";
}
```

#### 1.3 放置加密图片

将 `t_s.bmp` 文件放到以下目录：

```
entry/src/main/resources/rawfile/t_s.bmp
```

### 2. 配置 OHPM 源

编辑项目根目录的 `.ohpmrc` 文件，添加涂鸦 OHPM 源：

```ini
registry=https://ohpm.openharmony.cn/ohpm/
strict_ssl=false

# 涂鸦 OHPM 源
@thingsmart:registry=https://ohpm-repo.tuya.com/repos/ohpm
@rnoh:registry=https://ohpm-repo.tuya.com/repos/ohpm
@tuya-oh:registry=https://ohpm-repo.tuya.com/repos/ohpm

# 认证信息
//ohpm-repo.tuya.com/repos/ohpm/:_auth="你的认证token"
```

### 3. 配置 BOM 插件

#### 3.1 安装插件

将插件包放到 `plugins/` 目录下，然后在 `oh-package.json5` 中添加：

```json5
{
  "devDependencies": {
    "@tuya-harmony/thingHMBOMPlugin": "file:../plugins/tuya-harmony-thingHMBOMPlugin-1.0.0.tgz"
  }
}
```

#### 3.2 引入插件

在项目根目录的 `hvigorfile.ts` 中配置：

```typescript
import { thingBOMPlugin } from '@tuya-harmony/thingHMBOMPlugin';
import { appTasks } from '@ohos/hvigor-ohos-plugin';

export default {
    system: appTasks,
    plugins:[
        thingBOMPlugin()
    ]
}
```

### 4. 固定业务包版本

编辑 `entry/sdk-requirements.json`，指定所需的业务包版本：

```json5
{
  "tag": "feature/publish",
  "versions": {
    "@thingsmart/userlib": "1.1.18",
    "@thingsmart/channel": "1.1.62",
    "@thingsmart/theme": "1.1.4",
    // ... 其他业务包
  }
}
```

根据实际业务需求，从 `sdk-requirements.json` 中选择需要的组件添加到 `entry/thing-biz-components.json`。

### 5. 业务组件配置

编辑 `entry/thing-biz-components.json`，添加项目使用的业务组件：

```json5
{
  "components": {
    "@thingsmart/userlib": "1.1.18",
    "@thingsmart/channel": "1.1.62",
    "@thingsmart/theme": "1.1.4"
    // ... 根据需要添加
  }
}
```

## 依赖安装

```bash
ohpm install
```

## 运行项目

```bash
# 构建项目
hvigorw assembleHap

# 或在 DevEco Studio 中直接运行
```

## SDK 初始化

在 `entry/src/main/ets/app/AppAbilityStage.ets` 中添加：

```typescript
// 动态反射初始化
thingDynamicReflect.init(getReflectMetaInfo(`${bundleName}/${moduleName}`));

// Router 初始化
ThingRouter.initialize()
ThingRouter.getServiceMgr().setServiceModuleMap(servicesModuleMap());

// 主题初始化
ThingTheme.getInstance().init(this.context)

// 初始化任务
const initMetaInfo = thingDynamicReflect.filterMetaInfo(ThingInitializer.DEFAULT_GROUP);
new ThingInitializer(initMetaInfo).execute(this.context);

// 页面启动流水线
AppLaunchPipeliner.getInstance().loadPipelineInfo()
```
