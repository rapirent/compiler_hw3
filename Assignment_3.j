.class public main
.super java/lang/Object
.method public static main([Ljava/lang/String;)V
.limit stack 10
.limit locals 10

ldc 4 
istore 0
ldc 4
ldc 10 
imul 
ldc 40 
istore 1 
ldc 40
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/println(I)V
ldc 40
ldc 3 
ldc 2 
iadd 
idiv 
ldc 8 
istore 0 
ldc 8
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/println(I)V
ldc "Compile Success!"
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
return

.end method
