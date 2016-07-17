/*
 * This program demonstrates listing files in a directory under OS X.
 *
 * More specifically, this program creates two arrays that include
 * files, in each respetive directory, that end in ".jpg".
 *
 * This is meant to be an educational program.  Other functions, that
 * are not utilized, are there for educational purposes.  
 *
 * This was compiled against OS X v10.5.
 */

/*
 * Copyright (C) 2016 Ian M. Fink. All rights reserved.
 * Redistribution and use in source and binary forms, with or without 
 * modification, are permitted provided that the following conditions
 * are met:
 * 
 *  1. Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 * 
 *  2. Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in
 *     the documentation and/or other materials provided with the
 *     distribution.
 * 
 *  3. All advertising materials mentioning features or use of this
 *     software must display the following acknowledgement: 
 *        This product includes software developed by Ian M. Fink
 * 
 *  4. Neither Ian M. Fink nor the names of its contributors may be
 *     used to endorse or promote products derived from this software
 *     without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY COPYRIGHT HOLDER "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL IAN M. FINK BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 * GOODS OR SERVICES; LOSS OF USE, * DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
 * IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
 * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <ApplicationServices/ApplicationServices.h>
#import <Foundation/Foundation.h>

/*
 * Protos
 */

NSArray * directory_listing(const char *);
void dir_list(void);
void produce_file_names(const char *dir_name, NSMutableArray *file_names);
void make_mutable_file_list(NSArray * the_file_list, 
	const char * suffix, const char * directory_name, 
	NSMutableArray * the_mutable_file_list);

//*****************************************************************

/*
 * This function produces the file names in a directory.
 */

void
dir_list(void)
{
	NSFileManager *filemgr;
	NSString *currentpath;
	NSArray *filelist;
	int count, i;

	filemgr = [NSFileManager defaultManager];

	filelist = [filemgr contentsOfDirectoryAtPath: @"./foo_dir/" error: nil];

	count = [filelist count];

	for (i = 0; i < count; i++)
		NSLog (@"%@", [filelist objectAtIndex: i]);
	
	return;

} // dir_list

//**************************************************************

/*
 * Input:	a directory name
 *
 * Returns:	an array that includes file names of the directory
 */

NSArray *
directory_listing(const char *directory_path)
{
	NSArray *file_list;
	NSString *dpath;
	NSFileManager *file_manager;

	dpath = [NSString stringWithUTF8String:directory_path];

	file_manager = [NSFileManager defaultManager];

	file_list = [file_manager contentsOfDirectoryAtPath: dpath error: nil];

	return file_list;

} // directory_listing

//*****************************************************************

/* Input:	a directory name
 *			an array of file names of the directory
 *
 * Output:	the array of file names with the directory name prepended
 */

void
produce_file_names(const char *dir_name, NSMutableArray *file_names)
{
	NSString *s1, *s2;
	int count, i;

	count = [file_names count];

	for (i=0; i<count; i++) {
		s1 = [file_names objectAtIndex: i];
		s2 = [NSString stringWithFormat:@"%s%@", dir_name, s1];
		[file_names replaceObjectAtIndex: i withObject: s2];
	}

	return;

} // produce_file_names

//*****************************************************************

void
make_mutable_file_list(NSArray * the_file_list,
	const char * suffix,
	const char * directory_name,
	NSMutableArray * the_mutable_file_list)
{
	NSString * ns_suffix;
	NSString * ns_dir_name;
	BOOL		ending_slash;

	ns_suffix = [NSString stringWithFormat:@"%s", suffix];
	ns_dir_name = [NSString stringWithFormat:@"%s", directory_name];
	ending_slash = [ns_dir_name hasSuffix:@"/"];

	for (NSString *n in the_file_list) {
		if ([n hasSuffix:ns_suffix]) {
			if (ending_slash) {
				[the_mutable_file_list addObject: 
					[NSString stringWithFormat:@"%@%@", 
					ns_dir_name, n]];
			} else {
				[the_mutable_file_list addObject: 
					[NSString stringWithFormat:@"%@/%@", 
					ns_dir_name, n]];

			}
		}
	}
	
	return;

} // make_mutable_file_list

//*****************************************************************

int
main (int argc, const char * argv[])
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSArray * my_dir_list1;
	NSArray * my_dir_list2;
	NSMutableArray * my_jpeg_list1;
	NSMutableArray * my_jpeg_list2;
	NSMutableArray * my_list;
	NSString * file_name;
	NSMutableString * tmp_string;
	NSString * dir_string = @"foo_doo_dir/";
	int count, i;
	CFStringRef  cf_string;
	NSString *  my_ns_string;


	my_ns_string = @"this is a ns string";
	cf_string = (CFStringRef)my_ns_string;

	if (argc < 3) {
		NSLog (@"Usage:  %@ <directory1> <directory2>",
			[NSString stringWithCString:argv[0] 
			encoding:NSASCIIStringEncoding]);
		[pool drain];
		return 1;
	}

	my_dir_list1 = directory_listing(argv[1]);
	my_dir_list1 = directory_listing(argv[2]);

	NSLog (@"Finished getting directory_listing()");

	my_jpeg_list1 = [NSMutableArray array];
	my_jpeg_list2 = [NSMutableArray array];

	make_mutable_file_list(my_dir_list1, ".jpg", argv[1], 
		my_jpeg_list1);
	make_mutable_file_list(my_dir_list1, ".jpg", argv[2], 
		my_jpeg_list2);

	for (NSString *n in my_jpeg_list1) {
		NSLog (@"my_jpeg_list1: %@", n);
	}

	for (NSString *n in my_jpeg_list2) {
		NSLog (@"my_jpeg_list2: %@", n);
	}

	

	NSLog (@"Done....");

	[pool drain];

	return 0;

} // main

 /*
  * End of file:  dirs.m
  */
