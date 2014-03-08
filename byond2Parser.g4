parser grammar byond2Parser;

options
{
    tokenVocab = byond2Lexer;
}


////////////////////////////////////////////////////////////////////////////////
// parser

newline
    :   IGNORE_NEWLINE
    ;

label
    :   ID COLON?
        newline* block?
    ;

constant
    :   STRING
    |   (PLUS | MINUS)? (INT | FLOAT | ID)
    |   NULL
    ;

file
    :   block_inner
        EOF
    ;

block_inner
    :   newline*

    (   block
    |   line )

    (   newline line
    |   newline block
    |   newline
    )*
    ;

block_braced
    :   LCURV
        block_inner?
        RCURV
    ;

block_indented
    :   INDENT
        block_inner?
        DEDENT
    ;

block
    :   block_braced
    |   block_indented
    ;

block_inner_switch
    :   newline*
        if_const
        (   newline if_const
        |   newline
        )*
    (   ELSE
        (newline* block | statement)? )?
        newline*
    ;

block_braced_switch
    :   LCURV
        block_inner_switch?
        RCURV
    ;

block_indented_switch
    :   INDENT
        block_inner_switch?
        DEDENT
    ;

block_switch
    :   block_braced_switch
    |   block_indented_switch
    ;

line
    :   statement (SEMI statement?)*
    |   label
    ;

set
    :   SET
        (   statement
        |   expr IN expr
        )
    ;

op_deref
    :   (CALL | PICK | VAR | OBJ | PROC | NEW | LIST | ID)
        (POINT | COLON)
        ((CALL | PICK | VAR | OBJ | PROC | NEW | LIST | ID) | op_deref)
    ;

path_expr
    :   internal_var 
    |   (CALL | PICK | VAR | OBJ | PROC | NEW | LIST | ID) WS?
    |   WS? (CALL | PICK | VAR | OBJ | PROC | NEW | LIST | ID)
    |   WS? (SLASH | COLON | POINT)
        ((CALL | PICK | VAR | OBJ | PROC | NEW | LIST | ID) SLASH?)+
        (SLASH WS? | WS)?
    ;

path
    :   WS?
    (   internal_var
    |   (SLASH | COLON | POINT)?
        ((CALL | PICK | VAR | OBJ | PROC | LIST | ID ) SLASH?)+)
    ;

stat_var
    :   VAR path listDef? (EQ expr)? ( COMMA path listDef? (EQ expr)? )*
    ;

listDef
    :   (LBRACK expr? RBRACK)+
    ;

procDef
    :   path
        LPAREN
        (   formalParameters
        |   THREE_DOTS)?
        RPAREN
        (newline* block | statement)
        ;

procDecl
    :   path
        LPAREN
        (   formalParameters
        |   THREE_DOTS)?
        RPAREN
    ;
formalParameters
    :   formalParameter
        (   COMMA
            formalParameter
        )*
    ; 

formalParameter
    :   path (EQ expr)? (AS path (BITOR path)*)? (IN expr)?  
    ;

procCall
    :   callable LPAREN actualParameters? RPAREN
        (AS path (BITOR path)*)? (IN expr)?  
    ;

loop_for
    :   FOR
        LPAREN
        (   (stat_var | path) (AS path (BITOR path)*)? (IN expr)? (TO expr)?
        |   (statement | block_braced)? (SEMI | COMMA)
            (expr | LCURV SEMI* expr? SEMI* RCURV)? (SEMI | COMMA)
            (statement | block_braced)?
        )?
        RPAREN
        newline* (block | statement)
    ;

callable
    :   super_ref
    |   ID | LIST
    /*|   path*/
    |   op_deref
    ;

loop_while
    :   WHILE
        LPAREN expr RPAREN
        newline* (block | statement)
    ;

loop_do
    :   DO
        newline* (block | statement)
        newline*
        WHILE LPAREN expr RPAREN
    ;

stat_goto
    :   GOTO ID
    ;

if_const
    :   IF
        LPAREN
        (   expr (COMMA expr)*
        |   expr (OR expr)*
        |   expr TO expr)
        RPAREN
    (   newline* block | statement)?
        newline*
    ;

