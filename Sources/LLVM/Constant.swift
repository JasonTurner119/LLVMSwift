#if SWIFT_PACKAGE
import cllvm
#endif

/// An `IRConstant` is an entity whose value doees not change during the
/// runtime of a program.  This includes global variables and functions, whose
/// addresses are constant, and constant expressions.
public protocol IRConstant: IRValue {}

extension IRConstant {
  /// Perform a GEP (Get Element Pointer) with this value as the base.
  ///
  /// - parameter type: The type that `self` points to.
  /// - parameter indices: A list of indices that indicate which of the elements
  ///   of the aggregate object are indexed.
  ///
  /// - returns: A value representing the address of a subelement of the given
  ///   aggregate data structure value.
  public func constGEP(type: IRType, indices: [IRConstant]) -> IRConstant {
    var idxs = indices.map { $0.asLLVM() as Optional }
    return idxs.withUnsafeMutableBufferPointer { buf in
      return Constant<Struct>(llvm: LLVMConstGEP2(type.asLLVM(), asLLVM(), buf.baseAddress, UInt32(buf.count)))
    }
  }

  /// Build a constant bitcast to convert the given value to a value of the
  /// given type by just copying the bit pattern.
  ///
  /// - parameter type: The destination type.
  ///
  /// - returns: A constant value representing the result of bitcasting this
  ///   constant value to fit the given type.
  public func bitCast(to type: IRType) -> IRConstant {
    return Constant<Struct>(llvm: LLVMConstBitCast(asLLVM(), type.asLLVM()))
  }
}

/// A protocol to which the phantom types for a constant's representation conform.
public protocol ConstantRepresentation {}
/// A protocol to which the phantom types for all numerical constants conform.
public protocol NumericalConstantRepresentation: ConstantRepresentation {}
/// A protocol to which the phantom types for integral constants conform.
public protocol IntegralConstantRepresentation: NumericalConstantRepresentation {}

/// Represents unsigned integral types and operations.
public enum Unsigned: IntegralConstantRepresentation {}
/// Represents signed integral types and operations.
public enum Signed: IntegralConstantRepresentation {}
/// Represents floating types and operations.
public enum Floating: NumericalConstantRepresentation {}
/// Represents struct types and operations.
public enum Struct: ConstantRepresentation {}
/// Represents vector types and operations.
public enum Vector: ConstantRepresentation {}

/// A `Constant` represents a value initialized to a constant.  Constant values
/// may be manipulated with standard Swift arithmetic operations and used with
/// standard IR Builder instructions like any other operand.  The difference
/// being any instructions acting solely on constants and any arithmetic
/// performed on constants is evaluated at compile-time only.
///
/// `Constant`s keep track of the values they represent at the type level to
/// disallow mixed-type arithmetic.  Use the `cast` family of operations to
/// safely convert constants to other representations.
public struct Constant<Repr: ConstantRepresentation>: IRConstant {
  internal let llvm: LLVMValueRef

  internal init(llvm: LLVMValueRef!) {
    self.llvm = llvm
  }

  /// Retrieves the underlying LLVM constant object.
  public func asLLVM() -> LLVMValueRef {
    return llvm
  }
}

// MARK: Truncation

extension Constant where Repr == Signed {
  /// Creates a constant truncated to a given integral type.
  ///
  /// - parameter type: The type to truncate towards.
  ///
  /// - returns: A const value representing this value truncated to the given
  ///   integral type's bitwidth.
  public func truncate(to type: IntType) -> Constant<Signed> {
    return Constant<Signed>(llvm: LLVMConstTrunc(llvm, type.asLLVM()))
  }
}

extension Constant where Repr == Unsigned {
  /// Creates a constant truncated to a given integral type.
  ///
  /// - parameter type: The type to truncate towards.
  ///
  /// - returns: A const value representing this value truncated to the given
  ///   integral type's bitwidth.
  public func truncate(to type: IntType) -> Constant<Unsigned> {
    return Constant<Unsigned>(llvm: LLVMConstTrunc(llvm, type.asLLVM()))
  }
}

// MARK: Arithmetic Operations

// MARK: Negation

extension Constant {

  /// Creates a constant negate operation to negate a value.
  ///
  /// - parameter lhs: The operand to negate.
  /// - parameter overflowBehavior: Should overflow occur, specifies the
  ///   behavior of the resulting constant value.
  ///
  /// - returns: A constant value representing the negation of the given constant.
  public static func negate(_ lhs: Constant<Signed>, overflowBehavior: OverflowBehavior = .default) -> Constant<Signed> {

    let lhsVal = lhs.asLLVM()
    switch overflowBehavior {
    case .noSignedWrap:
      return Constant<Signed>(llvm: LLVMConstNSWNeg(lhsVal))
    case .noUnsignedWrap:
      return Constant<Signed>(llvm: LLVMConstNUWNeg(lhsVal))
    case .default:
      return Constant<Signed>(llvm: LLVMConstNeg(lhsVal))
    }
  }

}

extension Constant where Repr == Signed {

  /// Creates a constant negate operation to negate a value.
  ///
  /// - returns: A constant value representing the negation of the given constant.
  public func negate() -> Constant {
    return Constant.negate(self)
  }
}

// MARK: Addition

extension Constant {

  /// Creates a constant add operation to add two homogenous constants together.
  ///
  /// - parameter lhs: The first summand value (the augend).
  /// - parameter rhs: The second summand value (the addend).
  /// - parameter overflowBehavior: Should overflow occur, specifies the
  ///   behavior of the resulting constant value.
  ///
  /// - returns: A constant value representing the sum of the two operands.
  public static func add(_ lhs: Constant<Unsigned>, _ rhs: Constant<Unsigned>, overflowBehavior: OverflowBehavior = .default) -> Constant<Unsigned> {

    switch overflowBehavior {
    case .noSignedWrap:
      return Constant<Unsigned>(llvm: LLVMConstNSWAdd(lhs.llvm, rhs.llvm))
    case .noUnsignedWrap:
      return Constant<Unsigned>(llvm: LLVMConstNUWAdd(lhs.llvm, rhs.llvm))
    case .default:
      return Constant<Unsigned>(llvm: LLVMConstAdd(lhs.llvm, rhs.llvm))
    }
  }

  /// Creates a constant add operation to add two homogenous constants together.
  ///
  /// - parameter lhs: The first summand value (the augend).
  /// - parameter rhs: The second summand value (the addend).
  /// - parameter overflowBehavior: Should overflow occur, specifies the
  ///   behavior of the resulting constant value.
  ///
  /// - returns: A constant value representing the sum of the two operands.
  public static func add(_ lhs: Constant<Signed>, _ rhs: Constant<Signed>, overflowBehavior: OverflowBehavior = .default) -> Constant<Signed> {

    switch overflowBehavior {
    case .noSignedWrap:
      return Constant<Signed>(llvm: LLVMConstNSWAdd(lhs.llvm, rhs.llvm))
    case .noUnsignedWrap:
      return Constant<Signed>(llvm: LLVMConstNUWAdd(lhs.llvm, rhs.llvm))
    case .default:
      return Constant<Signed>(llvm: LLVMConstAdd(lhs.llvm, rhs.llvm))
    }
  }
}

extension Constant where Repr == Signed {

  /// Creates a constant add operation to add two homogenous constants together.
  ///
  /// - parameter rhs: The second summand value (the addend).
  /// - parameter overflowBehavior: Should overflow occur, specifies the
  ///   behavior of the resulting constant value.
  ///
  /// - returns: A constant value representing the sum of the two operands.
  public func adding(_ rhs: Constant, overflowBehavior: OverflowBehavior = .default) -> Constant {
    return Constant.add(self, rhs, overflowBehavior: overflowBehavior)
  }
}

extension Constant where Repr == Unsigned {

