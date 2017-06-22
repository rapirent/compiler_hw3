/*
	Topic: Homework2 for Compiler Course
    author: Kuo Teng, Ding
	Deadline: xxx.xx.xxxx
*/

%{

/*	Definition section */
/*	insert the C library and variables you need */

#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
/*Extern variables that communicate with lex*/
#define KRED  "\x1B[31m"
#define KWHT  "\x1B[0m"
extern int yylineno;
extern int yylex();
extern char* yytext;
void yyerror(char *);

void create_symbol();								/*establish the symbol table structure*/
void insert_symbol(char* id, char* type, double data, int is_assign);/*Insert an undeclared ID in symbol table*/
void symbol_assign(char* id, double data);				/*Assign value to a declared ID in symbol table*/
int lookup_symbol(char* id, int* symbol_stack_num);		/*Confirm the ID exists in the symbol table*/
void dump_symbol();									/*List the ids and values of all data*/
double lookup_double_sym(char* id);

/*for jasmin*/
FILE *file;
int error_count = 0;
int stack_count = 0;
////


int symnum;											/*The number of the symbol*/
const int eps = 1e-10;
int stmt_has_float;
int error = 0;

struct symbol {
    char sym_type[10];
    char name[100];
    double ddata;
    int idata;
    int stack_num;
    struct symbol *next;
    struct symbol *pre;
};

struct symbol *symbol_table = NULL;

/* Note that you should define the data structure of the symbol table yourself by any form */

%}

/* Token definition */

%union{
    int ival;
    double dval;
    char sval[100];
    char typeval[10];
}
/* Type declaration : */
%token SEM PRINT WHILE LB RB
%token ADD SUB MUL DIV
%token ASSIGN
%token <ival> NUMBER
%token <dval> FLOATNUM
%token <sval> ID STRING
%token <typeval> INT DOUBLE
/*避免ambigious*/
%left GE LE EQ NE G L
%left ADD SUB
%left MUL DIV

%nonassoc UMINUS

/*
	Use %type to specify the type of token within < >
	if the token or name of grammar rule will return value($$)

*/
%type <typeval> type
%type <dval> factor term arith group LB RB
%%

/* Define your parser grammar rule and the rule action */


lines:
     |lines stmt {
        error = 0;
        stmt_has_float = 0;
     }
     ;

stmt: decl SEM
    | arith SEM
    | print SEM
    | assign SEM
    ;
decl:type ID
    {
        if(!symnum) {
           printf("Create symbol table\n");
        }
        insert_symbol($2,$1,0,0);
    }
    |type ID ASSIGN arith
    {
        if(!symnum) {
            printf("Create Symbol table\n");
        }
        insert_symbol($2,$1,$4,1);
    }
    ;
type: INT {strcpy($$,"int");}
    | DOUBLE {strcpy($$,"double");}
    ;
assign: ID ASSIGN arith
    {
        if(!error) {
            symbol_assign($1, $3);
        }
        else {
            symbol_assign($1,0);
        }
        printf("ASSIGN\n");
    }
    ;
arith:term
    | arith ADD term
    {
        $$ = $1 + $3;
        printf("ADD\n");
        if(stmt_has_float) {
            fprintf(file,"ldc %lf\n",$1);
            fprintf(file,"ldc %lf\n",$3);
            fprintf(file, "fadd \n");
        }
        else {
            fprintf(file,"ldc %d\n",(int)$1);
            fprintf(file,"ldc %d\n",(int)$3);
            fprintf(file,"iadd \n");
        }
    }
    | arith SUB term
    {
        $$ = $1 - $3;
        printf("SUB\n");
        if(stmt_has_float) {
            fprintf(file,"ldc %lf\n",$1);
            fprintf(file,"ldc %lf\n",$3);
            fprintf(file,"fsub \n");
        }
        else {
            fprintf(file,"ldc %d\n",(int)$1);
            fprintf(file,"ldc %d\n",(int)$3);
            fprintf(file,"isub \n");
        }
    }
    ;
term: factor
    | term MUL factor
    {
        $$ = $1 * $3;
        printf("MUL\n");
        if(stmt_has_float) {
            fprintf(file,"ldc %lf\n",$1);
            fprintf(file,"ldc %lf\n",$3);
            fprintf(file,"fmul \n");
        }
        else {
            fprintf(file,"ldc %d\n",(int)$1);
            fprintf(file,"ldc %d\n",(int)$3);
            fprintf(file,"imul \n");
        }
    }
    | term DIV factor
    {
        if($3 == 0) {
            char tmp[200]="The divisor can’t be 0";
            yyerror(tmp);
        }
        else {
            $$ = $1 / $3;
            if(stmt_has_float) {
                fprintf(file,"ldc %lf\n",$1);
                fprintf(file,"ldc %lf\n",$3);
                fprintf(file,"fdiv \n");
            }
            else {
                fprintf(file,"ldc %d\n",(int)$1);
                fprintf(file,"ldc %d\n",(int)$3);
                fprintf(file,"idiv \n");
            }
        }
        printf("DIV\n");
    }
    ;
