// Generated from byond2Parser.g4 by ANTLR 4.1
import org.antlr.v4.runtime.misc.NotNull;
import org.antlr.v4.runtime.tree.ParseTreeListener;

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link byond2Parser}.
 */
public interface byond2ParserListener extends ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link byond2Parser#loop_while}.
	 * @param ctx the parse tree
	 */
	void enterLoop_while(@NotNull byond2Parser.Loop_whileContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#loop_while}.
	 * @param ctx the parse tree
	 */
	void exitLoop_while(@NotNull byond2Parser.Loop_whileContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#stat_del}.
	 * @param ctx the parse tree
	 */
	void enterStat_del(@NotNull byond2Parser.Stat_delContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#stat_del}.
	 * @param ctx the parse tree
	 */
	void exitStat_del(@NotNull byond2Parser.Stat_delContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#stat_cont}.
	 * @param ctx the parse tree
	 */
	void enterStat_cont(@NotNull byond2Parser.Stat_contContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#stat_cont}.
	 * @param ctx the parse tree
	 */
	void exitStat_cont(@NotNull byond2Parser.Stat_contContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#loop_for}.
	 * @param ctx the parse tree
	 */
	void enterLoop_for(@NotNull byond2Parser.Loop_forContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#loop_for}.
	 * @param ctx the parse tree
	 */
	void exitLoop_for(@NotNull byond2Parser.Loop_forContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#formalParameter}.
	 * @param ctx the parse tree
	 */
	void enterFormalParameter(@NotNull byond2Parser.FormalParameterContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#formalParameter}.
	 * @param ctx the parse tree
	 */
	void exitFormalParameter(@NotNull byond2Parser.FormalParameterContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#set}.
	 * @param ctx the parse tree
	 */
	void enterSet(@NotNull byond2Parser.SetContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#set}.
	 * @param ctx the parse tree
	 */
	void exitSet(@NotNull byond2Parser.SetContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#div}.
	 * @param ctx the parse tree
	 */
	void enterDiv(@NotNull byond2Parser.DivContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#div}.
	 * @param ctx the parse tree
	 */
	void exitDiv(@NotNull byond2Parser.DivContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#stat_internal}.
	 * @param ctx the parse tree
	 */
	void enterStat_internal(@NotNull byond2Parser.Stat_internalContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#stat_internal}.
	 * @param ctx the parse tree
	 */
	void exitStat_internal(@NotNull byond2Parser.Stat_internalContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#line}.
	 * @param ctx the parse tree
	 */
	void enterLine(@NotNull byond2Parser.LineContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#line}.
	 * @param ctx the parse tree
	 */
	void exitLine(@NotNull byond2Parser.LineContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#block}.
	 * @param ctx the parse tree
	 */
	void enterBlock(@NotNull byond2Parser.BlockContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#block}.
	 * @param ctx the parse tree
	 */
	void exitBlock(@NotNull byond2Parser.BlockContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#internal_var}.
	 * @param ctx the parse tree
	 */
	void enterInternal_var(@NotNull byond2Parser.Internal_varContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#internal_var}.
	 * @param ctx the parse tree
	 */
	void exitInternal_var(@NotNull byond2Parser.Internal_varContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExpr(@NotNull byond2Parser.ExprContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExpr(@NotNull byond2Parser.ExprContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#op_map_item}.
	 * @param ctx the parse tree
	 */
	void enterOp_map_item(@NotNull byond2Parser.Op_map_itemContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#op_map_item}.
	 * @param ctx the parse tree
	 */
	void exitOp_map_item(@NotNull byond2Parser.Op_map_itemContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#op_assign}.
	 * @param ctx the parse tree
	 */
	void enterOp_assign(@NotNull byond2Parser.Op_assignContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#op_assign}.
	 * @param ctx the parse tree
	 */
	void exitOp_assign(@NotNull byond2Parser.Op_assignContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#stat_call}.
	 * @param ctx the parse tree
	 */
	void enterStat_call(@NotNull byond2Parser.Stat_callContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#stat_call}.
	 * @param ctx the parse tree
	 */
	void exitStat_call(@NotNull byond2Parser.Stat_callContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#in_expr}.
	 * @param ctx the parse tree
	 */
	void enterIn_expr(@NotNull byond2Parser.In_exprContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#in_expr}.
	 * @param ctx the parse tree
	 */
	void exitIn_expr(@NotNull byond2Parser.In_exprContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#path_tail}.
	 * @param ctx the parse tree
	 */
	void enterPath_tail(@NotNull byond2Parser.Path_tailContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#path_tail}.
	 * @param ctx the parse tree
	 */
	void exitPath_tail(@NotNull byond2Parser.Path_tailContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#stat_goto}.
	 * @param ctx the parse tree
	 */
	void enterStat_goto(@NotNull byond2Parser.Stat_gotoContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#stat_goto}.
	 * @param ctx the parse tree
	 */
	void exitStat_goto(@NotNull byond2Parser.Stat_gotoContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#block_indented}.
	 * @param ctx the parse tree
	 */
	void enterBlock_indented(@NotNull byond2Parser.Block_indentedContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#block_indented}.
	 * @param ctx the parse tree
	 */
	void exitBlock_indented(@NotNull byond2Parser.Block_indentedContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#if_cond}.
	 * @param ctx the parse tree
	 */
	void enterIf_cond(@NotNull byond2Parser.If_condContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#if_cond}.
	 * @param ctx the parse tree
	 */
	void exitIf_cond(@NotNull byond2Parser.If_condContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#listDef}.
	 * @param ctx the parse tree
	 */
	void enterListDef(@NotNull byond2Parser.ListDefContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#listDef}.
	 * @param ctx the parse tree
	 */
	void exitListDef(@NotNull byond2Parser.ListDefContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#callable}.
	 * @param ctx the parse tree
	 */
	void enterCallable(@NotNull byond2Parser.CallableContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#callable}.
	 * @param ctx the parse tree
	 */
	void exitCallable(@NotNull byond2Parser.CallableContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#file}.
	 * @param ctx the parse tree
	 */
	void enterFile(@NotNull byond2Parser.FileContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#file}.
	 * @param ctx the parse tree
	 */
	void exitFile(@NotNull byond2Parser.FileContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#path}.
	 * @param ctx the parse tree
	 */
	void enterPath(@NotNull byond2Parser.PathContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#path}.
	 * @param ctx the parse tree
	 */
	void exitPath(@NotNull byond2Parser.PathContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#loop_do}.
	 * @param ctx the parse tree
	 */
	void enterLoop_do(@NotNull byond2Parser.Loop_doContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#loop_do}.
	 * @param ctx the parse tree
	 */
	void exitLoop_do(@NotNull byond2Parser.Loop_doContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#stat_break}.
	 * @param ctx the parse tree
	 */
	void enterStat_break(@NotNull byond2Parser.Stat_breakContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#stat_break}.
	 * @param ctx the parse tree
	 */
	void exitStat_break(@NotNull byond2Parser.Stat_breakContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#procDef}.
	 * @param ctx the parse tree
	 */
	void enterProcDef(@NotNull byond2Parser.ProcDefContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#procDef}.
	 * @param ctx the parse tree
	 */
	void exitProcDef(@NotNull byond2Parser.ProcDefContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#var_default_ret}.
	 * @param ctx the parse tree
	 */
	void enterVar_default_ret(@NotNull byond2Parser.Var_default_retContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#var_default_ret}.
	 * @param ctx the parse tree
	 */
	void exitVar_default_ret(@NotNull byond2Parser.Var_default_retContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#actualParameters}.
	 * @param ctx the parse tree
	 */
	void enterActualParameters(@NotNull byond2Parser.ActualParametersContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#actualParameters}.
	 * @param ctx the parse tree
	 */
	void exitActualParameters(@NotNull byond2Parser.ActualParametersContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#exprList}.
	 * @param ctx the parse tree
	 */
	void enterExprList(@NotNull byond2Parser.ExprListContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#exprList}.
	 * @param ctx the parse tree
	 */
	void exitExprList(@NotNull byond2Parser.ExprListContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#procCall}.
	 * @param ctx the parse tree
	 */
	void enterProcCall(@NotNull byond2Parser.ProcCallContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#procCall}.
	 * @param ctx the parse tree
	 */
	void exitProcCall(@NotNull byond2Parser.ProcCallContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#var_null}.
	 * @param ctx the parse tree
	 */
	void enterVar_null(@NotNull byond2Parser.Var_nullContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#var_null}.
	 * @param ctx the parse tree
	 */
	void exitVar_null(@NotNull byond2Parser.Var_nullContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#block_braced}.
	 * @param ctx the parse tree
	 */
	void enterBlock_braced(@NotNull byond2Parser.Block_bracedContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#block_braced}.
	 * @param ctx the parse tree
	 */
	void exitBlock_braced(@NotNull byond2Parser.Block_bracedContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#block_inner}.
	 * @param ctx the parse tree
	 */
	void enterBlock_inner(@NotNull byond2Parser.Block_innerContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#block_inner}.
	 * @param ctx the parse tree
	 */
	void exitBlock_inner(@NotNull byond2Parser.Block_innerContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#super_ref}.
	 * @param ctx the parse tree
	 */
	void enterSuper_ref(@NotNull byond2Parser.Super_refContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#super_ref}.
	 * @param ctx the parse tree
	 */
	void exitSuper_ref(@NotNull byond2Parser.Super_refContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#label}.
	 * @param ctx the parse tree
	 */
	void enterLabel(@NotNull byond2Parser.LabelContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#label}.
	 * @param ctx the parse tree
	 */
	void exitLabel(@NotNull byond2Parser.LabelContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#if_else}.
	 * @param ctx the parse tree
	 */
	void enterIf_else(@NotNull byond2Parser.If_elseContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#if_else}.
	 * @param ctx the parse tree
	 */
	void exitIf_else(@NotNull byond2Parser.If_elseContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#actualParameter}.
	 * @param ctx the parse tree
	 */
	void enterActualParameter(@NotNull byond2Parser.ActualParameterContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#actualParameter}.
	 * @param ctx the parse tree
	 */
	void exitActualParameter(@NotNull byond2Parser.ActualParameterContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#statement}.
	 * @param ctx the parse tree
	 */
	void enterStatement(@NotNull byond2Parser.StatementContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#statement}.
	 * @param ctx the parse tree
	 */
	void exitStatement(@NotNull byond2Parser.StatementContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#stat_spawn}.
	 * @param ctx the parse tree
	 */
	void enterStat_spawn(@NotNull byond2Parser.Stat_spawnContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#stat_spawn}.
	 * @param ctx the parse tree
	 */
	void exitStat_spawn(@NotNull byond2Parser.Stat_spawnContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#newline}.
	 * @param ctx the parse tree
	 */
	void enterNewline(@NotNull byond2Parser.NewlineContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#newline}.
	 * @param ctx the parse tree
	 */
	void exitNewline(@NotNull byond2Parser.NewlineContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#op_new}.
	 * @param ctx the parse tree
	 */
	void enterOp_new(@NotNull byond2Parser.Op_newContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#op_new}.
	 * @param ctx the parse tree
	 */
	void exitOp_new(@NotNull byond2Parser.Op_newContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#formalParameters}.
	 * @param ctx the parse tree
	 */
	void enterFormalParameters(@NotNull byond2Parser.FormalParametersContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#formalParameters}.
	 * @param ctx the parse tree
	 */
	void exitFormalParameters(@NotNull byond2Parser.FormalParametersContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#stat_ret}.
	 * @param ctx the parse tree
	 */
	void enterStat_ret(@NotNull byond2Parser.Stat_retContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#stat_ret}.
	 * @param ctx the parse tree
	 */
	void exitStat_ret(@NotNull byond2Parser.Stat_retContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#string}.
	 * @param ctx the parse tree
	 */
	void enterString(@NotNull byond2Parser.StringContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#string}.
	 * @param ctx the parse tree
	 */
	void exitString(@NotNull byond2Parser.StringContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#path_head}.
	 * @param ctx the parse tree
	 */
	void enterPath_head(@NotNull byond2Parser.Path_headContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#path_head}.
	 * @param ctx the parse tree
	 */
	void exitPath_head(@NotNull byond2Parser.Path_headContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#stat_switch}.
	 * @param ctx the parse tree
	 */
	void enterStat_switch(@NotNull byond2Parser.Stat_switchContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#stat_switch}.
	 * @param ctx the parse tree
	 */
	void exitStat_switch(@NotNull byond2Parser.Stat_switchContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#stat_pick}.
	 * @param ctx the parse tree
	 */
	void enterStat_pick(@NotNull byond2Parser.Stat_pickContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#stat_pick}.
	 * @param ctx the parse tree
	 */
	void exitStat_pick(@NotNull byond2Parser.Stat_pickContext ctx);

	/**
	 * Enter a parse tree produced by {@link byond2Parser#op_op_assign}.
	 * @param ctx the parse tree
	 */
	void enterOp_op_assign(@NotNull byond2Parser.Op_op_assignContext ctx);
	/**
	 * Exit a parse tree produced by {@link byond2Parser#op_op_assign}.
	 * @param ctx the parse tree
	 */
	void exitOp_op_assign(@NotNull byond2Parser.Op_op_assignContext ctx);
}