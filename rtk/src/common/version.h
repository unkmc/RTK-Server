#ifndef _VERSION_H_
#define _VERSION_H_

#define RETROTK_MAJOR_VERSION	0
#define RETROTK_MINOR_VERSION	1
#define RETROTK_PATCH_VERSION	0

#define RETROTK_RELEASE_FLAG	1	// 1=Develop,0=Stable

#if !defined( strcmpi )
#define strcmpi strcasecmp
#endif

#endif
