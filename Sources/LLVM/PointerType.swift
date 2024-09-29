#if SWIFT_PACKAGE
import cllvm
#endif

/// `PointerType` is used to specify memory locations. Pointers are commonly
/// used to reference objects in memory.
///
/// `PointerType` may have an optional address space attribute defining the
/// numbered address space where the pointed-to object resides. The default
/// address space is number zero. The semantics of non-zero address spaces are
/// target-specific.
///
/// Note that LLVM no longer uses typed pointers and instead uses [Opaque Pointers]( https://llvm.org/docs/OpaquePointers.html ).
public struct PointerType: IRType {
  internal let llvm: LLVMTypeRef
  
  /// Retrieves the address space where the pointed-to object resides.
  public let addressSpace: AddressSpace

  /// Creates a `PointerType` in an optional context and address space.
  ///
  /// - parameter context: The context to create this type in. Default is `.global`.
  /// - parameter addressSpace: The optional address space where the pointed-to
  ///   object resides.
  public init(in context: Context = .global, addressSpace: AddressSpace = .zero) {
    llvm = LLVMPointerTypeInContext(context.llvm, UInt32(addressSpace.rawValue))
    self.addressSpace = addressSpace
  }

  /// Retrieves the underlying LLVM type object.
  public func asLLVM() -> LLVMTypeRef {
    return llvm
  }
}

extension PointerType: Equatable {
  public static func == (lhs: PointerType, rhs: PointerType) -> Bool {
    return lhs.asLLVM() == rhs.asLLVM()
  }
}
