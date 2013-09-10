//
//  PCFWebModel.mƒƒ
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 10/31/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFWebModel.h"
#import "PCFObject.h"
#import "PCFClassModel.h"
#import "PCFCourseRecord.h"
#import "PCFAppDelegate.h"

@implementation PCFWebModel

extern BOOL internetActive;
extern NSString *finalTermValue;
@synthesize listOfClasses;

+(NSString *)queryServer:(NSString *)address connectionType:(NSString *)type referer:(NSString *)referer arguements:(NSString *)args 
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:address] cachePolicy:NSURLCacheStorageAllowed timeoutInterval:7];
    if (type) [request setHTTPMethod:type];
    if (referer) [request setValue:referer forHTTPHeaderField:@"Referer"];
    if (args) {
        NSData *requestBody = [args dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:requestBody];
    }
    NSError *error = nil;
    NSData *webData = nil;
    int counter = 0;
    while (!webData) {
        if (counter == 3) return nil;
        webData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        if ([error code] == -1001) {
            NSLog(@"Retrying\n");
        }else if ([error code] == -1009) {
            internetActive = NO;
            return @"No internet connection";
        }else if (error){
            NSLog(@"%@\n", [error description]);
            return nil;
        }
        counter++;
    }
    return [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
}

+(NSArray *)parseData:(NSString *)data type:(int)type
{
    //type 0
    if (type == 0) {
    static NSString *const kLookFor = @"<OPTION VALUE=";
    NSScanner *scanner = [NSScanner scannerWithString:data];
    NSScanner *tempScanner;
    NSMutableString *termVal = [NSMutableString string];
    NSMutableString *termDes = [NSMutableString string];
    NSMutableArray *semester = [NSMutableArray arrayWithCapacity:3];
    @try {
        while (![scanner isAtEnd]) {
            [scanner scanUpToString:kLookFor intoString:nil];
            //encountered <OPTION VALUE="
            [scanner setScanLocation:([scanner scanLocation] + 15)];
            [scanner scanUpToString:@"\"" intoString:&termVal];
            if ([termVal isEqual:@""]) continue;
            //NSLog(@"Term value is %@\n", termVal);
            [scanner setScanLocation:([scanner scanLocation] + 2)];
            [scanner scanUpToString:@"<" intoString:&termDes];
            tempScanner = [NSScanner scannerWithString:termDes];
            [tempScanner scanUpToString:@"(" intoString:&termDes];
            //NSLog(@"Term des is %@\n", termDes);
            [semester addObject:[[PCFObject alloc] initWithData:termDes value:termVal]];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"Error: %@\n", [exception description]);
    }
    @finally {
        //NSLog(@"%@", [termDict descriptionInStringsFileFormat]);
        scanner = nil;
        tempScanner = nil;
        termVal = nil;
        termDes = nil;
        return [semester copy];
    }
    }else if (type == 1) {
        static NSString *const kLookFor = @"<OPTION VALUE=";
        static NSString *const kInitialHeader = @"<SELECT NAME=\"sel_subj\" SIZE=\"10\" MULTIPLE ID=\"subj_id\">";
        NSScanner *scanner = [NSScanner scannerWithString:data];
        NSMutableString *classVal = [NSMutableString string];
        NSMutableString *classDes = [NSMutableString string];
        NSMutableArray *subjectArray = [NSMutableArray arrayWithCapacity:20];
        PCFObject *subject;
            [scanner scanUpToString:kInitialHeader intoString:nil];
            while (![scanner isAtEnd]) {
                [scanner scanUpToString:kLookFor intoString:nil];
                //encountered <OPTION VALUE="
                [scanner setScanLocation:([scanner scanLocation] + 15)];
                //scan to end of "
                [scanner scanUpToString:@"\"" intoString:&classVal];
                if ([classVal isEqual:@""]) continue;
                //NSLog(@"Term value is %@\n", termVal);
                [scanner setScanLocation:([scanner scanLocation] + 2)];
                [scanner scanUpToString:@"-" intoString:nil];
                [scanner setScanLocation:([scanner scanLocation] + 1)];
                [scanner scanUpToString:@"<" intoString:&classDes];
                //NSLog(@"Term des is %@\n", termDes);
                subject = [[PCFObject alloc] initWithData:classDes value:classVal];
                [subjectArray addObject:subject];
                if ([@"YDAE" isEqualToString:classVal]) break;
                if ([@"STAR" isEqualToString:classVal]) break;
            }
        static NSString *const kLookForProf = @"<SELECT NAME=\"sel_instr\" SIZE=\"3\" MULTIPLE ID=\"instr_id\">";
        scanner = [[NSScanner alloc] initWithString:data];
        NSString *professor;
        NSString *val;
        NSMutableArray *prof = [[NSMutableArray alloc] initWithCapacity:40];
        @try {
            [scanner scanUpToString:kLookForProf intoString:nil];
            [scanner scanUpToString:@"<OPTION VALUE=\"%\" SELECTED>All" intoString:nil];
            //[scanner setScanLocation:([scanner scanLocation] + 30)];
            while (![scanner isAtEnd]) {
                [scanner scanUpToString:@"<OPTION VALUE=\"" intoString:nil];
                [scanner setScanLocation:([scanner scanLocation] + 15)];
                [scanner scanUpToString:@"\"" intoString:&val];
                if ([val isEqualToString:@"%"]) continue;
                [scanner setScanLocation:([scanner scanLocation] + 2)];
                [scanner scanUpToString:@"<" intoString:&professor];
                professor = [professor stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                if ([professor isEqualToString:@"Day"]) break;
                PCFObject *obj = [[PCFObject alloc] initWithData:professor value:val];
                [prof addObject:obj];
            }
        }
        @catch (NSException *) {
            
        }
        @finally {
            NSArray *combinedArray = [[NSArray alloc] initWithObjects:[subjectArray copy], [prof copy], nil];
            scanner = nil;
            professor = nil;
            classDes = nil;
            classVal = nil;
            return combinedArray;
        }        
    }else if(type == 2) {
        static NSString *const kLookFor = @"<TH CLASS=\"ddlabel\" scope=\"row\" ><A HREF=\"";
        NSScanner *scanner = [NSScanner scannerWithString:data];
        NSMutableArray *classes = [[NSMutableArray alloc] initWithCapacity:30];
        NSString *tempString, *classLink, *catalogLink, *tempCatalogLink, *classTitle, *CRN, *courseName, *sectionNum, *numCredits, *classType, *classTime, *classDays, *classLocation, *classDateRange, *scheduleType, *instructor, *instructorEmail;
        NSScanner *tempScanner;
        @try {
            while (![scanner isAtEnd]) {
                tempString = nil, classLink = nil, catalogLink = nil, tempCatalogLink = nil, classTitle = nil, CRN = nil, courseName = nil,sectionNum = nil, numCredits = nil, classType = nil, classTime = nil, classDays = nil, classLocation = nil, classDateRange = nil, scheduleType = nil, instructor = nil, instructorEmail = nil;
                NSScanner *tempScanner;
                //encountered TH CLASS=\"ddlabel\" scope=\"row\" ><A HREF=\" - Link to Class
                [scanner scanUpToString:kLookFor intoString:nil];
                [scanner setScanLocation:([scanner scanLocation] + 42)];
                [scanner scanUpToString:@"\"" intoString:&classLink];
                classLink = [@"https://selfservice.mypurdue.purdue.edu" stringByAppendingString:classLink];
                //got link now move up two spaces
                classLink = [classLink stringByReplacingOccurrencesOfString:@"amp;" withString:@""];
                [scanner setScanLocation:([scanner scanLocation] + 2)];
                [scanner scanUpToString:@"<" intoString:&tempString];
                //use temp string for scanner
                tempScanner = [NSScanner scannerWithString:tempString];
                [tempScanner scanUpToString:@" -" intoString:&classTitle];
                [tempScanner setScanLocation:([tempScanner scanLocation] + 3)];
                [tempScanner scanUpToString:@"-" intoString:&CRN];
                CRN = [CRN stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                [tempScanner setScanLocation:([tempScanner scanLocation] + 2)];
                [tempScanner scanUpToString:@"-" intoString:&courseName];
                courseName = [courseName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                courseName = [courseName substringToIndex:([courseName length] - 2)];
                [tempScanner setScanLocation:([tempScanner scanLocation] + 2)];
                [tempScanner scanUpToString:@"<" intoString:&sectionNum];
                //done with substring extraction
                //back to scaning
                [scanner scanUpToString:@"Type" intoString:nil];
                [scanner scanUpToString:@">" intoString:nil];
                [scanner setScanLocation:([scanner scanLocation] + 1)];
                [scanner scanUpToString:@"<" intoString:&numCredits];
                NSString *tempStr = numCredits;
                numCredits = [tempStr substringToIndex:4];
                //numCredits = [numCredits stringByAppendingString:@" "];
                //numCredits = [numCredits stringByAppendingString:[tempStr substringFromIndex:6]];
                //get catalog link
                [scanner scanUpToString:@"<A HREF=\"" intoString:nil];
                [scanner setScanLocation:([scanner scanLocation] + 9)];
                [scanner scanUpToString:@"\"" intoString:&tempCatalogLink];
                catalogLink = [@"https://selfservice.mypurdue.purdue.edu" stringByAppendingString:tempCatalogLink];
                catalogLink = [catalogLink stringByReplacingOccurrencesOfString:@"amp;" withString:@""];
                [scanner scanUpToString:@"<TD CLASS=\"ddd" intoString:nil];
                [scanner setScanLocation:([scanner scanLocation] + 22)];
                [scanner scanUpToString:@"<" intoString:&classType];
                [scanner scanUpToString:@"<TD CLASS=\"ddd" intoString:nil];
                [scanner setScanLocation:([scanner scanLocation] + 22)];
                [scanner scanUpToString:@"<" intoString:&classTime];
                if ([classTime isEqualToString:@""] || !classTime) classTime = @"TBA";
                [scanner scanUpToString:@"<TD CLASS=\"ddd" intoString:nil];
                [scanner setScanLocation:([scanner scanLocation] + 22)];
                [scanner scanUpToString:@"<" intoString:&classDays];
                if ([classDays isEqualToString:@"&nbsp;"]) classDays = @"TBA";
                [scanner scanUpToString:@"<TD CLASS=\"ddd" intoString:nil];
                [scanner setScanLocation:([scanner scanLocation] + 22)];
                [scanner scanUpToString:@"<" intoString:&classLocation];
                if ([classLocation isEqualToString:@""] || !classLocation) classLocation = @"TBA";
                [scanner scanUpToString:@"<TD CLASS=\"ddd" intoString:nil];
                [scanner setScanLocation:([scanner scanLocation] + 22)];
                [scanner scanUpToString:@"<" intoString:&classDateRange];
                [scanner scanUpToString:@"<TD CLASS=\"ddd" intoString:nil];
                [scanner setScanLocation:([scanner scanLocation] + 22)];
                [scanner scanUpToString:@"<" intoString:&scheduleType];
                [scanner scanUpToString:@"<TD CLASS=\"ddd" intoString:nil];
                [scanner setScanLocation:([scanner scanLocation] + 22)];
                instructor = nil;
                [scanner scanUpToString:@"<ABBR" intoString:&instructor];
                if (instructor == nil) {
                    instructor = @"TBA";
                }else {
                    if ([instructor characterAtIndex:([instructor length]-1)] == '(') instructor = [instructor substringToIndex:([instructor length] -1)];
                }
                instructor = [instructor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if (![instructor isEqualToString:@"TBA"]) {
                    [scanner scanUpToString:@"mailto" intoString:nil];
                    [scanner setScanLocation:([scanner scanLocation] + 7)];
                    [scanner scanUpToString:@"\"" intoString:&instructorEmail];
                }else {
                    instructorEmail = nil;
                }
                
                [classes addObject:[[PCFClassModel alloc] initWithData:classTitle :CRN :courseName :classTime :classDays :classDateRange :scheduleType :instructor :numCredits :classLink :catalogLink :sectionNum :classLocation :instructorEmail]];
            }
            
        }
        @catch (NSException *exception) {
            NSLog(@"Error: %@\n", [exception description]);
        }
        @finally {
            //NSLog(@"%@", [termDict descriptionInStringsFileFormat]);
            scanner = nil;
            tempScanner = nil;
            tempString = nil;
            classLink = nil;
            catalogLink = nil;
            tempCatalogLink = nil;
            classTitle = nil;
            CRN = nil;
            courseName = nil;
            sectionNum = nil;
            numCredits = nil;
            classType = nil;
            classTime = nil;
            classDays = nil;
            classLocation = nil;
            classDateRange = nil;
            scheduleType = nil;
            instructor = nil;
            instructorEmail = nil;
            return [classes copy];
        }

    }else if (type == 3) {
        static NSString *const kLookFor = @"<TH CLASS=\"ddlabel\" scope=\"row\" ><SPAN class=\"fieldlabeltext\">Seats</SPAN></TH>";
        NSScanner *scanner = [NSScanner scannerWithString:data];
        NSString *courseCapacity, *courseAvailability, *courseActual;
        @try {
            [scanner scanUpToString:kLookFor intoString:nil];
            [scanner scanUpToString:@"<TD CLASS=\"dddefault\">" intoString:nil];
            [scanner setScanLocation:([scanner scanLocation] + 22)];
            [scanner scanUpToString:@"<" intoString:&courseCapacity];
            [scanner scanUpToString:@"<TD CLASS=\"dddefault\">" intoString:nil];
            [scanner setScanLocation:([scanner scanLocation] + 22)];
            [scanner scanUpToString:@"<" intoString:&courseActual];
            
            [scanner scanUpToString:@"<TD CLASS=\"dddefault\">" intoString:nil];
            [scanner setScanLocation:([scanner scanLocation] + 22)];
            [scanner scanUpToString:@"<" intoString:&courseAvailability];
            PCFCourseRecord *rec = [[PCFCourseRecord alloc] initWithData:courseCapacity value:courseAvailability rem:courseActual];
            NSArray *arr = [NSArray arrayWithObject:rec];
            return arr;
        }
        @catch (NSException *exception) {
            NSLog(@"Error: %@\n", [exception description]);
        }
        @finally {
            //NSLog(@"%@", [termDict descriptionInStringsFileFormat]);
            scanner = nil;
            courseActual = nil;
            courseAvailability = nil;
            courseCapacity = nil;
        }

    }else if(type == 4) {
        static NSString *const kLookFor = @"<TD CLASS=\"ntdefault\">";
        NSString *desc;
        NSScanner *scanner = [NSScanner scannerWithString:data];
        NSString *courseCatalogDescription;
        @try {
            [scanner scanUpToString:kLookFor intoString:nil];
            [scanner scanUpToString:@"." intoString:nil];
            [scanner setScanLocation:([scanner scanLocation] + 1)];
            [scanner scanUpToString:@"." intoString:nil];
            [scanner setScanLocation:([scanner scanLocation] + 1)];
            [scanner scanUpToString:@"<" intoString:&courseCatalogDescription];
            desc = courseCatalogDescription;
        }
        @catch (NSException *exception) {
            NSLog(@"Error: %@\n", [exception description]);
        }
        @finally {
            //NSLog(@"%@", [termDict descriptionInStringsFileFormat]);
            scanner = nil;
            return (NSArray *)desc;
        }

    }else if(type == 5) {
        static NSString *const kLookFor = @"<TH CLASS=\"ddlabel\" scope=\"row\" >";
        NSScanner *scanner = [[NSScanner alloc] initWithString:data];
        @try {
            
            [scanner scanUpToString:kLookFor intoString:nil];
            [scanner setScanLocation:([scanner scanLocation] + 33)];
            NSString *tempString, *courseName, *courseCRN, *coursePrefix, *courseSuffix;
            [scanner scanUpToString:@"<" intoString:&tempString];
            NSScanner *tempScanner = [[NSScanner alloc] initWithString:tempString];
            [tempScanner scanUpToString:@"-" intoString:&courseName];
            [tempScanner setScanLocation:([tempScanner scanLocation] + 1)];
            courseName = [courseName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            [tempScanner scanUpToString:@"-" intoString:&courseCRN];
            [tempScanner setScanLocation:([tempScanner scanLocation] + 2)];
            courseCRN = [courseCRN stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            [tempScanner scanUpToString:@" " intoString:&coursePrefix];
            [tempScanner setScanLocation:([tempScanner scanLocation] + 1)];
            [tempScanner scanUpToString:@"-" intoString:&courseSuffix];
            courseSuffix = [courseSuffix stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            courseSuffix = [courseSuffix substringToIndex:([courseSuffix length]-2)];
            NSString *queryString;
            if ([courseName length] > 25) {
                queryString = [NSString stringWithFormat:@"term_in=%@&sel_subj=dummy&sel_day=dummy&sel_schd=dummy&sel_insm=dummy&sel_camp=dummy&sel_levl=dummy&sel_sess=dummy&sel_instr=dummy&sel_ptrm=dummy&sel_attr=dummy&sel_subj=%@&sel_crse=%@&sel_title=&sel_schd=%%25&sel_from_cred=&sel_to_cred=&sel_camp=%%25&sel_ptrm=%%25&sel_instr=&sel_sess=%%25&sel_attr=%%25&begin_hh=0&begin_mi=0&begin_ap=a&end_hh=0&end_mi=0&end_ap=a", finalTermValue, coursePrefix, courseSuffix];
            }else {
                courseName = [courseName stringByReplacingOccurrencesOfString:@" " withString:@"+"];
                queryString = [NSString stringWithFormat:@"term_in=%@&sel_subj=dummy&sel_day=dummy&sel_schd=dummy&sel_insm=dummy&sel_camp=dummy&sel_levl=dummy&sel_sess=dummy&sel_instr=dummy&sel_ptrm=dummy&sel_attr=dummy&sel_subj=%@&sel_crse=%@&sel_title=%@&sel_schd=%%25&sel_from_cred=&sel_to_cred=&sel_camp=%%25&sel_ptrm=%%25&sel_instr=&sel_sess=%%25&sel_attr=%%25&begin_hh=0&begin_mi=0&begin_ap=a&end_hh=0&end_mi=0&end_ap=a", finalTermValue, coursePrefix, courseSuffix, courseName];
            }
            
                        return (NSArray *)queryString;

        }@catch(NSException *) {
            
        }@finally {
            scanner = nil;
        }
        return nil;
    }else if (type==6) {
        //class review
        static NSString *const kLookFor = @"<TH CLASS=\"ddlabel\" scope=\"row\" ><A HREF=\"";
        NSScanner *scanner = [NSScanner scannerWithString:data];
        NSMutableArray *classes = [[NSMutableArray alloc] initWithCapacity:3];
        NSString *tempString, *classLink, *catalogLink, *tempCatalogLink, *classTitle, *CRN, *courseName, *sectionNum, *numCredits, *classType, *classTime, *classDays, *classLocation, *classDateRange, *scheduleType, *instructor, *instructorEmail;
        NSScanner *tempScanner;
        @try {
            while (![scanner isAtEnd]) {
                tempString = nil, classLink = nil, catalogLink = nil, tempCatalogLink = nil, classTitle = nil, CRN = nil, courseName = nil,sectionNum = nil, numCredits = nil, classType = nil, classTime = nil, classDays = nil, classLocation = nil, classDateRange = nil, scheduleType = nil, instructor = nil, instructorEmail = nil;
                NSScanner *tempScanner;
                //encountered TH CLASS=\"ddlabel\" scope=\"row\" ><A HREF=\" - Link to Class
                [scanner scanUpToString:kLookFor intoString:nil];
                [scanner setScanLocation:([scanner scanLocation] + 42)];
                [scanner scanUpToString:@"\"" intoString:&classLink];
                classLink = [@"https://selfservice.mypurdue.purdue.edu" stringByAppendingString:classLink];
                //got link now move up two spaces
                classLink = [classLink stringByReplacingOccurrencesOfString:@"amp;" withString:@""];
                [scanner setScanLocation:([scanner scanLocation] + 2)];
                [scanner scanUpToString:@"<" intoString:&tempString];
                //use temp string for scanner
                tempScanner = [NSScanner scannerWithString:tempString];
                [tempScanner scanUpToString:@" -" intoString:&classTitle];
                [tempScanner setScanLocation:([tempScanner scanLocation] + 3)];
                [tempScanner scanUpToString:@"-" intoString:&CRN];
                CRN = [CRN stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                [tempScanner setScanLocation:([tempScanner scanLocation] + 2)];
                [tempScanner scanUpToString:@"-" intoString:&courseName];
                courseName = [courseName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                courseName = [courseName substringToIndex:([courseName length] - 2)];
                PCFObject *class = [[PCFObject alloc] initWithData:courseName value:classTitle];
                BOOL dupe = NO;
                for (PCFObject *course in classes) {
                    if ([course.value isEqualToString:classTitle]) {
                        dupe = YES;
                        break;
                    }
                }
                if (!dupe) [classes addObject:class];
            }
            
        }
        @catch (NSException *exception) {
            NSLog(@"Error: %@\n", [exception description]);
        }
        @finally {
            //NSLog(@"%@", [termDict descriptionInStringsFileFormat]);
            scanner = nil;
            tempScanner = nil;
            tempString = nil;
            classLink = nil;
            catalogLink = nil;
            tempCatalogLink = nil;
            classTitle = nil;
            CRN = nil;
            courseName = nil;
            return [classes copy];
        }
    }
}

@end

