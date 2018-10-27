//
//  kern_user.hpp
//  Lilu
//
//  Copyright © 2016-2017 vit9696. All rights reserved.
//

#ifndef kern_user_hpp
#define kern_user_hpp

#include <Headers/kern_config.hpp>
#include <Headers/kern_patcher.hpp>

#include <mach/shared_region.h>
#include <sys/kauth.h>

class UserPatcher {
public:
	/**
	 *  Initialise UserPatcher, prepare for modifications
	 *
	 *  @param patcher        kernel patcher instance
	 *  @param preferSlowMode policy boot type
	 *
	 *  @return true on success
	 */
	bool init(KernelPatcher &patcher, bool preferSlowMode);
	
	/**
	 *  Deinitialise UserPatcher, must be called regardless of the init error
	 */
	void deinit();
	
	/**
	 *  Obtain page protection
	 *
	 *  @param map  vm map
	 *  @param addr map offset
	 *
	 *  @return protection
	 */
	EXPORT vm_prot_t getPageProtection(vm_map_t map, vm_map_address_t addr);

	/**
	 *  Structure holding lookup-style binary patches
	 */
	struct BinaryModPatch {
		cpu_type_t cpu;
		const uint8_t *find;
		const uint8_t *replace;
		size_t size;
		size_t skip;
		size_t count;
		uint32_t section;
	};
	
	/**
	 *  Structure describing the modifications for the binary
	 */
	struct BinaryModInfo {
		const char *path;
		BinaryModPatch *patches;
		size_t count;
		vm_address_t start;
		vm_address_t end;
	};
	
	/**
	 *  Structure describing relevant processes run
	 */
	struct ProcInfo {
		const char *path;
		uint32_t len;
		uint32_t section;
	};
	
	/**
	 *  External callback type for on process invocation
	 *
	 *  @param user    user provided pointer at registering
	 *  @param patcher user patcher instance
	 *  @param map     process image vm_map
	 *  @param path    path to the binary absolute or relative
	 *  @param len     path length excluding null terminator
	 */
	using t_BinaryLoaded = void (*)(void *user, UserPatcher &patcher, vm_map_t map, const char *path, size_t len);
	
	/**
	 *  Instructs user patcher to do further actions
	 *
	 *  @param procs    process list
	 *  @param procNum  process list size
	 *  @param mods     modification list
	 *  @param modNum   modification list size
	 *  @param callback callback function
	 *  @param user     pointer that will be passed to the callback function
	 */
	bool registerPatches(ProcInfo **procs, size_t procNum, BinaryModInfo **mods, size_t modNum, t_BinaryLoaded callback, void *user);
	
private:
	
	/**
	 *  Kernel function prototypes
	 */
	using vm_shared_region_t = void *;
	using shared_file_mapping_np = void *;
	using t_codeSignValidatePageWrapper = boolean_t (*)(void *, memory_object_t, memory_object_offset_t, const void *, unsigned *);
    using t_codeSignValidateRangeWrapper = boolean_t (*)(void *, memory_object_t, memory_object_offset_t, const void *, memory_object_size_t, unsigned *);
	using t_vmSharedRegionMapFile = kern_return_t (*)(vm_shared_region_t, unsigned int, shared_file_mapping_np *, memory_object_control_t, memory_object_size_t, void *, uint32_t, user_addr_t slide_start, user_addr_t);
	using t_vmSharedRegionSlide = int (*)(uint32_t, mach_vm_offset_t, mach_vm_size_t, mach_vm_offset_t, mach_vm_size_t, memory_object_control_t);
	using t_currentMap = vm_map_t (*)(void);
	using t_getTaskMap = vm_map_t (*)(task_t);
	using t_getMapMin = vm_map_offset_t (*)(vm_map_t);
	using t_vmMapCheckProtection = boolean_t (*)(vm_map_t, vm_offset_t, vm_offset_t, vm_prot_t);
	using t_vmMapReadUser = kern_return_t (*)(vm_map_t, vm_map_address_t, const void *, vm_size_t);
	using t_vmMapWriteUser = kern_return_t (*)(vm_map_t, const void *, vm_map_address_t, vm_size_t);
	using t_procExecSwitchTask = proc_t (*)(proc_t, task_t, task_t, thread_t);

	/**
	 *  Original kernel function trampolines
	 */
	t_codeSignValidatePageWrapper orgCodeSignValidatePageWrapper {nullptr};
    t_codeSignValidateRangeWrapper orgCodeSignValidateRangeWrapper {nullptr};
	t_vmSharedRegionMapFile orgVmSharedRegionMapFile {nullptr};
	t_vmSharedRegionSlide orgVmSharedRegionSlide {nullptr};
	t_currentMap orgCurrentMap {nullptr};
	t_getMapMin orgGetMapMin {nullptr};
	t_getTaskMap orgGetTaskMap {nullptr};
	t_vmMapCheckProtection orgVmMapCheckProtection {nullptr};
	t_vmMapReadUser orgVmMapReadUser {nullptr};
	t_vmMapWriteUser orgVmMapWriteUser {nullptr};
	t_procExecSwitchTask orgProcExecSwitchTask {nullptr};
	
