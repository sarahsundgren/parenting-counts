import mx.utils.*;

class ExamEngine extends Object
{		
	public var onAnswerChanged:Function;
	public var onDisplayChanged:Function;
	public var onDisplayLoadStart:Function;
	public var onDisplayLoadComplete:Function;
	
	public static var UNLIMITED:Number = -99;
	public static var DELIMITER:String;
	
	private var $exam_Interface:ExamInterface;
	private var $xml_Data:_XMLFile;
	private var $arr_QuestionPools:Array;
	private var $arr_QuestionList:Array;
	private var $arr_TotalSubmittedQuestions:Array;
	private var $arr_CurrentSubmittedQuestions:Array;
	private var $arr_CurrentQuestions:Array;
	private var $n_QuestionsPossible:Number;
	private var $n_QuestionsCorrect:Number;
	private var $n_PointsPossible:Number;
	private var $n_PointsEarned:Number;
	private var $n_PassPercent:Number;
	private var $b_ShowFeedback:Boolean;
	private var $b_NumberedQuestions:Boolean;
	private var $b_DebugMode:Boolean;
	private var $n_CurrentQuestion:Number;
	private var $n_CurrentY:Number;
	private var $n_SimultaneousQuestions:Number;
	private var $n_TimeLimit:Number;
	private var $fn_DisplayComplete:Function;
	private var $area_Question:QuestionArea;
	private var $b_Randomize:Boolean;
	private var $n_QuestionAttempts:Number;
	
	public function get timeLimit():Number
	{
		return isNaN($n_TimeLimit) ? null : $n_TimeLimit;
	}
	
	public function get questions():Array
	{
		return $arr_QuestionList;
	}
	
	public function get currentSubmitedQuestions():Array
	{
		return $arr_CurrentSubmittedQuestions;
	}
	
	public function get currentStartQuestion():Number
	{
		return $arr_CurrentQuestions[0].index + 1;
	}
	
	public function get currentEndQuestion():Number
	{
		return $arr_CurrentQuestions[$arr_CurrentQuestions.length - 1].index + 1;
	}
	
	public function get currentQuestionScreen():Number
	{
		return Math.ceil(($arr_CurrentQuestions[0].index + 1) / $n_SimultaneousQuestions); 
	}
	
	public function get totalQuestionScreens():Number
	{
		return Math.ceil($arr_QuestionList.length / $n_SimultaneousQuestions); 
	}
	
	public function get unansweredQuestions():Array
	{
		var arr_Unanswered:Array = new Array();
		
		for (var i:Number = 0; i < $arr_CurrentQuestions.length; i ++)
		{
			if (!$arr_CurrentQuestions[i].isAnswered)
				arr_Unanswered.push($arr_CurrentQuestions[i]);
		}
		
		return arr_Unanswered;
	}
	
	public function get isQuestionComplete():Boolean
	{
		var b_Complete:Boolean = true;
		
		for (var i:Number = 0; i < $arr_CurrentQuestions.length; i ++)
		{
			if (!$arr_CurrentQuestions[i].isComplete)
				b_Complete = false;
		}
		
		return b_Complete;
	}
	
	public function get isComplete():Boolean
	{
		return isQuestionComplete && $n_CurrentQuestion >= $arr_QuestionList.length - 1;
	}
	
	public function get isPassed():Boolean
	{
		return scorePercent >= $n_PassPercent;
	}
	
	public function get passingScore():Number
	{
		return Math.round($n_PassPercent / 100 * $n_PointsPossible);
	}
	
	public function get passingPercent():Number
	{
		return $n_PassPercent;
	}
	
	public function get questionPoolSummary():String
	{
		var str_Summary:String		= "";
		var str_Format:String		= "<b>{$NAME}: </b>{#SCOREPERCENT}% ({#SCORE}/{#POSSIBLESCORE})";
		var obj_FormatNode:Object	= $exam_Interface.getInterfaceNode("qp_summary", "text");
		
		if (obj_FormatNode.value != null)
			str_Format = obj_FormatNode.value;
			
		for (var i:Number = 0; i < $arr_QuestionPools.length; i ++)
		{
			if (i > 0)
				str_Summary += "<br/>";
			
			str_Summary += str_Format;
			str_Summary = str_Summary.split("{$NAME}").join($arr_QuestionPools[i].name);
			str_Summary = str_Summary.split("{#SCORE}").join($arr_QuestionPools[i].pointsEarned.toString());
			str_Summary = str_Summary.split("{#SCOREPERCENT}").join($arr_QuestionPools[i].scorePercent.toString());
			str_Summary = str_Summary.split("{#POSSIBLESCORE}").join($arr_QuestionPools[i].pointsPossible.toString());
		}
		
		return str_Summary;
	}
	
