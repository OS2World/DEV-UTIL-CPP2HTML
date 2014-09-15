/*
 *  This is a flex input file but should be edited in -*-C-*- mode
 *  C++2HTML: Produce HTML files from  C++ or C sources.
 *  Copyright (C) 1994 Dimitry Kloper
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 1, or (at your option)
 *  any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 * ===========================================================================
 *                          dimka@tochna.technion.ac.il	
 *                                Dimitry Kloper			
 *                           ISRAEL , Haifa , Technion	                
 *                              Canada Dorm. 44/6/2		
 *                              phone :  04-29-4643		
 *           http://nearnet.gnn.com/gnn/netizens/dir/kloper-dimitry.html
 * ===========================================================================
 * 
 * Any commens , bug reports and suggestions are welcome .
 * You can obtain last version of the c++2html from
 *   ftp://tochna.technion.ac.il/pub/staff/dimka/c++2html.html
 * or
 *   ftp://tochna.technion.ac.il/pub/staff/dimka/c++2html/c++2html.shar.gz
 *
 */
/*
 *  This is a flex input file but should be edited in -*-C-*- mode
 *
 *  C++2LaTeX: Produce prettyprinted LaTeX files from  C++ or C sources.
 *  Copyright (C) 1990 Norbert Kiesel
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 1, or (at your option)
 *  any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 *  Norbert Kiesel     
 *  RWTH Aachen / Institut f. Informatik III
 *  Ahornstr. 55
 *  D-5100 Aachen
 *  West Germany  
 *
 *  Phone:  +49 241 80-7266
 *  EUNET:  norbert@rwthi3.uucp
 *  USENET: ...!mcvax!unido!rwthi3!norbert
 *  X.400:  norbert@rwthi3.informatik.rwth-aachen.de
 *
 *  Please contact me for any bugs you find in this code or any
 *  improvements! I'd also be very happy to get feedback where and
 *  how frequently this program is used (just drop a little mail :-).
 */

%x STRING BCOMMENT INCLUDE
%s CPLUSPLUS

%{
#define TAG(font,line) printf ("<%s>%s</%s>",font,line,font)
#define OTAG(tag)      printf ("<%s>",tag)
#define CTAG(tag)      printf ("</%s>",tag)
#define KEY	       TAG(keyword_tag,yytext);
#define CPP	       TAG(cpp_tag,yytext);
#define SYM(x)	symbols(x)
#define SUB(x)	substitute(x)
#define OUT(x)  printf("%s",x)
#define IND	indent(yytext)
#define INIT	BEGIN (cplusplus_mode ? CPLUSPLUS : INITIAL);

#include <stdio.h>

#ifdef ANSI_C
  #ifdef C_PLUSPLUS
    #error ANSI_C and C_PLUSPLUS are mutually exclusive
  #else
    int cplusplus_mode = 0;
  #endif
#else /* CPLUSPLUS or default */
  int cplusplus_mode = 1;
#endif

unsigned long linecount = 0;
int complete_file = 0;
int header = 0;
int tabtotab = 8;
int piped = 0;
int want_index = 0;
int want_indent_links = 0;
char * comment_tag = "EM";
char * keyword_tag = "STRONG";
char * header_tag = "KBD";
char * cpp_tag = "STRONG";
char * string_tag = "EM";
char * operator_tag = "STRONG";
char * include_html = "includes.html";
char * indent_html = "indent.html";
void substitute(const char *);
void indent(const char *);
void newpage(int);
void usage(const char *);
char *basename(char *);
%}

%%

	INIT;

"#"[ \t]*"include"	{ CPP; BEGIN (INCLUDE); }
"#"[ \t]*"define"	|
"#"[ \t]*"undef"	|
"#"[ \t]*"pragma"	|
"#"[ \t]*"if"		|
"#"[ \t]*"ifdef"	|
"#"[ \t]*"ifndef"       |
"#"[ \t]*"elif"		|
"#"[ \t]*"else"		|
"#"[ \t]*"error"	|
"#"[ \t]*"endif"	|
"#"[ \t]*"line"		CPP;


