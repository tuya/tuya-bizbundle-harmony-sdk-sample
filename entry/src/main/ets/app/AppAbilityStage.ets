import { AbilityStage, bundleManager, common } from "@kit.AbilityKit";
import { TSmartSDK } from "@thingsmart/channel";
import { ThingTheme } from "@thingsmart/theme";
import { _godzillapage_service_meta } from "@thingsmart/godzillapage"
import { thingDynamicReflect } from "@thingsmart/dynamicreflect";
import { getReflectMetaInfo } from "../_thing_src_g/thingReflectMetaInfo";
import { ThingRouter } from "@thingsmart/thingrouter"
import { servicesModuleMap } from "../_thing_src_g/serviceModuleMapRegister";
import { ThingInitializer } from "@thingsmart/dynamicinitializer";
import { AppLaunchPipeliner } from "@thingsmart/launchpipeline";
import { TSmartUser } from "@thingsmart/userlib";
import { ThingCustomConfig } from "../config/ThingCustomConfig";

export class AppAbilityStage extends AbilityStage {

  onCreate(): void {

    const bundleName = this.context.applicationInfo.name;
    const moduleName = this.context.currentHapModuleInfo.name;
    thingDynamicReflect.init(getReflectMetaInfo(`${bundleName}/${moduleName}`));
    ThingRouter.getServiceMgr().setServiceModuleMap(servicesModuleMap());

    ThingTheme.getInstance().init(this.context)

    const bundleFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION;
    const bundleInfo = bundleManager.getBundleInfoForSelfSync(bundleFlags);
    TSmartSDK.startWithAppKey(
      ThingCustomConfig.APP_KEY,
      ThingCustomConfig.APP_SECRET,
      this.context.getApplicationContext(),
      bundleInfo.name);

    // 初始化任务
    const initMetaInfo = thingDynamicReflect.filterMetaInfo(ThingInitializer.DEFAULT_GROUP);
    if (initMetaInfo && initMetaInfo.size > 0) {
      new ThingInitializer(initMetaInfo).execute(this.context);
    }
    // 自动登录
    if (TSmartUser.isLogin()) {
      TSmartUser.initUserAgent()
    }
    // 页面启动流水线
    AppLaunchPipeliner.getInstance().loadPipelineInfo()
  }
}