factor: group
    {
        $$ = $1;
    }
    | SUB NUMBER
    {
        $$ = -$2;
        //fprintf(file,"ldc %d \n",-$2);
    }
    | NUMBER
    {
        $$ = $1;
        //fprintf(file,"ldc %d \n",$1);
    }
    | FLOATNUM
    {
        $<dval>$ = $1;
        stmt_has_float = 1;
        //fprintf(file,"ldc %lf \n",$1);
    }
    | ID
    {
        int check;
        int symbol_stack_num;
        if(!(check = lookup_symbol($1,&symbol_stack_num))) {
            char tmp[200]={0};
            strcat(tmp,"can’t find variable ");
            strcat(tmp,$1);
            yyerror(tmp);
        
        }
        else {
            if(check==1) {
                $$ = (int)lookup_double_sym($1);
                fprintf(file,"iload %d\n",symbol_stack_num);
            }
            else if(check==2) {
                $<dval>$ = lookup_double_sym($1);
                fprintf(file,"fload %d\n",symbol_stack_num);
                stmt_has_float = 1;
            }
        }

    }
    ;
print: PRINT group
    {
//        if(!error) {
            if(stmt_has_float) {
                printf("Print : %lf\n",$2);
                fprintf(file, "ldc %lf \n",$2);
                fprintf(file, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
                fprintf(file, "swap\n");
                fprintf(file, "invokevirtual java/io/PrintStream/println(F)V\n");
            }
            else {
                printf("Print : %d\n",(int)$2);
                fprintf(file, "ldc %d \n",(int)$2);
                fprintf(file, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
                fprintf(file, "swap\n");
                fprintf(file, "invokevirtual java/io/PrintStream/println(I)V\n");

            }
//        }
    }
    | PRINT LB STRING RB
    {
        printf("Print : %s\n",$3);
        fprintf(file, "ldc %s \n",$3);
        fprintf(file, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
        fprintf(file, "swap\n");
        fprintf(file, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n"); 
    }
    ;
group:LB arith RB
    {
        $$ = $2;
    }
    ;
%%

int main(int argc, char** argv)
{
    file = fopen("Assignment_3.j","w");
    fprintf(file,".class public main\n.super java/lang/Object\n");
    fprintf(file,".method public static main([Ljava/lang/String;)V\n");
    fprintf(file,".limit stack %d\n.limit locals %d\n\n",20,20);
    yylineno = 1;
    symnum = 0;
    stmt_has_float=0;
    error = 0;
    error_count = 0;
//    yyparse();

    yyparse();


    if(error_count) {
        fprintf(file, "ldc \"Compile Failure!\" \n");
        fprintf(file, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
        fprintf(file, "swap\n");
        fprintf(file, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n"); 
 
        fprintf(file, "ldc \"Exist %d errors\" \n",error_count);
        fprintf(file, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
        fprintf(file, "swap\n");
        fprintf(file, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n"); 
 
    }
    else {
        fprintf(file, "ldc \"Compile Success!\"\n");
        fprintf(file, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
        fprintf(file, "swap\n");
        fprintf(file, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n"); 
    }
    
    fprintf(file,"return\n\n.end method\n");
    fclose(file);
//	printf("%d \n\n",yylineno);
    dump_symbol();
    printf("\nGenerated: %s\n","Assignment_3.j");
    return 0;
}

void yyerror(char *s) {
    error = 1;
    printf("%s<ERROR>%s ",KRED,KWHT);
    printf("%s (line %d)\n",s,yylineno);
    error_count++;
//    printf("%s on %d line %s \n",s , yylineno, yytext);
}


/*symbol create function*/
void create_symbol() {
    struct symbol *new_node;
    new_node = malloc(sizeof(struct symbol));
    if (new_node == NULL) {
        exit(EXIT_FAILURE);
    }
    memset(new_node->sym_type,0,sizeof(new_node->sym_type));
    memset(new_node->name,0,sizeof(new_node->name));
    new_node->idata = 0;
    new_node->ddata = 0.0;
    new_node->pre = NULL;
    new_node->stack_num = -1;
    if(symbol_table != NULL) {
        symbol_table -> pre = new_node;
    }
    new_node->next = symbol_table;
    symbol_table = new_node;

}

/*symbol insert function*/
void insert_symbol(char* id, char* type, double data, int is_assign) {
    int dump;
    if(lookup_symbol(id,&dump)!=0) {
        char tmp[200] = {0};
        strcat(tmp,"re-declaration for variable ");
        strcat(tmp,id);
        yyerror(tmp);
        return;
    }
    create_symbol();
    if(!strcmp(type,"int")) {
        symbol_table->idata = (int)data;
        if(is_assign) {
            fprintf(file,"ldc %d\n",(int)data);
            fprintf(file,"istore %d\n",stack_count);
        }
    }
    else if(!strcmp(type,"double")){
        symbol_table->ddata = data;
        if(is_assign) {
            fprintf(file,"ldc %lf\n",data);
            fprintf(file,"fstore %d\n",stack_count);
        }
    }
    else {
        printf("this symbol %s's type can't be distinguished\n",id);
    }
    strcpy(symbol_table->name,id);
    strcpy(symbol_table->sym_type,type);
    symbol_table->stack_num = stack_count++;
    printf("Insert a symbol: %s\n",id);
    symnum++;
}


/*symbol value lookup and check exist function*/
int lookup_symbol(char* id, int* symbol_stack_num) {
    struct symbol *tmp  = symbol_table;
    while(tmp!=NULL&&tmp->name!=NULL) {
        if(!strcmp(tmp->name,id)) {
            *symbol_stack_num = tmp->stack_num;
            if(!strcmp(tmp->sym_type,"int")) {
                return 1;
            }
            else if(!strcmp(tmp->sym_type, "double")) {
                return 2;
            }
            else {
                printf("this symbol's type can't be distinguished\n");
                return 0;
            }
        }
        tmp = tmp->next;
    }
    return 0;
}

/*symbol value assign function*/
void symbol_assign(char* id, double data) {
    int check;
    int dump;
    if(!(check = lookup_symbol(id,&dump))) {
        char str[200] = {0};
        strcat(str,"can’t find variable ");
        strcat(str,id);
        yyerror(str);
        return;
    }
    struct symbol *tmp  = symbol_table;
    if(check==1) {
        while(tmp!=NULL&&tmp->name!=NULL) {
            if(!strcmp(tmp->name,id)) {
                tmp->idata = (int)data;
                fprintf(file, "ldc %d\n",(int)data);
                fprintf(file, "istore %d \n", tmp->stack_num);
                return;
            }
            tmp = tmp->next;
        }
    }
    else if(check==2) {
        while(tmp!=NULL&&tmp->name!=NULL) {
            if(!strcmp(tmp->name,id)) {
                tmp->ddata = data;
                fprintf(file,"ldc %lf\n",data);
                fprintf(file, "fstore %d \n", tmp->stack_num);
                return;
            }
            tmp = tmp->next;
        }
    }
    else {
        printf("this symbol's type can't be distinguished\n");
    }
}

/*symbol dump function*/
void dump_symbol(){
    printf("Total lines: %d.\n\n",yylineno);
    printf("The symbol table: \n\n");
    struct symbol *tmp = symbol_table;
    if(tmp == NULL) {
        printf("symbol table is empty\n");
        return;
    }
    printf("ID \t Type \t Data\n");
    while(tmp->next!=NULL) {
        tmp = tmp->next;
    }
    while(tmp!=NULL) {
        if(!strcmp(tmp->sym_type,"int")) {
            printf("%s \t %s \t %d\n",tmp->name,tmp->sym_type,tmp->idata);
        }
        else if(!strcmp(tmp->sym_type,"double")) {
            printf("%s \t %s  %lf\n",tmp->name,tmp->sym_type,tmp->ddata);
        }
        else {
            printf("this symbol's type can't be distinguished\n");
        }
        tmp = tmp->pre;
        if(tmp!=NULL) {
            free(tmp->next);
        }
    }

}
double lookup_double_sym(char* id) {
    struct symbol *tmp  = symbol_table;
    while(tmp!=NULL&&tmp->name!=NULL) {
        if(!strcmp(tmp->name,id)) {
            if(!strcmp(tmp->sym_type,"int")) {
                return (double)tmp->idata;
            }
            else if(!strcmp(tmp->sym_type,"double")){
                return tmp->ddata;
            }
            else {
                printf("this symbol's type can't be distinguished\n");
            }
        }
        tmp = tmp->next;
    }
}

