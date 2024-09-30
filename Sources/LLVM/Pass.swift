#if SWIFT_PACKAGE
import cllvm
#endif

/// A type that represents an optimization pass
/// The subset of passes that appear in `opt --help` are available as static members
/// A comprehensive list can be found in `opt --print-passes`
public struct Pass {
  
  internal let string: String
  
  /// Create a pass from a string.
  /// Prefer using static members of this type if availiable.
  ///
  /// - parameter string: The string representation of a pass.
  public init(_ string: String) {
    self.string = string
  }
  
  /// Executes the optimization pass.
  ///
  /// - parameter module: The module to optimize.
  /// - parameter machine: The machine to optimize for.
  /// - parameter options: The pass build options to use.
  func execute(module: Module, machine: TargetMachine, options: PassBuildOptions = PassBuildOptions()) {
    LLVMRunPasses(module.llvm, string, machine.llvm, options.llvm)
  }
  
  // TODO: Add more readable names for the most common passes
  
  /// Function Alias Analysis Results
  public static let aa = Pass("aa")
  /// Combine AArch64 machine instrs before legalization
  public static let aarch64_O0_prelegalizer_combiner = Pass("aarch64-O0-prelegalizer-combiner")
  /// AArch64 A57 FP Load-Balancing
  public static let aarch64_a57_fp_load_balancing = Pass("aarch64-a57-fp-load-balancing")
  /// AArch64 Branch Targets
  public static let aarch64_branch_targets = Pass("aarch64-branch-targets")
  /// AArch64 CCMP Pass
  public static let aarch64_ccmp = Pass("aarch64-ccmp")
  /// AArch64 Collect Linker Optimization Hint (LOH)
  public static let aarch64_collect_loh = Pass("aarch64-collect-loh")
  /// AArch64 CondOpt Pass
  public static let aarch64_condopt = Pass("aarch64-condopt")
  /// AArch64 redundant copy elimination pass
  public static let aarch64_copyelim = Pass("aarch64-copyelim")
  /// AArch64 Dead register definitions
  public static let aarch64_dead_defs = Pass("aarch64-dead-defs")
  /// AArch64 pseudo instruction expansion pass
  public static let aarch64_expand_pseudo = Pass("aarch64-expand-pseudo")
  /// Falkor HW Prefetch Fix
  public static let aarch64_falkor_hwpf_fix = Pass("aarch64-falkor-hwpf-fix")
  /// Falkor HW Prefetch Fix Late Phase
  public static let aarch64_falkor_hwpf_fix_late = Pass("aarch64-falkor-hwpf-fix-late")
  /// AArch64 fix for A53 erratum 835769
  public static let aarch64_fix_cortex_a53_835769_pass = Pass("aarch64-fix-cortex-a53-835769-pass")
  /// AArch64 Globals Tagging Pass
  public static let aarch64_globals_tagging = Pass("aarch64-globals-tagging")
  /// AArch64 Instruction Selection
  public static let aarch64_isel = Pass("aarch64-isel")
  /// AArch64 compress jump tables pass
  public static let aarch64_jump_tables = Pass("aarch64-jump-tables")
  /// AArch64 load / store optimization pass
  public static let aarch64_ldst_opt = Pass("aarch64-ldst-opt")
  /// Transform specific loop idioms into optimized vector forms
  public static let aarch64_lit = Pass("aarch64-lit")
  /// AArch64 Local Dynamic TLS Access Clean-up
  public static let aarch64_local_dynamic_tls_cleanup = Pass("aarch64-local-dynamic-tls-cleanup")
  /// AArch64 homogeneous prolog/epilog lowering pass
  public static let aarch64_lower_homogeneous_prolog_epilog = Pass("aarch64-lower-homogeneous-prolog-epilog")
  /// AArch64 MI Peephole Optimization
  public static let aarch64_mi_peephole_opt = Pass("aarch64-mi-peephole-opt")
  /// Optimize AArch64 selected instructions
  public static let aarch64_post_select_optimize = Pass("aarch64-post-select-optimize")
  /// Combine AArch64 MachineInstrs after legalization
  public static let aarch64_postlegalizer_combiner = Pass("aarch64-postlegalizer-combiner")
  /// Lower AArch64 MachineInstrs after legalization
  public static let aarch64_postlegalizer_lowering = Pass("aarch64-postlegalizer-lowering")
  /// Combine AArch64 machine instrs before legalization
  public static let aarch64_prelegalizer_combiner = Pass("aarch64-prelegalizer-combiner")
  /// AArch64 Promote Constant Pass
  public static let aarch64_promote_const = Pass("aarch64-promote-const")
  /// AArch64 Pointer Authentication
  public static let aarch64_ptrauth = Pass("aarch64-ptrauth")
  /// AdvSIMD Scalar Operation Optimization
  public static let aarch64_simd_scalar = Pass("aarch64-simd-scalar")
  /// AArch64 SIMD instructions optimization pass
  public static let aarch64_simdinstr_opt = Pass("aarch64-simdinstr-opt")
  /// AArch64 sls hardening pass
  public static let aarch64_sls_hardening = Pass("aarch64-sls-hardening")
  /// SME ABI Pass
  public static let aarch64_sme_abi = Pass("aarch64-sme-abi")
  /// AArch64 speculation hardening pass
  public static let aarch64_speculation_hardening = Pass("aarch64-speculation-hardening")
  /// AArch64 Stack Tagging
  public static let aarch64_stack_tagging = Pass("aarch64-stack-tagging")
  /// AArch64 Stack Tagging PreRA Pass
  public static let aarch64_stack_tagging_pre_ra = Pass("aarch64-stack-tagging-pre-ra")
  /// AArch64 Store Pair Suppression
  public static let aarch64_stp_suppress = Pass("aarch64-stp-suppress")
  /// SVE intrinsics optimizations
  public static let aarch64_sve_intrinsic_opts = Pass("aarch64-sve-intrinsic-opts")
  /// Hoisting alloca instructions in non-entry blocks to the entry block
  public static let alloca_hoisting = Pass("alloca-hoisting")
  /// Inliner for always_inline functions
  public static let always_inline = Pass("always-inline")
  /// AMDGPU Address space based Alias Analysis
  public static let amdgpu_aa = Pass("amdgpu-aa")
  /// AMDGPU Address space based Alias Analysis Wrapper
  public static let amdgpu_aa_wrapper = Pass("amdgpu-aa-wrapper")
  /// AMDGPU Inline All Functions
  public static let amdgpu_always_inline = Pass("amdgpu-always-inline")
  /// Add AMDGPU function attributes
  public static let amdgpu_annotate_kernel_features = Pass("amdgpu-annotate-kernel-features")
  /// Add AMDGPU uniform metadata
  public static let amdgpu_annotate_uniform = Pass("amdgpu-annotate-uniform")
  /// Argument Register Usage Information Storage
  public static let amdgpu_argument_reg_usage_info = Pass("amdgpu-argument-reg-usage-info")
  /// AMDGPU atomic optimizations
  public static let amdgpu_atomic_optimizer = Pass("amdgpu-atomic-optimizer")
  /// AMDGPU Attributor
  public static let amdgpu_attributor = Pass("amdgpu-attributor")
  /// AMDGPU IR optimizations
  public static let amdgpu_codegenprepare = Pass("amdgpu-codegenprepare")
  /// AMDGPU GlobalISel divergence lowering
  public static let amdgpu_global_isel_divergence_lowering = Pass("amdgpu-global-isel-divergence-lowering")
  /// AMDGPU Image Intrinsic Optimizer
  public static let amdgpu_image_intrinsic_opt = Pass("amdgpu-image-intrinsic-opt")
  /// AMDGPU Insert Delay ALU
  public static let amdgpu_insert_delay_alu = Pass("amdgpu-insert-delay-alu")
  /// AMDGPU Insert SingleUseVDST
  public static let amdgpu_insert_single_use_vdst = Pass("amdgpu-insert-single-use-vdst")
  /// AMDGPU DAG->DAG Pattern Instruction Selection
  public static let amdgpu_isel = Pass("amdgpu-isel")
  /// AMDGPU IR late optimizations
  public static let amdgpu_late_codegenprepare = Pass("amdgpu-late-codegenprepare")
  /// Lower ctors and dtors for AMDGPU
  public static let amdgpu_lower_ctor_dtor = Pass("amdgpu-lower-ctor-dtor")
  /// Lower OpenCL enqueued blocks
  public static let amdgpu_lower_enqueued_block = Pass("amdgpu-lower-enqueued-block")
  /// AMDGPU Lower Kernel Arguments
  public static let amdgpu_lower_kernel_arguments = Pass("amdgpu-lower-kernel-arguments")
  /// AMDGPU Kernel Attributes
  public static let amdgpu_lower_kernel_attributes = Pass("amdgpu-lower-kernel-attributes")
  /// Lower uses of LDS variables from non-kernel functions
  public static let amdgpu_lower_module_lds = Pass("amdgpu-lower-module-lds")
  /// AMDGPU Mark last scratch load
  public static let amdgpu_mark_last_scratch_load = Pass("amdgpu-mark-last-scratch-load")
  /// GCN NSA Reassign
  public static let amdgpu_nsa_reassign = Pass("amdgpu-nsa-reassign")
  /// Analysis if a function is memory bound
  public static let amdgpu_perf_hint = Pass("amdgpu-perf-hint")
  /// Combine AMDGPU machine instrs after legalization
  public static let amdgpu_postlegalizer_combiner = Pass("amdgpu-postlegalizer-combiner")
  /// AMDGPU Pre-RA Long Branch Reg
  public static let amdgpu_pre_ra_long_branch_reg = Pass("amdgpu-pre-ra-long-branch-reg")
  /// Pre-RA optimizations
  public static let amdgpu_pre_ra_optimizations = Pass("amdgpu-pre-ra-optimizations")
  /// Combine AMDGPU machine instrs before legalization
  public static let amdgpu_prelegalizer_combiner = Pass("amdgpu-prelegalizer-combiner")
  /// Unkown
  public static let amdgpu_print_rp = Pass("amdgpu-print-rp")
  /// AMDGPU Printf lowering
  public static let amdgpu_printf_runtime_binding = Pass("amdgpu-printf-runtime-binding")
  /// AMDGPU promote alloca to vector or LDS
  public static let amdgpu_promote_alloca = Pass("amdgpu-promote-alloca")
  /// AMDGPU promote alloca to vector
  public static let amdgpu_promote_alloca_to_vector = Pass("amdgpu-promote-alloca-to-vector")
  /// AMDGPU Promote Kernel Arguments
  public static let amdgpu_promote_kernel_arguments = Pass("amdgpu-promote-kernel-arguments")
  /// Combine AMDGPU machine instrs after regbankselect
  public static let amdgpu_regbank_combiner = Pass("amdgpu-regbank-combiner")
  /// AMDGPU Register Bank Select
  public static let amdgpu_regbankselect = Pass("amdgpu-regbankselect")
  /// AMDGPU Remove Incompatible Functions
  public static let amdgpu_remove_incompatible_functions = Pass("amdgpu-remove-incompatible-functions")
  /// Function register usage analysis
  public static let amdgpu_resource_usage = Pass("amdgpu-resource-usage")
  /// AMDGPU Rewrite Out Arguments
  public static let amdgpu_rewrite_out_arguments = Pass("amdgpu-rewrite-out-arguments")
  /// Rewrite undef for PHI
  public static let amdgpu_rewrite_undef_for_phi = Pass("amdgpu-rewrite-undef-for-phi")
  /// Unify divergent function exit nodes
  public static let amdgpu_unify_divergent_exit_nodes = Pass("amdgpu-unify-divergent-exit-nodes")
  /// Unify multiple OpenCL metadata due to linking
  public static let amdgpu_unify_metadata = Pass("amdgpu-unify-metadata")
  /// Optimize addressing mode
  public static let amode_opt = Pass("amode-opt")
  /// ARM block placement
  public static let arm_block_placement = Pass("arm-block-placement")
  /// ARM Branch Targets
  public static let arm_branch_targets = Pass("arm-branch-targets")
  /// ARM constant island placement and branch shortening pass
  public static let arm_cp_islands = Pass("arm-cp-islands")
  /// ARM Execution Domain Fix
  public static let arm_execution_domain_fix = Pass("arm-execution-domain-fix")
  /// ARM fix for Cortex-A57 AES Erratum 1742098
  public static let arm_fix_cortex_a57_aes_1742098 = Pass("arm-fix-cortex-a57-aes-1742098")
  /// ARM Instruction Selection
  public static let arm_isel = Pass("arm-isel")
  /// ARM load / store optimization pass
  public static let arm_ldst_opt = Pass("arm-ldst-opt")
  /// ARM Low Overhead Loops pass
  public static let arm_low_overhead_loops = Pass("arm-low-overhead-loops")
  /// MVE gather/scattering lowering pass
  public static let arm_mve_gather_scatter_lowering = Pass("arm-mve-gather-scatter-lowering")
  /// ARM MVE VPT block pass
  public static let arm_mve_vpt = Pass("arm-mve-vpt")
  /// ARM MVE TailPred and VPT Optimisations pass
  public static let arm_mve_vpt_opts = Pass("arm-mve-vpt-opts")
  /// Transform functions to use DSP intrinsics
  public static let arm_parallel_dsp = Pass("arm-parallel-dsp")
  /// ARM pre- register allocation load / store optimization pass
  public static let arm_prera_ldst_opt = Pass("arm-prera-ldst-opt")
  /// ARM pseudo instruction expansion pass
  public static let arm_pseudo = Pass("arm-pseudo")
  /// ARM sls hardening pass
  public static let arm_sls_hardening = Pass("arm-sls-hardening")
  /// Assumption Cache Tracker
  public static let assumption_cache_tracker = Pass("assumption-cache-tracker")
  /// Expand Atomic instructions
  public static let atomic_expand = Pass("atomic-expand")
  /// AVR pseudo instruction expansion pass
  public static let avr_expand_pseudo = Pass("avr-expand-pseudo")
  /// AVR DAG->DAG Instruction Selection
  public static let avr_isel = Pass("avr-isel")
  /// AVR Shift Expansion
  public static let avr_shift_expand = Pass("avr-shift-expand")
  /// A No-Op Barrier Pass
  public static let barrier = Pass("barrier")
  /// Basic Alias Analysis (stateless AA impl)
  public static let basic_aa = Pass("basic-aa")
  /// CallGraph Construction
  public static let basiccg = Pass("basiccg")
  /// Reads and parses a basic block sections profile.
  public static let bbsections_profile_reader = Pass("bbsections-profile-reader")
  /// Block Frequency Analysis
  public static let block_freq = Pass("block-freq")
  /// BPF Check And Adjust IR
  public static let bpf_check_and_opt_ir = Pass("bpf-check-and-opt-ir")
  /// BPF DAG->DAG Pattern Instruction Selection
  public static let bpf_isel = Pass("bpf-isel")
  /// BPF MachineSSA Peephole Optimization For ZEXT Eliminate
  public static let bpf_mi_zext_elim = Pass("bpf-mi-zext-elim")
  /// Branch Probability Analysis
  public static let branch_prob = Pass("branch-prob")
  /// Break critical edges in CFG
  public static let break_crit_edges = Pass("break-crit-edges")
  /// Prepare callbr
  public static let callbrprepare = Pass("callbrprepare")
  /// Canonicalize Freeze Instructions in Loops
  public static let canon_freeze = Pass("canon-freeze")
  /// Check debug info from -debugify
  public static let check_debugify = Pass("check-debugify")
  /// Check debug info from -debugify-function
  public static let check_debugify_function = Pass("check-debugify-function")
  /// Optimize for code generation
  public static let codegenprepare = Pass("codegenprepare")
  /// Constant Hoisting
  public static let consthoist = Pass("consthoist")
  /// Analysis containing CSE Info
  public static let cseinfo = Pass("cseinfo")
  /// Cycle Info Analysis
  public static let cycles = Pass("cycles")
  /// Dependence Analysis
  public static let da = Pass("da")
  /// Dead Code Elimination
  public static let dce = Pass("dce")
  /// Dead Argument Elimination
  public static let deadargelim = Pass("deadargelim")
  /// Dead Argument Hacking (BUGPOINT USE ONLY; DO NOT USE)
  public static let deadarghaX0r = Pass("deadarghaX0r")
  /// Attach debug info to everything
  public static let debugify = Pass("debugify")
  /// Attach debug info to a function
  public static let debugify_function = Pass("debugify-function")
  /// Dominance Frontier Construction
  public static let domfrontier = Pass("domfrontier")
  /// Dominator Tree Construction
  public static let domtree = Pass("domtree")
  /// Print call graph to 'dot' file
  public static let dot_callgraph = Pass("dot-callgraph")
  /// Print dominance tree of function to 'dot' file
  public static let dot_dom = Pass("dot-dom")
  /// Print dominance tree of function to 'dot' file (with no function bodies)
  public static let dot_dom_only = Pass("dot-dom-only")
  /// Print postdominance tree of function to 'dot' file
  public static let dot_postdom = Pass("dot-postdom")
  /// Print postdominance tree of function to 'dot' file (with no function bodies)
  public static let dot_postdom_only = Pass("dot-postdom-only")
  /// Print regions of function to 'dot' file
  public static let dot_regions = Pass("dot-regions")
  /// Print regions of function to 'dot' file (with no function bodies)
  public static let dot_regions_only = Pass("dot-regions-only")
  /// Polly - Print Scops of function
  public static let dot_scops = Pass("dot-scops")
  /// Polly - Print Scops of function (with no function bodies)
  public static let dot_scops_only = Pass("dot-scops-only")
  /// Prepare DWARF exceptions
  public static let dwarf_eh_prepare = Pass("dwarf-eh-prepare")
  /// Early CSE
  public static let early_cse = Pass("early-cse")
  /// Early CSE w/ MemorySSA
  public static let early_cse_memssa = Pass("early-cse-memssa")
  /// Bundle Machine CFG Edges
  public static let edge_bundles = Pass("edge-bundles")
  /// Expand large div/rem
  public static let expand_large_div_rem = Pass("expand-large-div-rem")
  /// Expand large fp convert
  public static let expand_large_fp_convert = Pass("expand-large-fp-convert")
  /// Expand memcmp() to load/stores
  public static let expand_memcmp = Pass("expand-memcmp")
  /// Expand reduction intrinsics
  public static let expand_reductions = Pass("expand-reductions")
  /// Expand vector predication intrinsics
  public static let expandvp = Pass("expandvp")
  /// External Alias Analysis
  public static let external_aa = Pass("external-aa")
  /// Fast Tile Register Preconfigure
  public static let fastpretileconfig = Pass("fastpretileconfig")
  /// Fast Tile Register Configure
  public static let fasttileconfig = Pass("fasttileconfig")
  /// Convert irreducible control-flow into natural loops
  public static let fix_irreducible = Pass("fix-irreducible")
  /// Flatten the CFG
  public static let flattencfg = Pass("flattencfg")
  /// GCN Create VOPD Instructions
  public static let gcn_create_vopd = Pass("gcn-create-vopd")
  /// GCN DPP Combine
  public static let gcn_dpp_combine = Pass("gcn-dpp-combine")
  /// Ensure that the global variables are in the global address space
  public static let generic_to_nvvm = Pass("generic-to-nvvm")
  /// Analysis for ComputingKnownBits
  public static let gisel_known_bits = Pass("gisel-known-bits")
  /// Merge global variables
  public static let global_merge = Pass("global-merge")
  /// Globals Alias Analysis
  public static let globals_aa = Pass("globals-aa")
  /// Global Value Numbering
  /// This pass performs global value numbering and redundant load elimination
  /// cotemporaneously.
  public static let gvn = Pass("gvn")
  /// Hexagon bit simplification
  public static let hexagon_bit_simplify = Pass("hexagon-bit-simplify")
  /// Hexagon constant-extender optimization
  public static let hexagon_cext_opt = Pass("hexagon-cext-opt")
  /// Hexagon Constant Propagation
  public static let hexagon_constp = Pass("hexagon-constp")
  /// Hexagon Copy-To-Combine Pass
  public static let hexagon_copy_combine = Pass("hexagon-copy-combine")
  /// Hexagon early if conversion
  public static let hexagon_early_if = Pass("hexagon-early-if")
  /// Hexagon generate mux instructions
  public static let hexagon_gen_mux = Pass("hexagon-gen-mux")
  /// Hexagon DAG->DAG Pattern Instruction Selection
  public static let hexagon_isel = Pass("hexagon-isel")
  /// Recognize Hexagon-specific loop idioms
  public static let hexagon_loop_idiom = Pass("hexagon-loop-idiom")
  /// Hexagon NewValueJump
  public static let hexagon_nvj = Pass("hexagon-nvj")
  /// Hexagon Packetizer
  public static let hexagon_packetizer = Pass("hexagon-packetizer")
  /// Hexagon RDF optimizations
  public static let hexagon_rdf_opt = Pass("hexagon-rdf-opt")
  /// Hexagon Split Double Registers
  public static let hexagon_split_double = Pass("hexagon-split-double")
  /// Hexagon Vector Combine
  public static let hexagon_vc = Pass("hexagon-vc")
  /// Hexagon optimize vextract
  public static let hexagon_vextract = Pass("hexagon-vextract")
  /// Hexagon-specific predictive commoning for HVX vectors
  public static let hexagon_vlcr = Pass("hexagon-vlcr")
  /// Hexagon Hardware Loops
  public static let hwloops = Pass("hwloops")
  /// Expand indirectbr instructions
  public static let indirectbr_expand = Pass("indirectbr-expand")
  /// Infer address spaces
  public static let infer_address_spaces = Pass("infer-address-spaces")
  /// Combine redundant instructions
  public static let instcombine = Pass("instcombine")
  /// Select target instructions out of generic instructions
  public static let instruction_select = Pass("instruction-select")
  /// Remove redundant instructions
  public static let instsimplify = Pass("instsimplify")
  /// Lower interleaved memory accesses to target specific intrinsics
  public static let interleaved_access = Pass("interleaved-access")
  /// Combine interleaved loads into wide loads and shufflevector instructions
  public static let interleaved_load_combine = Pass("interleaved-load-combine")
  /// Interval Partition Construction
  public static let intervals = Pass("intervals")
  /// ir-similarity-identifier
  public static let ir_similarity_identifier = Pass("ir-similarity-identifier")
  /// IRTranslator LLVM IR -> MI
  public static let irtranslator = Pass("irtranslator")
  /// Induction Variable Users
  public static let iv_users = Pass("iv-users")
  /// Instrument function entry with call to __CheckForDebuggerJustMyCode
  public static let jmc_instrumenter = Pass("jmc-instrumenter")
  /// Insert KCFI indirect call checks
  public static let kcfi = Pass("kcfi")
  /// Lanai DAG->DAG Pattern Instruction Selection
  public static let lanai_isel = Pass("lanai-isel")
  /// Lazy Block Frequency Analysis
  public static let lazy_block_freq = Pass("lazy-block-freq")
  /// Lazy Branch Probability Analysis
  public static let lazy_branch_prob = Pass("lazy-branch-prob")
  /// Lazy Value Information Analysis
  public static let lazy_value_info = Pass("lazy-value-info")
  /// Loop-Closed SSA Form Pass
  public static let lcssa = Pass("lcssa")
  /// LCSSA Verifier
  public static let lcssa_verification = Pass("lcssa-verification")
  /// Legalize the Machine IR a function's Machine IR
  public static let legalizer = Pass("legalizer")
  /// Loop Invariant Code Motion
  /// This pass is a loop invariant code motion and memory promotion pass.
  public static let licm = Pass("licm")
  /// Live Interval Analysis
  public static let liveintervals = Pass("liveintervals")
  /// Live Register Matrix
  public static let liveregmatrix = Pass("liveregmatrix")
  /// Live Stack Slot Analysis
  public static let livestacks = Pass("livestacks")
  /// Live Variable Analysis
  public static let livevars = Pass("livevars")
  /// Vectorize load and store instructions
  public static let load_store_vectorizer = Pass("load-store-vectorizer")
  /// Generic memory optimizations
  public static let loadstore_opt = Pass("loadstore-opt")
  /// Move/duplicate certain instructions close to their use
  public static let localizer = Pass("localizer")
  /// LoongArch DAG->DAG Pattern Instruction Selection
  public static let loongarch_isel = Pass("loongarch-isel")
  /// LoongArch Pre-RA pseudo instruction expansion pass
  public static let loongarch_prera_expand_pseudo = Pass("loongarch-prera-expand-pseudo")
  /// Loop Data Prefetch
  public static let loop_data_prefetch = Pass("loop-data-prefetch")
  /// Extract loops into new functions
  public static let loop_extract = Pass("loop-extract")
  /// Extract at most one loop into a new function
  public static let loop_extract_single = Pass("loop-extract-single")
  /// Loop Strength Reduction
  public static let loop_reduce = Pass("loop-reduce")
  /// Rotate Loops
  public static let loop_rotate = Pass("loop-rotate")
  /// Canonicalize natural loops
  public static let loop_simplify = Pass("loop-simplify")
  /// Unroll loops
  public static let loop_unroll = Pass("loop-unroll")
  /// Natural Loop Information
  public static let loops = Pass("loops")
  /// Lower AMX intrinsics
  public static let lower_amx_intrinsics = Pass("lower-amx-intrinsics")
  /// Lower AMX type for load/store
  public static let lower_amx_type = Pass("lower-amx-type")
  /// Lower constant intrinsics
  public static let lower_constant_intrinsics = Pass("lower-constant-intrinsics")
  /// Lower @llvm.global_dtors via `__cxa_atexit`
  public static let lower_global_dtors = Pass("lower-global-dtors")
  /// Lower atomic intrinsics to non-atomic form
  public static let loweratomic = Pass("loweratomic")
  /// Lower invoke and unwind, for unwindless code generators
  public static let lowerinvoke = Pass("lowerinvoke")
  /// Lower SwitchInst's to branches
  public static let lowerswitch = Pass("lowerswitch")
  /// Tile Copy Lowering
  public static let lowertilecopy = Pass("lowertilecopy")
  /// Machine Block Frequency Analysis
  public static let machine_block_freq = Pass("machine-block-freq")
  /// Machine Branch Probability Analysis
  public static let machine_branch_prob = Pass("machine-branch-prob")
  /// Machine Cycle Info Analysis
  public static let machine_cycles = Pass("machine-cycles")
  /// Machine Dominance Frontier Construction
  public static let machine_domfrontier = Pass("machine-domfrontier")
  /// Machine Natural Loop Construction
  public static let machine_loops = Pass("machine-loops")
  /// Machine Trace Metrics
  public static let machine_trace_metrics = Pass("machine-trace-metrics")
  /// MachineDominator Tree Construction
  public static let machinedomtree = Pass("machinedomtree")
  /// MachinePostDominator Tree Construction
  public static let machinepostdomtree = Pass("machinepostdomtree")
  /// Promote Memory to Register
  public static let mem2reg = Pass("mem2reg")
  /// Memory Dependence Analysis
  public static let memdep = Pass("memdep")
  /// Memory SSA
  public static let memoryssa = Pass("memoryssa")
  /// Merge contiguous icmps into a memcmp
  public static let mergeicmps = Pass("mergeicmps")
  /// MicroMips instruction size reduce pass
  public static let micromips_reduce_size = Pass("micromips-reduce-size")
  /// Expand out of range branch instructions and fix forbidden slot hazards
  public static let mips_branch_expansion = Pass("mips-branch-expansion")
  /// Fill delay slot for MIPS
  public static let mips_delay_slot_filler = Pass("mips-delay-slot-filler")
  /// MIPS DAG->DAG Pattern Instruction Selection
  public static let mips_isel = Pass("mips-isel")
  /// Combine Mips machine instrs after legalization
  public static let mips_postlegalizer_combiner = Pass("mips-postlegalizer-combiner")
  /// Combine Mips machine instrs before legalization
  public static let mips_prelegalizer_combiner = Pass("mips-prelegalizer-combiner")
  /// Mips VR4300 mulmul bugfix
  public static let mips_vr4300_mulmul_fix = Pass("mips-vr4300-mulmul-fix")
  /// Module Summary Analysis
  public static let module_summary_analysis = Pass("module-summary-analysis")
  /// Module summary info
  public static let module_summary_info = Pass("module-summary-info")
  /// MSP430 DAG->DAG Pattern Instruction Selection
  public static let msp430_isel = Pass("msp430-isel")
  /// MVE lane interleaving
  public static let mve_laneinterleave = Pass("mve-laneinterleave")
  /// Transform predicated vector loops to use MVE tail predication
  public static let mve_tail_predication = Pass("mve-tail-predication")
  /// Nary reassociation
  public static let nary_reassociate = Pass("nary-reassociate")
  /// NVPTX Address space based Alias Analysis
  public static let nvptx_aa = Pass("nvptx-aa")
  /// NVPTX Address space based Alias Analysis Wrapper
  public static let nvptx_aa_wrapper = Pass("nvptx-aa-wrapper")
  /// Assign valid PTX names to globals
  public static let nvptx_assign_valid_global_names = Pass("nvptx-assign-valid-global-names")
  /// Lower atomics of local memory to simple load/stores
  public static let nvptx_atomic_lower = Pass("nvptx-atomic-lower")
  /// NVPTX DAG->DAG Pattern Instruction Selection
  public static let nvptx_isel = Pass("nvptx-isel")
  /// Lower aggregate copies, and llvm.mem intrinsics into loops
  public static let nvptx_lower_aggr_copies = Pass("nvptx-lower-aggr-copies")
  /// Lower Alloca
  public static let nvptx_lower_alloca = Pass("nvptx-lower-alloca")
  /// Lower arguments (NVPTX)
  public static let nvptx_lower_args = Pass("nvptx-lower-args")
  /// Lower ctors and dtors for NVPTX
  public static let nvptx_lower_ctor_dtor = Pass("nvptx-lower-ctor-dtor")
  /// Lower Unreachable
  public static let nvptx_lower_unreachable = Pass("nvptx-lower-unreachable")
  /// NVPTX ProxyReg Erasure
  public static let nvptx_proxyreg_erasure = Pass("nvptx-proxyreg-erasure")
  /// Add !range metadata to NVVM intrinsics.
  public static let nvvm_intr_range = Pass("nvvm-intr-range")
  /// Replace occurrences of __nvvm_reflect() calls with 0/1
  public static let nvvm_reflect = Pass("nvvm-reflect")
  /// Optimization Remark Emitter
  public static let opt_remark_emitter = Pass("opt-remark-emitter")
  /// R600 Packetizer
  public static let packets = Pass("packets")
  /// Partially inline calls to library functions
  public static let partially_inline_libcalls = Pass("partially-inline-libcalls")
  /// Phi Values Analysis
  public static let phi_values = Pass("phi-values")
  /// Place Backedge Safepoints
  public static let place_backedge_safepoints_impl = Pass("place-backedge-safepoints-impl")
  /// Polly - Generate an AST from the SCoP (isl)
  public static let polly_ast = Pass("polly-ast")
  /// Polly - Run canonicalization passes
  public static let polly_canonicalize = Pass("polly-canonicalize")
  /// Polly - Create LLVM-IR from SCoPs
  public static let polly_codegen = Pass("polly-codegen")
  /// Polly - Remove dead iterations
  public static let polly_dce = Pass("polly-dce")
  /// Polly - DeLICM/DePRE
  public static let polly_delicm = Pass("polly-delicm")
  /// Polly - Calculate dependences
  public static let polly_dependences = Pass("polly-dependences")
  /// Polly - Detect static control parts (SCoPs)
  public static let polly_detect = Pass("polly-detect")
  /// Polly - Dump Module
  public static let polly_dump_module = Pass("polly-dump-module")
  /// Polly - Export Scops as JSON (Writes a .jscop file for each Scop)
  public static let polly_export_jscop = Pass("polly-export-jscop")
  /// Polly - Flatten schedule
  public static let polly_flatten_schedule = Pass("polly-flatten-schedule")
  /// Polly - Calculate dependences for all the SCoPs of a function
  public static let polly_function_dependences = Pass("polly-function-dependences")
  /// Polly - Create polyhedral description of all Scops of a function
  public static let polly_function_scops = Pass("polly-function-scops")
  /// Polly - Import Scops from JSON (Reads a .jscop file for each Scop)
  public static let polly_import_jscop = Pass("polly-import-jscop")
  /// Polly - Maximal static expansion of SCoP
  public static let polly_mse = Pass("polly-mse")
  /// Polly - Optimize schedule of SCoP
  public static let polly_opt_isl = Pass("polly-opt-isl")
  /// Polly - Forward operand tree
  public static let polly_optree = Pass("polly-optree")
  /// Polly - Prepare code for polly
  public static let polly_prepare = Pass("polly-prepare")
  /// Polly - Print the AST from a SCoP (isl)
  public static let polly_print_ast = Pass("polly-print-ast")
  /// Polly - Print DeLICM/DePRE
  public static let polly_print_delicm = Pass("polly-print-delicm")
  /// Polly - Print dependences
  public static let polly_print_dependences = Pass("polly-print-dependences")
  /// Polly - Print static control parts (SCoPs)
  public static let polly_print_detect = Pass("polly-print-detect")
  /// Polly - Print flattened schedule
  public static let polly_print_flatten_schedule = Pass("polly-print-flatten-schedule")
  /// Polly - Print dependences for all the SCoPs of a function
  public static let polly_print_function_dependences = Pass("polly-print-function-dependences")
  /// Polly - Print polyhedral description of all Scops of a function
  public static let polly_print_function_scops = Pass("polly-print-function-scops")
  /// Polly - Print Scop import result
  public static let polly_print_import_jscop = Pass("polly-print-import-jscop")
  /// Polly - Print optimizer schedule of SCoP
  public static let polly_print_opt_isl = Pass("polly-print-opt-isl")
  /// Polly - Print forward operand tree result
  public static let polly_print_optree = Pass("polly-print-optree")
  /// Polly - Print polyhedral description of Scops
  public static let polly_print_scops = Pass("polly-print-scops")
  /// Polly - Print Simplify actions
  public static let polly_print_simplify = Pass("polly-print-simplify")
  /// Polly - Prune unprofitable SCoPs
  public static let polly_prune_unprofitable = Pass("polly-prune-unprofitable")
  /// inline functions based on how much of the function is a scop.
  public static let polly_scop_inliner = Pass("polly-scop-inliner")
  /// Polly - Create polyhedral description of Scops
  public static let polly_scops = Pass("polly-scops")
  /// Polly - Simplify
  public static let polly_simplify = Pass("polly-simplify")
  /// Polly - Interface to polyhedral analysis engine
  public static let polyhedral_info = Pass("polyhedral-info")
  /// Post-Dominator Tree Construction
  public static let postdomtree = Pass("postdomtree")
  /// PowerPC Expand Atomic
  public static let ppc_atomic_expand = Pass("ppc-atomic-expand")
  /// Convert i1 constants to i32/i64 if they are returned
  public static let ppc_bool_ret_to_int = Pass("ppc-bool-ret-to-int")
  /// Branch Coalescing
  public static let ppc_branch_coalescing = Pass("ppc-branch-coalescing")
  /// PowerPC Branch Selector
  public static let ppc_branch_select = Pass("ppc-branch-select")
  /// PowerPC CTR loops generation
  public static let ppc_ctrloops = Pass("ppc-ctrloops")
  /// PowerPC Early-Return Creation
  public static let ppc_early_ret = Pass("ppc-early-ret")
  /// PowerPC Expand ISEL Generation
  public static let ppc_expand_isel = Pass("ppc-expand-isel")
  /// Generate Scalar MASS entries
  public static let ppc_gen_scalar_mass = Pass("ppc-gen-scalar-mass")
  /// PowerPC DAG->DAG Pattern Instruction Selection
  public static let ppc_isel = Pass("ppc-isel")
  /// Prepare loop for ppc preferred instruction forms
  public static let ppc_loop_instr_form_prep = Pass("ppc-loop-instr-form-prep")
  /// Lower MASSV entries
  public static let ppc_lower_massv_entries = Pass("ppc-lower-massv-entries")
  /// PPC Merge String Pool
  public static let ppc_merge_strings = Pass("ppc-merge-strings")
  /// PowerPC MI Peephole Optimization
  public static let ppc_mi_peepholes = Pass("ppc-mi-peepholes")
  /// PowerPC Pre-Emit Peephole
  public static let ppc_pre_emit_peephole = Pass("ppc-pre-emit-peephole")
  /// PowerPC Reduce CR logical Operation
  public static let ppc_reduce_cr_ops = Pass("ppc-reduce-cr-ops")
  /// PowerPC TLS Dynamic Call Fixup
  public static let ppc_tls_dynamic_call = Pass("ppc-tls-dynamic-call")
  /// PowerPC TOC Register Dependencies
  public static let ppc_toc_reg_deps = Pass("ppc-toc-reg-deps")
  /// PowerPC VSX Copy Legalization
  public static let ppc_vsx_copy = Pass("ppc-vsx-copy")
  /// PowerPC VSX FMA Mutation
  public static let ppc_vsx_fma_mutate = Pass("ppc-vsx-fma-mutate")
  /// PowerPC VSX Swap Removal
  public static let ppc_vsx_swaps = Pass("ppc-vsx-swaps")
  /// Pre-ISel Intrinsic Lowering
  public static let pre_isel_intrinsic_lowering = Pass("pre-isel-intrinsic-lowering")
  /// Print function to stderr
  public static let print_function = Pass("print-function")
  /// Print module to stderr
  public static let print_module = Pass("print-module")
  /// Polly - Print interface to polyhedral analysis engine analysis
  public static let print_polyhedral_info = Pass("print-polyhedral-info")
  /// Profile summary info
  public static let profile_summary_info = Pass("profile-summary-info")
  /// Insert pseudo probe annotations for value profiling
  public static let pseudo_probe_inserter = Pass("pseudo-probe-inserter")
  /// R600ExpandSpecialInstrs
  public static let r600_expand_special_instrs = Pass("r600-expand-special-instrs")
  /// R600 Control Flow Finalizer
  public static let r600cf = Pass("r600cf")
  /// R600 Clause Merge
  public static let r600mergeclause = Pass("r600mergeclause")
  /// ReachingDefAnalysis
  public static let reaching_deps_analysis = Pass("reaching-deps-analysis")
  /// Reassociate expressions
  /// This pass reassociates commutative expressions in an order that
  /// is designed to promote better constant propagation, GCSE, LICM, PRE, etc.
  ///
  /// For example:
  /// ```
  /// 4 + (x + 5)  ->  x + (4 + 5)
  /// ```
  public static let reassociate = Pass("reassociate")
  /// Assign register bank of generic virtual registers
  public static let regbankselect = Pass("regbankselect")
  /// Detect single entry single exit regions
  public static let regions = Pass("regions")
  /// Replace intrinsics with calls to vector library
  public static let replace_with_veclib = Pass("replace-with-veclib")
  /// Rewrite Partial Register Uses
  public static let rewrite_partial_reg_uses = Pass("rewrite-partial-reg-uses")
  /// Combine RISC-V machine instrs before legalization
  public static let riscv_O0_prelegalizer_combiner = Pass("riscv-O0-prelegalizer-combiner")
  /// RISC-V CodeGenPrepare
  public static let riscv_codegenprepare = Pass("riscv-codegenprepare")
  /// RISC-V Dead register definitions
  public static let riscv_dead_defs = Pass("riscv-dead-defs")
  /// RISC-V pseudo instruction expansion pass
  public static let riscv_expand_pseudo = Pass("riscv-expand-pseudo")
  /// RISC-V post-regalloc pseudo instruction expansion pass
  public static let riscv_expand_pseudolisimm32 = Pass("riscv-expand-pseudolisimm32")
  /// RISC-V Fold Masks
  public static let riscv_fold_masks = Pass("riscv-fold-masks")
  /// RISC-V gather/scatter lowering pass
  public static let riscv_gather_scatter_lowering = Pass("riscv-gather-scatter-lowering")
  /// RISC-V init undef pass
  public static let riscv_init_undef = Pass("riscv-init-undef")
  /// RISC-V Insert Read/Write CSR Pass
  public static let riscv_insert_read_write_csr = Pass("riscv-insert-read-write-csr")
  /// RISC-V Insert VSETVLI pass
  public static let riscv_insert_vsetvli = Pass("riscv-insert-vsetvli")
  /// RISC-V Insert Write VXRM Pass
  public static let riscv_insert_write_vxrm = Pass("riscv-insert-write-vxrm")
  /// RISC-V DAG->DAG Pattern Instruction Selection
  public static let riscv_isel = Pass("riscv-isel")
  /// RISC-V Make Compressible
  public static let riscv_make_compressible = Pass("riscv-make-compressible")
  /// RISC-V Merge Base Offset
  public static let riscv_merge_base_offset = Pass("riscv-merge-base-offset")
  /// RISC-V Zcmp move merging pass
  public static let riscv_move_merge = Pass("riscv-move-merge")
  /// RISC-V Optimize W Instructions
  public static let riscv_opt_w_instrs = Pass("riscv-opt-w-instrs")
  /// Combine RISC-V MachineInstrs after legalization
  public static let riscv_postlegalizer_combiner = Pass("riscv-postlegalizer-combiner")
  /// Combine RISC-V machine instrs before legalization
  public static let riscv_prelegalizer_combiner = Pass("riscv-prelegalizer-combiner")
  /// RISC-V Pre-RA pseudo instruction expansion pass
  public static let riscv_prera_expand_pseudo = Pass("riscv-prera-expand-pseudo")
  /// RISC-V Zcmp Push/Pop optimization pass
  public static let riscv_push_pop_opt = Pass("riscv-push-pop-opt")
  /// Safe Stack instrumentation pass
  public static let safe_stack = Pass("safe-stack")
  /// Scalar Evolution Analysis
  public static let scalar_evolution = Pass("scalar-evolution")
  /// Scalarize unsupported masked memory intrinsics
  public static let scalarize_masked_mem_intrin = Pass("scalarize-masked-mem-intrin")
  /// ScalarEvolution-based Alias Analysis
  public static let scev_aa = Pass("scev-aa")
  /// Scoped NoAlias Alias Analysis
  public static let scoped_noalias_aa = Pass("scoped-noalias-aa")
  /// Optimize selects
  public static let select_optimize = Pass("select-optimize")
  /// Split GEPs to a variadic base and a constant offset for better CSE
  public static let separate_const_offset_from_gep = Pass("separate-const-offset-from-gep")
  /// Annotate SI Control Flow
  public static let si_annotate_control_flow = Pass("si-annotate-control-flow")
  /// SI Fix SGPR copies
  public static let si_fix_sgpr_copies = Pass("si-fix-sgpr-copies")
  /// SI Fix VGPR copies
  public static let si_fix_vgpr_copies = Pass("si-fix-vgpr-copies")
  /// SI Fold Operands
  public static let si_fold_operands = Pass("si-fold-operands")
  /// SI Form memory clauses
  public static let si_form_memory_clauses = Pass("si-form-memory-clauses")
  /// SI Lower i1 Copies
  public static let si_i1_copies = Pass("si-i1-copies")
  /// SI Insert Hard Clauses
  public static let si_insert_hard_clauses = Pass("si-insert-hard-clauses")
  /// SI Insert Waitcnts
  public static let si_insert_waitcnts = Pass("si-insert-waitcnts")
  /// SI insert s_cbranch_execz instructions
  public static let si_late_branch_lowering = Pass("si-late-branch-lowering")
  /// SI Load Store Optimizer
  public static let si_load_store_opt = Pass("si-load-store-opt")
  /// SI lower control flow
  public static let si_lower_control_flow = Pass("si-lower-control-flow")
  /// SI lower SGPR spill instructions
  public static let si_lower_sgpr_spills = Pass("si-lower-sgpr-spills")
  /// SI Lower WWM Copies
  public static let si_lower_wwm_copies = Pass("si-lower-wwm-copies")
  /// SI Memory Legalizer
  public static let si_memory_legalizer = Pass("si-memory-legalizer")
  /// Insert required mode register values
  public static let si_mode_register = Pass("si-mode-register")
  /// SI Optimize VGPR LiveRange
  public static let si_opt_vgpr_liverange = Pass("si-opt-vgpr-liverange")
  /// SI optimize exec mask operations
  public static let si_optimize_exec_masking = Pass("si-optimize-exec-masking")
  /// SI optimize exec mask operations pre-RA
  public static let si_optimize_exec_masking_pre_ra = Pass("si-optimize-exec-masking-pre-ra")
  /// SI Peephole SDWA
  public static let si_peephole_sdwa = Pass("si-peephole-sdwa")
  /// SI post-RA bundler
  public static let si_post_ra_bundler = Pass("si-post-ra-bundler")
  /// SI Pre-allocate WWM Registers
  public static let si_pre_allocate_wwm_regs = Pass("si-pre-allocate-wwm-regs")
  /// SI peephole optimizations
  public static let si_pre_emit_peephole = Pass("si-pre-emit-peephole")
  /// SI Shrink Instructions
  public static let si_shrink_instructions = Pass("si-shrink-instructions")
  /// SI Whole Quad Mode
  public static let si_wqm = Pass("si-wqm")
  /// Simplify the CFG
  public static let simplifycfg = Pass("simplifycfg")
  /// Code sinking
  public static let sink = Pass("sink")
  /// Prepare SjLj exceptions
  public static let sjlj_eh_prepare = Pass("sjlj-eh-prepare")
  /// Slot index numbering
  public static let slotindexes = Pass("slotindexes")
  /// Straight line strength reduction
  public static let slsr = Pass("slsr")
  /// SPARC DAG->DAG Pattern Instruction Selection
  public static let sparc_isel = Pass("sparc-isel")
  /// Speculatively execute instructions
  public static let speculative_execution = Pass("speculative-execution")
  /// Scalar Replacement Of Aggregates
  public static let sroa = Pass("sroa")
  /// Insert stack protectors
  public static let stack_protector = Pass("stack-protector")
  /// Stack Safety Analysis
  public static let stack_safety = Pass("stack-safety")
  /// Stack Safety Local Analysis
  public static let stack_safety_local = Pass("stack-safety-local")
  /// Structurize the CFG
  public static let structurizecfg = Pass("structurizecfg")
  /// SystemZ Comparison Elimination
  public static let systemz_elim_compare = Pass("systemz-elim-compare")
  /// SystemZ DAG->DAG Pattern Instruction Selection
  public static let systemz_isel = Pass("systemz-isel")
  /// SystemZ Local Dynamic TLS Access Clean-up
  public static let systemz_ld_cleanup = Pass("systemz-ld-cleanup")
  /// SystemZ Long Branch
  public static let systemz_long_branch = Pass("systemz-long-branch")
  /// SystemZ Post Rewrite pass
  public static let systemz_post_rewrite = Pass("systemz-post-rewrite")
  /// SystemZ Instruction Shortening
  public static let systemz_shorten_inst = Pass("systemz-shorten-inst")
  /// SystemZ Test Data Class optimization
  public static let systemz_tdc = Pass("systemz-tdc")
  /// Tail Call Elimination
  public static let tailcallelim = Pass("tailcallelim")
  /// Target Library Information
  public static let targetlibinfo = Pass("targetlibinfo")
  /// Target Pass Configuration
  public static let targetpassconfig = Pass("targetpassconfig")
  /// Type-Based Alias Analysis
  public static let tbaa = Pass("tbaa")
  /// Thumb2 instruction size reduce pass
  public static let thumb2_reduce_size = Pass("thumb2-reduce-size")
  /// Tile Register Configure
  public static let tileconfig = Pass("tileconfig")
  /// Tile Register Pre-configure
  public static let tilepreconfig = Pass("tilepreconfig")
  /// TLS Variable Hoist
  public static let tlshoist = Pass("tlshoist")
  /// Target Transform Information
  public static let tti = Pass("tti")
  /// Uniformity Analysis
  public static let uniformity = Pass("uniformity")
  /// Fixup each natural loop to have a single exit block
  public static let unify_loop_exits = Pass("unify-loop-exits")
  /// Remove unreachable machine basic blocks
  public static let unreachable_mbb_elimination = Pass("unreachable-mbb-elimination")
  /// Remove unreachable blocks from the CFG
  public static let unreachableblockelim = Pass("unreachableblockelim")
  /// VE DAG->DAG Pattern Instruction Selection
  public static let ve_isel = Pass("ve-isel")
  /// R600 Vector Reg Merger
  public static let vec_merger = Pass("vec-merger")
  /// Module Verifier
  public static let verify = Pass("verify")
  /// Safepoint IR Verifier
  public static let verify_safepoint_ir = Pass("verify-safepoint-ir")
  /// View call graph
  public static let view_callgraph = Pass("view-callgraph")
  /// View dominance tree of function
  public static let view_dom = Pass("view-dom")
  /// View dominance tree of function (with no function bodies)
  public static let view_dom_only = Pass("view-dom-only")
  /// View postdominance tree of function
  public static let view_postdom = Pass("view-postdom")
  /// View postdominance tree of function (with no function bodies)
  public static let view_postdom_only = Pass("view-postdom-only")
  /// View regions of function
  public static let view_regions = Pass("view-regions")
  /// View regions of function (with no function bodies)
  public static let view_regions_only = Pass("view-regions-only")
  /// Polly - View Scops of function
  public static let view_scops = Pass("view-scops")
  /// Polly - View Scops of function (with no function bodies)
  public static let view_scops_only = Pass("view-scops-only")
  /// Virtual Register Map
  public static let virtregmap = Pass("virtregmap")
  /// Add prototypes to prototypes-less functions
  public static let wasm_add_missing_prototypes = Pass("wasm-add-missing-prototypes")
  /// Move ARGUMENT instructions for WebAssembly
  public static let wasm_argument_move = Pass("wasm-argument-move")
  /// Reorders blocks in topological order
  public static let wasm_cfg_sort = Pass("wasm-cfg-sort")
  /// Insert BLOCK/LOOP/TRY markers for WebAssembly scopes
  public static let wasm_cfg_stackify = Pass("wasm-cfg-stackify")
  /// Ensures debug_value's that have been stackified become stack relative
  public static let wasm_debug_fixup = Pass("wasm-debug-fixup")
  /// Prepare WebAssembly exceptions
  public static let wasm_eh_prepare = Pass("wasm-eh-prepare")
  /// WebAssembly Exception Information
  public static let wasm_exception_info = Pass("wasm-exception-info")
  /// Convert registers to WebAssembly locals
  public static let wasm_explicit_locals = Pass("wasm-explicit-locals")
  /// Removes range checks and sets br_table default targets
  public static let wasm_fix_br_table_defaults = Pass("wasm-fix-br-table-defaults")
  /// Fix mismatching bitcasts for WebAssembly
  public static let wasm_fix_function_bitcasts = Pass("wasm-fix-function-bitcasts")
  /// Removes irreducible control flow
  public static let wasm_fix_irreducible_control_flow = Pass("wasm-fix-irreducible-control-flow")
  /// WebAssembly Instruction Selection
  public static let wasm_isel = Pass("wasm-isel")
  /// WebAssembly Late Exception Preparation
  public static let wasm_late_eh_prepare = Pass("wasm-late-eh-prepare")
  /// Lowers br_unless into inverted br_if
  public static let wasm_lower_br_unless = Pass("wasm-lower-br_unless")
  /// WebAssembly Lower Emscripten Exceptions / Setjmp / Longjmp
  public static let wasm_lower_em_ehsjlj = Pass("wasm-lower-em-ehsjlj")
  /// WebAssembly Lower RefTypes Int-Ptr Conversions
  public static let wasm_lower_reftypes_intptr_conv = Pass("wasm-lower-reftypes-intptr-conv")
  /// Collects information ahead of time for MC lowering
  public static let wasm_mclower_prepass = Pass("wasm-mclower-prepass")
  /// Optimize memory intrinsic result values for WebAssembly
  public static let wasm_mem_intrinsic_results = Pass("wasm-mem-intrinsic-results")
  /// WebAssembly Nullify DBG_VALUE_LISTs
  public static let wasm_nullify_dbg_value_lists = Pass("wasm-nullify-dbg-value-lists")
  /// Optimize LiveIntervals for WebAssembly
  public static let wasm_optimize_live_intervals = Pass("wasm-optimize-live-intervals")
  /// Optimize calls with "returned" attributes for WebAssembly
  public static let wasm_optimize_returned = Pass("wasm-optimize-returned")
  /// WebAssembly peephole optimizations
  public static let wasm_peephole = Pass("wasm-peephole")
  /// Minimize number of registers used
  public static let wasm_reg_coloring = Pass("wasm-reg-coloring")
  /// Assigns WebAssembly register numbers for virtual registers
  public static let wasm_reg_numbering = Pass("wasm-reg-numbering")
  /// Reorder instructions to use the WebAssembly value stack
  public static let wasm_reg_stackify = Pass("wasm-reg-stackify")
  /// Replace physical registers with virtual registers
  public static let wasm_replace_phys_regs = Pass("wasm-replace-phys-regs")
  /// Set the p2align operands for WebAssembly loads and stores
  public static let wasm_set_p2align_operands = Pass("wasm-set-p2align-operands")
  /// Prepare Windows exceptions
  public static let win_eh_prepare = Pass("win-eh-prepare")
  /// Write Bitcode
  public static let write_bitcode = Pass("write-bitcode")
  /// Machine code sinking
  public static let x86_avoid_SFB = Pass("x86-avoid-SFB")
  /// X86 avoid trailing call pass
  public static let x86_avoid_trailing_call = Pass("x86-avoid-trailing-call")
  /// X86 Call Frame Optimization
  public static let x86_cf_opt = Pass("x86-cf-opt")
  /// X86 cmov Conversion
  public static let x86_cmov_conversion = Pass("x86-cmov-conversion")
  /// X86 FP Stackifier
  public static let x86_codegen = Pass("x86-codegen")
  /// Compressing EVEX instrs when possible
  public static let x86_compress_evex = Pass("x86-compress-evex")
  /// X86 Domain Reassignment Pass
  public static let x86_domain_reassignment = Pass("x86-domain-reassignment")
  /// X86 Execution Domain Fix
  public static let x86_execution_domain_fix = Pass("x86-execution-domain-fix")
  /// X86 LEA Fixup
  public static let x86_fixup_LEAs = Pass("x86-fixup-LEAs")
  /// X86 Byte/Word Instruction Fixup
  public static let x86_fixup_bw_insts = Pass("x86-fixup-bw-insts")
  /// x86-fixup-setcc
  public static let x86_fixup_setcc = Pass("x86-fixup-setcc")
  /// X86 EFLAGS copy lowering
  public static let x86_flags_copy_lowering = Pass("x86-flags-copy-lowering")
  /// X86 DAG->DAG Instruction Selection
  public static let x86_isel = Pass("x86-isel")
  /// X86 LVI load hardening
  public static let x86_lvi_load = Pass("x86-lvi-load")
  /// X86 LVI ret hardener
  public static let x86_lvi_ret = Pass("x86-lvi-ret")
  /// X86 optimize LEA pass
  public static let x86_optimize_LEAs = Pass("x86-optimize-LEAs")
  /// X86 Partial Reduction
  public static let x86_partial_reduction = Pass("x86-partial-reduction")
  /// X86 pseudo instruction expansion pass
  public static let x86_pseudo = Pass("x86-pseudo")
  /// X86 Return Thunks
  public static let x86_return_thunks = Pass("x86-return-thunks")
  /// X86 Speculative Execution Side Effect Suppression
  public static let x86_seses = Pass("x86-seses")
  /// X86 speculative load hardener
  public static let x86_slh = Pass("x86-slh")
  /// Insert stores for EH state numbers
  public static let x86_winehstate = Pass("x86-winehstate")
  /// Argument Stack Rebase
  public static let x86argumentstackrebase = Pass("x86argumentstackrebase")
  /// XCore DAG->DAG Pattern Instruction Selection
  public static let xcore_isel = Pass("xcore-isel")
  
}
