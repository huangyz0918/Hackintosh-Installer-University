//
//  plugin_start.cpp
//  Lilu
//
//  Copyright © 2016-2017 vit9696. All rights reserved.
//

#include <Headers/plugin_start.hpp>
#include <Headers/kern_api.hpp>
#include <Headers/kern_util.hpp>

#ifndef LILU_CUSTOM_KMOD_INIT
bool ADDPR(startSuccess) = false;
#else
// Workaround custom kmod code and enable by default
bool ADDPR(startSuccess) = true;
#endif

bool ADDPR(debugEnabled) = false;

#ifndef LILU_CUSTOM_IOKIT_INIT

OSDefineMetaClassAndStructors(PRODUCT_NAME, IOService)

IOService *PRODUCT_NAME::probe(IOService *provider, SInt32 *score) {
	auto service = IOService::probe(provider, score);
	return ADDPR(startSuccess) ? service : nullptr;
}

bool PRODUCT_NAME::start(IOService *provider) {
	if (!IOService::start(provider)) {
		SYSLOG("init", "failed to start the parent");
		return false;
	}
	
	return ADDPR(startSuccess);
}

void PRODUCT_NAME::stop(IOService *provider) {
	IOService::stop(provider);
}

#endif /* LILU_CUSTOM_IOKIT_INIT */

#ifndef LILU_CUSTOM_KMOD_INIT

EXPORT extern "C" kern_return_t ADDPR(kern_start)(kmod_info_t *, void *) {
	LiluAPI::Error error = lilu.requestAccess();
	if (error == LiluAPI::Error::NoError) {
		error = lilu.shouldLoad(ADDPR(config).product, ADDPR(config).version, ADDPR(config).runmode, ADDPR(config).disableArg, ADDPR(config).disableArgNum,
								ADDPR(config).debugArg, ADDPR(config).debugArgNum, ADDPR(config).betaArg, ADDPR(config).betaArgNum, ADDPR(config).minKernel,
								ADDPR(config).maxKernel, ADDPR(debugEnabled));
		
		if (error == LiluAPI::Error::NoError) {
			ADDPR(startSuccess) = true;
			ADDPR(config).pluginStart();
		} else {
			SYSLOG("init", "parent said we should not continue %d", error);
		}
		
		lilu.releaseAccess();
	} else {
		SYSLOG("init", "failed to call parent %d", error);
	}

	// Report success but actually do not start and let I/O Kit unload us.
	// This works better and increases boot speed in some cases.
	return KERN_SUCCESS;
}

EXPORT extern "C" kern_return_t ADDPR(kern_stop)(kmod_info_t *, void *) {
	// It is not safe to unload Lilu plugins unless they were disabled!
	return ADDPR(startSuccess) ? KERN_FAILURE : KERN_SUCCESS;
}

#endif /* LILU_CUSTOM_KMOD_INIT */
