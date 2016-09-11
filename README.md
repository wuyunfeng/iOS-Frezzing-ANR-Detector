
#BMANRDector

#####An ANR (Application Not Respond) or Freeze Dector for iOS

`link plcrashreporter`

[plcrashreporter](https://github.com/plausiblelabs/plcrashreporter)


`It is useful for you to locate the program problem when your Application does not respond or freezing. Too much threads may result in spending a lot time to print the proccess StackTrace. we will optimize this in future`

检测应用程序无响应、冻屏并打印程序调用栈，帮助你定位程序问题(当应用程序过大，线程数太多打印调用栈可能会花费数分钟)

AUTHOR & Email & Team
================

wuyunfeng
    - wyfsky888@126.com
    
`iPhone Team of BaiDu Map`


How use?
========================
You can install `BMANRDector` in your `AppDelegate` or some `UIViewController`

            BMANRDector *tool = [BMANRDector sharedInstance];
           [tool installTraceMode:BMANRStackTraceLive tolerance:6 searchMode:BMANRSearchModeANR];


