.class public main
.super java/lang/Object
.method public static main([Ljava/lang/String;)V
.limit stack 100
.limit locals 100

ldc -100.045000
fstore 0
ldc -5
istore 1
iload 1
ldc -5.000000
ldc 20.550000
fmul 
ldc -102.750000
fstore 0 
fload 0
ldc 5.000000
ldc 5.000000
fadd 
ldc -102.750000
ldc 10.000000
fdiv 
ldc -10
istore 1 
fload 0
ldc -102.750000 
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/println(F)V
ldc "Compile Success!"
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
return

.end method