<INCLUDE>"<"[^>]*/">"	{ SUB ("<");
			   printf("<A HREF=\"%s#%s\">",include_html,yytext+1);
                           SUB (yytext+1);
                           printf("</A>"); 
                          SUB(">");
			  input(); INIT; }
<INCLUDE>\"[^\"]*/\"	{ SUB ("\"");
			   printf("<A HREF=\"%s#%s\">",include_html,yytext+1);
                           SUB (yytext+1);
                           printf("</A>"); 
                          SUB("\"");
			  input(); INIT; }
<INCLUDE>[ \t]+		SUB(yytext);
<INCLUDE>[\n]		OUT ("<P>");
<INCLUDE>.		{ yyless (0); INIT; }

"auto"			|
"double"		|
"int"			|
"struct"		|
"break"			|
"else"			|
"long"			|
"switch"		|
"case"			|
"enum"			|
"register"		|
"typedef"		|
"char"			|
"extern"		|
"return"		|
"union"			|
"const"			|
"float"			|
"short"			|
"unsigned"		|
"continue"		|
"for"			|
"signed"		|
"void"			|
"default"		|
"goto"			|
"sizeof"		|
"volatile"		|
"do"			|
"if"			|
"static"		|
"while"			|
<CPLUSPLUS>"new"	|
<CPLUSPLUS>"delete"	|
<CPLUSPLUS>"this"	|
<CPLUSPLUS>"operator"	|
<CPLUSPLUS>"class"	|
<CPLUSPLUS>"catch"      |
<CPLUSPLUS>"public"	|
<CPLUSPLUS>"protected"	|
<CPLUSPLUS>"private"	|
<CPLUSPLUS>"virtual"	|
<CPLUSPLUS>"friend"	|
<CPLUSPLUS>"inline"	|
<CPLUSPLUS>"template"   |
<CPLUSPLUS>"overload"	KEY;

"->"		        |
"<<"			|
">>"			|
"<="			|
">="			|
"!="			|
"||"			|
"..."			|
"*="			|
"<<="			|
">>="			|
"^="			|
"|="			|
"~"			|
"*"			|
"^"			|
"|"			|
<CPLUSPLUS>"->*"	|
"/"			|
"<"			|
">"			|
"&&"			|
"%="			|
"&="			|
"{"			|
"}"			|
"&"			|
"%"			|
"--"			|
"?"			|
":"			|
"="			|
","			|
"."			|
";"			|
"!"			|
"-"			|
"+"			|
"/="			|
"=="			|
"++"			|
"+="			|
"-="			|
"("			|
")"			|
"["			|
"]"			|
<CPLUSPLUS>"::"		|
<CPLUSPLUS>".*"		{ OTAG(operator_tag);
                          SUB(yytext);
                          CTAG(operator_tag); }


                                        
<CPLUSPLUS>[a-zA-Z_$][a-zA-Z_$0-9:~]*	|
[a-zA-Z_][a-zA-Z_0-9]*	       	{ if(want_indent_links) 
                                     printf("<A HREF=\"%s#%s\">",
                                            indent_html,yytext);
                                  SUB (yytext); 
                                  if(want_indent_links)
                                    CTAG("A"); }

"/*"				{ BEGIN (BCOMMENT); 
                                  TAG(operator_tag,"/*");
                                  OTAG(comment_tag); }

<BCOMMENT>"*/"			{ INIT; 
                                  CTAG(comment_tag); 
                                  TAG(operator_tag,"*/");
                                }

<BCOMMENT>^[ \t]+		IND;
<BCOMMENT>.			OUT (yytext);

<CPLUSPLUS>"//".*$		{ 
                                  OTAG(comment_tag);
                                  TAG(operator_tag,"//");
			          OUT (yytext+2);
				  CTAG(comment_tag);
                                }

L?\" 				{ BEGIN (STRING); 
                                  SUB("\"");
				  OTAG(string_tag); }
<STRING>\"			{ INIT;
                                  CTAG(string_tag);
                                  SUB("\""); }
                                  
<STRING>^[ \t]+			IND;
<STRING>.			SUB (yytext);

