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
    :   LCURV line?  RCURV
    |   LCURV line? newline+
        (INDENT block_inner?)?
        (DEDENT newline* RCURV | RCURV (newline+ DEDENT)?)
    ;

block_indented
    :   INDENT block_inner?  DEDENT
    ;

block
    :   block_braced
    |   block_indented
    ;

line
    :   statement (SEMI statement?)*
    ;

block_inner_switch
    :   newline*
        if_const
        (   newline if_const
        |   newline
        )*
    (   ELSE
        (newline* block_proc | statement_proc)? )?
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

block_inner_proc
    :   newline*

    (   block_proc
    |   line_proc )

    (   newline line_proc
    |   newline block_proc
    |   newline
    )*
    ;

block_braced_proc
    :   LCURV line_proc?  RCURV
    |   LCURV line_proc? newline+
        (INDENT block_inner_proc?)?
        (DEDENT newline* RCURV | RCURV (newline+ DEDENT)?)
    ;

block_indented_proc
    :   INDENT block_inner_proc?  DEDENT
    ;

block_proc
    :   block_braced_proc
    |   block_indented_proc
    ;

line_proc
    :   statement_proc (SEMI statement_proc?)*
    ;

set
    :   SET
        (   op_assign
        |   expr IN expr
        )
    ;

path_elem
    :   CALL | PICK | VAR | OBJ | PROC | NEW | LIST | STEP | ID | POINT+
    ;

op_deref
    :   path_elem (POINT | COLON) (path_elem | op_deref)
    ;

path_expr
    :   internal_var 
    |   WS? path_elem WS?
    |   WS? (SLASH | COLON | POINT) path_elem (SLASH path_elem)* SLASH? WS?
    ;

path
    :   WS?
    (   internal_var
    |   (SLASH | COLON | POINT)? path_elem (SLASH path_elem)* SLASH? WS?
    |   (SLASH | COLON | POINT) WS?
    ) 
    ;

stat_var
    :   VAR path
    (   block
    |   listDef? (EQ expr)? ( COMMA path listDef? (EQ expr)? )*
    )
    ;

listDef
    :   (LBRACK expr? RBRACK)+
    ;

procDef
    :   path
        LPAREN
        (   formalParameters
        |   POINT POINT POINT)?
        RPAREN
        (newline* block_proc | statement_proc)
    ;

procDecl
    :   path
        LPAREN
        (   formalParameters
        |   POINT POINT POINT)?
        RPAREN
    ;
formalParameters
    :   formalParameter
        (   COMMA
            formalParameter
        )*
    ; 

formalParameter
    :   path listDef? (EQ expr)? (AS path (BITOR path)*)? (IN expr)?  
    ;

procCall
    :   callable LPAREN actualParameters? RPAREN
    (   (IN expr)? (AS path (BITOR path)*)?
    |   (AS path (BITOR path)*)? (IN expr)? )
    ;

loop_for
    :   FOR
        LPAREN
        (   (stat_var | expr) (AS path (BITOR path)*)? (IN expr)? (TO expr)?
            (STEP expr)?
        |   (statement_proc | block_braced_proc)?
            (SEMI | COMMA)
            (expr | LCURV SEMI* expr? SEMI* RCURV)?
            (
            (SEMI | COMMA)
            (statement_proc | block_braced_proc)?
            )?
        )?
        RPAREN
        newline* (block_proc | statement_proc)
    ;

callable
    :   super_ref
    |   var_default_ret
    |   ID | LIST | STEP
    |   op_deref
    ;

loop_while
    :   WHILE
        LPAREN expr RPAREN
        newline* (block_proc | statement_proc)
    ;

loop_do
    :   DO
        newline* (block_proc | statement_proc)
        newline*
        WHILE LPAREN expr RPAREN
    ;

stat_goto
    :   GOTO ID
    ;

if_const
    :   IF
        LPAREN
        (   expr (COMMA expr)* COMMA?
        |   expr (OR expr)*
        |   expr TO expr)
        RPAREN
    (   newline* block_proc | statement_proc)?
        newline*
    ;

if_cond
    :   IF LPAREN expr RPAREN
    (   newline* block_proc | statement_proc)?
        newline*
    (   ELSE (newline* block_proc | statement_proc)? )?
        newline*
    ;

stat_ret
    :   RETURN expr?
    ;

stat_break
    :   BREAK ID?
    ;

stat_cont
    :   CONTINUE ID?
    ;

stat_spawn
    :   SPAWN
        (LPAREN expr? RPAREN)?
        newline* (block_proc | statement_proc)
    ;

stat_del
    :   DEL expr
    ;

stat_switch
    :   SWITCH LPAREN expr RPAREN
        newline* block_switch
    ;

stat_call
    :   CALL 
        LPAREN
        (expr (COMMA expr?)?)?
        RPAREN
        LPAREN
        actualParameters?
        RPAREN
    ;

stat_pick
    :   PICK 
        LPAREN
        (expr (SEMI* expr SEMI*)? COMMA?)* 
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
    |   op_assign
    |   op_op_assign
    |   (INC | DEC) expr
    |   expr (INC | DEC)        
    |   path newline* block
    ;

statement_proc
    :   label
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
    |   expr QMARK expr COLON expr
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

