.class public main
.super java/lang/Object
.method public static main([Ljava/lang/String;)V
.limit stack 20
.limit locals 20

ldc -100.045000 
fstore 0
ldc -5.500000 
istore 1
iload 1
ldc 20.550000 
fmul 
fstore 0 
fload 0
ldc 5 
ldc 5 
fadd 
fdiv 
istore 1 
fload 0
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/println(F)V
ldc -5 
istore 2
ldc -5.500000 
fstore 3
ldc 5 
ldc 10 
isub 
istore 2 
iload 2
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/println(I)V
fload 3
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/println(F)V
iload 2
fload 3
fmul 
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/println(F)V
iload 1
ldc 2 
imul 
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/println(I)V
ldc 5 
istore 4
iload 4
imul 
ldc "Compile Failure!" 
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
ldc "Exist 1 errors" 
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
return

.end method
