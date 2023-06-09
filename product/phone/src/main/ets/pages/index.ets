/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import display from '@ohos.display';
import router from '@system.router';

import { BigVideoTimer } from './BigVideoTimer'
import { CLog } from '../../../../../../common/src/main/ets/default/Utils/CLog'
import { Control } from './Control'
import { EventBus } from '../../../../../../common/src/main/ets/default/Utils/EventBus'
import EventBusManager from '../../../../../../common/src/main/ets/default/Utils/EventBusManager'
import { FootBar } from './FootBar'
import { ModeConfig } from '../common/ModeConfig'
import { PreviewArea } from './PreviewArea'
import RdbStoreManager from '../../../../../../common/src/main/ets/default/Utils/RdbStoreManager'
import ScreenLockManager from '../../../../../../common/src/main/ets/default/Utils/ScreenLockManager'
import { SmallVideoTimer } from './SmallVideoTimer'
import { TabBar
} from '../../../../../../features/featurecommon/src/main/ets/com/ohos/featurecommon/tabBar/TabBar'
import { ZoomView
} from '../../../../../../features/featurecommon/src/main/ets/com/ohos/featurecommon/zoomView/ZoomView'
import getStore from '../../../../../../common/src/main/ets/default/redux/store'
import { Action } from '../../../../../../common/src/main/ets/default/redux/actions/Action'
import { CameraWorker } from '../../../../../../common/src/main/ets/default/Utils/CameraWorker'

var mScreenLockManager = new ScreenLockManager()
var cameraWorker = CameraWorker.getInstance()

let indexState = (state) => {
  return {
    footBarHeight: state.ContextReducer.footBarHeight,
    permissionFlag: state.ContextReducer.permissionFlag,
    action: state.ContextReducer.action,
    mode: state.ModeReducer.mode,
    curMode: state.ModeReducer.curMode,
    isBigVideoTimerVisible: state.UiReducer.isBigVideoTimerVisible,
    isSmallVideoTimerVisible: state.UiReducer.isSmallVideoTimerVisible,
    videoState: state.RecordReducer.videoState,
  }
}

let indexDispatcher = (dispatch) => {
  return {
    initFootBarHeight: (footBarHeight: number) => {
      dispatch(Action.InitFootBarHeight(footBarHeight))
    },
    setPermissionFlag: (permissionFlag: boolean) => {
      console.info(`CameraApp setPermissionFlag: ${permissionFlag}`)
      dispatch(Action.SetPermissionFlag(permissionFlag))
    },
    initAction: (action: string) => {
      dispatch(Action.InitAction(action))
    },
    initCameraPosition: (cameraPosition: string) => {
      dispatch(Action.SetCameraPosition(cameraPosition))
    },
    initMode: (mode: string) => {
      dispatch(Action.InitMode(mode))
    }
  }
}

@Entry
@Component
struct Index {
  private TAG: string = '[Index]:'
  private modeConfig: ModeConfig = new ModeConfig()
  appEventBus: EventBus = EventBusManager.getInstance().getEventBus()
  @State state: any = {}
  private mConnect: any
  private ASPECT_RATIO: number = 4 / 3

  private aboutToAppear() {
    CLog.info(`${this.TAG} aboutToAppear E`)
    let dbStore = RdbStoreManager.getInstance()
    dbStore.initRdbConfig()
    mScreenLockManager.init()
    this.mConnect = getStore().connect(indexState, indexDispatcher)(this.state)

    display.getDefaultDisplay().then((dis) => {
      CLog.info(`${this.TAG} dis data = ${JSON.stringify(dis)}`)
      let footBarHeight = px2vp(dis.width) * this.ASPECT_RATIO - 100
      this.state.initFootBarHeight(footBarHeight)
    })

    if (!this.state.permissionFlag) {
      let permissionList: Array<string> = [
        "ohos.permission.MEDIA_LOCATION",
        "ohos.permission.READ_MEDIA",
        "ohos.permission.WRITE_MEDIA",
        "ohos.permission.CAMERA",
        "ohos.permission.MICROPHONE",
        "ohos.permission.DISTRIBUTED_DATASYNC"
      ]
      CLog.info(`${this.TAG} permissions need to require from user: ${JSON.stringify(permissionList)}`)
      globalThis.cameraAbilityContext.requestPermissionsFromUser(permissionList).then((data) => {
        CLog.info(`${this.TAG} data permissions: ${JSON.stringify(data.permissions)}`)
        CLog.info(`${this.TAG} data authResult: ${JSON.stringify(data.authResults)}`)
        let sum = 0
        for (let i = 0; i < data.authResults.length; i++) {
          sum += data.authResults[i]
        }
        if (sum >= 0) {
          globalThis.permissionFlag = true
          this.state.setPermissionFlag(true)
        } else {
          globalThis.permissionFlag = false
          this.state.setPermissionFlag(false)
        }
        CLog.info(`${this.TAG} request permissions result: ${globalThis.permissionFlag}`)
      }, (err) => {
        CLog.error(`${this.TAG} Failed to start ability err code: ${err.code}`)
      })
    }

    if (globalThis.cameraFormParam != undefined) {
      this.state.initAction(globalThis.cameraFormParam.action)
      this.state.initMode(globalThis.cameraFormParam.mode)
      globalThis.cameraFormParam = undefined
    }

    CLog.info(this.TAG + " router.getParams()= " + JSON.stringify(router.getParams()))
    if (router.getParams() != undefined) {
      this.state.initCameraPosition(router.getParams().position)
      this.state.initMode(router.getParams().mode)
    }

    CLog.info(`${this.TAG} aboutToAppear X`)
  }

  private onPageShow() {
    console.info("onPageShow this.permissionFlag= " + this.state.permissionFlag + '  globalThis.permissionFlag = ' + globalThis.permissionFlag)
    this.state.setPermissionFlag(globalThis.permissionFlag)
  }

  private aboutToDisappear(): void {
    CLog.info(`${this.TAG} aboutToDisappear E`)
    this.mConnect.destroy()
    CLog.info(`${this.TAG} aboutToDisappear X`)
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      if (this.state.permissionFlag) {
        PreviewArea()
        Stack() {
//          if (this.state.videoState === "beforeTakeVideo") {
//            TabBar()
//          }
          if (this.state.isSmallVideoTimerVisible) {
            SmallVideoTimer()
          }
        }.width('100%').height(48).position({ x: '0', y: '0' })
        if (this.state.isBigVideoTimerVisible) {
          BigVideoTimer()
        }
        Stack({ alignContent: Alignment.Bottom }) {
          Column() {
            if (this.state.mode === "PHOTO" || this.state.mode === "VIDEO") {
              ZoomView()
            }
            if (this.state.videoState === "beforeTakeVideo") {
              Control()
            }
            FootBar()
          }
        }.width('100%').height(254).position({ y: this.state.footBarHeight })
      }
    }.width('100%').height('100%').backgroundColor('#000')
  }
}