
 #if SWIFT_PACKAGE
import cllvm
#endif

// MARK: Deprecated

extension Pass {
  ///  This pass uses the SSA based Aggressive DCE algorithm.  This algorithm
  /// assumes instructions are dead until proven otherwise, which makes
  /// it more successful are removing non-obviously dead instructions.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let aggressiveDCE = Pass("")
  /// This pass uses a bit-tracking DCE algorithm in order to remove
  /// computations of dead bits.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let bitTrackingDCE = Pass("")
  /// Use assume intrinsics to set load/store alignments.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let alignmentFromAssumptions = Pass("")
  /// Merge basic blocks, eliminate unreachable blocks, simplify terminator
  /// instructions, etc.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let cfgSimplification = Pass("")
  /// This pass deletes stores that are post-dominated by must-aliased stores
  /// and are not loaded used between the stores.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let deadStoreElimination = Pass("")
  /// Converts vector operations into scalar operations.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let scalarizer = Pass("")
  /// This pass merges loads and stores in diamonds. Loads are hoisted into the
  /// header, while stores sink into the footer.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let mergedLoadStoreMotion = Pass("")
  /// Transform induction variables in a program to all use a single canonical
  /// induction variable per loop.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let indVarSimplify = Pass("")
  /// Combine instructions to form fewer, simple instructions. This pass does
  /// not modify the CFG, and has a tendency to make instructions dead, so a
  /// subsequent DCE pass is useful.
  ///
  /// This pass combines things like:
  /// ```asm
  /// %Y = add int 1, %X
  /// %Z = add int 1, %Y
  /// ```
  /// into:
  /// ```asm
  /// %Z = add int 2, %X
  /// ```
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let instructionCombining = Pass("")
  /// Thread control through mult-pred/multi-succ blocks where some preds
  /// always go to some succ. Thresholds other than minus one override the
  /// internal BB duplication default threshold.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let jumpThreading = Pass("")
  /// This pass performs DCE of non-infinite loops that it can prove are dead.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let loopDeletion = Pass("")
  /// This pass recognizes and replaces idioms in loops.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let loopIdiom = Pass("")
  /// This pass is a simple loop rotating pass.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let loopRotate = Pass("")
  /// This pass is a simple loop rerolling pass.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let loopReroll = Pass("")
  /// This pass is a simple loop unrolling pass.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let loopUnroll = Pass("")
  /// This pass is a simple loop unroll-and-jam pass.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let loopUnrollAndJam = Pass("")
  /// This pass is a simple loop unswitching pass.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let loopUnswitch = Pass("")
  /// This pass lowers atomic intrinsics to non-atomic form for use in a known
  /// non-preemptible environment.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let lowerAtomic = Pass("")
  /// This pass performs optimizations related to eliminating `memcpy` calls
  /// and/or combining multiple stores into memset's.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let memCpyOpt = Pass("")
  /// Tries to inline the fast path of library calls such as sqrt.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let partiallyInlineLibCalls = Pass("")
  /// This pass converts SwitchInst instructions into a sequence of chained
  /// binary branch instructions.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let lowerSwitch = Pass("")
  /// This pass is used to promote memory references to
  /// be register references. A simple example of the transformation performed
  /// by this pass is going from code like this:
  ///
  /// ```asm
  /// %X = alloca i32, i32 1
  /// store i32 42, i32 *%X
  /// %Y = load i32* %X
  /// ret i32 %Y
  /// ```
  ///
  /// To code like this:
  ///
  /// ```asm
  /// ret i32 42
  /// ```
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let promoteMemoryToRegister = Pass("")
  /// Adds DWARF discriminators to the IR.  Discriminators are
  /// used to decide what CFG path was taken inside sub-graphs whose instructions
  /// share the same line and column number information.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let addDiscriminators = Pass("")
  /// Sparse conditional constant propagation.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let sccp = Pass("")
  /// This pass eliminates call instructions to the current function which occur
  /// immediately before return instructions.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let tailCallElimination = Pass("")
  /// A worklist driven constant propagation pass.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let constantPropagation = Pass("")
  /// This pass is used to demote registers to memory references. It basically
  /// undoes the `.promoteMemoryToRegister` pass to make CFG hacking easier.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let demoteMemoryToRegister = Pass("")
  /// Propagate CFG-derived value information
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let correlatedValuePropagation = Pass("")
  /// This pass performs a simple and fast CSE pass over the dominator tree.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let earlyCSE = Pass("")
  ///  Removes `llvm.expect` intrinsics and creates "block_weights" metadata.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let lowerExpectIntrinsic = Pass("")
  /// Adds metadata to LLVM IR types and performs metadata-based
  /// Type-Based Alias Analysis (TBAA).
  ///
  /// TBAA requires that two pointers to objects of different types must never
  /// alias.  Because memory in LLVM is typeless, TBAA is performed using
  /// special metadata nodes describing aliasing relationships between types
  /// in the source language(s).
  ///
  /// To construct this metadata, see `MDBuilder`.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let typeBasedAliasAnalysis = Pass("")
  /// Adds metadata to LLVM IR types and performs metadata-based scoped no-alias
  /// analysis.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let scopedNoAliasAA = Pass("")
  /// LLVM's primary stateless and local alias analysis.
  ///
  /// Given a pointer value, walk the use-def chain to find out how that
  /// pointer is used.  The traversal terminates at global variables and
  /// aliases, stack allocations, and values of non-pointer types - referred
  /// to as "underlying objects". Analysis may reach multiple underlying object
  /// values because of branching control flow.  If the set of underlying
  /// objects for one pointer has a non-empty intersection with another, those
  /// two pointers are deemed `mayalias`.  Else, an empty intersection deems
  /// those pointers `noalias`.
  ///
  /// Basic Alias Analysis should generally be scheduled ahead of other
  /// AA passes.  This is because it is more conservative than other passes
  /// about declaring two pointers `mustalias`, and does so fairly efficiently.
  /// For example, loads through two members of a union with distinct types are
  /// declared by TBAA to be `noalias`, where BasicAA considers them
  /// `mustalias`.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let basicAliasAnalysis = Pass("")
  /// Performs alias and mod/ref analysis for internal global values that
  /// do not have their address taken.
  ///
  /// Internal global variables that are only loaded from may be marked as
  /// constants.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let globalsAliasAnalysis = Pass("")
  /// This pass is used to ensure that functions have at most one return
  /// instruction in them.  Additionally, it keeps track of which node is
  /// the new exit node of the CFG.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let unifyFunctionExitNodes = Pass("")
  /// Runs the LLVM IR Verifier to sanity check the results of passes.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let verifier = Pass("")
  /// A pass to inline and remove functions marked as "always_inline".
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let alwaysInliner = Pass("")
  /// This pass promotes "by reference" arguments to be passed by value if the
  /// number of elements passed is less than or equal to 3.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let argumentPromotion = Pass("")
  /// This function returns a new pass that merges duplicate global constants
  /// together into a single constant that is shared. This is useful because
  /// some passes (ie TraceValues) insert a lot of string constants into the
  /// program, regardless of whether or not they duplicate an existing string.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let constantMerge = Pass("")
  /// This pass removes arguments from functions which are not used by the body
  /// of the function.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let deadArgElimination = Pass("")
  /// This pass walks SCCs of the call graph in RPO to deduce and propagate
  /// function attributes. Currently it only handles synthesizing `norecurse`
  /// attributes.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let functionAttrs = Pass("")
  /// Uses a heuristic to inline direct function calls to small functions.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let functionInlining = Pass("")
  /// This transform is designed to eliminate unreachable internal globals
  /// (functions or global variables)
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let globalDCE = Pass("")
  /// This function returns a new pass that optimizes non-address taken internal
  /// globals.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let globalOptimizer = Pass("")
  /// This pass propagates constants from call sites into the bodies of
  /// functions.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let ipConstantPropagation = Pass("")
  /// This pass propagates constants from call sites into the bodies of
  /// functions, and keeps track of whether basic blocks are executable in the
  /// process.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let ipscc = Pass("")
  /// Return a new pass object which transforms invoke instructions into calls,
  /// if the callee can *not* unwind the stack.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let pruneEH = Pass("")
  /// This transformation attempts to discovery `alloca` allocations of aggregates that can be
  /// broken down into component scalar values.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let scalarReplacementOfAggregates = Pass("")
  /// This pass removes any function declarations (prototypes) that are not used.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let stripDeadPrototypes = Pass("")
  /// These functions removes symbols from functions and modules without
  /// touching symbols for debugging information.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let stripSymbols = Pass("")
  /// Performs a loop vectorization pass to widen instructions in loops to
  /// operate on multiple consecutive iterations.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let loopVectorize = Pass("")
  /// This pass performs a superword-level parallelism pass to combine
  /// similar independent instructions into vector instructions.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static let slpVectorize = Pass("")
  /// An invalid pass that crashes when added to the pass manager.
  @available(*, deprecated, message: "Use pass names from LLVM's new Pass Manager.")
  public static func invalid(reason: String) -> Pass { Pass("") }
  
  // TODO: Figure if these can be updated these to LLVM 18
  /// Working in conjunction with the linker, iterate through all functions and
  /// global values in the module and attempt to change their linkage from
  /// external to internal.
  ///
  /// To preserve the linkage of a global value, return `true` from the given
  /// callback.
  @available(*, deprecated)
  public static func internalize(mustPreserve: (IRGlobal) -> Bool) -> Pass { Pass("") }
  /// Working in conjunction with the linker, iterate through all functions and
  /// global values in the module and attempt to change their linkage from
  /// external to internal.
  ///
  /// When a function with the name "main" is encountered, if the value of
  /// `preserveMain` is `true`, "main" will not be internalized.
  @available(*, deprecated)
  public static func internalizeAll(preserveMain: Bool) -> Pass { Pass("") }
  
}
