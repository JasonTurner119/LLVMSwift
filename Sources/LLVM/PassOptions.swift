#if SWIFT_PACKAGE
import cllvm
#endif

/// A set of options for building optimization passes
public final class PassBuildOptions {
  
  internal let llvm: LLVMPassBuilderOptionsRef
  
  /// Create a default set of `PassBuildOptions`.
  public init() {
    self.llvm = LLVMCreatePassBuilderOptions()
  }
  
  deinit {
    LLVMDisposePassBuilderOptions(llvm)
  }
  
  public func setVerifyEach(_ verifyEach: Bool) {
    LLVMPassBuilderOptionsSetVerifyEach(llvm, verifyEach.llvm)
  }
  
  public func setDebugLogging(_ debugLogging: Bool) {
    LLVMPassBuilderOptionsSetDebugLogging(llvm, debugLogging.llvm)
  }
  
  public func setLoopInterleaving(_ loopInterleaving: Bool) {
    LLVMPassBuilderOptionsSetLoopInterleaving(llvm, loopInterleaving.llvm)
  }
  
  public func setLoopVectorization(_ loopVectorization: Bool) {
    LLVMPassBuilderOptionsSetLoopVectorization(llvm, loopVectorization.llvm)
  }
  
  public func setSLPVectorization(_ slpVectorization: Bool) {
    LLVMPassBuilderOptionsSetSLPVectorization(llvm, slpVectorization.llvm)
  }
  
  public func setLoopUnrolling(_ loopUnrolling: Bool) {
    LLVMPassBuilderOptionsSetLoopUnrolling(llvm, loopUnrolling.llvm)
  }
  
  public func setForgetAllSCEVInLoopUnroll(_ forgetAllSCEVInLoopUnroll: Bool) {
    LLVMPassBuilderOptionsSetForgetAllSCEVInLoopUnroll(llvm, forgetAllSCEVInLoopUnroll.llvm)
  }
  
  public func setLicmMssaOptCap(_ licmMssaOptCap: Int) {
    LLVMPassBuilderOptionsSetLicmMssaOptCap(llvm, UInt32(licmMssaOptCap))
  }
  
  public func setLicmMssaNoAccForPromotionCap(_ licmMssaNoAccForPromotionCap: Int) {
    LLVMPassBuilderOptionsSetLicmMssaNoAccForPromotionCap(llvm, UInt32(licmMssaNoAccForPromotionCap))
  }
  
  public func setCallGraphProfile(_ callGraphProfile: Bool) {
    LLVMPassBuilderOptionsSetCallGraphProfile(llvm, callGraphProfile.llvm)
  }
  
  public func setMergeFunctions(_ mergeFunctions: Bool) {
    LLVMPassBuilderOptionsSetMergeFunctions(llvm, mergeFunctions.llvm)
  }
  
  public func setInlinerThreshold(_ inlinerThreshold: Int) {
    LLVMPassBuilderOptionsSetInlinerThreshold(llvm, Int32(inlinerThreshold))
  }
  
}
