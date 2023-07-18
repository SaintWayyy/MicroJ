; ModuleID = 'MicroJ'
source_filename = "MicroJ"

@offset = global i64 0
@f1 = global i64 0
@f2 = global i64 0
@my_struct_ptr = global { i64, i64, i64, i64, i64, double }* null
@my_struct_ptr.3 = global { i64, i64, i64, i64, i64, double }* null
@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@fmt.4 = private unnamed_addr constant [4 x i8] c"%f\0A\00", align 1
@fmt.5 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@fmt.6 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@fmt.7 = private unnamed_addr constant [4 x i8] c"%f\0A\00", align 1
@fmt.8 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@str = private unnamed_addr constant [24 x i8] c"\22Nonstatic Animal bark\22\00", align 1
@fmt.9 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@fmt.10 = private unnamed_addr constant [4 x i8] c"%f\0A\00", align 1
@fmt.11 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@fmt.12 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@fmt.13 = private unnamed_addr constant [4 x i8] c"%f\0A\00", align 1
@fmt.14 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@str.15 = private unnamed_addr constant [21 x i8] c"\22Static Animal bark\22\00", align 1
@fmt.16 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@fmt.17 = private unnamed_addr constant [4 x i8] c"%f\0A\00", align 1
@fmt.18 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@str.19 = private unnamed_addr constant [11 x i8] c"\22Cat miao\22\00", align 1
@fmt.20 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@fmt.21 = private unnamed_addr constant [4 x i8] c"%f\0A\00", align 1
@fmt.22 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@str.23 = private unnamed_addr constant [18 x i8] c"\22My class is Cat\22\00", align 1
@fmt.24 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@fmt.25 = private unnamed_addr constant [4 x i8] c"%f\0A\00", align 1
@fmt.26 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@str.27 = private unnamed_addr constant [16 x i8] c"\22Cats eat fish\22\00", align 1
@fmt.28 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@fmt.29 = private unnamed_addr constant [4 x i8] c"%f\0A\00", align 1
@fmt.30 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1

declare i32 @printf(i8*, ...)

define { i64, i64, i64, i64, i64, double }* @Animal() {
entry:
  %malloccall = tail call i8* @malloc(i32 ptrtoint ({ i64, i64, i64, i64, i64, double }* getelementptr ({ i64, i64, i64, i64, i64, double }, { i64, i64, i64, i64, i64, double }* null, i32 1) to i32))
  %struct_ptr = bitcast i8* %malloccall to { i64, i64, i64, i64, i64, double }*
  store { i64, i64, i64, i64, i64, double }* %struct_ptr, { i64, i64, i64, i64, i64, double }** @my_struct_ptr, align 8
  %field_ptr = getelementptr inbounds { i64, i64, i64, i64, i64, double }, { i64, i64, i64, i64, i64, double }* %struct_ptr, i32 0, i32 0
  store i64 0, i64* %field_ptr, align 4
  %field_ptr1 = getelementptr inbounds { i64, i64, i64, i64, i64, double }, { i64, i64, i64, i64, i64, double }* %struct_ptr, i32 0, i32 1
  store i64 0, i64* %field_ptr1, align 4
  %field_ptr2 = getelementptr inbounds { i64, i64, i64, i64, i64, double }, { i64, i64, i64, i64, i64, double }* %struct_ptr, i32 0, i32 2
  store i64 0, i64* %field_ptr2, align 4
  %field_ptr3 = getelementptr inbounds { i64, i64, i64, i64, i64, double }, { i64, i64, i64, i64, i64, double }* %struct_ptr, i32 0, i32 3
  store i64 0, i64* %field_ptr3, align 4
  %field_ptr4 = getelementptr inbounds { i64, i64, i64, i64, i64, double }, { i64, i64, i64, i64, i64, double }* %struct_ptr, i32 0, i32 4
  store i64 0, i64* %field_ptr4, align 4
  %field_ptr5 = getelementptr inbounds { i64, i64, i64, i64, i64, double }, { i64, i64, i64, i64, i64, double }* %struct_ptr, i32 0, i32 5
  store double 0.000000e+00, double* %field_ptr5, align 8
  ret { i64, i64, i64, i64, i64, double }* %struct_ptr
}

