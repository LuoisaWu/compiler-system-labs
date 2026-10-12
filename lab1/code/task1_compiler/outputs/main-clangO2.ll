; ModuleID = 'src/main.c'
source_filename = "src/main.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

; Function Attrs: nofree nounwind uwtable
define dso_local noundef i32 @main() local_unnamed_addr #0 {
  %1 = alloca i32, align 4
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %1) #4
  %2 = call i32 (ptr, ...) @__isoc99_scanf(ptr noundef nonnull @.str, ptr noundef nonnull %1)
  %3 = load i32, ptr %1, align 4, !tbaa !5
  %4 = icmp slt i32 %3, 2
  br i1 %4, label %35, label %5

5:                                                ; preds = %0
  %6 = add nsw i32 %3, -1
  %7 = icmp ult i32 %3, 9
  br i1 %7, label %26, label %8

8:                                                ; preds = %5
  %9 = and i32 %6, -8
  %10 = or disjoint i32 %9, 2
  br label %11

11:                                               ; preds = %11, %8
  %12 = phi i32 [ 0, %8 ], [ %19, %11 ]
  %13 = phi <4 x i32> [ splat (i32 1), %8 ], [ %17, %11 ]
  %14 = phi <4 x i32> [ splat (i32 1), %8 ], [ %18, %11 ]
  %15 = phi <4 x i32> [ <i32 2, i32 3, i32 4, i32 5>, %8 ], [ %20, %11 ]
  %16 = add <4 x i32> %15, splat (i32 4)
  %17 = mul <4 x i32> %13, %15
  %18 = mul <4 x i32> %14, %16
  %19 = add nuw i32 %12, 8
  %20 = add <4 x i32> %15, splat (i32 8)
  %21 = icmp eq i32 %19, %9
  br i1 %21, label %22, label %11, !llvm.loop !9

22:                                               ; preds = %11
  %23 = mul <4 x i32> %18, %17
  %24 = call i32 @llvm.vector.reduce.mul.v4i32(<4 x i32> %23)
  %25 = icmp eq i32 %6, %9
  br i1 %25, label %35, label %26

26:                                               ; preds = %5, %22
  %27 = phi i32 [ 1, %5 ], [ %24, %22 ]
  %28 = phi i32 [ 2, %5 ], [ %10, %22 ]
  br label %29

29:                                               ; preds = %26, %29
  %30 = phi i32 [ %32, %29 ], [ %27, %26 ]
  %31 = phi i32 [ %33, %29 ], [ %28, %26 ]
  %32 = mul nuw nsw i32 %30, %31
  %33 = add nuw i32 %31, 1
  %34 = icmp eq i32 %31, %3
  br i1 %34, label %35, label %29, !llvm.loop !13

35:                                               ; preds = %29, %22, %0
  %36 = phi i32 [ 1, %0 ], [ %24, %22 ], [ %32, %29 ]
  %37 = call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str.1, i32 noundef %36)
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %1) #4
  ret i32 0
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: nofree nounwind
declare noundef i32 @__isoc99_scanf(ptr noundef readonly captures(none), ...) local_unnamed_addr #2

; Function Attrs: nofree nounwind
declare noundef i32 @printf(ptr noundef readonly captures(none), ...) local_unnamed_addr #2

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.vector.reduce.mul.v4i32(<4 x i32>) #3

attributes #0 = { nofree nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { nofree nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #4 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{!"Ubuntu clang version 21.1.8 (6ubuntu1)"}
!5 = !{!6, !6, i64 0}
!6 = !{!"int", !7, i64 0}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C/C++ TBAA"}
!9 = distinct !{!9, !10, !11, !12}
!10 = !{!"llvm.loop.mustprogress"}
!11 = !{!"llvm.loop.isvectorized", i32 1}
!12 = !{!"llvm.loop.unroll.runtime.disable"}
!13 = distinct !{!13, !10, !12, !11}
