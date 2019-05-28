%{
	#include <stdio.h>
	#include <string.h>

	#include "./header/sym_table.h"
	#include "./header/assem_table.h"
	#include "./header/func_table.h"
	int yylex(void);
	void yyerror(char*s);

%}


%token tMAIN tRETURN tPRINT tIF tELSE tWHILE tINT tFLOAT tDOUBLE tCONST tACC_L tACC_R tOR tAND tEQUALS tDIFF tPLUS tMINUS tMULT tDIV tAFFECT tPAR_L tPAR_R tCOMA tBRK_PT tADDR tL_BRCK tR_BRCK tID tNUMBER tINF tSUP tNOT

%union { int nb ; char * var ; }

%right tAFFECT
%left tPLUS tMINUS
%left tMULT tDIV

%type <nb> Condition 
%type <nb> Expression


%type <nb> tNUMBER
%type <var> tID
%type <nb> tIF
%type <nb> tACC_R
%type <nb> tWHILE

%start Start

// Token IF virtuel permettant de marquer un IF présent juste avant un ELSE. On lève ainsi l'ambigüité s'il y a des IF successifs.
%nonassoc tIFX
%nonassoc tELSE
%%

Start :	Fonctions;

Fonctions : Fonction Fonctions | Main ;

Fonction : tINT tID tPAR_L { sym_incr_depth(); func_update($2, 1, assem_number_instr());
							 func_set_active($2);} Params tPAR_R ContentFonction { func_set_inactive();};

Params : ListeParams | ;

ListeParams : tINT tID tCOMA { sym_add_symbol($2,0,0); } ListeParams | tINT tID { sym_add_symbol($2,0,0); };

Arguments : SuiteArguments | ;     

SuiteArguments : Expression tCOMA SuiteArguments | Expression;

ContentFonction : tACC_L Declarations InstructionsFonc tACC_R { sym_delete_body(); sym_decr_depth(); } ;
																					
InstructionsFonc : InstructionFonc InstructionsFonc | InstructionFonc;

InstructionFonc : Instruction | tRETURN Expression tBRK_PT { assem_add_instr_arg2("AFC",0,$2); assem_add_instr_arg2("STORE", 1000,0);  assem_add_instr_arg0("RET");} ;

Instruction : Expression tBRK_PT | Print tBRK_PT | If | While; // Supprimer les variables temporaires à la fin de chaque instruction 

Main : tINT tMAIN tPAR_L { func_update("main",1,assem_number_instr());} tPAR_R { func_set_inactive(); } tACC_L { sym_incr_depth(); } Declarations Instructions tACC_R { sym_delete_body(); sym_decr_depth(); };

Declarations :	tCONST tINT ListeDeclarationConst tBRK_PT Declarations | tINT ListeDeclaration tBRK_PT Declarations |;

ListeDeclarationConst :	DeclarationConst tCOMA ListeDeclarationConst | DeclarationConst;

DeclarationConst : tID {
				   sym_add_symbol($1,0,1);
                   } 
				 | tID tAFFECT Expression { 
				   sym_add_symbol($1, 1, 1); 
				   assem_add_instr_arg2("LOAD",0,sym_get_last_temporary_index()); 
				   assem_add_instr_arg2("STORE",sym_get_index_decl($1),0);
				   sym_delete_last_temporary(); 
				  }
				 |;

ListeDeclaration : Declaration tCOMA ListeDeclaration | Declaration;

Declaration : tID {sym_add_symbol($1,0,0);} 
			| tID tAFFECT Expression {
		  	sym_add_symbol($1,1,0); sym_add_symbol($1, 1, 1); 
	        assem_add_instr_arg2("LOAD",0,sym_get_last_temporary_index()); 
		    assem_add_instr_arg2("STORE",sym_get_index_decl($1),0);
		    sym_delete_last_temporary(); 
									 } 
			| tMULT tID {sym_add_symbol($2,0,0);} 
			| tMULT tID  tAFFECT Expression {sym_add_symbol($2,1,0);} 
			| tID tL_BRCK tNUMBER tR_BRCK {sym_add_symbol($1,0,0);};


ConditionIf : Condition { assem_add_instr_arg2("LOAD", 1,$1);
					 assem_add_instr_arg2("JMPC", -1, 1);
					 $<nb>$ = assem_number_instr() - 1;	} ;