  /// Creates a constant add operation to add two homogenous constants together.
  ///
  /// - parameter rhs: The second summand value (the addend).
  /// - parameter overflowBehavior: Should overflow occur, specifies the
  ///   behavior of the resulting constant value.
  ///
  /// - returns: A constant value representing the sum of the two operands.
  public func adding(_ rhs: Constant, overflowBehavior: OverflowBehavior = .default) -> Constant {
    return Constant.add(self, rhs, overflowBehavior: overflowBehavior)
  }
}

// MARK: Subtraction

extension Constant {

  /// Creates a constant sub operation to subtract two homogenous constants.
  ///
  /// - parameter lhs: The first value (the minuend).
  /// - parameter rhs: The second value (the subtrahend).
  /// - parameter overflowBehavior: Should overflow occur, specifies the
  ///   behavior of the resulting constant value.
  ///
  /// - returns: A constant value representing the difference of the two operands.
  public static func subtract(_ lhs: Constant<Unsigned>, _ rhs: Constant<Unsigned>, overflowBehavior: OverflowBehavior = .default) -> Constant<Unsigned> {

    switch overflowBehavior {
    case .noSignedWrap:
      return Constant<Unsigned>(llvm: LLVMConstNSWSub(lhs.llvm, rhs.llvm))
    case .noUnsignedWrap:
      return Constant<Unsigned>(llvm: LLVMConstNUWSub(lhs.llvm, rhs.llvm))
    case .default:
      return Constant<Unsigned>(llvm: LLVMConstSub(lhs.llvm, rhs.llvm))
    }
  }

  /// Creates a constant sub operation to subtract two homogenous constants.
  ///
  /// - parameter lhs: The first value (the minuend).
  /// - parameter rhs: The second value (the subtrahend).
  /// - parameter overflowBehavior: Should overflow occur, specifies the
  ///   behavior of the resulting constant value.
  ///
  /// - returns: A constant value representing the difference of the two operands.
  public static func subtract(_ lhs: Constant<Signed>, _ rhs: Constant<Signed>, overflowBehavior: OverflowBehavior = .default) -> Constant<Signed> {

    switch overflowBehavior {
    case .noSignedWrap:
      return Constant<Signed>(llvm: LLVMConstNSWSub(lhs.llvm, rhs.llvm))
    case .noUnsignedWrap:
      return Constant<Signed>(llvm: LLVMConstNUWSub(lhs.llvm, rhs.llvm))
    case .default:
      return Constant<Signed>(llvm: LLVMConstSub(lhs.llvm, rhs.llvm))
    }
  }
}

extension Constant where Repr == Unsigned {

  /// Creates a constant sub operation to subtract two homogenous constants.
  ///
  /// - parameter rhs: The second value (the subtrahend).
  /// - parameter overflowBehavior: Should overflow occur, specifies the
  ///   behavior of the resulting constant value.
  ///
  /// - returns: A constant value representing the difference of the two operands.
  public func subtracting(_ rhs: Constant, overflowBehavior: OverflowBehavior = .default) -> Constant {
    return Constant.subtract(self, rhs, overflowBehavior: overflowBehavior)
  }
}

extension Constant where Repr == Signed {

  /// Creates a constant sub operation to subtract two homogenous constants.
  ///
  /// - parameter rhs: The second value (the subtrahend).
  /// - parameter overflowBehavior: Should overflow occur, specifies the
  ///   behavior of the resulting constant value.
  ///
  /// - returns: A constant value representing the difference of the two operands.
  public func subtracting(_ rhs: Constant, overflowBehavior: OverflowBehavior = .default) -> Constant {
    return Constant.subtract(self, rhs, overflowBehavior: overflowBehavior)
  }
}

// MARK: Multiplication

extension Constant {

  /// Creates a constant multiply operation with the given values as operands.
  ///
  /// - parameter lhs: The first factor value (the multiplier).
  /// - parameter rhs: The second factor value (the multiplicand).
  /// - parameter overflowBehavior: Should overflow occur, specifies the
  ///   behavior of the resulting constant value.
  ///
  /// - returns: A constant value representing the product of the two operands.
  public static func multiply(_ lhs: Constant<Unsigned>, _ rhs: Constant<Unsigned>, overflowBehavior: OverflowBehavior = .default) -> Constant<Unsigned> {

    switch overflowBehavior {
    case .noSignedWrap:
      return Constant<Unsigned>(llvm: LLVMConstNSWMul(lhs.llvm, rhs.llvm))
    case .noUnsignedWrap:
      return Constant<Unsigned>(llvm: LLVMConstNUWMul(lhs.llvm, rhs.llvm))
    case .default:
      return Constant<Unsigned>(llvm: LLVMConstMul(lhs.llvm, rhs.llvm))
    }
  }

  /// Creates a constant multiply operation with the given values as operands.
  ///
  /// - parameter lhs: The first factor value (the multiplier).
  /// - parameter rhs: The second factor value (the multiplicand).
  /// - parameter overflowBehavior: Should overflow occur, specifies the
  ///   behavior of the resulting constant value.
  ///
  /// - returns: A constant value representing the product of the two operands.
  public static func multiply(_ lhs: Constant<Signed>, _ rhs: Constant<Signed>, overflowBehavior: OverflowBehavior = .default) -> Constant<Signed> {

    switch overflowBehavior {
    case .noSignedWrap:
      return Constant<Signed>(llvm: LLVMConstNSWMul(lhs.llvm, rhs.llvm))
    case .noUnsignedWrap:
      return Constant<Signed>(llvm: LLVMConstNUWMul(lhs.llvm, rhs.llvm))
    case .default:
      return Constant<Signed>(llvm: LLVMConstMul(lhs.llvm, rhs.llvm))
    }
  }
}

extension Constant where Repr == Unsigned {

  /// Creates a constant multiply operation with the given values as operands.
  ///
  /// - parameter rhs: The second factor value (the multiplicand).
  /// - parameter overflowBehavior: Should overflow occur, specifies the
  ///   behavior of the resulting constant value.
  ///
  /// - returns: A constant value representing the product of the two operands.
  public func multiplying(_ rhs: Constant, overflowBehavior: OverflowBehavior = .default) -> Constant {
    return Constant.multiply(self, rhs, overflowBehavior: overflowBehavior)
  }
}

// MARK: Comparison Operations

extension Constant where Repr: IntegralConstantRepresentation {

  /// A constant equality comparison between two values.
  ///
  /// - parameter lhs: The first value to compare.
  /// - parameter rhs: The second value to compare.
  ///
  /// - returns: A constant integral value (i1) representing the result of the
  ///   comparision of the given operands.
  public static func equals(_ lhs: Constant, _ rhs: Constant) -> Constant<Signed> {
    return Constant<Signed>(llvm: LLVMConstICmp(IntPredicate.equal.llvm, lhs.llvm, rhs.llvm))
  }
}

extension Constant where Repr == Signed {

  /// A constant less-than comparison between two values.
  ///
  /// - parameter lhs: The first value to compare.
  /// - parameter rhs: The second value to compare.
  ///
  /// - returns: A constant integral value (i1) representing the result of the
  ///   comparision of the given operands.
  public static func lessThan(_ lhs: Constant, _ rhs: Constant) -> Constant<Signed> {
    return Constant<Signed>(llvm: LLVMConstICmp(IntPredicate.unsignedLessThan.llvm, lhs.llvm, rhs.llvm))
  }

  /// A constant greater-than comparison between two values.
  ///
  /// - parameter lhs: The first value to compare.
  /// - parameter rhs: The second value to compare.
  ///
  /// - returns: A constant integral value (i1) representing the result of the
  ///   comparision of the given operands.
  public static func greaterThan(_ lhs: Constant, _ rhs: Constant) -> Constant<Signed> {
    return Constant<Signed>(llvm: LLVMConstICmp(IntPredicate.signedGreaterThan.llvm, lhs.llvm, rhs.llvm))
  }

