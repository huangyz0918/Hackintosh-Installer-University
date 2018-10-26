//
//  kern_start.hpp
//  AppleALC
//
//  Copyright © 2016 vit9696. All rights reserved.
//

#ifndef kern_start_hpp
#define kern_start_hpp

#include <Headers/kern_util.hpp>

#include <Library/LegacyIOService.h>
#include <sys/types.h>

struct PluginConfiguration {
	const char *product;		// Product name (e.g. xStringify(PRODUCT_NAME))
	const char **disableArg;	// Pointer to disabling boot arguments array
	size_t disableArgNum;		// Number of disabling boot arguments
	const char **debugArg;		// Pointer to debug boot arguments array
	size_t debugArgNum;			// Number of debug boot arguments
	const char **betaArg;		// Pointer to beta boot arguments array
	size_t betaArgNum;			// Number of beta boot arguments
	KernelVersion minKernel;	// Minimal required kernel version
	KernelVersion maxKernel;	// Maximum supported kernel version
	void (*pluginStart)();		// Main function
};

extern PluginConfiguration xConcat(PRODUCT_NAME, _config);

class EXPORT PRODUCT_NAME : public IOService {
	OSDeclareDefaultStructors(PRODUCT_NAME)
public:
	bool init(OSDictionary *dict) override;
	bool start(IOService *provider) override;
	void stop(IOService *provider) override;
};

#endif /* kern_start_hpp */