	public function get feedbackOn():Boolean
	{
		return $b_ShowFeedback;
	}
	
	public function get feedback():Boolean
	{
		var b_QuestionFeedback:Boolean;
		
		for (var i:Number = 0; i < $arr_CurrentQuestions.length; i ++)
		{
			if ($arr_CurrentQuestions[i].feedback)
			{
				b_QuestionFeedback = true;
				break;
			}
		}
		
		return $b_ShowFeedback && b_QuestionFeedback;
	}
	
	public function get randomize():Boolean
	{
		return $b_Randomize;
	}
	
	public function get questionAttempts():Number
	{
		return $n_QuestionAttempts;
	}
	
	public function get debug():Boolean
	{
		return $b_DebugMode;
	}
	
	public function get score():Number
	{
		return $n_PointsEarned;
	}
	
	public function get scorePercent():Number
	{
		return Math.round($n_PointsEarned / $n_PointsPossible * 100);
	}
	
	public function get pointsPossible():Number
	{
		return $n_PointsPossible;
	}
	
	public function get x():Number
	{
		return $area_Question._x;
	}
	
	public function get y():Number
	{
		return $area_Question._y;
	}
	
	public function get width():Number
	{
		return $area_Question._width;
	}
	
	public function get height():Number
	{
		var qst_First:Question	= $arr_CurrentQuestions[0];
		var qst_Last:Question	= $arr_CurrentQuestions[$arr_CurrentQuestions.length - 1];
		
		return qst_Last.y + qst_Last.height - qst_First.y;
	}
	
	public function get questionSpacing():Number
	{
		return $area_Question.questionSpacing;
	}
	
	public function get questionArea():QuestionArea
	{
		return $area_Question;
	}
	
	public function set questionArea( area_Question:QuestionArea ):Void
	{
		$area_Question = area_Question;
	}
	
