.class public main
.super java/lang/Object
.method public static main([Ljava/lang/String;)V
.limit stack 20
.limit locals 20

ldc 5
istore 0
iload 0
ldc 6
ldc 5
imul 
ldc 30
istore 1
ldc 0
istore 2
ldc 48
ldc 6
idiv 
ldc 8
istore 1 
ldc 4
ldc 0
imul 
iload 1
ldc 19
ldc 8
iadd 
ldc 27
ldc 10
imul 
ldc 270
istore 2 
iload 0
iload 2
ldc 5
ldc 270
imul 
ldc 1350 
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/println(I)V
ldc "Compile Failure!" 
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
ldc "Exist 5 errors" 
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
return

.end method
