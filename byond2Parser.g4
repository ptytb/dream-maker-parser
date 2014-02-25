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
    :    ID COLON?
    ;

string
    :   STRING
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
        ((CALL | PICK | VAR | OBJ | PROC | NEW | LIST | ID)
        | op_deref)
    ;

path_expr
    :   internal_var 
    |   (CALL | PICK | VAR | OBJ | PROC | NEW | LIST | ID) WS?
    |   WS? (CALL | PICK | VAR | OBJ | PROC | NEW | LIST | ID)
    |   WS? (SLASH | COLON | POINT) path_expr_tail
    ;

path_expr_tail
    :   (CALL | PICK | VAR | OBJ | PROC | NEW | LIST | ID)
        (   WS
        |   (SLASH (WS | path_expr_tail))
        )?
    ;

path
    :    WS? (SLASH | COLON | POINT)? path_head
    ;

path_tail
    :   newline* block
    |   ID listDef? (EQ expr)? ( COMMA ID listDef? (EQ expr)? )*
    |
    (
        (   CALL | PICK | VAR | OBJ | PROC | NEW | LIST | ID )

        (   newline* block
        |   procDef newline* block
        |   SLASH path_tail? )?
    )
    ;

path_head
    :   internal_var 
    |   VAR path_tail
    |
    (   ID  listDef
    |   ID  procDef newline* block
    |   (
        (   CALL | PICK | VAR | OBJ | PROC | NEW | LIST | ID )

        (   newline* block
        |   SLASH path_tail? )?
        )
    )
    ;

listDef
    :   (LBRACK expr? RBRACK)+
    ;

procDef
    :   LPAREN
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
    :   path (EQ expr)? (AS path (BITOR path)* (IN expr)? )?  
    ;

procCall
    :   callable LPAREN actualParameters? RPAREN
    ;

loop_for
    :   FOR
        LPAREN
        (   in_expr
        |   path (AS path (BITOR path)* (IN expr)? )?  
        |   statement? (SEMI | COMMA) expr? (SEMI | COMMA) statement?
        /*|   expr*/
        |   statement TO expr
        )
        RPAREN
        (   newline* statement
        |   newline* block)
    ;

callable
    :   ID
    |   path
    |   op_deref
    ;

loop_while
    :   WHILE
        LPAREN expr RPAREN
        (   newline* statement
        |   newline* block)
    ;

loop_do
    :   DO
        (   newline* statement
        |   newline* block)
        newline*
        WHILE LPAREN expr RPAREN
    ;

stat_goto
    :   GOTO
        ID
    ;

if_cond
    :   IF
        LPAREN
        (   exprList 
        |   expr TO expr    // make separate ``if_range''
        )
        RPAREN
        (   newline* statement
        |   newline* block)
    ;

if_else
    :   ELSE
        (   newline* statement
        |   newline* block)
    ;

in_expr
    :   path IN expr
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
        (   newline* statement
        |   newline* block)
    ;

stat_del
    :   DEL
        (   (path | op_deref)
        |   LPAREN (path | op_deref) RPAREN)
    ;

stat_switch
    :   SWITCH
        LPAREN expr RPAREN
        (   newline* statement
        |   newline* block)
    ;

stat_call
    :   CALL 
        
        LPAREN
        (   (path)
        |   (path COMMA path)
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
    :   (STRING | INT | ID) EQ (STRING | INT | ID)
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
    |   stat_internal
    |   set
    |   stat_del
    |   loop_for
    |   loop_do
    |   loop_while
    |   if_cond
    |   if_else
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
    |   string
    |   INT
    |   FLOAT
    |   expr IN expr
    |   op_deref
    |   (path_expr | procCall) (AS path_expr (IN expr)?)?
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
    |   var_null
    ;

var_default_ret
    :   POINT 
    ;

super_ref
    :   POINT POINT
    ;

var_null
    :   NULL 
    ;