	public function ExamEngine( exam_Interface:ExamInterface, xml_Data:_XMLFile, str_Bookmark:String )
	{
		$exam_Interface						= exam_Interface;
		$xml_Data							= xml_Data;
		$arr_QuestionList					= new Array();
		$arr_CurrentQuestions				= new Array();
		$arr_TotalSubmittedQuestions		= new Array();
		$arr_QuestionPools					= new Array();
		$n_QuestionsPossible				= 0;
		$n_QuestionsCorrect					= 0;
		$n_PointsEarned						= 0;
		$n_PointsPossible					= 0;
		$n_CurrentQuestion					= -1;
		Question.reset();
		
		var xml_Config:_XMLNode				= $xml_Data.xtc_findNode("config");
		var xml_QuestionPools:_XMLNode		= $xml_Data.xtc_findNode("question_pools");
		var arr_QuestionPoolNodes:Array		= xml_QuestionPools.xtc_findChildren("question_pool");
		var str_TimeLimit					= xml_Config.xtc_getAttribute("time_limit");
		$b_Randomize						= xml_Config.xtc_getBooleanAttribute("random");
		$n_SimultaneousQuestions			= xml_Config.xtc_getNumericAttribute("simultaneous_questions");
		$n_PassPercent						= xml_Config.xtc_getNumericAttribute("pass");
		$b_ShowFeedback						= xml_Config.xtc_getBooleanAttribute("feedback");
		$b_NumberedQuestions				= xml_Config.xtc_getBooleanAttribute("numbered_questions");
		$b_DebugMode						= xml_Config.xtc_getBooleanAttribute("debug");
		$n_QuestionAttempts					= xml_Config.xtc_getNumericAttribute("question_attempts");
		
		if ($n_QuestionAttempts == null)
			$n_QuestionAttempts = 1;
		else if (isNaN($n_QuestionAttempts))
			$n_QuestionAttempts = ExamEngine.UNLIMITED;
		
		if (str_TimeLimit.indexOf(":") >= 0)
		{
			var arr_TimeLimit:Array = str_TimeLimit.split(":");
			$n_TimeLimit = Number(arr_TimeLimit[0]) * 60 + Number(arr_TimeLimit[1]);
		}
		else
			$n_TimeLimit = Number(str_TimeLimit);
		
		var arr_TotalQuestionNodes:Array = xml_QuestionPools.xtc_getNodeList("question");
		
		for (var i:Number = 0; i < arr_TotalQuestionNodes.length; i ++)
			arr_TotalQuestionNodes[i].xtc_setAttribute("global_index", i);
		
		if (str_Bookmark != null && str_Bookmark != "")
		{
			var obj_QuestionPoolsCreated:Object	= new Object();
			var arr_CompletedQuestions:Array	= new Array();
			var xml_CurrentPoolNode:_XMLNode;
			
			var arr_Bookmark:Array = str_Bookmark.split(DELIMITER);
			
			for (var i:Number = 0; i < arr_Bookmark.length; i += 2)
			{
				var n_QuestionIndex:Number		= arr_Bookmark[i];
				var str_QuestionResponse:String = arr_Bookmark[i + 1];
				var xml_Question:_XMLNode		= arr_TotalQuestionNodes[n_QuestionIndex];
				var xml_QuestionPool:_XMLNode	= xml_Question.xtc_getParent();
				
					// If this is the first time in set the current pool
				if (xml_CurrentPoolNode == null)
					xml_CurrentPoolNode = xml_QuestionPool;
				
					// If we started recording questions for a new pool, it's time to create the current pool
				if (!xml_CurrentPoolNode.xtc_equals(xml_QuestionPool))
				{
					createQuestionPool(xml_CurrentPoolNode, xml_Config, arr_CompletedQuestions);
					obj_QuestionPoolsCreated[xml_CurrentPoolNode.xtc_getAttribute("id")] = true;
					arr_CompletedQuestions	= new Array();
					xml_CurrentPoolNode		= xml_QuestionPool;
				}
				
				arr_CompletedQuestions.push({xml: xml_Question, response: str_QuestionResponse});
				
					// If this is the last question recorded, we need to create this pool, including this question
				if (i >= arr_Bookmark.length - 2)
				{
					createQuestionPool(xml_CurrentPoolNode, xml_Config, arr_CompletedQuestions);
					obj_QuestionPoolsCreated[xml_CurrentPoolNode.xtc_getAttribute("id")] = true;
				}
			}
			
			if ($b_Randomize)
				ExamEngine.randomizeArray(arr_QuestionPoolNodes);
			
			for (var i:Number = 0; i < arr_QuestionPoolNodes.length; i ++)
			{
					// If this pool hasn't been created yet, lets create it
				if (!obj_QuestionPoolsCreated[arr_QuestionPoolNodes[i].xtc_getAttribute("id")])
					createQuestionPool(arr_QuestionPoolNodes[i], xml_Config);
			}
			
				// The minus 1 is because it should be set to one less than the index you want (i.e. first question is -1 not 0)
				// This is because the interface will call displayNextQuestion to being with
			$n_CurrentQuestion = arr_Bookmark.length / 2 - 1;
		}
		else
		{
			if ($b_Randomize)
				ExamEngine.randomizeArray(arr_QuestionPoolNodes);
			
			for (var i:Number = 0; i < arr_QuestionPoolNodes.length; i ++)
				createQuestionPool(arr_QuestionPoolNodes[i], xml_Config);
		}
		
		if ($n_SimultaneousQuestions == null)
			$n_SimultaneousQuestions = 1;
		else if (isNaN($n_SimultaneousQuestions))
			$n_SimultaneousQuestions = $arr_QuestionList.length;
	}
	
