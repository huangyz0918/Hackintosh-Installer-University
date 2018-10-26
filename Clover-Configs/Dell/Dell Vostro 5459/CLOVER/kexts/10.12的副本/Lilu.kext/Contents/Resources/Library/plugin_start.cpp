//
//  plugin_start.cpp
//  Lilu
//
//  Copyright © 2016-2017 vit9696. All rights reserved.
//

#include <Headers/plugin_start.hpp>
#include <Headers/kern_api.hpp>
#include <Headers/kern_util.hpp>

OSDefineMetaClassAndStructors(PRODUCT_NAME, IOService)

bool PRODUCT_NAME::init(OSDictionary *dict) {
	if (!IOService::init(dict)) {
		SYSLOG("init @ failed to initalise the parent");
		return false;
	}
	
	return true;
}

bool PRODUCT_NAME::start(IOService *provider) {
	if (!IOService::start(provider)) {
		SYSLOG("init @ failed to start the parent");
		return false;
	}
	
	return true;
}

void PRODUCT_NAME::stop(IOService *provider) {
	IOService::stop(provider);
}

bool ADDPR(debugEnabled) = false;

EXPORT extern "C" kern_return_t ADDPR(kern_start)(kmod_info_t *, void *) {
	LiluAPI::Error error = lilu.requestAccess();
	
	if (error != LiluAPI::Error::NoError) {
		SYSLOG("init @ failed to call parent %d", error);
		return KERN_FAILURE;
	}
	
	error = lilu.shouldLoad(ADDPR(config).product, ADDPR(config).disableArg, ADDPR(config).disableArgNum,
							ADDPR(config).debugArg, ADDPR(config).debugArgNum, ADDPR(config).betaArg, ADDPR(config).betaArgNum,
							ADDPR(config).minKernel, ADDPR(config).maxKernel, ADDPR(debugEnabled));
	
	if (error == LiluAPI::Error::NoError) {
		ADDPR(config).pluginStart();
	} else {
		SYSLOG("init @ parent said we should not continue %d", error);
	}
	
	lilu.releaseAccess();
	
	return KERN_SUCCESS;
}

EXPORT extern "C" kern_return_t ADDPR(kern_stop)(kmod_info_t *, void *) {
	// It is not safe to unload Lilu plugins!
	return KERN_FAILURE;
}

