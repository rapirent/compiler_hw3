# compiler_hw3

- description: 編譯系統的作業三
- author: 丁國騰
- student number: E94036209

# start


- lex

```
    flex Compiler_E94036209_HW3.l 
```

- yacc

```
    yacc Compiler_E94036209_HW3.y -d
```

- compile with gcc

```
    gcc lex.yy.c y.tab.c -o output
```



- generate the java assemble code 

```
    ./ouptut < [your_output]
```

- use jasmin (provided in this repo) to deal with assemble code

```
    java -jar jasmin.jar Assignment_3.j
```

- execute with jvm

```
    java main
```

# LICENSE

MIT @ kuoteng, Ding
