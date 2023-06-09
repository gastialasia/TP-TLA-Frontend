%{

#include "flex-actions.h"

%}

/* Obliga a crear una regla explícita para manejar lexemas desconocidos. */
%option nodefault

/* Escanea un único archivo y se detiene. */
%option noyywrap

/* Dispone una variable global "yylineno" con el número de línea actual. */
%option yylineno

/* Contextos de Flex. */
%x COMMENT

/* Patrones reutilizables. */
digit			[0-9]
letter          [a-zA-Z][a-zA-Z0-9:/]*
endline			[\n]
whitespace		[ \f\n\r\t\v]


%%

"/*"										{ BEGIN(COMMENT); BeginCommentPatternAction(); }
<COMMENT>.									{ ; }
<COMMENT>{endline}							{ ; }
<COMMENT>"*/"								{ EndCommentPatternAction(); BEGIN(INITIAL); }

"{"											{ return OpenBracketPatternAction(yytext); }
"}"											{ return CloseBracketPatternAction(yytext); }

"+"											{ return AdditionOperatorPatternAction(yytext); }
"-"											{ return SubtractionOperatorPatternAction(yytext); }
"*"											{ return MultiplicationOperatorPatternAction(yytext); }

"."                                         { return DotPatternAction(yytext); }

"create"                                    { return CreatePatternAction(yytext); }
"vm"                                        { return VmPatternAction(yytext); }
"name"                                      { return NamePatternAction(yytext); }
"cores"                                     { return CoresPatternAction(yytext); }
"ram"                                       { return RamPatternAction(yytext); }
"disk"                                      { return DiskPatternAction(yytext); }
"iso"                                       { return IsoPatternAction(yytext); }
"bios"                                      { return BiosPatternAction(yytext); }

"TB"                                         { return TbPatternAction(yytext); }
"GB"                                         { return GbPatternAction(yytext); }
"MB"                                         { return MbPatternAction(yytext); }
"KB"                                         { return KbPatternAction(yytext); }
"UEFI"                                      { return UEFIPatternAction(yytext); }
"legacy"                                    { return legacyPatternAction(yytext); }

"net-controller"                            { return NetPatternAction(yytext); }
"type"                                      { return TypePatternAction(yytext); }
"mac"                                       { return MacPatternAction(yytext); }
"so"                                        { return SoPatternAction(yytext); }
"nat"                                       { return NatPatternAction(yytext); }
"bridge"                                    { return BridgePatternAction(yytext); }
"macvtap"                                   { return MacvtapPatternAction(yytext); }

{digit}+									{ return IntegerPatternAction(yytext, yyleng); }

{letter}+									{ return StringPatternAction(yytext, yyleng); }

{whitespace}								{ IgnoredPatternAction(yytext, yyleng); }

.											{ return UnknownPatternAction(yytext, yyleng); }

%%