if_cond
    :   IF LPAREN expr RPAREN
    (   newline* block | statement)?
        newline*
    (   ELSE (newline* block | statement)? )?
        newline*
    ;

stat_ret
    :   RETURN expr?
    ;

stat_break
    :   BREAK
    ;

stat_cont
    :   CONTINUE ID?
    ;

stat_spawn
    :   SPAWN
        (LPAREN expr? RPAREN)?
        newline* (block | statement)
    ;

stat_del
    :   DEL
        (   (path | op_deref)
        |   LPAREN (path | op_deref) RPAREN)
    ;

stat_switch
    :   SWITCH LPAREN expr RPAREN
        newline* block_switch
    ;

stat_call
    :   CALL 
        
        LPAREN
        (   (path_expr | op_deref)
        |   ((path_expr | op_deref) COMMA (path_expr | op_deref))
        |   (STRING COMMA STRING)
        )
        RPAREN
        
        LPAREN
        actualParameters
        RPAREN
    ;

stat_pick
    :   PICK 
        LPAREN
        (expr SEMI)? expr
        (COMMA (expr SEMI)? expr)*
        RPAREN
    ;

stat_internal
    :   stat_call
    |   stat_pick
    ;

op_new
    :   NEW 
        (path | op_deref)?
        (LPAREN actualParameters? RPAREN)?
    ;

op_map_item
    :   (constant | ID) EQ (constant | ID)
    ;

op_assign
    :   expr
        EQ <assoc=right>
        expr
        (AS path (IN expr)?)?
    ;

op_op_assign
    :   expr
    (   EQPLUS <assoc=right>
    |   EQMINUS <assoc=right>
    |   EQMUL <assoc=right>
    |   EQSLASH <assoc=right>
    |   EQMOD <assoc=right>
    |   EQBITOR <assoc=right>
    |   EQBITAND <assoc=right>
    |   EQBITRSH <assoc=right>
    |   EQBITLSH <assoc=right>
    |   EQBITXOR <assoc=right> )
        expr
    ;

statement
    :   path (AS path (IN expr)?)?
    |   procDef
    |   procDecl
    |   stat_var
    |   stat_internal
    |   set
    |   stat_del
    |   loop_for
    |   loop_do
    |   loop_while
    |   if_cond
    |   stat_switch
    |   stat_ret
    |   stat_break
    |   stat_cont
    |   stat_goto
    |   stat_spawn
    |   procCall
    |   op_assign
    |   op_op_assign
    |   op_new
    |   expr BITSHR expr
    |   expr BITSHL expr
    |   (INC | DEC) expr
    |   expr (INC | DEC)        
    |   path newline* block
    ;

expr
    :   LPAREN expr RPAREN
    |   expr LBRACK expr? RBRACK
    |   (PLUS | MINUS) expr
    |   NOT expr
    |   BITNOT expr
    |   (INC | DEC) expr
    |   expr (INC | DEC)
    |   expr POW <assoc=right> expr
    |   expr (WS? SLASH WS? | MUL | MOD) expr
    |   expr (PLUS | MINUS) expr
    |   expr (LT | LTEQ | GT | GTEQ ) expr
    |   expr (BITSHL | BITSHR) expr
    |   expr (CMP | NOTEQ) expr
    |   expr (BITAND) expr
    |   expr (BITXOR) expr
    |   expr (BITOR) expr
    |   expr (AND) expr
    |   expr (OR) expr
    |   expr QMARK expr COLON expr
    |   op_new
    |   stat_internal
    |   procCall
    |   op_map_item
    |   constant
    |   expr IN expr (TO expr)?
    |   op_deref
    |   path_expr
    ; 

exprList
    :   expr (COMMA expr)*
    ; 

actualParameters
    :   (actualParameter | COMMA actualParameter?)
        (COMMA actualParameter | COMMA)*
    ; 
    
actualParameter
    :   path
    |   expr
    |   op_assign
    ;

internal_var
    :   var_default_ret
    |   super_ref
    |   NULL
    ;

var_default_ret
    :   POINT 
    ;

super_ref
    :   POINT POINT
    ;

