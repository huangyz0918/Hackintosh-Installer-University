//
//  kern_api.hpp
//  Lilu
//
//  Copyright © 2016-2017 vit9696. All rights reserved.
//

#ifndef kern_api_h
#define kern_api_h

#include <Headers/kern_config.hpp>
#include <Headers/kern_patcher.hpp>
#include <Headers/kern_user.hpp>

#include <stdint.h>
#include <sys/types.h>
#include <libkern/OSAtomic.h>

class LiluAPI {
public:
	/**
	 *  Initialise lilu api
 	 */
	void init();
	
	/**
	 *  Deinitialise lilu api
	 */
	void deinit();
	
	/**
	 *  Errors returned by functions
	 */
	enum class Error {
		NoError,
		LockError,
		MemoryError,
		UnsupportedFeature,
		IncompatibleOS,
		Disabled,
		TooLate
	};
	
	/**
	 *  Obtains api access by holding a lock, which is required when accessing out of the main context
	 *
	 *  @param check do not wait on the lock but return Error::LockError on failure
	 *
	 *  @return Error::NoError on success
	 */
	EXPORT Error requestAccess(bool check=false);
	
	/**
	 *  Releases api lock
	 *
	 *  @return Error::NoError on success
	 */
	EXPORT Error releaseAccess();
	
	/**
	 *  Decides whether you are eligible to continue
	 *
	 *  @param product       product name
	 *  @param disableArg    pointer to disabling boot arguments array
	 *  @param disableArgNum number of disabling boot arguments
	 *  @param debugArg      pointer to debug boot arguments array
	 *  @param debugArgNum   number of debug boot arguments
	 *  @param betaArg       pointer to beta boot arguments array
	 *  @param betaArgNum    number of beta boot arguments
	 *  @param min           minimal required kernel version
	 *  @param max           maximum supported kernel version
	 *  @param printDebug    returns debug printing status (based on debugArg)
	 *
	 *  @return Error::NoError on success
	 */
	EXPORT Error shouldLoad(const char *product, const char **disableArg, size_t disableArgNum, const char **debugArg, size_t debugArgNum, const char **betaArg, size_t betaArgNum, KernelVersion min, KernelVersion max, bool &printDebug);
	
	/**
	 *  Kernel patcher loaded callback
	 *
	 *  @param user    user provided pointer at registering
	 *  @param patcher kernel patcher instance
	 */
	using t_patcherLoaded = void (*)(void *user, KernelPatcher &patcher);
	
	/**
	 *  Registers custom provided callbacks for later invocation on kernel patcher initialisation
	 *
	 *  @param callback your callback function
	 *  @param user     your pointer that will be passed to the callback function
	 *
	 *  @return Error::NoError on success
	 */
	EXPORT Error onPatcherLoad(t_patcherLoaded callback, void *user=nullptr);
	
	/**
	 *  Kext loaded callback
	 *  Note that you will get notified of all the requested kexts for speed reasons
	 *
	 *  @param user    user provided pointer at registering
	 *  @param patcher kernel patcher instance
	 *  @param id      loaded kinfo id
	 *  @param slide   loaded slide
	 *  @param size    loaded memory size
	 */
	using t_kextLoaded = void (*)(void *user, KernelPatcher &patcher, size_t id, mach_vm_address_t slide, size_t size);
	
	/**
	 *  Registers custom provided callbacks for later invocation on kext load
	 *
	 *  @param infos    your kext list (make sure to point to const memory)
	 *  @param num      number of provided kext entries
	 *  @param callback your callback function
	 *  @param user     your pointer that will be passed to the callback function
	 *
	 *  @return Error::NoError on success
	 */
	EXPORT Error onKextLoad(KernelPatcher::KextInfo *infos, size_t num, t_kextLoaded callback, void *user=nullptr);
	
	/**
	 *  Registers custom provided callbacks for later invocation on binary load
	 *
	 *  @param infos    your binary list (make sure to point to const memory)
	 *  @param num      number of provided binary entries
	 *  @param callback your callback function (could be null)
	 *  @param user     your pointer that will be passed to the callback function
	 *  @param mods     optional mod list (make sure to point to const memory)
	 *  @param modnum   number of provided mod entries
	 *
	 *  @return Error::NoError on success
	 */
	EXPORT Error onProcLoad(UserPatcher::ProcInfo *infos, size_t num, UserPatcher::t_BinaryLoaded callback, void *user=nullptr, UserPatcher::BinaryModInfo *mods=nullptr, size_t modnum=0);

	/**
	 *  Processes all the registered patcher load callbacks
	 *
	 *  @param patcher kernel patcher instance
	 */
	void processPatcherLoadCallbacks(KernelPatcher &patcher);

	/**
	 *  Processes all the registered kext load callbacks
	 *
	 *  @param patcher kernel patcher instance
	 *  @param id      loaded kinfo id
	 *  @param slide   loaded slide
	 *  @param size    loaded memory size
	 */
	void processKextLoadCallbacks(KernelPatcher &patcher, size_t id, mach_vm_address_t slide, size_t size);
	
	/**
	 *  Processes all the registered user patcher load callbacks
	 *
	 *  @param patcher user patcher instance
	 */
	void processUserLoadCallbacks(UserPatcher &patcher);
	
	/**
	 *  Processes all the registered binary load callbacks
	 *
	 *  @param patcher kernel patcher instance
	 *  @param map     process image vm_map
	 *  @param path    path to the binary absolute or relative
	 *  @param len     path length excluding null terminator
	 */
	void processBinaryLoadCallbacks(UserPatcher &patcher, vm_map_t map, const char *path, size_t len);
	
private:
	
	/**
	 *  Api lock
	 */
	IOSimpleLock *access {nullptr};
	
	/**
	 *  No longer accept any requests
	 */
	bool apiRequestsOver {false};
	
	/**
	 *  Stores call function and user pointer
	 */
	template <typename T, typename Y=void *>
	using stored_pair = ppair<T, Y>;
	
	/**
	 *  Stores multiple callbacks
	 */
	template <typename T, typename Y=void *>
	using stored_vector = evector<stored_pair<T, Y> *, stored_pair<T, Y>::deleter>;
	
	/**
	 *  List of patcher callbacks
	 */
	stored_vector<t_patcherLoaded> patcherLoadedCallbacks;
	
	/**
	 *  List of kext callbacks
	 */
	stored_vector<t_kextLoaded> kextLoadedCallbacks;
	
	/**
	 *  List of binary callbacks
	 */
	stored_vector<UserPatcher::t_BinaryLoaded> binaryLoadedCallbacks;
	
	/**
	 *  List of processed kexts
	 */
	stored_vector<KernelPatcher::KextInfo *, size_t> storedKexts;
	
	/**
	 *  List of processed procs
	 */
	evector<UserPatcher::ProcInfo *> storedProcs;
	
	/**
	 *  List of processed binary mods
	 */
	evector<UserPatcher::BinaryModInfo *> storedBinaryMods;
};

EXPORT extern LiluAPI lilu;

#endif /* kern_api_h */
