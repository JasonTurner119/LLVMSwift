#if SWIFT_PACKAGE
import cllvm
import llvmshims
#endif

/// Implements a pass manager, pipeliner, and executor for a set of
/// user-provided optimization passes.
///
/// A `PipelineManager` handles the creation of a related set of optimization
/// passes called a "pipeline".  Grouping passes is done for multiple reasons,
/// chief among them is that optimizer passes are extremely sensitive to their
/// ordering relative to other passes.  In addition, pass groupings allow for
/// the clean segregation of otherwise unrelated passes.  For example, a
/// pipeline might consist of "mandatory" passes such as Jump Threading, LICM,
/// and DCE in one pipeline and "diagnostic" passes in another.
public final class PipelineManager {
  
  /// The module for this pass pipeline.
  public let module: Module
  /// The machine for this pass pipeline.
  public let machine: TargetMachine
  /// The pipeline stages registered with this pass pipeliner.
  public private(set) var stages: [String]
  
  private var stageMapping: [String: PassPipeline]
  private var frozen: Bool = false
  
  
  /// Initializes a new, empty pipeline manager.
  ///
  /// - Parameter module: The module the pipeliner will run over.
  /// - Parameter module: The machine this pass pipeline will optimize for.
  public init(module: Module, machine: TargetMachine) {
    self.machine = machine
    self.module = module
    self.stages = []
    self.stageMapping = [:]
  }
  
  /// Executes the pipelines within the pipeline manager.
  ///
  /// - Parameter pipelineMask: The names of the subset of pipelines that should
  ///   be executed.  If the mask is empty, all pipelines will be executed.
  public func execute(mask pipelineMask: Set<String> = []) {
    precondition(!self.frozen, "Cannot execute a frozen pipeline!")

    self.frozen = true
    defer { self.frozen = false }

    stageLoop: for stage in self.stages {
      guard pipelineMask.isEmpty || pipelineMask.contains(stage) else {
        continue
      }

      guard let pipeline = self.stageMapping[stage] else {
        fatalError("Unregistered pass stage?")
      }
      
      pipeline.execute(module: module, machine: machine)
    }
  }
  
  /// Adds a named pipeline to the pipeline manager.
  ///
  /// - parameter name: The name of the pipline.
  /// - parameter pipeline: The pipleine to add.
  public func addPipeline(_ name: String, _ pipeline: PassPipeline) {
    self.stages.append(name)
    self.stageMapping[name] = pipeline
  }
  
}

// MARK: Deprecated

extension PipelineManager {
  
  /// A helper object that can add passes to a pipeline.
  ///
  /// To add a new pass, call `add(_:)`.
  @available(*, deprecated, message: "The 'addStage(_:_:)' method is deprecated. Use 'addPipeline(_:_:)' instead.")
  public final class Builder {
    fileprivate var passes: [Pass] = []

    fileprivate init() {}

    /// Appends a pass to the current pipeline.
    public func add(_ type: Pass) {
      self.passes.append(type)
    }
  }
  
  /// Initializes a new, empty pipeliner.
  /// A runtime trap will occur if `TargetMachine()` throws.
  ///
  /// - Parameter module: The module the pipeliner will run over.
  @available(*, deprecated, renamed: "init(module:machine:)", message: "Supply a machine to initialize a pass pipeliner.")
  public convenience init(module: Module) {
    self.init(module: module, machine: try! TargetMachine())
  }

  /// Appends a stage to the pipeliner.
  ///
  /// The staging function provides a `Builder` object into which the types
  /// of passes for a given pipeline are inserted.
  ///
  /// - Parameters:
  ///   - name: The name of the pipeline stage.
  ///   - stager: A builder function.
  @available(*, deprecated, message: "Use 'addPipeline(_:_:)' instead.'")
  public func addStage(_ name: String, _ stager: (Builder) -> Void) {
    precondition(!self.frozen, "Cannot add new stages to a frozen pipeline!")

    self.frozen = true
    defer { self.frozen = false }

    self.stages.append(name)
    let builder = Builder()
    stager(builder)
    self.stageMapping[name] = PassPipeline(builder.passes)
  }
  
  /// Adds a pipeline stage populated with function passes that LLVM considers
  /// standard for languages like C and C++.  Additional parameters are
  /// available to tune the overall behavior of the optimization pipeline at a
  /// macro level.
  ///
  /// - Parameters:
  ///   - name: The name of the pipeline stage.
  ///   - optimization: The level of optimization.
  ///   - size: The level of size optimization.
  @available(*, deprecated, message: "Pass a default pipleine to 'addPipeline(_:)' instead.")
  public func addStandardFunctionPipeline(
    _ name: String,
    optimization: CodeGenOptLevel = .`default`,
    size: CodeGenOptLevel = .none
  ) {
    switch optimization {
    case .none:
      self.addPipeline(name, .defaultO0)
    case .less:
      self.addPipeline(name, .defaultO1)
    case .default:
      self.addPipeline(name, .defaultO2)
    case .aggressive:
      self.addPipeline(name, .defaultO3)
    }
  }

  /// Adds a pipeline stage populated with module passes that LLVM considers
  /// standard for languages like C and C++.  Additional parameters are
  /// available to tune the overall behavior of the optimization pipeline at a
  /// macro level.
  ///
  /// - Parameters:
  ///   - name: The name of the pipeline stage.
  ///   - optimization: The level of optimization.
  ///   - size: The level of size optimization.
  @available(*, deprecated, message: "Pass a default pipleine to 'addPipeline(_:)' instead.")
  public func addStandardModulePipeline(
    _ name: String,
    optimization: CodeGenOptLevel = .`default`,
    size: CodeGenOptLevel = .none
  ) {
    switch optimization {
    case .none:
      self.addPipeline(name, .defaultO0)
    case .less:
      self.addPipeline(name, .defaultO1)
    case .default:
      self.addPipeline(name, .defaultO2)
    case .aggressive:
      self.addPipeline(name, .defaultO3)
    }
  }
}

@available(*, deprecated, renamed: "PipelineManager")
public typealias PassPipeliner = PipelineManager
