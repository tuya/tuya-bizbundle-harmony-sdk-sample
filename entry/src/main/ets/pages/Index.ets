import { ZRouter } from '@hzw/zrouter'
import { TSmartUser } from '@thingsmart/userlib'
import {ThingRouter} from "@thingsmart/thingrouter";
import { DEFAULT_STACK_NAME as thing_router_name } from '@thingsmart/thingrouter/src/main/ets/model/Model';

@Entry
@Component
struct Index {
  routerStack = ZRouter.getNavStack()

  aboutToAppear(): void {
    ThingRouter.registerNavStack(thing_router_name, this.routerStack)
  }

  build() {
    Column() {
      Navigation(this.routerStack) {
        Column() {
          Text("Hello Tuya")
            .fontSize(36)
            .fontWeight(FontWeight.Bold)
        }
        .justifyContent(FlexAlign.Center)
        .width("100%")
        .height("100%")

      }
      .hideToolBar(true)
      .mode(NavigationMode.Stack)
      .onAppear(() => {
        if (TSmartUser.isLogin()) {
          TSmartUser.getUserName()
          ZRouter.getInstance().push("HMHomePage")
        } else {
          ZRouter.getInstance().push("DemoLoginPage")
        }
      }).customNavContentTransition(ZRouter.getInstance().animateMgr().getAnimCustomNavContentTransition())
    }
    .height('100%')
    .width('100%')
  }
}