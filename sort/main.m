//
//  main.m
//  sort
//
//  Created by 吴孜健 on 2019/5/20.
//  Copyright © 2019 wuzijian. All rights reserved.
//

#import <Foundation/Foundation.h>

void bubbleSort(NSMutableArray *array) {
    for (NSInteger i = 0; i < array.count; i++) {
        BOOL isChange = NO;
        for (NSInteger j = 0; j < array.count-i-1; j++) {
            if ([array[j] integerValue]< [array[j+1] integerValue]) {
                NSNumber *tmp = array[j];
                array[j] = array[j+1];
                array[j+1] = tmp;
                isChange = YES;
            }
        }
        if (!isChange) {
            //如果未发生数据交换，则认为数据已有序
            break;
        }
        
    }
    NSLog(@"array : %@",array);
    
}


void insertSort(NSMutableArray *array) {
    for (NSInteger i = 1; i < array.count; i++) {
        NSInteger pre = i-1;
        NSNumber *current = array[i];//获取当前的数值
        while (pre >= 0 && [current integerValue] < [array[pre] integerValue]) {
            array[pre+1] = array[pre];
            pre -= 1;
            NSLog(@"while array : %@",array);
        }
        
        array[pre+1] = current;
        NSLog(@"for array : %@",array);
    }
    NSLog(@"array : %@",array);
    
}

void shellSort(NSMutableArray *array) {
    // len = 9
    int len = (int)array.count;
    // floor 向下取整，所以 gap的值为：4，2，1
    for (int gap = floor(len / 2); gap > 0; gap = floor(gap/2)) {
        // i=4;i<9;i++ (4,5,6,7,8)
        for (int i = gap; i < len; i++) {
            // j=0,1,2,3,4
            // [0]-[4] [1]-[5] [2]-[6] [3]-[7] [4]-[8]
            for (int j = i - gap; j >= 0 && [array[j] integerValue] > [array[j+gap] integerValue]; j-=gap) {
                // 交换位置
                NSNumber *temp = array[j];
                array[j] = array[gap+j];
                array[gap+j] = temp;
            }
        }
    }
    NSLog(@"array : %@",array);
}

void quickSort(NSMutableArray *array, NSInteger leftIndex,NSInteger rightIndex){
    NSInteger i =  leftIndex; NSInteger j = rightIndex;
    NSNumber *pivot = array[(leftIndex+rightIndex)/2];
    while (i <= j) {
        while ([array[i] integerValue] < [pivot integerValue]) {
            i++;
        }
        while ([array[j] integerValue] > [pivot integerValue]) {
            j--;
        }
        
        if (i <= j) {
            if (i != j) {
                NSNumber *tmp = array[i];
                array[i] = array[j];
                array[j] = tmp;
            }
            i++;
            j--;
        }
    }
    if (leftIndex < j) {
        quickSort(array, leftIndex, j);
    }
    if (i < rightIndex) {
        quickSort(array, i, rightIndex);
    }
    
    NSLog(@"array : %@",array);
    
}

NSMutableArray* mergeSort(NSMutableArray *array) {
   
    if (array.count <= 1) {
        return array;
    }
    NSInteger middle = array.count/2;
    NSMutableArray *leftArray = mergeSort([array subarrayWithRange:NSMakeRange(0, middle)].mutableCopy);
    NSMutableArray *rightArray = mergeSort([array subarrayWithRange:NSMakeRange(middle, array.count-middle)].mutableCopy);
    NSInteger lIndex = 0;
    NSInteger rIndex = 0;
    NSMutableArray *sortArray = @[].mutableCopy;
    while (lIndex < leftArray.count && rIndex < rightArray.count) {
        if ([leftArray[lIndex] integerValue] < [rightArray[rIndex] integerValue]) {
            [sortArray addObject:leftArray[lIndex]];
            lIndex++;
        } else {
            [sortArray addObject:rightArray[rIndex]];
            rIndex++;
        }
    }
    
    if (lIndex < leftArray.count) {
        [sortArray addObjectsFromArray:[leftArray subarrayWithRange:NSMakeRange(lIndex, leftArray.count-lIndex)]];
    }
    if (rIndex < rightArray.count) {
        [sortArray addObjectsFromArray:[rightArray subarrayWithRange:NSMakeRange(rIndex, rightArray.count-rIndex)]];
    }
    NSLog(@"%@",sortArray);
    return sortArray;
}