([0-9]*\.[0-9]+[fFlL]?)		 |
([0-9]+\.[0-9]*[fFlL]?)		 |
([0-9]*\.?[0-9]+[eE][+-]?[0-9]+) |
([0-9]+\.?[0-9]*[eE][+-]?[0-9]+) ECHO;

[0-9]+[uUlL]?			ECHO;

L?'[ -~]'			|
L?'\\[ntvbrfa\\?'"]'		|
L?'\\[0-7]{1,3}'		|
L?'\\x[0-9a-fA-F]{1,2}'		SUB (yytext);

0[0-7]+[uUlL]?			ECHO;

0x[0-9a-fA-F]+[uUlL]?		ECHO;

^[ \t]+			        IND;
[ \t]+				IND;
                              
"\n"                            {linecount++;ECHO;}


%%

void substitute (const char * input)
{
  while (*input)
    {
      switch (*input)
	{
	case '<':
          printf("&lt;");
          break;
	case '>':
	  printf ("&gt;");
	  break;
	case '&':
	  printf ("&amp;");
	  break;
	case '"':
	  printf ("&quot;");
	  break;
	default:
	  printf ("%c", *input);
	  break;
	}
      input++;
    }
}

void
indent(const char * blanks)
{
  int i;
  
  while (*blanks)
    {
      if (*blanks == ' ')
	{
	  printf(" "); 
	}
      else			/* *blanks == '\t' */
	{
	  i = tabtotab ; 
          while (i--) printf(" ");          
	}
      blanks++;
    }
}

#undef getopt
#include "getopt.h"
#include <string.h>
#include <fcntl.h>
#include <ctype.h>
#include <time.h>



extern char * version_string;

static struct option opts[] =
{
  {"ansi-c", 0, 0, 'a'},
  {"c-plusplus", 0, 0, 'p'},
  {"complete-file", 0, 0, 'c'},
  {"header", 0, 0, 'h'},
  {"output", 1, 0, 'o'},
  {"tabstop", 1, 0, 'T'},
  {"comment-tag", 1, 0, 'C'},
  {"string-tag", 1, 0, 'S'},
  {"keyword-tag", 1, 0, 'K'},
  {"header-tag", 1, 0, 'H'},
  {"cpp-tag", 1, 0, 'P'},
  {"operator-tag", 1, 0, 'O'},
  {"indent-links",0,0,'l'},
  {"version", 0, 0, 'V'},
  {"index", 0, 0, 'x'},
  {"includes-html",1,0,'I'},
  {"ident-html",1,0,'D'},
  {0, 0, 0, 0}
};


