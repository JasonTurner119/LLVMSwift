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

// MARK: Deprecations

extension PointerType {
  
  /// Creates a `PointerType` from a pointee type and an optional address space.
  /// Creates a `PointerType` in an optional context and address space.
  ///
  /// - parameter pointee: The type of the pointed-to object.
  /// - parameter context: The context to create this type in. Default is `.global`.
  /// - parameter addressSpace: The optional address space where the pointed-to
  ///   object resides.
  /// - note: The context of this type is taken from it's pointee
  @available(*, deprecated, message: "Use PointerType.init(in:addressSpace:) instead.")
  public init(pointee: IRType, addressSpace: AddressSpace = .zero) {
    self.init(in: pointee.context, addressSpace: addressSpace)
  }
  
  @available(*, deprecated, message: "Use PointerType.init(in:addressSpace:) instead.")
  public static let toVoid = PointerType()
  
  @available(*, deprecated, message: "Typed pointers are no longer supported by LLVM, the pointee type should be stored elsewhere.")
  public static var pointee: Never { fatalError("PointerType.pointee is not supported because all pointers are opaque.") }
  
}

extension PointerType: Equatable {
  public static func == (lhs: PointerType, rhs: PointerType) -> Bool {
    return lhs.asLLVM() == rhs.asLLVM()
  }
}