  /// A constant less-than-or-equal comparison between two values.
  ///
  /// - parameter lhs: The first value to compare.
  /// - parameter rhs: The second value to compare.
  ///
  /// - returns: A constant integral value (i1) representing the result of the
  ///   comparision of the given operands.
  public static func lessThanOrEqual(_ lhs: Constant, _ rhs: Constant) -> Constant<Signed> {
    return Constant<Signed>(llvm: LLVMConstICmp(IntPredicate.signedLessThanOrEqual.llvm, lhs.llvm, rhs.llvm))
  }

  /// A constant greater-than-or-equal comparison between two values.
  ///
  /// - parameter lhs: The first value to compare.
  /// - parameter rhs: The second value to compare.
  ///
  /// - returns: A constant integral value (i1) representing the result of the
  ///   comparision of the given operands.
  public static func greaterThanOrEqual(_ lhs: Constant, _ rhs: Constant) -> Constant<Signed> {
    return Constant<Signed>(llvm: LLVMConstICmp(IntPredicate.signedGreaterThanOrEqual.llvm, lhs.llvm, rhs.llvm))
  }
}

extension Constant where Repr == Unsigned {

  /// A constant less-than comparison between two values.
  ///
  /// - parameter lhs: The first value to compare.
  /// - parameter rhs: The second value to compare.
  ///
  /// - returns: A constant integral value (i1) representing the result of the
  ///   comparision of the given operands.
  public static func lessThan(_ lhs: Constant, _ rhs: Constant) -> Constant<Signed> {
    return Constant<Signed>(llvm: LLVMConstICmp(IntPredicate.unsignedLessThan.llvm, lhs.llvm, rhs.llvm))
  }

  /// A constant greater-than comparison between two values.
  ///
  /// - parameter lhs: The first value to compare.
  /// - parameter rhs: The second value to compare.
  ///
  /// - returns: A constant integral value (i1) representing the result of the
  ///   comparision of the given operands.
  public static func greaterThan(_ lhs: Constant, _ rhs: Constant) -> Constant<Signed> {
    return Constant<Signed>(llvm: LLVMConstICmp(IntPredicate.unsignedGreaterThan.llvm, lhs.llvm, rhs.llvm))
  }

  /// A constant less-than-or-equal comparison between two values.
  ///
  /// - parameter lhs: The first value to compare.
  /// - parameter rhs: The second value to compare.
  ///
  /// - returns: A constant integral value (i1) representing the result of the
  ///   comparision of the given operands.
  public static func lessThanOrEqual(_ lhs: Constant, _ rhs: Constant) -> Constant<Signed> {
    return Constant<Signed>(llvm: LLVMConstICmp(IntPredicate.unsignedLessThanOrEqual.llvm, lhs.llvm, rhs.llvm))
  }

  /// A constant greater-than-or-equal comparison between two values.
  ///
  /// - parameter lhs: The first value to compare.
  /// - parameter rhs: The second value to compare.
  ///
  /// - returns: A constant integral value (i1) representing the result of the
  ///   comparision of the given operands.
  public static func greaterThanOrEqual(_ lhs: Constant, _ rhs: Constant) -> Constant<Signed> {
    return Constant<Signed>(llvm: LLVMConstICmp(IntPredicate.unsignedGreaterThanOrEqual.llvm, lhs.llvm, rhs.llvm))
  }
}

extension Constant where Repr == Floating {

  /// A constant equality comparison between two values.
  ///
  /// - parameter lhs: The first value to compare.
  /// - parameter rhs: The second value to compare.
  ///
  /// - returns: A constant integral value (i1) representing the result of the
  ///   comparision of the given operands.
  public static func equals(_ lhs: Constant, _ rhs: Constant) -> Constant<Signed> {
    return Constant<Signed>(llvm: LLVMConstFCmp(RealPredicate.orderedEqual.llvm, lhs.llvm, rhs.llvm))
  }

  /// A constant less-than comparison between two values.
  ///
  /// - parameter lhs: The first value to compare.
  /// - parameter rhs: The second value to compare.
  ///
  /// - returns: A constant integral value (i1) representing the result of the
  ///   comparision of the given operands.
  public static func lessThan(_ lhs: Constant, _ rhs: Constant) -> Constant<Signed> {
    return Constant<Signed>(llvm: LLVMConstFCmp(RealPredicate.orderedLessThan.llvm, lhs.llvm, rhs.llvm))
  }

  /// A constant greater-than comparison between two values.
  ///
  /// - parameter lhs: The first value to compare.
  /// - parameter rhs: The second value to compare.
  ///
  /// - returns: A constant integral value (i1) representing the result of the
  ///   comparision of the given operands.
  public static func greaterThan(_ lhs: Constant, _ rhs: Constant) -> Constant<Signed> {
    return Constant<Signed>(llvm: LLVMConstFCmp(RealPredicate.orderedGreaterThan.llvm, lhs.llvm, rhs.llvm))
  }

  /// A constant less-than-or-equal comparison between two values.
  ///
  /// - parameter lhs: The first value to compare.
  /// - parameter rhs: The second value to compare.
  ///
  /// - returns: A constant integral value (i1) representing the result of the
  ///   comparision of the given operands.
  public static func lessThanOrEqual(_ lhs: Constant, _ rhs: Constant) -> Constant<Signed> {
    return Constant<Signed>(llvm: LLVMConstFCmp(RealPredicate.orderedLessThanOrEqual.llvm, lhs.llvm, rhs.llvm))
  }

  /// A constant greater-than-or-equal comparison between two values.
  ///
  /// - parameter lhs: The first value to compare.
  /// - parameter rhs: The second value to compare.
  ///
  /// - returns: A constant integral value (i1) representing the result of the
  ///   comparision of the given operands.
  public static func greaterThanOrEqual(_ lhs: Constant, _ rhs: Constant) -> Constant<Signed> {
    return Constant<Signed>(llvm: LLVMConstFCmp(RealPredicate.orderedGreaterThanOrEqual.llvm, lhs.llvm, rhs.llvm))
  }
}


extension Constant where Repr == Signed {

  /// Creates a constant multiply operation with the given values as operands.
  ///
  /// - parameter rhs: The second factor value (the multiplicand).
  /// - parameter overflowBehavior: Should overflow occur, specifies the
  ///   behavior of the resulting constant value.
  ///
  /// - returns: A constant value representing the product of the two operands.
  public func multiplying(_ rhs: Constant, overflowBehavior: OverflowBehavior = .default) -> Constant {
    return Constant.multiply(self, rhs, overflowBehavior: overflowBehavior)
  }
}

// MARK: Logical Operations

extension Constant {

  /// A constant bitwise logical not with the given integral value as an operand.
  ///
  /// - parameter val: The value to negate.
  ///
  /// - returns: A constant value representing the logical negation of the given
  ///   operand.
  public static func not<T: IntegralConstantRepresentation>(_ lhs: Constant<T>) -> Constant<T> {
    return Constant<T>(llvm: LLVMConstNot(lhs.llvm))
  }

  /// A constant bitwise logical exclusive OR with the given values as operands.
  ///
  /// - parameter lhs: The first operand.
  /// - parameter rhs: The second operand.
  ///
  /// - returns: A constant value representing the exclusive OR of the values of
  ///   the two given operands.
  public static func xor<T: IntegralConstantRepresentation>(_ lhs: Constant<T>, _ rhs: Constant<T>) -> Constant<T> {
    return Constant<T>(llvm: LLVMConstXor(lhs.llvm, rhs.llvm))
  }

  // MARK: Bitshifting Operations

  /// A constant left-shift of the first value by the second amount.
  ///
  /// - parameter lhs: The first operand.
  /// - parameter rhs: The second operand.
  ///
  /// - returns: A constant value representing the value of the first operand
  ///   shifted left by the number of bits specified in the second operand.
  public static func leftShift<T: IntegralConstantRepresentation>(_ lhs: Constant<T>, _ rhs: Constant<T>) -> Constant<T> {
    return Constant<T>(llvm: LLVMConstShl(lhs.llvm, rhs.llvm))
  }
}

