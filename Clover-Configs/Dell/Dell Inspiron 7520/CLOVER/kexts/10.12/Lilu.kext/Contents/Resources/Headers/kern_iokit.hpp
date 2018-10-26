//
//  kern_iokit.hpp
//  Lilu
//
//  Copyright © 2016-2017 vit9696. All rights reserved.
//

#ifndef kern_iokit_hpp
#define kern_iokit_hpp

#include <Headers/kern_config.hpp>
#include <Headers/kern_util.hpp>
#include <Headers/kern_patcher.hpp>

#include <libkern/c++/OSSerialize.h>
#include <IOKit/IORegistryEntry.h>

namespace WIOKit {

	/**
	 *  AppleHDAEngine::getLocation teaches us to use while(1) when talking to IOReg
	 *  This feels mad and insane, since it may prevent the system from booting.
	 *  Although this had never happened, we will use a far bigger fail-safe stop value.
	 */
	static constexpr size_t bruteMax {0x10000000};

	/**
	 *  Read typed OSData
	 *
	 *  @param obj    read object
	 *  @param value  read value
	 *  @param name   propert name
	 *
	 *  @return true on success
	 */
	template <typename T>
	bool getOSDataValue(const OSObject *obj, const char *name, T &value) {
		if (obj) {
			auto data = OSDynamicCast(OSData, obj);
			if (data && data->getLength() == sizeof(T)) {
				value = *static_cast<const T *>(data->getBytesNoCopy());
				DBGLOG("iokit", "getOSData %s has %llX value", name, static_cast<uint64_t>(value));
				return true;
			} else {
				SYSLOG("iokit", "getOSData %s has unexpected format", name);
			}
		} else {
			DBGLOG("iokit", "getOSData %s was not found", name);
		}
		return false;
	}
	
	/**
	 *  Read typed OSData from IORegistryEntry
	 *
	 *  @see getOSDataValue
	 */
	template <typename T>
	bool getOSDataValue(const IORegistryEntry *sect, const char *name, T &value) {
		return getOSDataValue(sect->getProperty(name), name, value);
	}
	
	/**
	 *  Read typed OSData from IORegistryEntry
	 *
	 *  @see getOSDataValue
	 */
	template <typename T>
	bool getOSDataValue(const OSDictionary *dict, const char *name, T &value) {
		return getOSDataValue(dict->getObject(name), name, value);
	}

	/**
	 *  Retrieve property object
	 *
	 *  @param entry    IORegistry entry
	 *  @param property property name
	 *
	 *  @return property object (must be released) or nullptr
	 */
	EXPORT OSSerialize *getProperty(IORegistryEntry *entry, const char *property);
	
	/**
	 *  Model variants
	 */
	struct ComputerModel {
		enum {
			ComputerInvalid = 0x0,
			ComputerLaptop  = 0x1,
			ComputerDesktop = 0x2,
			ComputerAny = ComputerLaptop | ComputerDesktop
		};
	};
	
	/**
	 *  Retrieve the computer type
	 *
	 *  @return valid computer type or ComputerAny
	 */
	EXPORT int getComputerModel();
	
	/**
	 *  Retrieve computer model and/or board-id properties
	 *
	 *  @param model    model name output buffer or null
	 *  @param modelsz  model name output buffer size
	 *  @param board    board identifier output buffer or null
	 *  @param boardsz  board identifier output buffer size
	 *
	 *  @return true if relevant properties already are available, otherwise buffers are unchanged
	 */
	EXPORT bool getComputerInfo(char *model, size_t modelsz, char *board, size_t boardsz);
	
	/**
	 *  Retrieve an ioreg entry by path/prefix
	 *
	 *  @param path    an exact lookup path
	 *  @param prefix  entry prefix at path
	 *  @param plane   plane to lookup in
	 *  @param proc    process every found entry with the method
	 *  @param brute   kick ioreg until a value is found
	 *  @param user    pass some value to the callback function
	 *
	 *  @return entry pointer (must NOT be released) or nullptr (on failure or in proc mode)
	 */
	EXPORT IORegistryEntry *findEntryByPrefix(const char *path, const char *prefix, const IORegistryPlane *plane, bool (*proc)(void *, IORegistryEntry *)=nullptr, bool brute=false, void *user=nullptr);
	
	/**
	 *  Retrieve an ioreg entry by path/prefix
	 *
	 *  @param entry   an ioreg entry to look in
	 *  @param prefix  entry prefix at path
	 *  @param plane   plane to lookup in
	 *  @param proc    process every found entry with the method
	 *  @param brute   kick ioreg until a value is found
	 *  @param user    pass some value to the callback function
	 *
	 *  @return entry pointer (must NOT be released) or nullptr (on failure or in proc mode)
	 */
	EXPORT IORegistryEntry *findEntryByPrefix(IORegistryEntry *entry, const char *prefix, const IORegistryPlane *plane, bool (*proc)(void *, IORegistryEntry *)=nullptr, bool brute=false, void *user=nullptr);

	/**
	 *  Check if we are using prelinked kernel/kexts or not
	 *
	 *  @return true when confirmed that we definitely are
	 */
	EXPORT bool usingPrelinkedCache();
}

#endif /* kern_iokit_hpp */
