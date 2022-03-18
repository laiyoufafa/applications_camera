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

import Ability from '@ohos.application.Ability'

export default class MainAbility extends Ability {
    onCreate(want, launchParam) {
        console.info('Camera MainAbility onCreate.')
        globalThis.cameraAbilityContext = this.context
        globalThis.cameraAbilityWant = this.launchWant
        globalThis.permissionFlag = false
    }

    onDestroy() {
        console.info('Camera MainAbility onDestroy.')
    }

    async onWindowStageCreate(windowStage) {
        console.info('Camera MainAbility onWindowStageCreate.')
        if (this.launchWant.uri === 'capture') {
            globalThis.cameraFormParam = {
                action: 'capture',
                cameraPosition: 'PHOTO',
                previewImage: 'PHOTO'
            }
        } else if (this.launchWant.uri === 'video') {
            globalThis.cameraFormParam = {
                action: 'video',
                cameraPosition: 'VIDEO',
                previewImage: 'VIDEO'
            }
        }

        windowStage.setUIContent(this.context, 'pages/indexLand', null)
    }

    onWindowStageDestroy() {
        console.info('Camera MainAbility onWindowStageDestory.')
    }

    onForeground() {
        console.info('Camera MainAbility onForeground.')
        globalThis.onForegroundInit()
    }

    onBackground() {
        console.info('Camera MainAbility onBackground.')
        globalThis.releaseCamera()
    }
}