// MARK: Constant Pointer To Integer

extension Constant where Repr: IntegralConstantRepresentation {
  /// Creates a constant pointer-to-integer operation to convert the given constant
  /// global pointer value to the given integer type.
  ///
  /// - parameter val: The pointer value.
  /// - parameter intType: The destination integer type.
  ///
  /// - returns: An constant value representing the constant value of the given
  ///   pointer converted to the given integer type.
  public static func pointerToInt(_ val: IRConstant, _ intType: IntType) -> Constant {
    precondition(val.isConstant, "May only convert global constant pointers to integers")
    return Constant<Repr>(llvm: LLVMConstPtrToInt(val.asLLVM(), intType.asLLVM()))
  }
}

// MARK: Struct Operations

extension Constant where Repr == Struct {
  /// Build a constant `GEP` (Get Element Pointer) instruction with a resultant
  /// value that is undefined if the address is outside the actual underlying
  /// allocated object and not the address one-past-the-end.
  ///
  /// The `GEP` instruction is often the source of confusion.  LLVM [provides a
  /// document](http://llvm.org/docs/GetElementPtr.html) to answer questions
  /// around its semantics and correct usage.
  ///
  /// - parameter type: The type that `self` points to.
  /// - parameter indices: A list of indices that indicate which of the elements
  ///   of the aggregate object are indexed.
  ///
  /// - returns: A value representing the address of a subelement of the given
  ///   aggregate data structure value.
  public func getElementPointer(_ type: IRType, indices: [IRConstant]) -> IRConstant {
    var indices = indices.map({ $0.asLLVM() as LLVMValueRef? })
    return indices.withUnsafeMutableBufferPointer { buf in
      return Constant<Struct>(llvm: LLVMConstGEP2(type.asLLVM(), asLLVM(), buf.baseAddress, UInt32(buf.count)))
    }
  }

  /// Build a GEP (Get Element Pointer) instruction.
  ///
  /// The `GEP` instruction is often the source of confusion.  LLVM [provides a
  /// document](http://llvm.org/docs/GetElementPtr.html) to answer questions
  /// around its semantics and correct usage.
  ///
  /// - parameter type: The type that `self` points to.
  /// - parameter indices: A list of indices that indicate which of the elements
  ///   of the aggregate object are indexed.
  ///
  /// - returns: A value representing the address of a subelement of the given
  ///   aggregate data structure value.
  public func inBoundsGetElementPointer(_ type: IRType, indices: [IRConstant]) -> IRConstant {
    var indices = indices.map({ $0.asLLVM() as LLVMValueRef? })
    return indices.withUnsafeMutableBufferPointer { buf in
      return Constant<Struct>(llvm: LLVMConstInBoundsGEP2(type.asLLVM(), asLLVM(), buf.baseAddress, UInt32(buf.count)))
    }
  }
}

// MARK: Vector Operations

extension Constant where Repr == Vector {
  /// Builds a constant operation to construct a permutation of elements
  /// from the two given input vectors, returning a vector with the same element
  /// type as the inputs and length that is the same as the shuffle mask.
  ///
  /// - parameter vector1: The first constant vector to shuffle.
  /// - parameter vector2: The second constant vector to shuffle.
  /// - parameter mask: A constant vector of `i32` values that acts as a mask
  ///   for the shuffled vectors.
  ///
  /// - returns: A value representing a constant vector with the same element
  ///   type as the inputs and length that is the same as the shuffle mask.
  public static func buildShuffleVector(_ vector1: Constant, and vector2: Constant, mask: Constant) -> Constant {
    guard let maskTy = mask.type as? VectorType, maskTy.elementType is IntType else {
      fatalError("Vector shuffle mask's elements must be 32-bit integers")
    }
    return Constant(llvm: LLVMConstShuffleVector(vector1.asLLVM(), vector2.asLLVM(), mask.asLLVM()))
  }
}

// MARK: Swift Operators

extension Constant where Repr == Signed {

  /// Creates a constant add operation to add two homogenous constants together.
  ///
  /// - parameter lhs: The first summand value (the augend).
  /// - parameter rhs: The second summand value (the addend).
  ///
  /// - returns: A constant value representing the sum of the two operands.
  public static func + (lhs: Constant, rhs: Constant) -> Constant {
    return lhs.adding(rhs)
  }

  /// Creates a constant sub operation to subtract two homogenous constants.
  ///
  /// - parameter lhs: The first value (the minuend).
  /// - parameter rhs: The second value (the subtrahend).
  ///
  /// - returns: A constant value representing the difference of the two operands.
  public static func - (lhs: Constant, rhs: Constant) -> Constant {
    return lhs.subtracting(rhs)
  }

  /// Creates a constant multiply operation with the given values as operands.
  ///
  /// - parameter lhs: The first factor value (the multiplier).
  /// - parameter rhs: The second factor value (the multiplicand).
  ///
  /// - returns: A constant value representing the product of the two operands.
  public static func * (lhs: Constant, rhs: Constant) -> Constant {
    return lhs.multiplying(rhs)
  }
  
  /// A constant left-shift of the first value by the second amount.
  ///
  /// - parameter lhs: The first operand.
  /// - parameter rhs: The second operand.
  ///
  /// - returns: A constant value representing the value of the first operand
  ///   shifted left by the number of bits specified in the second operand.
  public static func << (lhs: Constant, rhs: Constant) -> Constant {
    return Constant.leftShift(lhs, rhs)
  }
  
}

extension Constant where Repr == Unsigned {

  /// Creates a constant add operation to add two homogenous constants together.
  ///
  /// - parameter lhs: The first summand value (the augend).
  /// - parameter rhs: The second summand value (the addend).
  ///
  /// - returns: A constant value representing the sum of the two operands.
  public static func + (lhs: Constant, rhs: Constant) -> Constant {
    return lhs.adding(rhs)
  }

  /// Creates a constant sub operation to subtract two homogenous constants.
  ///
  /// - parameter lhs: The first value (the minuend).
  /// - parameter rhs: The second value (the subtrahend).
  ///
  /// - returns: A constant value representing the difference of the two operands.
  public static func - (lhs: Constant, rhs: Constant) -> Constant {
    return lhs.subtracting(rhs)
  }

  /// Creates a constant multiply operation with the given values as operands.
  ///
  /// - parameter lhs: The first factor value (the multiplier).
  /// - parameter rhs: The second factor value (the multiplicand).
  ///
  /// - returns: A constant value representing the product of the two operands.
  public static func * (lhs: Constant, rhs: Constant) -> Constant {
    return lhs.multiplying(rhs)
  }

  /// A constant left-shift of the first value by the second amount.
  ///
  /// - parameter lhs: The first operand.
  /// - parameter rhs: The second operand.
  ///
  /// - returns: A constant value representing the value of the first operand
  ///   shifted left by the number of bits specified in the second operand.
  public static func << (lhs: Constant, rhs: Constant) -> Constant {
    return Constant.leftShift(lhs, rhs)
  }
  
}

extension Constant where Repr: IntegralConstantRepresentation {

  /// A constant bitwise logical not with the given integral value as an operand.
  ///
  /// - parameter val: The value to negate.
  ///
  /// - returns: A constant value representing the logical negation of the given
  ///   operand.
  public static prefix func ! (_ lhs: Constant) -> Constant {
    return Constant(llvm: LLVMConstNot(lhs.llvm))
  }
  
}

extension Constant where Repr == Signed {

  /// A constant equality comparison between two values.
  ///
  /// - parameter lhs: The first value to compare.
  /// - parameter rhs: The second value to compare.
  ///
  /// - returns: A constant integral value (i1) representing the result of the
  ///   comparision of the given operands.
  public static func == (lhs: Constant, rhs: Constant) -> Constant {
    return Constant.equals(lhs, rhs)
  }

