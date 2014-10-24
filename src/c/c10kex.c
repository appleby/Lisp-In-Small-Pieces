/* Compiler to C $Revision: 4.3 $ 
(begin
  (set! index 1)
  ((lambda (cnter . tmp)
     (set! tmp
       (cnter (lambda (i) (lambda x (cons i x)))))
     (if cnter (cnter tmp) index))
   (lambda (f) (set! index (+ 1 index)) (f index))
   'foo))  */

#include "scheme.h"

/* Global environment: */
SCM_DefineGlobalVariable(INDEX, "index");

/* Quotations: */
#define thing3 SCM_nil		/* () */
SCM_DefineString(thing4_object, "foo");
#define thing4 SCM_Wrap(&thing4_object)
SCM_DefineSymbol(thing2_object, thing4);	/* foo */
#define thing2 SCM_Wrap(&thing2_object)
#define thing1 SCM_Int2fixnum(1)
#define thing0 thing1		/* 1 */

/* Functions: */
SCM_DefineClosure(function_0, SCM I;
    );

SCM_DeclareFunction(function_0)
{
    SCM_DeclareLocalVariable(v_37, 0);
    SCM_DeclareLocalDottedVariable(X, 1);
    SCM v_39;
    SCM v_38;
    return (v_38 = SCM_Free(I),
	    (v_39 = X, SCM_invoke1(v_37, SCM_cons(v_38, v_39))));
}

SCM_DefineClosure(function_1, SCM_Empty);

SCM_DeclareFunction(function_1)
{
    SCM_DeclareLocalVariable(v_36, 0);
    SCM_DeclareLocalVariable(I, 1);
    return SCM_invoke1(v_36,
		       SCM_close(SCM_CfunctionAddress(function_0), -2, 1,
				 I));
}

SCM_DefineClosure(function_2, SCM v_32;
		  SCM CNTER;
		  SCM TMP;
    );

SCM_DeclareFunction(function_2)
{
    SCM_DeclareLocalVariable(v_40, 0);
    SCM v_44;
    SCM v_43;
    SCM v_42;
    SCM v_41;
    return (v_41 = (SCM_Content(SCM_Free(TMP)) = v_40),
	    (v_42 = SCM_Free(CNTER), ((v_42 != SCM_false)
				      ? (v_43 = SCM_Free(CNTER),
					 (v_44 =
					  SCM_Content(SCM_Free(TMP)),
					  SCM_invoke2(v_43, SCM_Free(v_32),
						      v_44)))
				      : SCM_invoke1(SCM_Free(v_32),
						    SCM_CheckedGlobal
						    (INDEX)))));
}

SCM_DefineClosure(function_3, SCM_Empty);

SCM_DeclareFunction(function_3)
{
    SCM_DeclareLocalVariable(v_32, 0);
    SCM_DeclareLocalVariable(CNTER, 1);
    SCM_DeclareLocalVariable(TMP, 2);
    SCM v_35;
    SCM v_34;
    SCM v_33;
    return (v_33 = TMP = SCM_allocate_box(TMP),
	    (v_34 = CNTER,
	     (v_35 = SCM_close(SCM_CfunctionAddress(function_1), 2, 0),
	      SCM_invoke2(v_34,
			  SCM_close(SCM_CfunctionAddress(function_2), 1, 3,
				    v_32, CNTER, TMP), v_35))));
}

SCM_DefineClosure(function_4, SCM_Empty);

SCM_DeclareFunction(function_4)
{
    SCM_DeclareLocalVariable(v_46, 0);
    SCM_DeclareLocalVariable(F, 1);
    SCM v_52;
    SCM v_51;
    SCM v_50;
    SCM v_49;
    SCM v_48;
    SCM v_47;
    return (v_47 = thing1,
	    (v_48 = SCM_CheckedGlobal(INDEX),
	     (v_49 = SCM_Plus(v_47,
			      v_48),
	      (v_50 = (INDEX = v_49),
	       (v_51 = F,
		(v_52 = SCM_CheckedGlobal(INDEX),
		 SCM_invoke2(v_51, v_46, v_52)))))));
}

SCM_DefineClosure(function_5, SCM_Empty);

SCM_DeclareFunction(function_5)
{
    SCM_DeclareLocalVariable(v_56, 0);
    return v_56;
}

SCM_DefineClosure(function_6, SCM_Empty);

SCM_DeclareFunction(function_6)
{
    SCM v_55;
    SCM v_54;
    SCM v_53;
    SCM v_45;
    SCM v_31;
    SCM v_30;
    SCM v_29;
    return (v_29 = thing0,
	    (v_30 = (INDEX = v_29),
	     (v_31 = SCM_close(SCM_CfunctionAddress(function_3), 3, 0),
	      (v_45 = SCM_close(SCM_CfunctionAddress(function_4), 2, 0),
	       (v_53 = thing2,
		(v_54 = thing3,
		 (v_55 = SCM_cons(v_53,
				  v_54),
		  SCM_invoke3(v_31,
			      SCM_close(SCM_CfunctionAddress(function_5),
					1, 0), v_45, v_55))))))));
}


/* Expression: */
int main(void)
{
  SCM r;
  int i;
  for (i=0; i<=10000; i++) r = (SCM_invoke0(SCM_close(SCM_CfunctionAddress(function_6), 0, 0)));
  SCM_print(r);
  exit(0);
}

/* End of generated code. */