	private function createQuestionPool( xml_QuestionPoolNode:_XMLNode, xml_Config:_XMLNode, arr_CompletedQuestions:Array ):QuestionPool
	{
		var qp_Data:QuestionPool = new QuestionPool(this, xml_QuestionPoolNode, xml_Config, arr_CompletedQuestions);
		
		$n_PointsPossible		+= qp_Data.pointsPossible;
		$n_QuestionsPossible	+= qp_Data.questions.length;
	
		for (var j:Number = 0; j < qp_Data.questions.length; j ++)
		{
			if (qp_Data.questions[j].response != null)
			{
				var n_Points:Number = qp_Data.questions[j].grade();
//	flash.external.ExternalInterface.call("alert", "n_Points: " + n_Points);
				$n_PointsEarned += n_Points;
				qp_Data.questions[j].questionPool.pointsEarned += n_Points;
				$arr_TotalSubmittedQuestions.push(qp_Data.questions[j]);
			}
			
			$arr_QuestionList.push(qp_Data.questions[j]);
		}
		
		$arr_QuestionPools.push(qp_Data);
		return qp_Data;
	}
	
	public function displayNextQuestion():Void
	{
		while ($arr_CurrentQuestions.length > 0)
		{
			var qst_Target:Question = Question($arr_CurrentQuestions.shift());
			qst_Target.destroy();
		}
		
		$n_CurrentY = 0;
		
		loadQuestion(++ $n_CurrentQuestion, $n_CurrentY);
		onDisplayLoadStart();
	}
	
	public function loadQuestion( n_Question:Number, n_Y:Number ):Void
	{				
		$arr_CurrentQuestions.push($arr_QuestionList[n_Question]);
		$arr_QuestionList[n_Question].onLoaded	= Delegate.create(this, questionLoaded);
		$arr_QuestionList[n_Question].onChange	= Delegate.create(this, answerChange);
		$arr_QuestionList[n_Question].width		= width;
		$arr_QuestionList[n_Question].x			= 0;
		$arr_QuestionList[n_Question].y			= n_Y;
		$arr_QuestionList[n_Question].numbered	= $b_NumberedQuestions;
		$arr_QuestionList[n_Question].display($area_Question);
		
		if ($arr_QuestionList[n_Question].hasExternalMedia)
			$exam_Interface.preloader.monitor($arr_QuestionList[n_Question]);
	}
	
	public function questionLoaded():Void
	{
		if ($arr_CurrentQuestions[$arr_CurrentQuestions.length - 1].hasExternalMedia)
			$exam_Interface.preloader.reset();
		
		if ($arr_CurrentQuestions.length < $n_SimultaneousQuestions && $n_CurrentQuestion < $arr_QuestionList.length - 1)
		{
			$n_CurrentY += $arr_CurrentQuestions[$arr_CurrentQuestions.length - 1].height + questionSpacing;
			loadQuestion(++ $n_CurrentQuestion, $n_CurrentY);
		}
		else
		{
			onDisplayChanged();
			onDisplayLoadComplete();
			$exam_Interface.scrollToTop();
		}
	}
	
	private function repositionQuestions():Void
	{
		$n_CurrentY = 0;
		
		for (var i:Number = 0; i < $arr_CurrentQuestions.length; i ++)
		{
			$arr_CurrentQuestions[i].y = $n_CurrentY;
			$n_CurrentY += $arr_CurrentQuestions[i].height + questionSpacing;
		}
		
		onDisplayChanged();
	}
	
	public function answerChange():Void
	{
		var b_AllAnswered:Boolean = true;
		
		for (var i:Number = 0; i < $arr_CurrentQuestions.length; i ++)
		{
			if (!$arr_CurrentQuestions[i].isAnswered)
			{
				b_AllAnswered = false;
				break;
			}
		}
		
		onAnswerChanged(b_AllAnswered);
	}
	
	public function submit():Void
	{
		$arr_CurrentSubmittedQuestions = new Array();
		
		for (var i:Number = 0; i < $arr_CurrentQuestions.length; i ++)
		{
				// Don't re-grade a question if it's already complete
			if (!$arr_CurrentQuestions[i].isComplete)
			{
				var n_PointsEarned:Number = $arr_CurrentQuestions[i].grade();
				
					// If it's complete now, then record it's score
				if ($arr_CurrentQuestions[i].isComplete)
				{
					$arr_CurrentSubmittedQuestions.push($arr_CurrentQuestions[i]);
					$arr_TotalSubmittedQuestions.push($arr_CurrentQuestions[i]);
					
					$n_PointsEarned += n_PointsEarned;
					$arr_CurrentQuestions[i].questionPool.pointsEarned += n_PointsEarned;
					
					if (n_PointsEarned > 0)
						$n_QuestionsCorrect ++;
				}
			}
		}
		
			// Adjust the postioning to account for feedback
		repositionQuestions();
	}
	