If : tIF  ConditionIf

	tACC_L Declarations Instructions tACC_R %prec tIFX 
					{
					assem_modify_arg_instr($<nb>2, 0, assem_number_instr() + 1 ); // On rectifie la ligne du saut du JMPC, préalablement initialisée à une valeur par défaut (-1).
					}

	|tIF ConditionIf
	
	tACC_L Declarations Instructions tACC_R {
					 /*JUMP POUR EVITER LE ELSE ---> (1) */
					 assem_add_instr_arg2("JMPC", -1, 1);
					 $6 = assem_number_instr() - 1;
					 /*RETOURNER LA lIGNE OU JUMP POUR LE ELSE*/
					 assem_modify_arg_instr($<nb>2, 0, assem_number_instr() + 1);
				   }
	
	tELSE tACC_L Declarations Instructions tACC_R { /*EN LIEN AVEC (1) PERMET DE FORNI LE NUMERO DE LIGNE*/ 
	     assem_modify_arg_instr($6, 0, assem_number_instr() + 1);
                                                	} ;

/*PAS OPÉRATIOINNEL :	- LOAD NE FONCTIONNE PAS (MEME PB QUE POUR LE IF)
						- INF COMPARE LE MEME REGISTRE R0 AVEC LUI-MEME (TOUJOURS FAUX) ==> ==> 29 AVRIL : BUG RESOLU, FAIRE D'AUTRES TESTS
						- BIEN QU'ON FASSE R0<R0 COMME TEST, ON ENTRE QUAND MEME DANS LA BOUCLE
						- JUMP AU MAUVAIS ENDROIT, COMME SI ON EFFECTUAIT UN IF (ET NON AU DEBUT DE LA BOUCLE) ==> 29 AVRIL : BUG RESOLU, FAIRE D'AUTRES TESTS
						*/

While : tWHILE Condition tACC_L { /*MEME IDEE QUE POUR LE IF*/
						   $<nb>3 = assem_number_instr() - 7; 
						   assem_add_instr_arg2("LOAD", 1, $2);
						   assem_add_instr_arg2("JMPC", -1, 1);
                           $1 = assem_number_instr() - 1;
						 }  Declarations Instructions tACC_R 
						 { /*RETOURNER LA lIGNE OU JUMP POUR LE WHILE : JUMP EN ARRIERE */
						   assem_add_instr_arg1("JMPC", $<nb>3);
						   assem_modify_arg_instr($1, 0, assem_number_instr() + 1); 
						 };
		
Condition: tPAR_L Expression tINF Expression tPAR_R { 
												assem_add_instr_arg2("LOAD", 0 , $2);
												assem_add_instr_arg2("LOAD", 1 , $4);
												assem_add_instr_arg3("INF", 0, 0, 1);		
												assem_add_instr_arg2("STORE", $2, 0);			
												sym_delete_last_temporary();
											    $$ = $2; // On récupère l'adresse où se trouve le resultat de la comparaison
													}
	 | tPAR_L Expression tINF tAFFECT Expression tPAR_R {
												assem_add_instr_arg2("LOAD", 0 , $2);
												assem_add_instr_arg2("LOAD", 1 , $5);
												assem_add_instr_arg3("INFE", 0, 0, 1);
												assem_add_instr_arg2("STORE", $2, 0);
												sym_delete_last_temporary();
											    $$ = $2;
														} 
	 | tPAR_L Expression tSUP Expression tPAR_R {
												assem_add_instr_arg2("LOAD", 0 , $2);
												assem_add_instr_arg2("LOAD", 1 , $4);
												assem_add_instr_arg3("SUP", 0, 0, 1);
												assem_add_instr_arg2("STORE", $2, 0);
												sym_delete_last_temporary();
											    $$ = $2;
												}
	 | tPAR_L Expression tSUP tAFFECT Expression tPAR_R {
												assem_add_instr_arg2("LOAD", 0 , $2);
												assem_add_instr_arg2("LOAD", 1 , $5);
												assem_add_instr_arg3("SUPE", 0, 0, 1);
												assem_add_instr_arg2("STORE", $2, 0);
												sym_delete_last_temporary();
											    $$ = $2;	
												}
	 | tPAR_L Expression tEQUALS Expression tPAR_R {
												assem_add_instr_arg2("LOAD", 0 , $2);
												assem_add_instr_arg2("LOAD", 1 , $4);
												assem_add_instr_arg3("EQU", 0, 0, 1);
												assem_add_instr_arg2("STORE", $2, 0);
												sym_delete_last_temporary();
											    $$ = $2;
												}
	 | tPAR_L Expression tINF tSUP Expression tPAR_R {
												// On ne sait pas quoi mettree comme instruction assembleur.
													}
	 | tPAR_L tNOT Expression tPAR_R {
												// On ne sait pas quoi mettree comme instruction assembleur.
									 }; 