    /**
     * Base of image activation parameters
     *
     * Partially taken from: bsd/sys/imgact.h
     */
    struct image_params {
        user_addr_t	ip_user_fname;	/* argument */
        user_addr_t	ip_user_argv;	/* argument */
        user_addr_t	ip_user_envv;	/* argument */
        int         ip_seg;			/* segment for arguments */
        vnode_t     ip_vp;          /* file */
        vnode_attr	*ip_vattr;      /* run file attributes */
        vnode_attr	*ip_origvattr;	/* invocation file attributes */
    };
    
    /**
     *  Image activation callback handler
     */
    using t_exImgact = int (*)(image_params *);

    /**
     *  Original mach image activator
     */
    t_exImgact orgExecMachImgact {nullptr};
    
	/**
	 *  Kernel function wrappers
	 */
	static boolean_t codeSignValidatePageWrapper(void *blobs, memory_object_t pager, memory_object_offset_t page_offset, const void *data, unsigned *tainted);
    static boolean_t codeSignValidateRangeWrapper(void *blobs, memory_object_t pager, memory_object_offset_t range_offset, const void *data, memory_object_size_t data_size, unsigned *tainted);
	static vm_map_t swapTaskMap(task_t task, thread_t thread, vm_map_t map, boolean_t doswitch);
	static vm_map_t vmMapSwitch(vm_map_t map);
	static kern_return_t vmSharedRegionMapFile(vm_shared_region_t shared_region, unsigned int mappings_count, shared_file_mapping_np *mappings, memory_object_control_t file_control, memory_object_size_t file_size, void *root_dir, uint32_t slide, user_addr_t slide_start, user_addr_t slide_size);
	static void execsigs(proc_t p, thread_t thread);
	static int vmSharedRegionSlide(uint32_t slide, mach_vm_offset_t entry_start_address, mach_vm_size_t entry_size, mach_vm_offset_t slide_start, mach_vm_size_t slide_size, memory_object_control_t sr_file_control);
    static int exImgact(image_params *igmp);
	static proc_t procExecSwitchTask(proc_t p, task_t current_task, task_t new_task, thread_t new_thread);

    /**
     *  Applies page patches to the memory range
     *
     *  @param data_ptr  pages in kernel memory
     *  @param data_size data size divisible by PAGE_SIZE
     */
    void performPagePatch(const void *data_ptr, size_t data_size);
    
	/**
	 * dyld shared cache map entry structure
	 */
	struct MapEntry {
		const char *filename;
		size_t length;
		vm_address_t start;
		vm_address_t end;
	};
	
	/**
	 *  Obtains __TEXT addresses from .map files
	 *
	 *  @param mapBuf     read .map file
	 *  @param mapSz      .map file size
	 *  @param mapEntries entries to look for
	 *  @param nentries   number of entries
	 *
	 *  @return number of entries found
	 */
	size_t mapAddresses(const char *mapBuf, MapEntry *mapEntries, size_t nentries);

	/**
	 *  Stored ASLR slide of dyld shared cache
	 */
	uint32_t storedSharedCacheSlide {0};

	/**
	 *  Set once shared cache slide is defined
	 */
	bool sharedCacheSlideStored {false};
	
	/**
	 *  Set on init to decide on whether to use __RESTRICT or patch dyld shared cache
	 */
	bool patchDyldSharedCache {false};
	
	/**
	 *  Kernel patcher instance
	 */
	KernelPatcher *patcher {nullptr};
	
	/**
	 *  Patch requested for path
	 */
	char pendingPath[MAXPATHLEN] {};
	
	/**
	 *  Patch requested for path
	 */
	uint32_t pendingPathLen {0};
	
	/**
	 *  Patch requested
	 */
	bool pendingPatchCallback {false};
	
	/**
	 *  Current minimal proc name length
	 */
	uint32_t currentMinProcLength {0};
	
	/**
	 *  Provided binary modification list
	 */
	BinaryModInfo **binaryMod {nullptr};
	
	/**
	 *  Amount of provided binary modifications
	 */
	size_t binaryModSize {0};
	
	/**
	 *  Provided process list
	 */
	ProcInfo **procInfo {nullptr};
	
	/**
	 *  Amount of provided processes
	 */
	size_t procInfoSize {0};
	
	/**
	 *  Provided global callback for on proc invocation
	 */
	ppair<t_BinaryLoaded, void *> userCallback;
	