void countingSort(NSArray *datas) {
    // 1.找出数组中最大数和最小数
    NSNumber *max = [datas firstObject];
    NSNumber *min = [datas firstObject];
    for (int i = 0; i < datas.count; i++) {
        NSNumber *item = datas[i];
        if ([item integerValue] > [max integerValue]) {
            max = item;
        }
        if ([item integerValue] < [min integerValue]) {
            min = item;
        }
    }
    // 2.创建一个数组 countArr 来保存 datas 中元素出现的个数
    NSInteger sub = [max integerValue] - [min integerValue] + 1;
    NSMutableArray *countArr = [NSMutableArray arrayWithCapacity:sub];
    for (int i = 0; i < sub; i++) {
        [countArr addObject:@(0)];
    }
    // 3.把 datas 转换成 countArr，使用 datas[i] 与 countArr 的下标对应起来
    for (int i = 0; i < datas.count; i++) {
        NSNumber *aData = datas[i];
        NSInteger index = [aData integerValue] - [min integerValue];
        countArr[index] = @([countArr[index] integerValue] + 1);
    }
    // 4.从countArr中输出结果
    NSMutableArray *resultArr = [NSMutableArray arrayWithCapacity:datas.count];
    for (int i = 0; i < countArr.count; i++) {
        NSInteger count = [countArr[i] integerValue];
        while (count > 0) {
            [resultArr addObject:@(i + [min integerValue])];
            count -= 1;
        }
    }
    NSLog(@"%@",resultArr);
}


void bucketSort(NSMutableArray *array) {
    NSInteger max = [[array valueForKeyPath:@"@max.integerValue"] integerValue];
    NSInteger min = [[array valueForKeyPath:@"@min.integerValue"] integerValue];
    
    NSInteger bucketCounts = 3;
    NSMutableArray *buckets = @[].mutableCopy;
    for (NSInteger i = 0; i < bucketCounts; i++) {
        [buckets addObject:@[].mutableCopy];
    }
    
    float space = (max-min+1)/3.f;
    for (NSInteger i = 0; i < array.count; i++) {
        NSInteger index = floor(([array[i] integerValue]-min)/space);
        NSMutableArray *bucket = buckets[index];
        NSInteger minIndex = 0;
        for (NSInteger j = 0; j < bucket.count; j++) {
            if ([array[i] integerValue] > [bucket[j] integerValue]) {
                minIndex++;
            }
        }
        [bucket insertObject:array[i] atIndex:minIndex];
    }
    NSMutableArray *sortArray = @[].mutableCopy;
    for (NSMutableArray *buc in buckets) {
        [sortArray addObjectsFromArray:buc];
    }
    NSLog(@"sortArray: %@",sortArray);
}

void radixSort(NSMutableArray *array) {
    
    NSMutableArray *tmpArray;
    NSInteger maxValue = 0;
    NSInteger maxDigit = 0;
    NSInteger level = 0;
    do {
        NSMutableArray *buckets = [NSMutableArray array];
        for (NSInteger i = 0; i < 10; i++) {
            [buckets addObject:@[].mutableCopy];
        }
        for (NSInteger i = 0; i < array.count; i++) {
            NSInteger value = [array[i] integerValue];
            NSInteger ex = (level < 1 ? 1 : (pow(10, level)));
            NSInteger mod = value / ex % 10;
            [buckets[mod] addObject:array[i]];
            
            if (maxDigit == 0) {
                if (value > maxValue) {
                    maxValue = value;
                }
            }
        }
        
        tmpArray = @[].mutableCopy;
        for (NSInteger i = 0; i < 10; i++) {
            NSMutableArray *abucket = buckets[i];
            [tmpArray addObjectsFromArray:abucket];
        }
        
        if (maxDigit == 0) {
            while (maxValue > 0) {
                maxValue = maxValue /10;
                maxDigit++;
            }
        }
        
        array = tmpArray;
        level += 1;
    } while (level < maxDigit);
    
    NSLog(@"radix: %@",tmpArray);
}

void selectSort(NSMutableArray *array) {
    for (NSInteger i = 0; i < array.count; i++) {
        NSInteger minIndex = i;
        for (NSInteger j = i; j < array.count; j++) {
            if ([array[j] integerValue] < [array[minIndex] integerValue]) {
                minIndex = j;
            }
         
        }
        NSNumber *tmp = array[i];
        array[i] = array[minIndex];
        array[minIndex] = tmp;
    }
    NSLog(@"selec: %@",array);
}


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSMutableArray *array =@[@22,@8,@34,@46,@12,@53,@45,@27].mutableCopy;
//        bubbleSort(array);
        insertSort(array);
//        shellSort(array);
//        quickSort(array, 0, array.count-1);
//            mergeSort(array);
//        countingSort(array);
//        bucketSort(array);
//        radixSort(array);
//        selectSort(array);
      
     
    }
    
    return 0;
}