Instructions :	Instruction Instructions | ;
	
Print : tPRINT tPAR_L Expression tPAR_R {/*INSTRUCTION PRINT */};
		

Expression : Expression tPLUS Expression {	
										 assem_add_instr_arg2("LOAD", 0 , $1);
										 assem_add_instr_arg2("LOAD", 1 , $3);
										 assem_add_instr_arg3("ADD", 0 , 1, 0);		
										 assem_add_instr_arg2("STORE", $1 , 0);			
										 sym_delete_last_temporary();
										 $$ = $1;
										}
	| Expression tMINUS Expression  {  
									   	assem_add_instr_arg2("LOAD", 0 , $1);
										assem_add_instr_arg2("LOAD", 1 , $3);	
										assem_add_instr_arg3("SUB", 0 , 1, 0);		
										assem_add_instr_arg2("STORE", $1 , 0);			
										sym_delete_last_temporary();
										$$ = $1; 
									}
	| Expression tMULT Expression {
									   assem_add_instr_arg2("LOAD", 0 , $1);
									   assem_add_instr_arg2("LOAD", 1 , $3);	
									   assem_add_instr_arg3("MULT", 0 , 1, 0);		
									   assem_add_instr_arg2("STORE", $1 , 0);			
									   sym_delete_last_temporary();
									   $$ = $1;    
								  }
	| Expression tDIV Expression { 
									   assem_add_instr_arg2("LOAD", 0 , $1);
									   assem_add_instr_arg2("LOAD", 1 , $3);	
									   assem_add_instr_arg3("DIV", 0 , 1, 0);		
									   assem_add_instr_arg2("STORE", $1 , 0);			
									   sym_delete_last_temporary();
									   $$ = $1; 
								 }
	| tPAR_L Expression tPAR_R { $$ = $2 ; }
	| tID tAFFECT Expression { 
								if (sym_check_const($1) == 1 ){
									printf("La variable est une constante  !! ");		
								}else if(sym_check_const($1) == -1){
									printf(" Elle n'existe même pas ta variable ! \n" );	
								}else{	
							   		sym_set_init_id($1, 1);
									assem_add_instr_arg2("LOAD",0,$3);
									assem_add_instr_arg2("STORE",sym_get_index_decl($1),0);
									}				
							 }
	| tMULT tID tAFFECT Expression { $$ = 123; }
	| tID tL_BRCK tNUMBER tR_BRCK tAFFECT Expression { $$ = 123; }
	| tID { 
			if (sym_check_init_id($1) == -1){
				printf(" Elle n'existe même pas ta variable ! \n" );
			}else
			 if (sym_check_init_id($1) == 0){
				printf(" La variable %s n'est pas initialisée\n",$1);
			}else{
			 	 sym_add_temporary(); 
				 assem_add_instr_arg2("LOAD",0,sym_get_index_decl($1));
				 assem_add_instr_arg2("STORE",sym_get_last_temporary_index(),0);
			     $$ = sym_get_last_temporary_index();
				 }
		  }
	| tMULT tID { $$ = 123; }
	| tADDR tID { $$ = 123; }
	| tID tL_BRCK tNUMBER tR_BRCK  { $$ = 123; }
	| tNUMBER {
				sym_add_temporary(); 
				assem_add_instr_arg2("AFC", 0, $1); 
				assem_add_instr_arg2("STORE", sym_get_last_temporary_index(), 0);
				$$ = sym_get_last_temporary_index();
			  }
	| tID tPAR_L Arguments tPAR_R  { $$ = 123; };
%%
int main(){
	yydebug = 0;
	//lab_init(); 
	sym_init();
	assem_init();
	//fonc_init();
	yyparse();
	func_table_display();
	sym_display();
	assem_display();
	assem_write_file_instrs();
	//fonc_maj_appels_mem_instr();
	//mem_ecr_instrs();
	assem_write_obj();
}


