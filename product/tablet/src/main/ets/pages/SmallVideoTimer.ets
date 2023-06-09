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

@Component
export struct SmallVideoTimer {
  @State smallVideoTime: string = '00:03'
  @State spotVisibility: boolean = true
  @State smallTimer: number = 0
  @State spotTimer: number = 0
  @Provide showSecond: string = '03'
  @Provide showMinute: string = '00'
  @State originSecond: number = 3
  @State second: number = 3
  @State minute: number = 0
  @Link @Watch("watchIsResumeVideo") isResumeVideo: boolean
  @Link @Watch("watchIscContinueVideo") iscContinueVideo: boolean
  @State timerPosition: number= 0
  private ASPECT_RATIO: number = 4 / 3

  private aboutToAppear() {
    this.setIntervalSmallVideoTimer()
  }

  private aboutToDisappear() {
    clearInterval(this.spotTimer)
    clearInterval(this.smallTimer)
    display.getDefaultDisplay().then((dis) => {
      this.timerPosition = px2vp(dis.height) * this.ASPECT_RATIO
    })
  }

  setIntervalSmallVideoTimer() {
    clearInterval(this.smallTimer);
    this.smallTimer = setInterval(() => {
      this.second++;
      this.originSecond++;
      if (this.second < 10) {
        this.showSecond = `0${this.second}`;
      } else if (this.second < 60) {
        this.showSecond = this.second.toString();
      } else {
        this.showSecond = '00';
        this.second = 0;
      }
      if (this.originSecond > 59) {
        this.minute = Math.floor(this.originSecond / 60);
        if (this.minute < 10) {
          this.showMinute = `0${this.minute}`;
        } else {
          this.showMinute = this.minute.toString();
        }
      }
      this.smallVideoTime = `${this.showMinute}:${this.showSecond}`;
    }, 1000);
    clearInterval(this.spotTimer)
    this.spotTimer = setInterval(() => {
      this.spotVisibility = !this.spotVisibility
    }, 500)
  }

  watchIsResumeVideo() {
    if (this.isResumeVideo) {
      clearInterval(this.spotTimer)
      clearInterval(this.smallTimer)
    }
  }

  watchIscContinueVideo() {
    if (this.iscContinueVideo) {
      this.setIntervalSmallVideoTimer()
    }
  }

  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.End }) {
        if (this.isResumeVideo) {
          Image($r('app.media.ic_video_recording'))
            .width(12)
            .height(12)
            .fillColor(Color.White)
        } else {
          if (this.spotVisibility) {
            Column() {
            }
            .width(12)
            .height(12)
            .backgroundColor('#FF0000')
            .borderRadius(6)
            .visibility(Visibility.Visible)
          } else {
            Column() {
            }
            .width(12)
            .height(12)
            .backgroundColor('#FF0000')
            .borderRadius(6)
            .visibility(Visibility.Hidden)
          }
        }
        Text(this.showMinute)
          .margin({ left: 8 })
          .fontSize('28fp')
          .fontWeight(FontWeight.Lighter)
          .fontColor('#FFFFFF')
      }
      .layoutWeight(1)

      Text(":")
        .fontSize('28fp')
        .fontWeight(FontWeight.Lighter)
        .fontColor('#FFFFFF')
      Text(this.showSecond)
        .fontSize('28fp')
        .fontWeight(FontWeight.Lighter)
        .fontColor('#FFFFFF')
        .textAlign(TextAlign.Start)
        .layoutWeight(1)
    }
    .width(this.timerPosition == 0 ? '100%' : this.timerPosition)
    .height(48)
  }
}