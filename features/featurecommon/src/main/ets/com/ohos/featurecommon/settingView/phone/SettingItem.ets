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

import {SettingsUtil} from '../../../../../../../../../../common/src/main/ets/default/Utils/SettingsUtil'
import {CLog} from '../../../../../../../../../../common/src/main/ets/default/Utils/CLog'
import {SetResolution} from './SetResolution'
import {SetToggle} from './SetToggle'
import {BaseData}  from '../../../../../../../../../../common/src/main/ets/default/Utils/bean/BaseData'

@Component
export struct SettingItem {
  private TAG: string = '[SettingItem]:'
  @Link settingsList: any[]
  private item: BaseData
  private index: number
  private settingsListIndex: number
  private getPhotoValue: Promise<string>
  private getVideoValue: Promise<string>
  private WH_100_100: string = "100%";
  private settingsUtil = SettingsUtil.getInstance()

  aboutToAppear() {
    CLog.info(`${this.TAG} aboutToAppear start`)
    CLog.info(`${this.TAG} aboutToAppear ${JSON.stringify(this.item.settingChildren)}`)
    CLog.info(`${this.TAG} aboutToAppear end`)
  }

  build() {
    Flex({ direction: FlexDirection.Column,
      alignItems: ItemAlign.Center,
      justifyContent: FlexAlign.SpaceBetween }) {
      Column() {
        Row() {
          Text(this.item.settingTitle)
            .margin({ top: $r('app.float.margin_value_20'),
              left: $r("sys.float.ohos_id_card_margin_start"),
              bottom: $r('app.float.margin_value_8') })
            .fontColor($r('app.color.font_color_FFFFFF'))
            .opacity($r('app.float.opacity_6'))
            .fontSize($r('app.float.font_14'))
            .fontWeight(FontWeight.Medium)
        }
        .width(this.WH_100_100)
        .height(this.WH_100_100)
      }
      .width(this.WH_100_100)
      .height(48)

      Column() {
        List() {
          ForEach(this.item.settingChildren, (itemValue) => {
            ListItem() {
              Column() {
                if (itemValue.selectType === "radio") {
                  SetResolution({
                    settingsList: $settingsList,
                    itemValue: itemValue
                  })
                }
                if (itemValue.selectType === "toggle") {
                  SetToggle({
                    settingsList: $settingsList,
                    itemValue: itemValue
                  })
                }
              }
            }
          })
        }
        .listDirection(Axis.Vertical)
        .divider({ strokeWidth: 2, color: 0xFFFFFF, startMargin: 56, endMargin: 12 })
        .borderRadius($r("sys.float.ohos_id_corner_radius_card"))
        .backgroundColor("#202224")
      }.width(this.WH_100_100)
    }
  }
}