#ifndef _VERSION_H_
#define _VERSION_H_

#define CLASSICTK_MAJOR_VERSION	0
#define CLASSICTK_MINOR_VERSION	1
#define CLASSICTK_PATCH_VERSION	0

#define CLASSICTK_RELEASE_FLAG	1	// 1=Develop,0=Stable

#if !defined( strcmpi )
#define strcmpi strcasecmp
#endif

#endif