	/**
	 *  Applies dyld shared cache patches
	 *
	 *  @param map     current process map
	 *  @param slide   ASLR offset
	 *  @param cpu     cache cpu type
	 *  @param restore true to rollback the changes
	 */
	void patchSharedCache(vm_map_t map, uint32_t slide, cpu_type_t cpu, bool applyChanges=true);

	/**
	 *  Structure holding userspace lookup patches
	 */
	struct LookupStorage {
		struct PatchRef {
			size_t i {0};
			evector<off_t> pageOffs;
			evector<off_t> segOffs;
			static PatchRef *create() {
				return new PatchRef;
			}
			static void deleter(PatchRef *r) {
				r->pageOffs.deinit();
				r->segOffs.deinit();
				delete r;
			}
		};
		
		const BinaryModInfo *mod {nullptr};
		evector<PatchRef *, PatchRef::deleter> refs;
		Page *page {nullptr};
		vm_address_t pageOff {0};

		static LookupStorage *create() {
			auto p = new LookupStorage;
			if (p) {
				p->page = Page::create();
				if (!p->page) {
					deleter(p);
					p = nullptr;
				}
			}
			return p;
		}
		
		static void deleter(LookupStorage *p) {
			if (p->page) {
				Page::deleter(p->page);
				p->page = nullptr;
			}
			p->refs.deinit();
			delete p;
		}
	};

	struct Lookup {
		uint32_t offs[4];
		static constexpr size_t matchNum {4};
		evector<uint64_t> c[matchNum];
	};
	
	evector<LookupStorage *, LookupStorage::deleter> lookupStorage;
	Lookup lookup;
	
	/**
	 *  Restrict entry overlapping DYLD_SHARED_CACHE to enforce manual library loading
	 */
	segment_command_64 restrictSegment {
		.cmd		= LC_SEGMENT_64,
		.cmdsize	= sizeof(segment_command_64),
		.nsects		= 0,
		.segname	= "__RESTRICT",
		.vmaddr		= SHARED_REGION_BASE_X86_64,
		.vmsize		= 1
	};
	
	/**
	 *  Temporary header for reading data
	 */
	mach_header_64 tmpHeader;
	
	/**
	 *  Kernel auth listener handle
	 */
	kauth_listener_t listener {nullptr};
	
	/**
	 *  Validation cookie
	 */
	void *cookie = {reinterpret_cast<void *>(0xB16B00B5)};
	
	/**
	 *  Exec callback
	 *
	 *  @param credential kauth credential
	 *  @param idata      cookie
	 *  @param action     passed action, we only need KAUTH_FILEOP_EXEC
	 *  @param arg0       pointer to vnode (vnode *) for executable
	 *  @param arg1       pointer to path (char *) to executable
	 *  @param arg2       unused
	 *  @param arg3       unsed
	 *
	 *  @return 0 to allow further execution
	 */
	static int execListener(kauth_cred_t credential, void *idata, kauth_action_t action, uintptr_t arg0, uintptr_t arg1, uintptr_t arg2, uintptr_t arg3);

	/**
	 *  Callback invoked at process loading
	 *
	 *  @param path binary path
	 *  @param len  path length
	 */
	void onPath(const char *path, uint32_t len);
	
	/**
	 *  Reads files from BinaryModInfos and prepares lookupStorage
	 *
	 *  @return true on success
	 */
	bool loadFilesForPatching();
	
	/**
	 *  Reads dyld shared cache and obtains segment offsets
	 *
	 *  @return true on success
	 */
	bool loadDyldSharedCacheMapping();
	
	/**
	 *  Prepares quick page lookup based on lookupStorage values
	 *
	 *  @return true on success
	 */
	bool loadLookups();
	
	/**
	 *  Hooks memory access to get ready for patching
	 *
	 *  @return true on success
	 */
	bool hookMemoryAccess();
	
	/**
	 *  Disables dyld_shared_cache for the current process
	 *
	 *  @param map  vm map
	 *
	 *  @return false on mach image failure
	 */
	bool injectRestrict(vm_map_t map);
	
	/**
	 *  Peforms the actual binary patching
	 *
	 *  @param map  vm map
	 *  @param path binary path
	 *  @param len  path length
	 */
	void patchBinary(vm_map_t map, const char *path, uint32_t len);
	
	/**
	 *  Possible dyld shared cache map paths
	 */
	static constexpr size_t sharedCacheMapPathsNum {2};
	const char *sharedCacheMap[sharedCacheMapPathsNum] {
		"/private/var/db/dyld/dyld_shared_cache_x86_64h.map",	//since 10.10
		"/private/var/db/dyld/dyld_shared_cache_x86_64.map"
	};

};

#endif /* kern_user_hpp */
