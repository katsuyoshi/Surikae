Surikae
=
                                   ITO SOFT DESIGN Inc. http://www.itosoft.com/
                                   Katsuyoshi Ito <kito@itosoft.com>
                                   February 10, 2012

Introduction
=

Surikae exchanges a class or instance method.  
It’s helpful for unit testing for Objective-C.  

Installation
=
Import Surikae folder to you project.


How to use
=
There are 2 kind of methods.  
One is for a class method. Other is for an instance method.  

For a class method:
--
It exchanges +[originalClass method] for +[mockClass method].  
If global is YES, UITSurikae class retains UITSurikae object.  
When you retrieve all exchanged methods, call +[IUTSurikae cleanAll].  

\+ (IUTSurikae *)surikaeWithClassMethod:(SEL)method originalClass:(Class)originalClass mockClass:(Class)mockClass global:(BOOL)global;

It’s call with global NO  
\+ (IUTSurikae *)surikaeWithClassMethod:(SEL)method originalClass:(Class)originalClass mockClass:(Class)mockClass;


For an instance method:  
-
It exchanges -[originalClass method] for -[mockClass method].  
If global is YES, UITSurikae class retains UITSurikae object.  
When you retrieve all exchanged methods, call +[IUTSurikae cleanAll].  

\+ (IUTSurikae *)surikaeWithInstanceMethod:(SEL)method originalClass:(Class)originalClass mockClass:(Class)mockClass global:(BOOL)global;

It’s call with global NO  
\+ (IUTSurikae *)surikaeWithInstanceMethod:(SEL)method originalClass:(Class)originalClass mockClass:(Class)mockClass;

Reset:  
--
It retrieve all exchanged methods which are marked global YES.  
\+[IUTSurikae cleanAll]

How do I choose global YES or NO?
--
Your exchange effects only inside a methods, choose NO.  
It will retrieve when NSAutoreleasePool releases the UITSurikae object.
You don’t need to call +[IUTSurikae cleanAll].

Your exchange effects more long term, choose YES.  
Usually you call it in -setup. Then call +[IUTSurikae cleanAll] in teardown.

Please see a sample project’s CalenderTest and WeatherTest.

LICENCE
=
BSD Licence
