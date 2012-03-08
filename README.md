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
Use +surikaeWithSelector:surikae:context of NSObject.  
It replace the selector of the Class by surikae block.  
If you want to replace an instance method, use -surikaeWithSelector:surikae:context of NSObject.
This effect is available in the context block only.  
  
[See StopWatchTest.m](https://github.com/katsuyoshi/Surikae/blob/master/sample/iUnitTest/Tests/StopWatchTest.m)

    [NSDate surikaeWithSelector:@selector(date)
        surikae:^()
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

If you need these effect more long period, use +registedSurikaeWithSelector:surikae of NSObject.  
In this case IUTSurikae class retains UITSurikae object.  
When you retrieve all replaced methods, call +[NSObject removeAllSurikaes].  


[See StopWatchTest2.m](https://github.com/katsuyoshi/Surikae/blob/master/sample/iUnitTest/Tests/StopWatchTest2.m)

    - (void)setUp
    {
        [super setUp];
        second = 0;
        [NSDate registedSurikaeWithSelector:@selector(date)
            surikae:^()
            {
                return [NSDate dateWithYear:2012 month:2 day:17 hour:hour minute:minute second:second];
            }
        ];
        self.stopWatch = [StopWatch new];
    }

    - (void)tearDown
    {
        self.stopWatch = nil;
        [NSDate removeAllSurikaes];
        [super tearDown];
    }
Please see a sample project  

LICENCE  
=
BSD Licence


Thanks
=
hayashi311: implementation blocks
