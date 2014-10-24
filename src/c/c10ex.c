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
SCM_DefineClosure(function_0, SCM_Empty);

SCM_DeclareFunction(function_0)
{
    SCM_DeclareLocalVariable(F, 0);
    return ((INDEX = SCM_Plus(thing1,
			      SCM_CheckedGlobal(INDEX))),
	    SCM_invoke1(F, SCM_CheckedGlobal(INDEX)));
}

SCM_DefineClosure(function_1, SCM I;
    );

SCM_DeclareFunction(function_1)
{
    SCM_DeclareLocalDottedVariable(X, 0);
    return SCM_cons(SCM_Free(I), X);
}

SCM_DefineClosure(function_2, SCM_Empty);

SCM_DeclareFunction(function_2)
{
    SCM_DeclareLocalVariable(I, 0);
    return SCM_close(SCM_CfunctionAddress(function_1), -1, 1, I);
}

SCM_DefineClosure(function_3, SCM_Empty);

SCM_DeclareFunction(function_3)
{
    SCM TMP_2;
    SCM CNTER_1;
    return ((INDEX = thing0),
	    (CNTER_1 = SCM_close(SCM_CfunctionAddress(function_0), 1, 0),
	     TMP_2 = SCM_cons(thing2,
			      thing3),
	     (TMP_2 = SCM_allocate_box(TMP_2),
	      ((SCM_Content(TMP_2) = SCM_invoke1(CNTER_1,
						 SCM_close
						 (SCM_CfunctionAddress
						  (function_2), 1, 0))),
	       ((CNTER_1 != SCM_false)
		? SCM_invoke1(CNTER_1, SCM_Content(TMP_2))
		: SCM_CheckedGlobal(INDEX))))));
}


/* Expression: */
int main(void)
{
  SCM r;
  int i;
  for (i=0; i<=10000; i++) r = (SCM_invoke0(SCM_close(SCM_CfunctionAddress(function_3), 0, 0)));
  SCM_print(r);
  exit(0);
}

/* End of generated code. */
