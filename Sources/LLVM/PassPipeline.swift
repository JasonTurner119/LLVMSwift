#if SWIFT_PACKAGE
import cllvm
#endif

/// A type that represents a sequence of optimization passes
public struct PassPipeline {
  
  internal var passes: [Pass]
  
  /// Construct a pipeline from an array of passes.
  ///
  /// - parameter passes: An array of passes which will be executed in
  /// order when the pipeline is executed.
  public init(_ passes: [Pass] = []) {
    self.passes = passes
  }
  
  /// A pipeline which approxomitely coresponds to `-O0`.
  static let defaultO0 = PassPipeline([Pass("default<O0>")])
  /// A pipeline which approxomitely coresponds to `-O1`.
  static let defaultO1 = PassPipeline([Pass("default<O1>")])
  /// A pipeline which approxomitely coresponds to `-O2`.
  static let defaultO2 = PassPipeline([Pass("default<O2>")])
  /// A pipeline which approxomitely coresponds to `-O3`.
  static let defaultO3 = PassPipeline([Pass("default<O3>")])
  /// A pipeline which approxomitely coresponds to `-Os`.
  static let defaultOs = PassPipeline([Pass("default<Os>")])
  /// A pipeline which approxomitely coresponds to `-Oz`.
  static let defaultOz = PassPipeline([Pass("default<Oz>")])
  
  /// Adds a pass to end end of this pipeline.
  ///
  /// - parameter pass: The pass to add to this pipeline.
  mutating func addPass(_ pass: Pass) {
    passes.append(pass)
  }
  
  /// Adds the passes from a pipeline to end end of this pipeline.
  ///
  /// - parameter pipeline: The pipeline to add to this pipeline.
  mutating func addPipeline(_ pipeline: PassPipeline) {
    passes.append(contentsOf: pipeline.passes)
  }
  
  /// Executes the optimization pass pipeline.
  ///
  /// - parameter module: The module to optimize.
  /// - parameter machine: The machine to optimize for.
  /// - parameter options: The pass build options to use.
  func execute(module: Module, machine: TargetMachine, options: PassBuildOptions = PassBuildOptions()) {
    guard !passes.isEmpty else { return }
    let passes = passes.map(\.string).joined(separator: ",")
    LLVMRunPasses(module.llvm, passes, machine.llvm, options.llvm)
  }
}
