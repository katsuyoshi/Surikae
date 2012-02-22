Surikae
=
ITO SOFT DESIGN Inc. http://www.itosoft.com/  
Katsuyoshi Ito <kito@itosoft.com>  
February 10, 2012  
  
Introduction
=

Surikae replace a method by blocks.  
It’s helpful for unit testing for Objective-C.  

Installation
=
Import Surikae folder to you project.


How to use
=
Use +surikaeWithClassName:surikae:context of IUTSurikae.  
It replace the method(methodName) of class(className) by surikae block.  
The methodName you specify by string with + or -. If omit it, treat it as -.  
This effect is available in the context block only.  
  
[See StopWatchTest.m](https://github.com/katsuyoshi/Surikae/blob/master/sample/iUnitTest/Tests/StopWatchTest.m)

    [IUTSurikae surikaeWithClassName:@"NSDate" methodName:@"+date" surikae:^()
        {
            return [NSDate dateWithYear:2012 month:2 day:17 hour:0 minute:0 second:second];
        }
    context:^()
        {
            [self.stopWatch start];
            second = 1;
            [self.stopWatch stop];
            ASSERT_EQUAL_DOUBLE(1.0, self.stopWatch.time);
        }
    ];

--

If you need these effect more long period, use +registedSurikaeWithClassName:methodName:surikae of IUTSurikae class.  
In this case IUTSurikae class retains UITSurikae object.  
When you retrieve all replaced methods, call +[IUTSurikae cleanAll].  
  
[See StopWatchTest2.m](https://github.com/katsuyoshi/Surikae/blob/master/sample/iUnitTest/Tests/StopWatchTest2.m)

    - (void)setUp
    {
        [super setUp];
        second = 0;
        [IUTSurikae registedSurikaeWithClassName:@"NSDate" methodName:@"+date" surikae:^(){
            return [NSDate dateWithYear:2012 month:2 day:17 hour:hour minute:minute second:second];
        }];
        self.stopWatch = [StopWatch new];
    }

    - (void)tearDown
    {
        self.stopWatch = nil;
        [IUTSurikae clearAll];
        [super tearDown];
    }
Please see a sample project  

LICENCE  
=
BSD Licence


Thanks
=
hayashi311: implementation blocks