  /// A constant less-than comparison between two values.
  ///
  /// - parameter lhs: The first value to compare.
  /// - parameter rhs: The second value to compare.
  ///
  /// - returns: A constant integral value (i1) representing the result of the
  ///   comparision of the given operands.
  public static func < (lhs: Constant, rhs: Constant) -> Constant {
    return Constant.lessThan(lhs, rhs)
  }

  /// A constant greater-than comparison between two values.
  ///
  /// - parameter lhs: The first value to compare.
  /// - parameter rhs: The second value to compare.
  ///
  /// - returns: A constant integral value (i1) representing the result of the
  ///   comparision of the given operands.
  public static func > (lhs: Constant, rhs: Constant) -> Constant {
    return Constant.greaterThan(lhs, rhs)
  }

  /// A constant less-than-or-equal comparison between two values.
  ///
  /// - parameter lhs: The first value to compare.
  /// - parameter rhs: The second value to compare.
  ///
  /// - returns: A constant integral value (i1) representing the result of the
  ///   comparision of the given operands.
  public static func <= (lhs: Constant, rhs: Constant) -> Constant {
    return Constant.lessThanOrEqual(lhs, rhs)
  }

  /// A constant greater-than-or-equal comparison between two values.
  ///
  /// - parameter lhs: The first value to compare.
  /// - parameter rhs: The second value to compare.
  ///
  /// - returns: A constant integral value (i1) representing the result of the
  ///   comparision of the given operands.
  public static func >= (lhs: Constant, rhs: Constant) -> Constant {
    return Constant.greaterThanOrEqual(lhs, rhs)
  }
  
}


extension Constant where Repr == Unsigned {
  
  /// A constant equality comparison between two values.
  ///
  /// - parameter lhs: The first value to compare.
  /// - parameter rhs: The second value to compare.
  ///
  /// - returns: A constant integral value (i1) representing the result of the
  ///   comparision of the given operands.
  public static func == (lhs: Constant, rhs: Constant) -> Constant<Signed> {
    return Constant.equals(lhs, rhs)
  }
  
  /// A constant less-than comparison between two values.
  ///
  /// - parameter lhs: The first value to compare.
  /// - parameter rhs: The second value to compare.
  ///
  /// - returns: A constant integral value (i1) representing the result of the
  ///   comparision of the given operands.
  public static func < (lhs: Constant, rhs: Constant) -> Constant<Signed> {
    return Constant.lessThan(lhs, rhs)
  }
  
  /// A constant greater-than comparison between two values.
  ///
  /// - parameter lhs: The first value to compare.
  /// - parameter rhs: The second value to compare.
  ///
  /// - returns: A constant integral value (i1) representing the result of the
  ///   comparision of the given operands.
  public static func > (lhs: Constant, rhs: Constant) -> Constant<Signed> {
    return Constant.greaterThan(lhs, rhs)
  }
  
  /// A constant less-than-or-equal comparison between two values.
  ///
  /// - parameter lhs: The first value to compare.
  /// - parameter rhs: The second value to compare.
  ///
  /// - returns: A constant integral value (i1) representing the result of the
  ///   comparision of the given operands.
  public static func <= (lhs: Constant, rhs: Constant) -> Constant<Signed> {
    return Constant.lessThanOrEqual(lhs, rhs)
  }
  
  /// A constant greater-than-or-equal comparison between two values.
  ///
  /// - parameter lhs: The first value to compare.
  /// - parameter rhs: The second value to compare.
  ///
  /// - returns: A constant integral value (i1) representing the result of the
  ///   comparision of the given operands.
  public static func >= (lhs: Constant, rhs: Constant) -> Constant<Signed> {
    return Constant.greaterThanOrEqual(lhs, rhs)
  }
  
}

// MARK: Undef

extension Constant where Repr: IntegralConstantRepresentation {
  /// Returns the special LLVM `undef` value for this type.
  ///
  /// The `undef` value can be used anywhere a constant is expected, and
  /// indicates that the user of the value may receive an unspecified
  /// bit-pattern.
  public static func undef(_ ty: IntType) -> Constant {
    return Constant<Repr>(llvm: ty.undef().asLLVM())
  }
}

extension Constant where Repr == Floating {
  /// Returns the special LLVM `undef` value for this type.
  ///
  /// The `undef` value can be used anywhere a constant is expected, and
  /// indicates that the user of the value may receive an unspecified
  /// bit-pattern.
  public static func undef(_ ty: FloatType) -> Constant {
    return Constant(llvm: ty.undef().asLLVM())
  }
}

extension Constant where Repr == Struct {
  /// Returns the special LLVM `undef` value for this type.
  ///
  /// The `undef` value can be used anywhere a constant is expected, and
  /// indicates that the user of the value may receive an unspecified
  /// bit-pattern.
  public static func undef(_ ty: StructType) -> Constant {
    return Constant(llvm: ty.undef().asLLVM())
  }
}

extension Constant where Repr == Vector {
  /// Returns the special LLVM `undef` value for this type.
  ///
  /// The `undef` value can be used anywhere a constant is expected, and
  /// indicates that the user of the value may receive an unspecified
  /// bit-pattern.
  public static func undef(_ ty: VectorType) -> Constant {
    return Constant(llvm: ty.undef().asLLVM())
  }
}





// MARK: Removed Functions
// These are still around to help with error messages

// MARK: Casts

extension Constant {

  /// This method has been removed because the corresponding C function
  /// has been removed from LLVM.
  ///
  /// Please use `IRBuilder.buildCast(_:value:type:name:)`
  /// instead, which will likely be folded to a constant.
  @available(*, deprecated, message: "Use IRBuilder.buildCast(_:value:type:name:) instead.")
  public func cast(to type: IntType) -> Never {
    fatalError("Attempted to call Constant.cast(to:), use IRBuilder.buildCast(_:value:type:name:) instead.")
  }

  /// This method has been removed because the corresponding C function
  /// has been removed from LLVM.
  ///
  /// Please use `IRBuilder.buildCast(_:value:type:name:)`
  /// instead, which will likely be folded to a constant.
  @available(*, deprecated, message: "Use IRBuilder.buildCast(_:value:type:name:) instead.")
  public func cast(to type: FloatType) -> Never {
    fatalError("Attempted to call Constant.cast(to:), use IRBuilder.buildCast(_:value:type:name:) instead.")
  }
  
}

// MARK: Truncation

extension Constant where Repr == Floating {
  
  /// This method has been removed because the corresponding C function
  /// has been removed from LLVM.
  ///
  /// Please use `IRBuilder.buildTrunc(_:type:name:)`
  /// instead, which will likely be folded to a constant.
  ///
  /// Note the integer version of this API is still supported.
  @available(*, deprecated, message: "Use IRBuilder.buildTrunc(_:type:name:) instead.")
  public func truncate(to type: IntType) -> Never {
    fatalError("Attempted to call Constant.truncate(to:) on a float, use IRBuilder.buildTrunc(_:type:name:) instead.")
  }
  
  /// This method has been removed because the corresponding C function
  /// has been removed from LLVM.
  ///
  /// Please use `IRBuilder.buildTrunc(_:type:name:)`
  /// instead, which will likely be folded to a constant.
  ///
  /// Note the integer version of this API is still supported.
  @available(*, deprecated, message: "Use IRBuilder.buildTrunc(_:type:name:) instead.")
  public func truncate(to type: FloatType) -> Never {
    fatalError("Attempted to call Constant.truncate(to:) on a float, use IRBuilder.buildTrunc(_:type:name:) instead.")
  }

  /// This method has been removed because the corresponding C function
  /// has been removed from LLVM.
  @available(*, deprecated, message: "Use IRBuilder instead.")
  public func extend(to type: FloatType) -> Never {
    fatalError("Attempted to call Constant.extend(to:), use IRBuilder instead.")
  }
  
}

// MARK: Arithmetic Operations

// MARK: Negation

extension Constant {

