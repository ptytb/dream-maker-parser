lexer grammar byond2Common;

STRING
    :   '"' (STRING_MACRO | EVAL | ~('\\'|'"'))*? '"'
    |   '\'' (STRING_MACRO | EVAL | ~('\\'|'"'))*? '\''
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
    (   'the' | 'The'
    |   'a' | 'an' 
    |   'A' | 'An'
    |   'he' | 'He'
    |   'she' | 'She'
    |   'his' | 'His'
    |   'him'
    |   'himself' | 'herself'
    |   'hers'
    |   'proper' | 'improper'
    |   'th'
    |   's'
    |   'icon'
    |   'ref'
    |   'roman' | 'Roman'
    |   '...'
    |   'n' | '"' | '\\' | '<' | '>' | ' ' | '\n' | '[' | ']' | 't' | '\''
    |   'b' | 'i' | 'u'
    |   COLOR)
    ;

fragment COLOR
    :   'black' //#000000
    |   'silver'//#C0C0C0
    |   'gray' 	//#808080
    |   'grey' 	//#808080
    |   'white' //#FFFFFF
    |   'maroon' //#800000
    |   'red' 	//#FF0000
    |   'purple' //#800080
    |   'fuchsia' //#FF00FF
    |   'magenta' //#FF00FF
    |   'green' //#00C000
    |   'lime' 	//#00FF00
    |   'olive' //#808000
    |   'gold' 	//#808000
    |   'yellow'//#FFFF00
    |   'navy' 	//#000080
    |   'blue' 	//#0000FF
    |   'teal' 	//#008080
    |   'aqua' 	//#00FFFF
    |   'cyan' 	//#00FFFF
    ;