define { i64, i64, i64, i64, i64, double }* @Animal.1(i64 %0, i64 %1) {
entry:
  %malloccall = tail call i8* @malloc(i32 ptrtoint ({ i64, i64, i64, i64, i64, double }* getelementptr ({ i64, i64, i64, i64, i64, double }, { i64, i64, i64, i64, i64, double }* null, i32 1) to i32))
  %struct_ptr = bitcast i8* %malloccall to { i64, i64, i64, i64, i64, double }*
  store { i64, i64, i64, i64, i64, double }* %struct_ptr, { i64, i64, i64, i64, i64, double }** @my_struct_ptr, align 8
  %field_ptr = getelementptr inbounds { i64, i64, i64, i64, i64, double }, { i64, i64, i64, i64, i64, double }* %struct_ptr, i32 0, i32 0
  store i64 0, i64* %field_ptr, align 4
  %field_ptr1 = getelementptr inbounds { i64, i64, i64, i64, i64, double }, { i64, i64, i64, i64, i64, double }* %struct_ptr, i32 0, i32 1
  store i64 0, i64* %field_ptr1, align 4
  %field_ptr2 = getelementptr inbounds { i64, i64, i64, i64, i64, double }, { i64, i64, i64, i64, i64, double }* %struct_ptr, i32 0, i32 2
  store i64 0, i64* %field_ptr2, align 4
  %field_ptr3 = getelementptr inbounds { i64, i64, i64, i64, i64, double }, { i64, i64, i64, i64, i64, double }* %struct_ptr, i32 0, i32 3
  store i64 0, i64* %field_ptr3, align 4
  %field_ptr4 = getelementptr inbounds { i64, i64, i64, i64, i64, double }, { i64, i64, i64, i64, i64, double }* %struct_ptr, i32 0, i32 4
  store i64 0, i64* %field_ptr4, align 4
  %field_ptr5 = getelementptr inbounds { i64, i64, i64, i64, i64, double }, { i64, i64, i64, i64, i64, double }* %struct_ptr, i32 0, i32 5
  store double 0.000000e+00, double* %field_ptr5, align 8
  %field_ptr6 = getelementptr inbounds { i64, i64, i64, i64, i64, double }, { i64, i64, i64, i64, i64, double }* %struct_ptr, i32 0, i32 1
  store i64 %0, i64* %field_ptr6, align 4
  store i64 %1, i64* @offset, align 4
  ret { i64, i64, i64, i64, i64, double }* %struct_ptr
}

define i64 @sum({ i64, i64, i64, i64, i64, double }* %self, i64 %x) {
entry:
  %self1 = alloca { i64, i64, i64, i64, i64, double }*, align 8
  store { i64, i64, i64, i64, i64, double }* %self, { i64, i64, i64, i64, i64, double }** %self1, align 8
  %x2 = alloca i64, align 8
  store i64 %x, i64* %x2, align 4
  %a = alloca i64, align 8
  %x3 = load i64, i64* %x2, align 4
  %static_field = load i64, i64* @offset, align 4
  %tmp = add i64 %x3, %static_field
  store i64 %tmp, i64* %a, align 4
  %a4 = load i64, i64* %a, align 4
  ret i64 %a4
}

define void @bark({ i64, i64, i64, i64, i64, double }* %self) {
entry:
  %self1 = alloca { i64, i64, i64, i64, i64, double }*, align 8
  store { i64, i64, i64, i64, i64, double }* %self, { i64, i64, i64, i64, i64, double }** %self1, align 8
  %printf = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt.8, i32 0, i32 0), i8* getelementptr inbounds ([24 x i8], [24 x i8]* @str, i32 0, i32 0))
  ret void
}

define void @bark1() {
entry:
  %printf = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt.14, i32 0, i32 0), i8* getelementptr inbounds ([21 x i8], [21 x i8]* @str.15, i32 0, i32 0))
  ret void
}