  /// This method has been removed because the corresponding C function
  /// has been removed from LLVM.
  ///
  /// Please use `IRBuilder.buildNeg(_:overflowBehavior:name:)`
  /// instead, which will likely be folded to a constant.
  ///
  /// Note the integer version of this API is still supported.
  @available(*, deprecated, message: "Use IRBuilder.buildNeg(_:overflowBehavior:name:) instead.")
  public static func negate(_ lhs: Constant<Floating>) -> Never {
    fatalError("Attempted to call Constant.negate(to:) on a float, use IRBuilder.buildNeg(_:overflowBehavior:name:) instead.")
  }
  
}

extension Constant where Repr == Floating {

  /// This method has been removed because the corresponding C function
  /// has been removed from LLVM.
  ///
  /// Please use `IRBuilder.buildNeg(_:overflowBehavior:name:)`
  /// instead, which will likely be folded to a constant.
  ///
  /// Note the integer version of this API is still supported.
  @available(*, deprecated, message: "Use IRBuilder.buildNeg(_:overflowBehavior:name:) instead.")
  public func negate() -> Never {
    fatalError("Attempted to call Constant.negate() on a float, use IRBuilder.buildNeg(_:overflowBehavior:name:) instead.")
  }
  
}

// MARK: Addition

extension Constant {

  /// This method has been removed because the corresponding C function
  /// has been removed from LLVM.
  ///
  /// Please use `IRBuilder.buildAdd(_:_:overflowBehavior:name:)`
  /// instead, which will likely be folded to a constant.
  ///
  /// Note the integer version of this API is still supported.
  @available(*, deprecated, message: "Use IRBuilder.buildAdd(_:_:overflowBehavior:name:) instead.")
  public static func add(_ lhs: Constant<Floating>, _ rhs: Constant<Floating>) -> Never {
    fatalError("Attempted to call Constant.add(_:_:) with floats, use IRBuilder.buildAdd(_:_:overflowBehavior:name:) instead.")
  }
  
}

extension Constant where Repr == Floating {

  /// This method has been removed because the corresponding C function
  /// has been removed from LLVM.
  ///
  /// Please use `IRBuilder.buildAdd(_:_:overflowBehavior:name:)`
  /// instead, which will likely be folded to a constant.
  ///
  /// Note the integer version of this API is still supported.
  @available(*, deprecated, message: "Use IRBuilder.buildAdd(_:_:overflowBehavior:name:) instead.")
  public func adding(_ rhs: Constant) -> Never {
    fatalError("Attempted to call Constant.adding(_:) on a float, use IRBuilder.buildAdd(_:_:overflowBehavior:name:) instead.")
  }
  
}

// MARK: Subtraction

extension Constant {

  /// This method has been removed because the corresponding C function
  /// has been removed from LLVM.
  ///
  /// Please use `IRBuilder.buildSub(_:_:overflowBehavior:name:)`
  /// instead, which will likely be folded to a constant.
  ///
  /// Note the integer version of this API is still supported.
  @available(*, deprecated, message: "Use IRBuilder.buildSub(_:_:overflowBehavior:name:) instead.")
  public static func subtract(_ lhs: Constant<Floating>, _ rhs: Constant<Floating>) -> Never {
    fatalError("Attempted to call Constant.subtract(_:_:) with floats, use IRBuilder.buildSub(_:_:overflowBehavior:name:) instead.")
  }
  
}

extension Constant where Repr == Floating {
  
  /// This method has been removed because the corresponding C function
  /// has been removed from LLVM.
  ///
  /// Please use `IRBuilder.buildSub(_:_:overflowBehavior:name:)`
  /// instead, which will likely be folded to a constant.
  ///
  /// Note the integer version of this API is still supported.
  @available(*, deprecated, message: "Use IRBuilder.buildSub(_:_:overflowBehavior:name:) instead.")
  public static func subtracting(_ rhs: Constant) -> Never {
    fatalError("Attempted to call Constant.subtracting(_:) on a float, use IRBuilder.buildSub(_:_:overflowBehavior:name:) instead.")
  }
  
}

// MARK: Multiplication

extension Constant {

  /// This method has been removed because the corresponding C function
  /// has been removed from LLVM.
  ///
  /// Please use `IRBuilder.buildMul(_:_:overflowBehavior:name:)`
  /// instead, which will likely be folded to a constant.
  ///
  /// Note the integer version of this API is still supported.
  @available(*, deprecated, message: "Use IRBuilder.buildMul(_:_:overflowBehavior:name:) instead.")
  public static func multiply(_ lhs: Constant<Floating>, _ rhs: Constant<Floating>) -> Never {
    fatalError("Attempted to call Constant.multiply(_:_:) with floats, use IRBuilder.buildMul(_:_:overflowBehavior:name:) instead.")
  }
  
}

extension Constant where Repr == Floating {
  
  /// This method has been removed because the corresponding C function
  /// has been removed from LLVM.
  ///
  /// Please use `IRBuilder.buildMul(_:_:overflowBehavior:name:)`
  /// instead, which will likely be folded to a constant.
  ///
  /// Note the integer version of this API is still supported.
  @available(*, deprecated, message: "Use IRBuilder.buildMul(_:_:overflowBehavior:name:) instead.")
  public static func multiplying(_ rhs: Constant) -> Never {
    fatalError("Attempted to call Constant.multiplying(_:) on a float, use IRBuilder.buildMul(_:_:overflowBehavior:name:) instead.")
  }
  
}

// MARK: Divide

extension Constant {

  /// This method has been removed because the corresponding C function
  /// has been removed from LLVM.
  ///
  /// Please use `IRBuilder.buildDiv(_:_:signed:exact:name:)`
  /// instead, which will likely be folded to a constant.
  @available(*, deprecated, message: "Use IRBuilder.buildDiv(_:_:signed:exact:name:) instead.")
  public static func divide(_ lhs: Constant<Unsigned>, _ rhs: Constant<Unsigned>) -> Never {
    fatalError("Attempted to call Constant.divide(_:_:), use IRBuilder.buildDiv(_:_:signed:exact:name:) instead.")
  }

  /// This method has been removed because the corresponding C function
  /// has been removed from LLVM.
  ///
  /// Please use `IRBuilder.buildDiv(_:_:signed:exact:name:)`
  /// instead, which will likely be folded to a constant.
  @available(*, deprecated, message: "Use IRBuilder.buildDiv(_:_:signed:exact:name:) instead.")
  public static func divide(_ lhs: Constant<Signed>, _ rhs: Constant<Signed>) -> Never {
    fatalError("Attempted to call Constant.divide(_:_:), use IRBuilder.buildDiv(_:_:signed:exact:name:) instead.")
  }

  /// This method has been removed because the corresponding C function
  /// has been removed from LLVM.
  ///
  /// Please use `IRBuilder.buildDiv(_:_:signed:exact:name:)`
  /// instead, which will likely be folded to a constant.
  @available(*, deprecated, message: "Use IRBuilder.buildDiv(_:_:signed:exact:name:) instead.")
  public static func divide(_ lhs: Constant<Floating>, _ rhs: Constant<Floating>) -> Never {
    fatalError("Attempted to call Constant.divide(_:_:), use IRBuilder.buildDiv(_:_:signed:exact:name:) instead.")
  }
  
}

extension Constant {

  /// This method has been removed because the corresponding C function
  /// has been removed from LLVM.
  ///
  /// Please use `IRBuilder.buildDiv(_:_:signed:exact:name:)`
  /// instead, which will likely be folded to a constant.
  @available(*, deprecated, message: "Use IRBuilder.buildDiv(_:_:signed:exact:name:) instead.")
  public func dividing(by rhs: Constant) -> Never {
    fatalError("Attempted to call Constant.dividing(_:), use IRBuilder.buildDiv(_:_:signed:exact:name:) instead.")
  }
  
}

// MARK: Remainder

extension Constant {

