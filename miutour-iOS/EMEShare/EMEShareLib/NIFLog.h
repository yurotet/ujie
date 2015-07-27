
/**
 *	 NIFLog
 *	 Add a Preprocessor Macro in Build : DEBUG
 *
 */


//#warning 发行版的时候注释掉


#define XCODE_COLORS_ESCAPE @"\033["
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color
#define DDLogRedColor  @"255,0,0;"
#define DDLogGrayColor @"125,125,125;"
#define DDLogBlackColor @"0,0,0;"
#define DDLogWhitColor @"255,255,255;"
#define DDLogOrangeColor @"255,255,0;"
#define DDLogBlueColor @"131,201,153;"


 #define _NIFLog(info,fmt,bgColor,fgColor, ...) NSLog((XCODE_COLORS_ESCAPE  @"bg" bgColor XCODE_COLORS_ESCAPE @"fg" fgColor info XCODE_COLORS_RESET @"\n%s [Line:%d] \n" fmt @"\n\n"),__PRETTY_FUNCTION__,__LINE__,##__VA_ARGS__)


//
//#if  XcodeColors
//
//
//#define _NIFLog(info,fmt,bgColor,fgColor, ...) NSLog((XCODE_COLORS_ESCAPE  @"bg" bgColor XCODE_COLORS_ESCAPE @"fg" fgColor info XCODE_COLORS_RESET @"\n%s [Line:%d] \n" fmt @"\n\n"),__PRETTY_FUNCTION__,__LINE__,##__VA_ARGS__)
//
//#else
//    #define _NIFLog(info,fmt,bgColor,fgColor, ...) NSLog(( info  @"\n%s [Line:%d] \n" fmt @"\n\n"),__PRETTY_FUNCTION__,__LINE__,##__VA_ARGS__)
//#endif



#ifdef DEBUG


#define NIF_INFO(fmt, ...)     _NIFLog(@"=========== INFO ===========",fmt,DDLogWhitColor,DDLogGrayColor,##__VA_ARGS__)
#define NIF_WARN(fmt, ...)     _NIFLog(@"!!========= WARN =========!!",fmt,DDLogOrangeColor,DDLogBlackColor,##__VA_ARGS__)
#define NIF_ERROR(fmt, ...)    _NIFLog(@"!!!======== ERROR =========!!!",fmt,DDLogRedColor,DDLogBlackColor,##__VA_ARGS__)
#define NIF_DEBUG(fmt, ...)    _NIFLog(@"!========== DEBUG ==========!",fmt,DDLogGrayColor,DDLogWhitColor,##__VA_ARGS__)

#else

#define NIF_INFO(fmt, ...)  ((void)0)
#define NIF_WARN(fmt, ...) ((void)0)
#define NIF_ERROR(fmt, ...) ((void)0)
#define NIF_DEBUG(fmt, ...) ((void)0)

#endif

