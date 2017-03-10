
#BMANRDector

#####An ANR (Application Not Respond) or Freeze Dector for iOS

`link plcrashreporter`

[plcrashreporter](https://github.com/plausiblelabs/plcrashreporter)


`It is useful for you to locate the program problem when your Application does not respond or freezing. Too much threads may result in spending a lot time to print the proccess StackTrace. we will optimize this in future`

检测应用程序无响应、冻屏并打印程序调用栈，帮助你定位程序问题


Download steps
========================

`git clone https://github.com/wuyunfeng/iOS-Frezzing-ANR-Detector.git`
`git submodule update --init --recursive`


Design Principle
========================

![](http://p1.bpimg.com/567571/c16a5aa6e9c238ac.jpg)
    


How use?
========================
You can install `BMANRDector` in your `AppDelegate` or some `UIViewController`

            BMANRDector *tool = [BMANRDector sharedInstance];
           [tool installTraceMode:BMANRStackTraceLive tolerance:6 searchMode:BMANRSearchModeANR];