  /// This method has been removed because the corresponding C function
  /// has been removed from LLVM.
  ///
  /// Please use `IRBuilder.buildRem(_:_:signed:name:)`
  /// instead, which will likely be folded to a constant.
  @available(*, deprecated, message: "Use IRBuilder.buildRem(_:_:signed:name:) instead.")
  public static func remainder(_ lhs: Constant<Signed>, _ rhs: Constant<Signed>) -> Never {
    fatalError("Attempted to call Constant.remainder(_:_:), use IRBuilder.buildRem(_:_:signed:name:) instead.")
  }

  /// This method has been removed because the corresponding C function
  /// has been removed from LLVM.
  ///
  /// Please use `IRBuilder.buildRem(_:_:signed:name:)`
  /// instead, which will likely be folded to a constant.
  @available(*, deprecated, message: "Use IRBuilder.buildRem(_:_:signed:name:) instead.")
  public static func remainder(_ lhs: Constant<Unsigned>, _ rhs: Constant<Unsigned>) -> Never {
    fatalError("Attempted to call Constant.remainder(_:_:), use IRBuilder.buildRem(_:_:signed:name:) instead.")
  }

  /// This method has been removed because the corresponding C function
  /// has been removed from LLVM.
  ///
  /// Please use `IRBuilder.buildRem(_:_:signed:name:)`
  /// instead, which will likely be folded to a constant.
  @available(*, deprecated, message: "Use IRBuilder.buildRem(_:_:signed:name:) instead.")
  public static func remainder(_ lhs: Constant<Floating>, _ rhs: Constant<Floating>) -> Never {
    fatalError("Attempted to call Constant.remainder(_:_:), use IRBuilder.buildRem(_:_:signed:name:) instead.")
  }
  
}

extension Constant {
  
  /// This method has been removed because the corresponding C function
  /// has been removed from LLVM.
  ///
  /// Please use `IRBuilder.buildRem(_:_:signed:name:)`
  /// instead, which will likely be folded to a constant.
  @available(*, deprecated, message: "Use IRBuilder.buildRem(_:_:signed:name:) instead.")
  public func remainder(by rhs: Constant) -> Never {
    fatalError("Attempted to call Constant.remainder(_:), use IRBuilder.buildRem(_:_:signed:name:) instead.")
  }
  
}

// MARK: Logical Operations

extension Constant {

  /// This method has been removed because the corresponding C function
  /// has been removed from LLVM.
  ///
  /// Please use `IRBuilder.buildAnd(_:_:)`
  /// instead, which will likely be folded to a constant.
  @available(*, deprecated, message: "Use IRBuilder.buildAnd(_:_:) instead.")
  public static func and<T: IntegralConstantRepresentation>(_ lhs: Constant<T>, _ rhs: Constant<T>) -> Never {
    fatalError("Attempted to call Constant.and(_:_:), use IRBuilder.buildAnd(_:_:) instead.")
  }

  /// This method has been removed because the corresponding C function
  /// has been removed from LLVM.
  ///
  /// Please use `IRBuilder.buildOr(_:_:name:)`
  /// instead, which will likely be folded to a constant.
  @available(*, deprecated, message: "Use IRBuilder.buildOr(_:_:name:) instead.")
  public static func or<T: IntegralConstantRepresentation>(_ lhs: Constant<T>, _ rhs: Constant<T>) -> Never {
    fatalError("Attempted to call Constant.and(_:_:), use IRBuilder.buildOr(_:_:name:) instead.")
  }

  /// This method has been removed because the corresponding C function
  /// has been removed from LLVM.
  ///
  /// Please use `IRBuilder.buildXor(_:_:)`
  /// instead, which will likely be folded to a constant.
  @available(*, deprecated, message: "Use IRBuilder.buildXor(_:_:) instead.")
  public static func xor<T: IntegralConstantRepresentation>(_ lhs: Constant<T>, _ rhs: Constant<T>) -> Never {
    fatalError("Attempted to call Constant.and(_:_:), use IRBuilder.buildXor(_:_:) instead.")
  }
  
  // MARK: Bitshifting Operations

  /// This method has been removed because the corresponding C function
  /// has been removed from LLVM.
  ///
  /// Please use `IRBuilder.buildShr(_:_:)`
  /// instead, which will likely be folded to a constant.
  @available(*, deprecated, message: "Use IRBuilder.buildShr(_:_:) instead.")
  public static func rightShift<T: IntegralConstantRepresentation>(_ lhs: Constant<T>, _ rhs: Constant<T>, arithmetic: Bool = true) -> Never {
    fatalError("Attempted to call Constant.rightShift(_:_:), use IRBuilder.buildShr(_:_:) instead.")
  }

  // MARK: Conditional Operations

  /// This method has been removed because the corresponding C function
  /// has been removed from LLVM.
  ///
  /// Please use `IRBuilder.buildSelect(_:then:else:name:)`
  /// instead, which will likely be folded to a constant.
  @available(*, deprecated, message: "Use IRBuilder.buildSelect(_:then:else:name:) instead.")
  public static func select<T: IntegralConstantRepresentation, U>(_ cond: Constant<T>, then: Constant<U>, else: Constant<U>) -> Never {
    fatalError("Attempted to call Constant.select(_:then:else:), use IRBuilder.buildSelect(_:then:else:name:) instead.")
  }
  
}

// MARK: Struct Operations

extension Constant where Repr == Struct {

  /// This method has been removed because the corresponding C function
  /// has been removed from LLVM.
  ///
  /// Please use `IRBuilder.buildExtractValue(_:index:name:)`
  /// instead, which will likely be folded to a constant.
  @available(*, deprecated, message: "Use IRBuilder.buildExtractValue(_:index:name:) instead.")
  public func getElement(indices: [Int]) -> Never {
    fatalError("Attempted to call Constant.getElement(indices:), use IRBuilder.buildSelect(_:index:name:) instead.")
  }

  /// This method has been removed because the corresponding C function
  /// has been removed from LLVM.
  ///
  /// Please use `IRBuilder.buildGEP(_:type:indicies:name:)`
  /// instead, which will likely be folded to a constant.
  @available(*, deprecated, message: "Use IRBuilder.buildGEP(_:type:indicies:name:) instead.")
  public func getElementPointer(indices: [IRConstant]) -> IRConstant {
    fatalError("Attempted to call Constant.getElementPointer(indices:), use IRBuilder.buildGEP(_:type:indicies:name:) instead.")
  }

  /// This method has been removed because the corresponding C function
  /// has been removed from LLVM.
  ///
  /// Please use `IRBuilder.buildInBoundsGEP(_:type:indicies:name:)`
  /// instead, which will likely be folded to a constant.
  @available(*, deprecated, message: "Use IRBuilder.buildInBoundsGEP(_:type:indicies:name:) instead.")
  public func inBoundsGetElementPointer(indices: [IRConstant]) -> IRConstant {
    fatalError("Attempted to call Constant.getElementPointer(indices:), use IRBuilder.buildInBoundsGEP(_:type:indicies:name:) instead.")
  }
  
}

// MARK: Swift Operators

extension Constant where Repr == Floating {
  
  /// This method has been removed because the corresponding C function
  /// has been removed from LLVM.
  ///
  /// Please use `IRBuilder.buildAdd(_:_:overflowBehavior:name:)`
  /// instead, which will likely be folded to a constant.
  @available(*, deprecated, message: "Use IRBuilder.buildAdd(_:_:overflowBehavior:name:) instead.")
  public static func + (lhs: Constant, rhs: Constant) -> Never {
    fatalError("Attempted to call Constant's `+` operator, use IRBuilder.buildAdd(_:_:overflowBehavior:name:) instead.")
  }
  