declare noalias i8* @malloc(i32)

define { i64, i64, i64, i64, i64, double }* @Cat() {
entry:
  %malloccall = tail call i8* @malloc(i32 ptrtoint ({ i64, i64, i64, i64, i64, double }* getelementptr ({ i64, i64, i64, i64, i64, double }, { i64, i64, i64, i64, i64, double }* null, i32 1) to i32))
  %struct_ptr = bitcast i8* %malloccall to { i64, i64, i64, i64, i64, double }*
  store { i64, i64, i64, i64, i64, double }* %struct_ptr, { i64, i64, i64, i64, i64, double }** @my_struct_ptr.3, align 8
  %field_ptr = getelementptr inbounds { i64, i64, i64, i64, i64, double }, { i64, i64, i64, i64, i64, double }* %struct_ptr, i32 0, i32 0
  store i64 0, i64* %field_ptr, align 4
  %field_ptr1 = getelementptr inbounds { i64, i64, i64, i64, i64, double }, { i64, i64, i64, i64, i64, double }* %struct_ptr, i32 0, i32 1
  store i64 0, i64* %field_ptr1, align 4
  %field_ptr2 = getelementptr inbounds { i64, i64, i64, i64, i64, double }, { i64, i64, i64, i64, i64, double }* %struct_ptr, i32 0, i32 2
  store i64 0, i64* %field_ptr2, align 4
  %field_ptr3 = getelementptr inbounds { i64, i64, i64, i64, i64, double }, { i64, i64, i64, i64, i64, double }* %struct_ptr, i32 0, i32 3
  store i64 0, i64* %field_ptr3, align 4
  %field_ptr4 = getelementptr inbounds { i64, i64, i64, i64, i64, double }, { i64, i64, i64, i64, i64, double }* %struct_ptr, i32 0, i32 4
  store i64 0, i64* %field_ptr4, align 4
  %field_ptr5 = getelementptr inbounds { i64, i64, i64, i64, i64, double }, { i64, i64, i64, i64, i64, double }* %struct_ptr, i32 0, i32 5
  store double 0.000000e+00, double* %field_ptr5, align 8
  ret { i64, i64, i64, i64, i64, double }* %struct_ptr
}

define void @bark.2({ i64, i64, i64, i64, i64, double }* %self) {
entry:
  %self1 = alloca { i64, i64, i64, i64, i64, double }*, align 8
  store { i64, i64, i64, i64, i64, double }* %self, { i64, i64, i64, i64, i64, double }** %self1, align 8
  %printf = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt.18, i32 0, i32 0), i8* getelementptr inbounds ([11 x i8], [11 x i8]* @str.19, i32 0, i32 0))
  ret void
}

define void @class_name({ i64, i64, i64, i64, i64, double }* %self) {
entry:
  %self1 = alloca { i64, i64, i64, i64, i64, double }*, align 8
  store { i64, i64, i64, i64, i64, double }* %self, { i64, i64, i64, i64, i64, double }** %self1, align 8
  %printf = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt.22, i32 0, i32 0), i8* getelementptr inbounds ([18 x i8], [18 x i8]* @str.23, i32 0, i32 0))
  ret void
}

define void @eat({ i64, i64, i64, i64, i64, double }* %self) {
entry:
  %self1 = alloca { i64, i64, i64, i64, i64, double }*, align 8
  store { i64, i64, i64, i64, i64, double }* %self, { i64, i64, i64, i64, i64, double }** %self1, align 8
  %printf = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt.26, i32 0, i32 0), i8* getelementptr inbounds ([16 x i8], [16 x i8]* @str.27, i32 0, i32 0))
  ret void
}

define i64 @num({ i64, i64, i64, i64, i64, double }* %self, i64 %x) {
entry:
  %self1 = alloca { i64, i64, i64, i64, i64, double }*, align 8
  store { i64, i64, i64, i64, i64, double }* %self, { i64, i64, i64, i64, i64, double }** %self1, align 8
  %x2 = alloca i64, align 8
  store i64 %x, i64* %x2, align 4
  %x3 = load i64, i64* %x2, align 4
  %printf = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt.28, i32 0, i32 0), i64 %x3)
  %x4 = load i64, i64* %x2, align 4
  %tmp = add i64 %x4, 2
  ret i64 %tmp
}

