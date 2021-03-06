// RUN: %target-swift-frontend -module-name test -emit-ir -verify -primary-file %s %S/Inputs/require-layout-generic-class.swift | %FileCheck --check-prefix=FILE1 %s
// RUN: %target-swift-frontend -module-name test -emit-ir -verify %s -primary-file %S/Inputs/require-layout-generic-class.swift | %FileCheck --check-prefix=FILE2 %s

// REQUIRES: CPU=x86_64

// The offset of the typemetadata in the class typemetadata must match.

// FILE1-LABEL: define internal swiftcc void @"$S4test12requestType21xyx_tlFyAA3SubCyxGXEfU_"(%T4test3SubC*)
// FILE1: entry:
// FILE1:   [[T1:%.*]] = bitcast %T4test3SubC* %0 to %swift.type**
// FILE1:   [[TYPEMETADATA:%.*]] = load %swift.type*, %swift.type** [[T1]]
// FILE1:   [[T2:%.*]] = bitcast %swift.type* [[TYPEMETADATA]] to %swift.type**
// This offset of T needs to be the same as the offset below.
// FILE1:   [[T_PTR:%.*]] = getelementptr inbounds %swift.type*, %swift.type** [[T2]], i64 16
// FILE1:   [[T:%.*]] = load %swift.type*, %swift.type** [[T_PTR]]
// FILE1:   call %swift.type* @"$S4test3SubCMa"(%swift.type* [[T]])

public func requestType2<T>(x: T) {
  requestTypeThrough(closure: { x in print(x) }, arg: x)
}
// FILE2-LABEL: define internal %swift.type* @"$S4test3SubCMi"(%swift.type_descriptor*, i8**, i8**)
// FILE2:   [[T_ADDR:%.*]] = bitcast i8** %1 to %swift.type**
// FILE2:   [[T:%.*]] = load %swift.type*, %swift.type** [[T_ADDR]]
// FILE2:   [[CLASSMETADATA:%.*]] = call %swift.type* @swift_allocateGenericClassMetadata
// FILE2:   [[ADDR:%.*]] = bitcast %swift.type* [[CLASSMETADATA]] to i8**
// This offset of T here needs to be the same as the offset above.
// FILE2:   [[T_IN_CLASSMETADATA:%.*]] = getelementptr inbounds i8*, i8** [[ADDR]], i64 16
// FILE2:   [[T2:%.*]] = bitcast %swift.type* [[T]] to i8*
// FILE2:   store i8* [[T2]], i8** [[T_IN_CLASSMETADATA]]