  /// This method has been removed because the corresponding C function
  /// has been removed from LLVM.
  ///
  /// Please use `IRBuilder.buildSub(_:_:overflowBehavior:name:)`
  /// instead, which will likely be folded to a constant.
  @available(*, deprecated, message: "Use IRBuilder.buildSub(_:_:overflowBehavior:name:) instead.")
  public static func - (lhs: Constant, rhs: Constant) -> Never {
    fatalError("Attempted to call Constant's `-` operator, use IRBuilder.buildSub(_:_:overflowBehavior:name:) instead.")
  }
  
  /// This method has been removed because the corresponding C function
  /// has been removed from LLVM.
  ///
  /// Please use `IRBuilder.buildMul(_:_:overflowBehavior:name:)`
  /// instead, which will likely be folded to a constant.
  @available(*, deprecated, message: "Use IRBuilder.buildMul(_:_:overflowBehavior:name:) instead.")
  public static func * (lhs: Constant, rhs: Constant) -> Never {
    fatalError("Attempted to call Constant's `*` operator, use IRBuilder.buildMul(_:_:overflowBehavior:name:) instead.")
  }
  
  /// This method has been removed because the corresponding C function
  /// has been removed from LLVM.
  ///
  /// Please use `IRBuilder.buildICmp(_:_:predicate::name:)`
  /// instead, which will likely be folded to a constant.
  @available(*, deprecated, message: "Use IRBuilder.buildICmp(_:_:predicate::name:) instead.")
  public static func == (lhs: Constant, rhs: Constant) -> Never {
    fatalError("Attempted to call Constant's `==` operator, use IRBuilder.buildICmp(_:_:predicate::name:) instead.")
  }

  /// This method has been removed because the corresponding C function
  /// has been removed from LLVM.
  ///
  /// Please use `IRBuilder.buildICmp(_:_:predicate::name:)`
  /// instead, which will likely be folded to a constant.
  @available(*, deprecated, message: "Use IRBuilder.buildICmp(_:_:predicate::name:) instead.")
  public static func < (lhs: Constant, rhs: Constant) -> Never {
    fatalError("Attempted to call Constant's `<` operator, use IRBuilder.buildICmp(_:_:predicate::name:) instead.")
  }

  /// This method has been removed because the corresponding C function
  /// has been removed from LLVM.
  ///
  /// Please use `IRBuilder.buildICmp(_:_:predicate::name:)`
  /// instead, which will likely be folded to a constant.
  @available(*, deprecated, message: "Use IRBuilder.buildICmp(_:_:predicate::name:) instead.")
  public static func > (lhs: Constant, rhs: Constant) -> Never {
    fatalError("Attempted to call Constant's `>` operator, use IRBuilder.buildICmp(_:_:predicate::name:) instead.")
  }

  /// This method has been removed because the corresponding C function
  /// has been removed from LLVM.
  ///
  /// Please use `IRBuilder.buildICmp(_:_:predicate::name:)`
  /// instead, which will likely be folded to a constant.
  @available(*, deprecated, message: "Use IRBuilder.buildICmp(_:_:predicate::name:) instead.")
  public static func <= (lhs: Constant, rhs: Constant) -> Never {
    fatalError("Attempted to call Constant's `<=` operator, use IRBuilder.buildICmp(_:_:predicate::name:) instead.")
  }

  /// This method has been removed because the corresponding C function
  /// has been removed from LLVM.
  ///
  /// Please use `IRBuilder.buildICmp(_:_:predicate::name:)`
  /// instead, which will likely be folded to a constant.
  @available(*, deprecated, message: "Use IRBuilder.buildICmp(_:_:predicate::name:) instead.")
  public static func >= (lhs: Constant, rhs: Constant) -> Never {
    fatalError("Attempted to call Constant's `==` operator, use IRBuilder.buildICmp(_:_:predicate::name:) instead.")
  }
  
}

extension Constant {

  /// This method has been removed because the corresponding C function
  /// has been removed from LLVM.
  ///
  /// Please use `IRBuilder.buildDiv(_:_:signed:exact:name:)`
  /// instead, which will likely be folded to a constant.
  @available(*, deprecated, message: "Use IRBuilder.buildDiv(_:_:signed:exact:name:) instead.")
  public static func / (lhs: Constant, rhs: Constant) -> Never {
    fatalError("Attempted to call Constant's `/` operator, use IRBuilder.buildDiv(_:_:signed:exact:name:) instead.")
  }

  /// This method has been removed because the corresponding C function
  /// has been removed from LLVM.
  ///
  /// Please use `IRBuilder.buildRem(_:_:signed:name:)`
  /// instead, which will likely be folded to a constant.
  @available(*, deprecated, message: "Use IRBuilder.buildRem(_:_:signed:name:) instead.")
  public static func % (lhs: Constant, rhs: Constant) -> Never {
    fatalError("Attempted to call Constant's `%` operator, use IRBuilder.buildRem(_:_:signed:name:) instead.")
  }

}

extension Constant where Repr == Signed {
  
  /// This method has been removed because the corresponding C function
  /// has been removed from LLVM.
  ///
  /// Please use `IRBuilder.buildOr(_:_:name:)`
  /// instead, which will likely be folded to a constant.
  @available(*, deprecated, message: "Use IRBuilder.buildOr(_:_:name:) instead.")
  public static func | (lhs: Constant, rhs: Constant) -> Never {
    fatalError("Attempted to call Constant's `|` operator, use IRBuilder.buildOr(_:_:name:) instead.")
  }

  /// This method has been removed because the corresponding C function
  /// has been removed from LLVM.
  ///
  /// Please use `IRBuilder.buildAnd(_:_:name:)`
  /// instead, which will likely be folded to a constant.
  @available(*, deprecated, message: "Use IRBuilder.buildAnd(_:_:name:) instead.")
  public static func & (lhs: Constant, rhs: Constant) -> Never {
    fatalError("Attempted to call Constant's `&` operator, use IRBuilder.buildAnd(_:_:name:) instead.")
  }
  
  /// This method has been removed because the corresponding C function
  /// has been removed from LLVM.
  ///
  /// Please use `IRBuilder.buildShr(_:_:isArithmetic:name:)`
  /// instead, which will likely be folded to a constant.
  @available(*, deprecated, message: "Use IRBuilder.buildShr(_:_:isArithmetic:name:) instead.")
  public static func >> (lhs: Constant, rhs: Constant) -> Never {
    fatalError("Attempted to call Constant's `>>` operator, use IRBuilder.buildShr(_:_:isArithmetic:name:) instead.")
  }
  
}

extension Constant where Repr == Unsigned {
  
  /// This method has been removed because the corresponding C function
  /// has been removed from LLVM.
  ///
  /// Please use `IRBuilder.buildOr(_:_:name:)`
  /// instead, which will likely be folded to a constant.
  @available(*, deprecated, message: "Use IRBuilder.buildOr(_:_:name:) instead.")
  public static func | (lhs: Constant, rhs: Constant) -> Never {
    fatalError("Attempted to call Constant's `|` operator, use IRBuilder.buildOr(_:_:name:) instead.")
  }

  /// This method has been removed because the corresponding C function
  /// has been removed from LLVM.
  ///
  /// Please use `IRBuilder.buildAnd(_:_:name:)`
  /// instead, which will likely be folded to a constant.
  @available(*, deprecated, message: "Use IRBuilder.buildAnd(_:_:name:) instead.")
  public static func & (lhs: Constant, rhs: Constant) -> Never {
    fatalError("Attempted to call Constant's `&` operator, use IRBuilder.buildAnd(_:_:name:) instead.")
  }
  
  /// This method has been removed because the corresponding C function
  /// has been removed from LLVM.
  ///
  /// Please use `IRBuilder.buildShr(_:_:isArithmetic:name:)`
  /// instead, which will likely be folded to a constant.
  @available(*, deprecated, message: "Use IRBuilder.buildShr(_:_:isArithmetic:name:) instead.")
  public static func >> (lhs: Constant, rhs: Constant) -> Never {
    fatalError("Attempted to call Constant's `>>` operator, use IRBuilder.buildShr(_:_:isArithmetic:name:) instead.")
  }
  
}
