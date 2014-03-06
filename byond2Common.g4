lexer grammar byond2Common;

STRING
    :   '"' (STRING_MACRO | STRING_ESC | EVAL | ~('\\'|'"'))*? '"'
    |   '\'' (STRING_MACRO | STRING_ESC | EVAL | ~('\\'|'"'))*? '\''
    |   STRING_MULTILINE
    ;

fragment EVAL
    :   '[' (EVAL | ~(']'))*? ']'
    ;

fragment STRING_MULTILINE
    :   '{"' .*? '"}'
    ;

fragment STRING_MACRO
    :   '\\'
        ('the' | 'The')
    |   ('a' | 'an' | 'A' | 'An')
    |   ('he' | 'He' | 'she' | 'She')
    |   ('his' | 'His')
    |   ('hers')
    |   ('him')
    |   ('himself' | 'herself')
    |   ('th')
    |   ('s')
    |   ('proper' | 'improper')
    |   'ref' | 'icon'
    |   ('red' | 'blue' )
    |   ID
    ;

fragment STRING_ESC : '\\' (THREE_DOTS | .) ;

fragment THREE_DOTS  :   '...'   ;


