class QuestionPool extends Object
{		
	private var $exam_Engine:ExamEngine;
	private var $xml_Data:_XMLNode;
	private var $arr_Questions:Array;
	private var $n_PointsPossible:Number;
	private var $n_PointsEarned:Number;
	private var $n_QuestionAttempts:Number;
	
	public function get name():String
	{
		return $xml_Data.xtc_getAttribute("name");
	}
	
	public function get questions():Array
	{
		return $arr_Questions;
	}
	
	public function get questionAttempts():Number
	{
		return $n_QuestionAttempts;
	}
	
	public function get pointsPossible():Number
	{
		return $n_PointsPossible;
	}
	
	public function get pointsEarned():Number
	{
		return $n_PointsEarned;
	}
	
	public function get scorePercent():Number
	{
		return Math.round($n_PointsEarned / $n_PointsPossible * 100);
	}
	
	public function set pointsEarned( n_Points:Number ):Void
	{
		$n_PointsEarned = n_Points;
	}
	
	public function get examEngine():ExamEngine
	{
		return $exam_Engine;
	}
	
	public function QuestionPool( exam_Engine:ExamEngine, xml_Data:_XMLNode, xml_Config:_XMLNode, arr_CompletedQuestions:Array )
	{
		$exam_Engine		= exam_Engine;
		$xml_Data			= xml_Data;
		$arr_Questions		= new Array();
		$n_PointsPossible	= 0;
		$n_PointsEarned		= 0;
		
		var b_Randomize:Boolean		= $xml_Data.xtc_getBooleanAttribute("random");
		var n_QuestionsToUse:Number = $xml_Data.xtc_getNumericAttribute("how_many_to_use");
		var arr_QuestionNodes:Array = $xml_Data.xtc_findChildren("question");
		$n_QuestionAttempts			= $xml_Data.xtc_getNumericAttribute("question_attempts");
		
		if ($n_QuestionAttempts == null)
			$n_QuestionAttempts = exam_Engine.questionAttempts;
		else if (isNaN($n_QuestionAttempts))
			$n_QuestionAttempts = ExamEngine.UNLIMITED;
		
		if ($xml_Data.xtc_getAttribute("random") == null)
			b_Randomize = exam_Engine.randomize;
			
		if (n_QuestionsToUse == null || n_QuestionsToUse < 0 || n_QuestionsToUse > arr_QuestionNodes.length)
			n_QuestionsToUse = arr_QuestionNodes.length;
		
		if (b_Randomize)
			ExamEngine.randomizeArray(arr_QuestionNodes);

		var obj_QuestionsCreated:Object	= new Object();
		
		if (arr_CompletedQuestions != null)
		{
			for (var i:Number = 0; i < arr_CompletedQuestions.length; i ++)
			{
				var xml_Question:_XMLNode	= arr_CompletedQuestions[i].xml;
				var qst_Current:Question	= createQuestion(xml_Question, xml_Config, arr_CompletedQuestions[i].response);
				
				obj_QuestionsCreated[xml_Question.xtc_getAttribute("global_index")] = true;
			}
		}
		
		var n_NodeIndex:Number = 0;
		
		while ($arr_Questions.length < n_QuestionsToUse && n_NodeIndex < arr_QuestionNodes.length)
		{
			if (!obj_QuestionsCreated[arr_QuestionNodes[n_NodeIndex].xtc_getAttribute("global_index")])
				createQuestion(arr_QuestionNodes[n_NodeIndex], xml_Config);
			
			n_NodeIndex ++;
		}
	}
	
	private function createQuestion( xml_Question:_XMLNode, xml_Config:_XMLNode, str_Response:String ):Question
	{
		var qst_Current:Question = Question.createQuestion(this, xml_Question, xml_Config, str_Response);
		
		$n_PointsPossible += qst_Current.pointValue;
		$arr_Questions.push(qst_Current);
		
		return qst_Current;
	}
}