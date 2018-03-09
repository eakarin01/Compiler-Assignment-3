/* Infix notation calculator.  */


%{
  #include <math.h>
  #include <stdio.h>
  #include <stdlib.h>
  int yylex (void);
  void yyerror (char const *);
  int reg[26];
  int acc;
  // struct linked-list for stack
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
%left T_MUL T_DIV T_MOD
%left T_AND T_OR
%right T_NOT T_SHOW T_PUSH T_POP T_LOAD
%token LEFT_PAREN RIGHT_PAREN
%precedence NEG   /* negation--unary minus */
%right T_POW        /* exponentiation */
%token T_ENDL T_EXIT T_ERR


/* The grammar follows.  */
%% 
// starting symbol
input:
  %empty
| input line
;

line:
 T_ENDL 
| exp T_ENDL  { acc=$1;  printf ("\t%d\n", $1);  }
| T_SHOW vreg T_ENDL   { printf ("\t%d\n",$2); }
| T_PUSH vreg T_ENDL   { push($2); }
| T_POP T_REG T_ENDL   { if(top!=NULL)reg[$2]=pop();
                          else {pop(); }
                        } // check pop when empty
| T_POP T_ACC T_ENDL   { if(top!=NULL)acc=pop(); 
                          else {pop(); }
                          } // check pop when empty
| T_LOAD vreg T_REG T_ENDL   { reg[$3]=$2; }
| T_LOAD vreg T_ACC T_ENDL   { acc=$2; }
| T_EXIT T_ENDL                  {exit(0);}
| error T_ENDL      {yyerrok ;} // when error occur skip token util T_ENDL
;

vreg:
  T_REG             { $$ = reg[$1];           }
| T_ACC             { $$ = acc;          }
| T_SIZE             { $$ = size;           }
| T_TOP             { 
                      if(top!=NULL)$$ = peek();  
                      else
                      {peek();YYERROR ;}         
                      } // check pop when empty
;

exp:
  NUM                { $$ = $1;           }
| vreg                { $$ = $1;           }
| exp T_PLUS exp        { $$ = $1 + $3;      }
| exp T_MINUS exp        { $$ = $1 - $3;      }
| exp T_MUL exp        { $$ = $1 * $3;      }
| exp T_DIV exp       { if ($3 != 0) $$ = $1 / $3;   
                        else { yyerror("ERROR: Divide by 0"); YYERROR ;} 
                      } // check when divide by 0
| T_MINUS exp  %prec NEG { $$ = -$2;          }
| exp T_POW exp        { $$ = pow ($1, $3); }
| LEFT_PAREN exp RIGHT_PAREN        { $$ = $2;           }
| exp T_AND exp        { $$ = $1 & $3;           }
| exp T_OR exp        { $$ = $1 | $3;           }
| T_NOT exp        { $$ = ~$2;           }
| exp T_MOD exp        { if ($3 != 0) $$ = $1 % $3;   
                        else { yyerror("ERROR: Divide by 0"); YYERROR ;}       
                        } // check when mod by 0
;

%%

// push function
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
// pop function
int pop()
{
   if(top == NULL)
   {
      yyerror("ERROR: Stack Empty");
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
// return top of stack
int peek()
{
   if(top == NULL)
   {
      yyerror("ERROR: Stack Empty");
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
  // end process when with token "END"
  while(1)
    yyparse();
}


