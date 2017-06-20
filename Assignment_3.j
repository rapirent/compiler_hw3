.class public main
.super java/lang/Object
.method public static main([Ljava/lang/String;)V
.limit stack 20
.limit locals 20

ldc 30.000000
ldc 6.500000
fdiv 
ldc 4.615385 
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/println(F)V
ldc 5
istore 0
ldc 20.500000
fstore 1
fload 1
iload 0
ldc 20.500000
ldc 5.000000
fdiv 
ldc 4.100000 
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/println(F)V
ldc 20.500000
ldc 5.000000
fdiv 
ldc 4.100000 
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/println(F)V
ldc "Compile Success!"
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
return

.end method