main (int argc, char** argv)
{
  int c;
  int index;
  int i;
  int has_filename;
  char * input_name;
  char * output_name;
  char * program_name;

  time_t now;
  char * today;

  input_name = NULL ;
  output_name = NULL ;

  now = time(0);
  today = ctime(&now);


  program_name = basename(argv[0]);

#ifdef USE_NAME 
#if defined(ANSI_C) || defined(C_PLUSPLUS)
#error USE_NAME, ANSI_C and C_PLUSPLUS are mutually exclusive
#else
  /* simple heuristic: '+' in name means C++ */
  cplusplus_mode = (strchr (program_name, '+') != 0);
#endif
#endif
  
  while ((c = getopt_long (argc, argv,
			   "lacpo:O:I:D:hT:C:H:S:K:P:Vx", opts, &index))
	 != EOF)
    {
      if (c == 0)		/* Long option */
	{
	  c = opts[index].val;
	}
      switch (c)
	{
        case 'I':
          include_html = optarg;
          break;
        case 'D':
          indent_html = optarg;
          break;
        case 'l':
          want_indent_links = 1;
          break;
	case 'a':
	  cplusplus_mode = 0;
	  break;
	case 'p':
	  cplusplus_mode = 1;
	  break;
	case 'c':
	  complete_file = 1;
	  break;
	case 'o':
	  output_name = optarg;
	  break;
        case 'O':
	  operator_tag = optarg;
	  break;
	case 'T':
	  tabtotab = atoi(optarg);
	  break;
	case 'h':
	  header = 1;
	  complete_file = 1;	/* header implies complete-file */
	  break;
	case 'C':
	  comment_tag = optarg;
	  break;
	case 'H':
	  header_tag = optarg;
	  break;
	case 'P':
	  cpp_tag = optarg;
	  break;
	case 'S':
	  string_tag = optarg;
	  break;
	case 'K':
	  keyword_tag = optarg;
	  break;
	case 'V':
	  fprintf (stderr, "%s\n", version_string);
	  break;
        case 'x':
          want_index = 1;
          break;
	default:
	  usage(program_name);
	}
    }

  has_filename = (argc - optind == 1);
  if (has_filename)		/* last argument is input file name */
    {
      input_name = argv[optind];
      if (freopen (input_name, "r", stdin) == NULL)
	{
	  fprintf (stderr, "%s: Can't open `%s' for reading\n",
		   program_name, input_name);
	  exit (2);
	}
    }
  else
     input_name = "StdIn"; 

  if (output_name != NULL)
    {
      if (freopen (output_name, "w", stdout) == NULL)
	{
	  fprintf (stderr, "%s: Can't open `%s' for writing\n",
		   program_name, output_name);
	  exit (4);
	}
    }
  else
     output_name = "StdOut"; 




  if(complete_file) 
    {
      printf ("<HTML>\n");
      printf ("<HEAD>\n");
      printf ("<TITLE>%s</TITLE>\n",input_name);
    }
  printf("<! %s>\n",today);
  printf("<! This file created from \"%s\" by %s converter >\n",input_name,
          program_name);
  printf("<! %s is written by Dimitry Kloper (dimka@tochna.technion.ac.il)>\n",
          program_name);
  printf("<! actually it is rewritten c++2latex (1.1) by Norbert Kiesel.>\n"); 
  printf("<! See COPYING file for license information .>\n"); 
  if(header)
    {
      printf("<H2>%s</H2>\n<STRONG>Composed on %s</STRONG>\n<HR>\n",
             output_name,today);
    }

  if(complete_file) 
     printf ("</HEAD>\n<BODY>\n");
 
  printf ("<H1>%s</H1><HR><P>\n",input_name);

  printf ("<PRE>\n");
  yylex();

  printf ("</PRE>\n");
  if(complete_file) 
    {
      printf ("</BODY>\n");
      printf ("</HTML>\n");
    }

  exit(0);
}

void
usage(const char * name)
{
  fprintf (stderr, "%s\n", version_string);
  fprintf (stderr, "\
\n
  {-a,+ansi-c} 
       The input is an ANSI-C program. Default is C++, so don't give this
       option for C++ programs and always give this option for ANSI-C pro-
       grams.

  {-c,+complete-file}
       The output is enveloped in commands which produce a complete HTML 
       source. 

  {-h,+header}
       Each page of output has a header giving the input file name and the
       date the file was produced. This option implies the {-c,+complete-
       file} option.

  {-o,+output} path 
       The output is written in the file pointed to by path.

  {-C,+comment-tag} tag 
       The comments are set in the given tag. Default is `EM'.

  {-H,+header-tag} tag 
       The headers are set in the given tag. Default is `KBD'.

  {-K,+keyword-tag} tag 
       The keywords are set in the given font. Default is `STRONG'.

  {-P,+cpp-tag} tag
       The preprocessor directives are set in the given tag. Default is
       `STRONG'.

  {-S,+string-tag} tag
       The string and character constants are set in the given tag.
       Default is `EM'.

  {-O,+operator-tag} tag
       The operators are set in the given tag.
       Default is `STRONG'.

  {-T,+tabstop} wide
       The wide of tabs is wide. Default is `8'.

  {-V,+version}
       Prints the version number on stderr.

  {-x,+index}
       Creates index commands for all identifiers.
       NOT IMPLEMENTED YET ! 

  {-l,+indent-links}
       Whether to mark all identifiers as hyper-links . 
       Default is `false' . 

  {-I,+include-html}
       Set file name for HTML index for all included files . 

  {-D,+ident-html}
       Set file name for HTML index for all  identifiers.
\n");


  exit (1);
}

char *
basename (s)
     char *s;
{
  char *this;

  this = strrchr (s, '/');
  if (this == NULL)
    {				/* no path separator */
      this = s;
    }
  else
    {
      this++;
    }
  return this;
}