define i64 @main() {
entry:
  %ob2 = alloca { i64, i64, i64, i64, i64, double }*, align 8
  %Animal_result = call { i64, i64, i64, i64, i64, double }* @Animal.1(i64 87, i64 100)
  store { i64, i64, i64, i64, i64, double }* %Animal_result, { i64, i64, i64, i64, i64, double }** %ob2, align 8
  %ob3 = alloca { i64, i64, i64, i64, i64, double }*, align 8
  %Animal_result1 = call { i64, i64, i64, i64, i64, double }* @Animal()
  store { i64, i64, i64, i64, i64, double }* %Animal_result1, { i64, i64, i64, i64, i64, double }** %ob3, align 8
  %c = alloca { i64, i64, i64, i64, i64, double }*, align 8
  %Cat_result = call { i64, i64, i64, i64, i64, double }* @Cat()
  store { i64, i64, i64, i64, i64, double }* %Cat_result, { i64, i64, i64, i64, i64, double }** %c, align 8
  %c2 = load { i64, i64, i64, i64, i64, double }*, { i64, i64, i64, i64, i64, double }** %c, align 8
  call void @bark.2({ i64, i64, i64, i64, i64, double }* %c2)
  %ob23 = load { i64, i64, i64, i64, i64, double }*, { i64, i64, i64, i64, i64, double }** %ob2, align 8
  %field_ptr = getelementptr inbounds { i64, i64, i64, i64, i64, double }, { i64, i64, i64, i64, i64, double }* %ob23, i32 0, i32 5
  %0 = load double, double* %field_ptr, align 8
  %printf = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt.4, i32 0, i32 0), double %0)
  %ob24 = load { i64, i64, i64, i64, i64, double }*, { i64, i64, i64, i64, i64, double }** %ob2, align 8
  %field_ptr5 = getelementptr inbounds { i64, i64, i64, i64, i64, double }, { i64, i64, i64, i64, i64, double }* %ob24, i32 0, i32 0
  %1 = load i64, i64* %field_ptr5, align 4
  %printf6 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i64 %1)
  %static_field = load i64, i64* @f1, align 4
  %printf7 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i64 %static_field)
  %ob28 = load { i64, i64, i64, i64, i64, double }*, { i64, i64, i64, i64, i64, double }** %ob2, align 8
  %sum_result = call i64 @sum({ i64, i64, i64, i64, i64, double }* %ob28, i64 2)
  %printf9 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i64 %sum_result)
  %ob2cpy = alloca { i64, i64, i64, i64, i64, double }*, align 8
  %ob210 = load { i64, i64, i64, i64, i64, double }*, { i64, i64, i64, i64, i64, double }** %ob2, align 8
  store { i64, i64, i64, i64, i64, double }* %ob210, { i64, i64, i64, i64, i64, double }** %ob2cpy, align 8
  %ob211 = load { i64, i64, i64, i64, i64, double }*, { i64, i64, i64, i64, i64, double }** %ob2, align 8
  %ob2cpy12 = load { i64, i64, i64, i64, i64, double }*, { i64, i64, i64, i64, i64, double }** %ob2cpy, align 8
  %tmp = icmp eq { i64, i64, i64, i64, i64, double }* %ob211, %ob2cpy12
  %printf13 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i1 %tmp)
  %ob214 = load { i64, i64, i64, i64, i64, double }*, { i64, i64, i64, i64, i64, double }** %ob2, align 8
  %ob315 = load { i64, i64, i64, i64, i64, double }*, { i64, i64, i64, i64, i64, double }** %ob3, align 8
  %tmp16 = icmp eq { i64, i64, i64, i64, i64, double }* %ob214, %ob315
  %printf17 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i1 %tmp16)
  call void @bark1()
  %ob218 = load { i64, i64, i64, i64, i64, double }*, { i64, i64, i64, i64, i64, double }** %ob2, align 8
  call void @bark({ i64, i64, i64, i64, i64, double }* %ob218)
  %ob219 = load { i64, i64, i64, i64, i64, double }*, { i64, i64, i64, i64, i64, double }** %ob2, align 8
  %field_ptr20 = getelementptr inbounds { i64, i64, i64, i64, i64, double }, { i64, i64, i64, i64, i64, double }* %ob219, i32 0, i32 1
  store i64 198, i64* %field_ptr20, align 4
  %res1 = alloca i64, align 8
  %ob221 = load { i64, i64, i64, i64, i64, double }*, { i64, i64, i64, i64, i64, double }** %ob2, align 8
  %sum_result22 = call i64 @sum({ i64, i64, i64, i64, i64, double }* %ob221, i64 3)
  store i64 %sum_result22, i64* %res1, align 4
  %res123 = load i64, i64* %res1, align 4
  %printf24 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i64 %res123)
  %ob325 = load { i64, i64, i64, i64, i64, double }*, { i64, i64, i64, i64, i64, double }** %ob3, align 8
  %field_ptr26 = getelementptr inbounds { i64, i64, i64, i64, i64, double }, { i64, i64, i64, i64, i64, double }* %ob325, i32 0, i32 1
  store i64 34, i64* %field_ptr26, align 4
  %res2 = alloca i64, align 8
  %ob327 = load { i64, i64, i64, i64, i64, double }*, { i64, i64, i64, i64, i64, double }** %ob3, align 8
  %sum_result28 = call i64 @sum({ i64, i64, i64, i64, i64, double }* %ob327, i64 4)
  store i64 %sum_result28, i64* %res2, align 4
  %res229 = load i64, i64* %res2, align 4
  %printf30 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i64 %res229)
  call void @bark1()
  %arr = alloca { i64, i64, i64, i64, i64, double }**, align 8
  %2 = trunc i64 3 to i32
  %mallocsize = mul i32 %2, ptrtoint ({ i64, i64, i64, i64, i64, double }** getelementptr ({ i64, i64, i64, i64, i64, double }*, { i64, i64, i64, i64, i64, double }** null, i32 1) to i32)
  %malloccall = tail call i8* @malloc(i32 %mallocsize)
  %array = bitcast i8* %malloccall to { i64, i64, i64, i64, i64, double }**
  store { i64, i64, i64, i64, i64, double }** %array, { i64, i64, i64, i64, i64, double }*** %arr, align 8
  %arr31 = load { i64, i64, i64, i64, i64, double }**, { i64, i64, i64, i64, i64, double }*** %arr, align 8
  %array32 = getelementptr { i64, i64, i64, i64, i64, double }*, { i64, i64, i64, i64, i64, double }** %arr31, i64 1
  %ob233 = load { i64, i64, i64, i64, i64, double }*, { i64, i64, i64, i64, i64, double }** %ob2, align 8
  store { i64, i64, i64, i64, i64, double }* %ob233, { i64, i64, i64, i64, i64, double }** %array32, align 8
  %copy = alloca { i64, i64, i64, i64, i64, double }*, align 8
  %arr34 = load { i64, i64, i64, i64, i64, double }**, { i64, i64, i64, i64, i64, double }*** %arr, align 8
  %array35 = getelementptr { i64, i64, i64, i64, i64, double }*, { i64, i64, i64, i64, i64, double }** %arr34, i64 1
  %arr36 = load { i64, i64, i64, i64, i64, double }*, { i64, i64, i64, i64, i64, double }** %array35, align 8
  store { i64, i64, i64, i64, i64, double }* %arr36, { i64, i64, i64, i64, i64, double }** %copy, align 8
  %copy37 = load { i64, i64, i64, i64, i64, double }*, { i64, i64, i64, i64, i64, double }** %copy, align 8
  call void @bark({ i64, i64, i64, i64, i64, double }* %copy37)
  ret i64 0
}
