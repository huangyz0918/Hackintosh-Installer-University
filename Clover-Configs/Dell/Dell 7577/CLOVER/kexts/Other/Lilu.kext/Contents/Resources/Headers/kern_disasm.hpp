//
//  kern_disasm.hpp
//  Lilu
//
//  Copyright © 2016-2017 vit9696. All rights reserved.
//

#ifndef kern_disasm_hpp
#define kern_disasm_hpp

#include <Headers/kern_config.hpp>
#include <Headers/kern_util.hpp>

#include <sys/types.h>
#include <mach/vm_types.h>

class Disassembler {
	/**
	 *  Because captsone handle can be 0
	 */
	bool initialised {false};
	
	/**
	 *  Internal capstone handle
	 */
	size_t handle;

	/**
	 *  Max instruction size
	 */
	static constexpr size_t MaxInstruction {15};
public:

	/**
	 *  Initialise dissassembling framework
	 *
	 *  @param detailed  debugging output necessity
	 *
	 *  @return true on success
	 */
	EXPORT bool init(bool detailed=false);
	
	/**
	 *  Deinitialise dissassembling framework, must be called regardless of the init error
	 */
	EXPORT void deinit();
	
	/**
	 *  Return the real instruction size contained within min bytes
	 *
	 *  @param ptr instruction pointer
	 *  @param min minimal possible size
	 *
	 *  @return instruction size >= min on success or 0
	 */
	EXPORT size_t instructionSize(mach_vm_address_t ptr, size_t min);
};

#endif /* kern_disasm_hpp */
