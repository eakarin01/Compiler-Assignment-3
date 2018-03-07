/* Infix notation calculator.  */

%{
  #include <math.h>
  #include <stdio.h>
  int yylex (void);
  void yyerror (char const *);
  int reg[26];
  int acc;
  struct Node{
    int data;
    struct Node *next;
  }*top=NULL;
  void push(int value);
  int pop();
  int peek();
  int size=0;
%}

/* Bison declarations.  */
//%define api.value.type {double}
%token NUM T_REG T_ACC T_TOP T_SIZE
%left T_PLUS T_MINUS
%left T_MUL T_DIV
%left T_AND T_OR
%right T_NOT T_SHOW T_PUSH T_POP T_LOAD T_MOD
%token LEFT_PAREN RIGHT_PAREN
%precedence NEG   /* negation--unary minus */
%right T_POW        /* exponentiation */
%token T_ENDL

%% /* The grammar follows.  */

input:
  %empty
| input line
;

line:
  T_ENDL 
| exp T_ENDL  { acc=$1;  printf ("\t%d\n", $1);  }
| T_SHOW value T_ENDL   { printf ("\t%d\n",$2); }
| T_PUSH vregister T_ENDL   { push($2); }
| T_POP T_REG T_ENDL   { reg[$2]=pop(); }
| T_POP T_ACC T_ENDL   { acc=pop(); }
| T_LOAD T_ACC T_REG T_ENDL   { reg[$3]=acc; }
| T_LOAD T_REG T_ACC T_ENDL   { acc=reg[$2]; }
;

value:
  T_REG             { $$ = reg[$1];           }
| T_SIZE             { $$ = size;           }
| T_TOP             { $$ = peek();           }
;

vregister:
  T_REG             { $$ = reg[$1];           }
| T_ACC             { $$ = acc;           }
;

exp:
  NUM                { $$ = $1;           }
| vregister                { $$ = $1;           }
| exp T_PLUS exp        { $$ = $1 + $3;      }
| exp T_MINUS exp        { $$ = $1 - $3;      }
| exp T_MUL exp        { $$ = $1 * $3;      }
| exp T_DIV exp        { $$ = $1 / $3;      }
| T_MINUS exp  %prec NEG { $$ = -$2;          }
| exp T_POW exp        { $$ = pow ($1, $3); }
| LEFT_PAREN exp RIGHT_PAREN        { $$ = $2;           }
| exp T_AND exp        { $$ = $1 & $3;           }
| exp T_OR exp        { $$ = $1 | $3;           }
| T_NOT exp        { $$ = ~$2;           }
| exp T_MOD exp        { $$ = $1 % $3;           }
;

%%


void push(int value)
{
   struct Node *newNode;
   newNode = (struct Node*)malloc(sizeof(struct Node));
   newNode->data = value;
   size++;
   if(top == NULL)
      newNode->next = NULL;
   else
      newNode->next = top;
   top = newNode;
}
int pop()
{
   if(top == NULL)
   {
      yyerror("Stack Empty\n");
      return 0;
   }
   else{
      size--;
      struct Node *temp = top;
      int ret = temp->data;
      top = temp->next;
      free(temp);
      return ret;
   }
}
int peek()
{
   if(top == NULL)
   {
      yyerror("Stack Empty\n");
      return 0;
   }
   else{
      return top->data;
   }
}

/* Called by yyparse on error.  */
void yyerror (char const *s)
{
	fprintf (stderr, "%s\n", s);
}

int main()
{
 /* int err = yyparse();
  while(err)
  {
    err = yyparse();
  }*/
  yyparse();
}


