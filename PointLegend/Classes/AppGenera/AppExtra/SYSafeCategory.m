
#import "SYSafeCategory.h"
#import "JRSwizzle.h"
#import <objc/runtime.h>

#define LOG_Error {if(error)NSLog(@"%@",error.debugDescription);error = nil;}

@interface NSString(SYSafeCategory)
-(id)SY_safeSetString:(NSString *)str;
@end

@interface NSArray(SYSafeCategory)
-(id)SY_safeObjectAtIndex:(int)index;
-(id)SY_safeInitWithObjects:(const id [])objects count:(NSUInteger)cnt;
@end
@interface NSMutableArray(SYSafeCategory)
-(void)SY_safeAddObject:(id)anObject;
@end

@interface NSDictionary(SYSafeCategory)
-(id)SY_safeObjectForKey:(id)aKey;
-(id)SY_safeInitWithObjects:(const id [])objects forKeys:(const id <NSCopying> [])keys count:(NSUInteger)cnt;
@end

@interface NSMutableDictionary(SYSafeCategory)
-(void)SY_safeSetObject:(id)anObject forKey:(id<NSCopying>)aKey;
@end

@implementation NSArray(SYSafeCategory)
-(id)SY_safeObjectAtIndex:(int)index{
    if(index>=0 && index < self.count)
    {
        return [self SY_safeObjectAtIndex:index];
    }
    NSLog(@"数组越界：%d",index);
    return nil;
}
-(id)SY_safeInitWithObjects:(const id [])objects count:(NSUInteger)cnt
{
    NSMutableArray *nilObjectArray = [NSMutableArray new];
    BOOL hasNilObject = NO;
    for (int i=0; i<cnt; i++) {
        if(objects[i] == nil)
        {
            [nilObjectArray addObject:@(i)];
            hasNilObject = YES;
        }
    }
    
    if (hasNilObject) {
        NSLog(@"序号：%@ 对应的对象为空",nilObjectArray);
        return nil;
    }
    
    return [self SY_safeInitWithObjects:objects count:cnt];
}
@end

@implementation NSMutableArray(SYSafeCategory)
-(void)SY_safeAddObject:(id)anObject
{
    if(anObject != nil){
        [self SY_safeAddObject:anObject];
    }
}
@end

@implementation NSDictionary(SYSafeCategory)
-(id)SY_safeObjectForKey:(id)aKey
{
    if(aKey == nil)
    {
        NSLog(@"空键取值");
        return nil;
    }
    id value = [self SY_safeObjectForKey:aKey];
    if (value == [NSNull null]) {
        NSLog(@"键:%@对应值为[NSNull null]，自动转换为nil",aKey);
        return nil;
    }
    return value;
}
-(id)SY_safeInitWithObjects:(const id [])objects forKeys:(const id <NSCopying> [])keys count:(NSUInteger)cnt
{
    BOOL hasNilKey = NO;
    BOOL hasNilValue = NO;

    NSMutableArray *ks = [NSMutableArray new];
    for (int i=0; i<cnt; i++) {
        if(objects[i] == nil)
        {
            hasNilValue = YES;
            [ks addObject:keys[i]];
        }
    }
    NSMutableArray *os = [NSMutableArray new];
    for (int i=0; i<cnt; i++) {
        if(keys[i] == nil)
        {
            hasNilKey = YES;
            [os addObject:objects[i]];
        }
    }
    if (hasNilKey) {
        NSLog(@"字典初始化失败！因为value:%@对应空键！",os);
    }
    if (hasNilValue) {
        NSLog(@"字典初始化失败！因为key:%@对应空值！",ks);
    }
    if (hasNilValue || hasNilKey) {
        return nil;
    }
    return [self SY_safeInitWithObjects:objects forKeys:keys count:cnt];
}
@end

@implementation NSMutableDictionary(SYSafeCategory)
-(void)SY_safeSetObject:(id)anObject forKey:(id<NSCopying>)aKey{
    if(anObject == nil || aKey == nil)
    {
        if (anObject==nil&&aKey==nil) {
            NSLog(@"空键空值");
        }
        if (anObject==nil&&aKey!=nil) {
            NSLog(@"键:%@ 对应空值",aKey);
        }
        if (anObject!=nil&&aKey==nil) {
            NSLog(@"值:%@ 对应空键",anObject);
        }
        return;
    }
    
    [self SY_safeSetObject:anObject forKey:aKey];
}
@end

@interface NSURL(SYSafeCategory)
@end;
@implementation NSURL(SYSafeCategory)
+(id)SY_safeFileURLWithPath:(NSString *)path isDirectory:(BOOL)isDir
{
    if(path == nil)
        return nil;
    
    return [self SY_safeFileURLWithPath:path isDirectory:isDir];
}
@end
@interface NSFileManager(SYSafeCategory)

@end
@implementation NSFileManager(SYSafeCategory)
-(NSDirectoryEnumerator *)SY_safeEnumeratorAtURL:(NSURL *)url includingPropertiesForKeys:(NSArray *)keys options:(NSDirectoryEnumerationOptions)mask errorHandler:(BOOL (^)(NSURL *, NSError *))handler
{
    if(url == nil)
        return nil;
    
    return [self SY_safeEnumeratorAtURL:url includingPropertiesForKeys:keys options:mask errorHandler:handler];
}
@end


@implementation SYSafeCategory
+(void)callSafeCategory
{
    NSError* error = nil;
    [objc_getClass("__NSPlaceholderArray") jr_swizzleMethod:@selector(initWithObjects:count:) withMethod:@selector(SY_safeInitWithObjects:count:) error:&error];
    LOG_Error
    
    [objc_getClass("__NSArrayI") jr_swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(SY_safeObjectAtIndex:) error:&error];
    LOG_Error
    
    [objc_getClass("__NSArrayM") jr_swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(SY_safeObjectAtIndex:) error:&error];
    LOG_Error
    [objc_getClass("__NSArrayM") jr_swizzleMethod:@selector(addObject:) withMethod:@selector(SY_safeAddObject:) error:&error];
    LOG_Error
    
    [objc_getClass("__NSDictionaryI") jr_swizzleMethod:@selector(objectForKey:) withMethod:@selector(SY_safeObjectForKey:) error:&error];
    LOG_Error
    [objc_getClass("__NSPlaceholderDictionary") jr_swizzleMethod:@selector(initWithObjects:forKeys:count:) withMethod:@selector(SY_safeInitWithObjects:forKeys:count:) error:&error];
    LOG_Error
    
    [objc_getClass("__NSDictionaryM") jr_swizzleMethod:@selector(objectForKey:) withMethod:@selector(SY_safeObjectForKey:) error:&error];
    LOG_Error
    [objc_getClass("__NSDictionaryM") jr_swizzleMethod:@selector(setObject:forKey:) withMethod:@selector(SY_safeSetObject:forKey:) error:&error];
    LOG_Error
    
    
    [NSURL jr_swizzleClassMethod:@selector(fileURLWithPath:isDirectory:) withClassMethod:@selector(SY_safeFileURLWithPath:isDirectory:) error:&error];
    LOG_Error
    
    [NSFileManager jr_swizzleMethod:@selector(enumeratorAtURL:includingPropertiesForKeys:options:errorHandler:) withMethod:@selector(SY_safeEnumeratorAtURL:includingPropertiesForKeys:options:errorHandler:) error:&error];
    LOG_Error
}
@end