	public function getBookmark():String
	{
		var str_Bookmark:String = "";
				
		for (var i:Number = 0; i < $arr_TotalSubmittedQuestions.length; i ++)
		{
			if (str_Bookmark != "")
				str_Bookmark += DELIMITER;
				
			str_Bookmark += $arr_TotalSubmittedQuestions[i].globalIndex;
			str_Bookmark += DELIMITER;
			
			if ($arr_TotalSubmittedQuestions[i].response != null)
				str_Bookmark += $arr_TotalSubmittedQuestions[i].response;
		}
		
		return str_Bookmark;
	}
	
	public function replaceVariableTokens( str_Content:String ):String
	{
			// For backwards compatability
		str_Content = str_Content.split("{score}").join(scorePercent.toString());
		
		str_Content = str_Content.split("{#CURRENTP}").join(currentQuestionScreen.toString());
		str_Content = str_Content.split("{#TOTALP}").join(totalQuestionScreens.toString());
		str_Content = str_Content.split("{#CURRENTSTARTQ}").join(currentStartQuestion.toString());
		str_Content = str_Content.split("{#CURRENTENDQ}").join(currentEndQuestion.toString());
		str_Content = str_Content.split("{#CORRECTQ}").join($n_QuestionsCorrect.toString());
		str_Content = str_Content.split("{#TOTALQ}").join($n_QuestionsPossible.toString());
		str_Content = str_Content.split("{#SCORE}").join(score.toString());
		str_Content = str_Content.split("{#POSSIBLESCORE}").join(pointsPossible.toString());
		str_Content = str_Content.split("{#SCOREPERCENT}").join(scorePercent.toString());
		str_Content = str_Content.split("{#PASSSCORE}").join(passingScore.toString());
		str_Content = str_Content.split("{#PASSPERCENT}").join(passingPercent.toString());
		
			// This formatting is resource intensive, should only be done if needed.
		if (str_Content.indexOf("{$QPSUMMARY}") >= 0)
			str_Content = str_Content.split("{$QPSUMMARY}").join(questionPoolSummary);
		
		return str_Content;
	}
	
	public function selectCorrectAnswers():Void
	{
		for (var i:Number = 0; i < $arr_CurrentQuestions.length; i ++)
		{
			if (!$arr_CurrentQuestions[i].isComplete)
				$arr_CurrentQuestions[i].selectCorrectAnswers();
		}
	}
	
	public function selectIncorrectAnswers():Void
	{
		for (var i:Number = 0; i < $arr_CurrentQuestions.length; i ++)
		{
			if (!$arr_CurrentQuestions[i].isComplete)
				$arr_CurrentQuestions[i].selectIncorrectAnswers();
		}
	}
	
	public static function randomizeArray( arr_Data:Array ):Array
	{
			// Create a key to map the new order to the old order
		var arr_Key:Array = new Array();
		
			// Keep track of the original indices
		for (var i:Number = 0; i < arr_Data.length; i ++)
			arr_Key[i] = {index: i};
		
		for (var i:Number = 0; i < arr_Data.length; i ++)
		{
			var n_RandomIndex:Number = randomNumber(i, arr_Data.length - 1);
			arr_Data.unshift(arr_Data.splice(n_RandomIndex, 1)[0]);
			arr_Key.unshift(arr_Key.splice(n_RandomIndex, 1)[0]);
		}
		
		for (var i:Number = 0; i < arr_Key.length; i ++)
			arr_Key[arr_Key[i].index].newIndex = i;
		
		return arr_Key;
	}
	
	private static function randomNumber( n_Min:Number, n_Max:Number ):Number
	{
		if (n_Max == null)
		{
			n_Max = n_Min;
			n_Min = 0;
		}
		
		return Math.round(Math.random() * (n_Max - n_Min)) + n_Min;
	}
}