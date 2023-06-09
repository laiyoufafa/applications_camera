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

import { Action } from '../redux/actions/Action'
import { CameraService } from '../Camera/CameraService'
import { EventBus } from '../Utils/EventBus'
import EventBusManager from '../Utils/EventBusManager'
import { WorkerManager } from '../Utils/WorkerManager'

export abstract class Function {
  protected mCameraService: CameraService = CameraService.getInstance()
  protected mWorkerManager: WorkerManager = new WorkerManager()
  protected mEventBus = EventBusManager.getInstance().getEventBus()

  protected enableUi() {
    this.mWorkerManager.postMessage(Action.UiState(true))
  }

  protected disableUi() {
    this.mWorkerManager.postMessage(Action.UiState(false))
  }

  abstract load(): void;

  abstract unload(): void;
}