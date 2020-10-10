import mx.transitions.*;
import mx.transitions.easing.*;

class QuestionMatching extends QuestionWithFeedback
{		
	private var $arr_OrderedSourceItems:Array;
	private var $arr_SourceItems:Array;
	private var $arr_TargetItems:Array;
	private var $arr_SourceKeys:Array;
	private var $arr_TargetKeys:Array;
	private var $b_Complete:Boolean;
	
	public function get SCORMType():String
	{
		return "matching";
	}
	
	public function get currentResponse():String
	{
		var str_Response:String = "";
		
		for (var i:Number = 0; i < $arr_OrderedSourceItems.length; i ++)
		{
			if ($arr_OrderedSourceItems[i].target != null)
			{
				if (str_Response != "")
					str_Response += ",";
					
				str_Response += String.fromCharCode(97 + $arr_OrderedSourceItems[i].index);
				str_Response += ".";
				str_Response += String.fromCharCode(97 + $arr_OrderedSourceItems[i].target.index);
			}
		}
		
		return str_Response;
	}
	
	public function get correctResponse():String
	{
		var xml_Sources	:_XMLNode	= $xml_Data.xtc_findNode("source_items");
		var arr_Sources	:Array	  	= xml_Sources.xtc_findChildren("item");
		var xml_Targets :_XMLNode	= $xml_Data.xtc_findNode("target_items");
		var arr_Targets	:Array	  	= xml_Targets.xtc_findChildren("item");
		
		var str_Response:String = "";
		
		for (var i:Number = 0; i < arr_Sources.length; i ++)
		{
			if (arr_Sources[i].xtc_getNumericAttribute("match") != null)
			{
				if (str_Response != "")
					str_Response += ",";
					
				str_Response += String.fromCharCode(97 + i);
				str_Response += ".";
				str_Response += String.fromCharCode(97 + arr_Sources[i].xtc_getNumericAttribute("match"));
			}
		}
		
		return str_Response;
	}
	
	public function set enabled( b_Enabled:Boolean ):Void
	{
		super.enabled = b_Enabled;
		
		for (var i:Number = 0; i < $arr_SourceItems.length; i ++)
			$arr_SourceItems[i].enabled = b_Enabled;
	}
	
	public function get isAnswered():Boolean
	{
		for (var i:Number = 0; i < $arr_SourceItems.length; i ++)
		{
			if ($arr_SourceItems[i].isAnswered)
				return true;
		}

		return false;
	}
	
	public function get isComplete():Boolean
	{
		return $b_Complete;
	}
	
	public function QuestionMatching( qp_Engine:QuestionPool, xml_Data:_XMLNode, xml_Config:_XMLNode, str_Response:String )
	{
		super(qp_Engine, xml_Data, xml_Config, str_Response);
	}
	
	private function build( mc_ContentArea:MovieClip ):Void
	{
		super.build(mc_ContentArea);
		
		var xml_SourceItems:_XMLNode	= $xml_Data.xtc_findNode("source_items");
		var xml_TargetItems:_XMLNode	= $xml_Data.xtc_findNode("target_items");
		var arr_SourceItems:Array		= xml_SourceItems.xtc_findChildren("item");
		var arr_TargetItems:Array		= xml_TargetItems.xtc_findChildren("item");
		
		var n_GroupSpacing:Number	= $xml_Data.xtc_getNumericAttribute("group_spacing", "type_settings");
		var n_SourceSpacing:Number	= xml_SourceItems.xtc_getNumericAttribute("spacing");
		var n_TargetSpacing:Number	= xml_TargetItems.xtc_getNumericAttribute("spacing");
		var b_SourceRandom:Boolean	= xml_SourceItems.xtc_getBooleanAttribute("random");
		var b_TargetRandom:Boolean	= xml_TargetItems.xtc_getBooleanAttribute("random");
		
		if (n_GroupSpacing == null)
			n_GroupSpacing = 0;
		
		if (n_SourceSpacing == null)
			n_SourceSpacing = 0;
		
		if (n_TargetSpacing == null)
			n_TargetSpacing = 0;
		
		if (questionArea.horizontalGroupSpacing != null)
			n_GroupSpacing  += questionArea.horizontalGroupSpacing;
			
		if (questionArea.verticalOptionSpacing != null)
		{
			n_SourceSpacing += questionArea.verticalOptionSpacing;
			n_TargetSpacing += questionArea.verticalOptionSpacing;
		}
		
		if (b_SourceRandom)
			$arr_SourceKeys = ExamEngine.randomizeArray(arr_SourceItems);
		
		if (b_TargetRandom)
			$arr_TargetKeys = ExamEngine.randomizeArray(arr_TargetItems);
		
		var n_SourceWidth:Number	= ($n_StemWidth - n_GroupSpacing) / 2;
		var n_TargetWidth:Number	= ($n_StemWidth - n_GroupSpacing) / 2;
		var n_CurrentSourceY:Number	= answerStartY;
		var n_CurrentTargetY:Number	= answerStartY;
		$arr_OrderedSourceItems		= new Array();
		$arr_SourceItems			= new Array();
		$arr_TargetItems			= new Array();
		
		var n_MaxSourceWidth:Number = 0;
		
		for (var i:Number = 0; i < arr_SourceItems.length; i ++)
		{
			var n_Index:Number = $arr_SourceKeys == null ? i : $arr_SourceKeys[i].index;
			
			var strSourceStyle:String = arr_SourceItems[i].xtc_getAttribute("style");
			
			if ((strSourceStyle == null) || (strSourceStyle == ""))
				strSourceStyle = "SOURCE";
			
			var mc_Source:Source				= Source($mc_Display.attachMovie("comp_Source", "mc_Source" + i, $mc_Display.getNextHighestDepth(), {$str_Style: strSourceStyle}));
			mc_Source._x						= $n_StemX;
			mc_Source._y						= n_CurrentSourceY;
			mc_Source.width						= n_SourceWidth;
			mc_Source.xml						= arr_SourceItems[i];
			mc_Source.text						= arr_SourceItems[i].xtc_getValue();
			mc_Source.index						= n_Index;
			mc_Source.match						= arr_SourceItems[i].xtc_getNumericAttribute("match");
			mc_Source.dragItem.onPress			= onDragPress;
			mc_Source.dragItem.onRelease		= onDragRelease;
			mc_Source.dragItem.onReleaseOutside	= onDragRelease;
			mc_Source.question					= this;
			
			n_CurrentSourceY += mc_Source._height + n_SourceSpacing;
			
			$arr_SourceItems.push(mc_Source);
			$arr_OrderedSourceItems[n_Index] = mc_Source;
			
			if (mc_Source._width > n_MaxSourceWidth)
				n_MaxSourceWidth = mc_Source._width;
		}
		
		if (n_MaxSourceWidth < n_SourceWidth)
		{
			n_TargetWidth += n_SourceWidth - n_MaxSourceWidth;
			n_SourceWidth = n_MaxSourceWidth;
			
			for (var i:Number = 0; i < $arr_SourceItems.length; i ++)
				$arr_SourceItems[i].width = n_SourceWidth;
		}
		
		for (var i:Number = 0; i < arr_TargetItems.length; i ++)
		{
			var n_Index:Number = $arr_TargetKeys == null ? i : $arr_TargetKeys[i].index;
			
			var strTargetStyle:String = arr_TargetItems[i].xtc_getAttribute("style");
			
			if ((strTargetStyle == null) || (strTargetStyle == ""))
				strTargetStyle = "TARGET";
			
			var mc_Target:Target	= Target($mc_Display.attachMovie("comp_Target", "mc_Target" + i, $mc_Display.getNextHighestDepth(), {$str_Style: strTargetStyle}));
			mc_Target._x			= $n_StemX + n_SourceWidth + n_GroupSpacing;
			mc_Target._y			= n_CurrentTargetY;
			mc_Target.width			= n_TargetWidth;
			mc_Target.xml			= arr_TargetItems[i];
			mc_Target.text			= arr_TargetItems[i].xtc_getValue();
			mc_Target.index			= n_Index;
			mc_Target.question		= this;
			
			n_CurrentTargetY += mc_Target._height + n_TargetSpacing;
			
			$arr_TargetItems.push(mc_Target);
		}
		
		loadComplete();
	}
	
	public function destroy():Void
	{
		super.destroy();
		$arr_OrderedSourceItems = null;
		$arr_SourceItems		= null;
		$arr_TargetItems		= null;
		$arr_SourceKeys			= null;
		$arr_TargetKeys			= null;
	}
	
	private function onDragPress():Void
	{
		var mc_DragItem:MovieClip		= MovieClip(this);
		var mc_SourceItem:Source		= Source(mc_DragItem._parent._parent);
		var qst_This:QuestionMatching	= QuestionMatching(mc_SourceItem.question);
		
		mc_SourceItem.swapDepths(qst_This.$mc_Display.getNextHighestDepth());
		qst_This.stopDragItemAnimation(mc_DragItem);
		mc_DragItem.onMouseMove = qst_This.onDragMove;
		mc_DragItem.startDrag();
	}
	
	private function onDragMove():Void
	{
		var mc_DragItem:MovieClip	= MovieClip(this);
		var mc_SourceItem:Source	= Source(mc_DragItem._parent._parent);
		
		var n_AnchorX:Number	= mc_SourceItem.anchor._x + mc_SourceItem.anchor._width / 2;
		var n_AnchorY:Number	= mc_SourceItem.anchor._y + mc_SourceItem.anchor._height / 2;
		var n_DragX:Number		= mc_DragItem._x + mc_DragItem._width / 2;
		var n_DragY:Number		= mc_DragItem._y + mc_DragItem._height / 2;
		
		mc_SourceItem.line.clear();
		mc_SourceItem.line.lineStyle(1, 0xFFFFFF);
		mc_SourceItem.line.moveTo(n_AnchorX, n_AnchorY);
		mc_SourceItem.line.lineTo(n_DragX, n_DragY);
		updateAfterEvent();
	}
	
	private function onDragRelease():Void
	{
		var mc_DragItem:MovieClip		= MovieClip(this);
		var mc_SourceItem:Source		= Source(mc_DragItem._parent._parent);
		var qst_This:QuestionMatching	= QuestionMatching(mc_SourceItem.question);
		var mc_Target:Target			= qst_This.getCurrentTarget(mc_SourceItem);
		
		mc_DragItem.stopDrag();
		
			// If there is already a source on this target, remove it
		if (mc_Target.source != null)
		{
				// If this source came from another target, move this source there
			if (mc_SourceItem.target != null)
				qst_This.animateToTarget(mc_Target.source, mc_SourceItem.target);
				// Otherwise send it back to the start
			else
				qst_This.animateToStart(mc_Target.source);
		}
		
		if (mc_Target == null)
			qst_This.animateToStart(mc_SourceItem);
		else
			qst_This.animateToTarget(mc_SourceItem, mc_Target);
		
		qst_This.$fn_Change();
	}
	
	private function stopDragItemAnimation( mc_Item:MovieClip ):Void
	{
		mc_Item.__twnX.stop();
		mc_Item.__twnY.stop();
	}
	
	private function animateToStart( mc_Source:Source ):Void
	{
		mc_Source.target.source	= null;
		mc_Source.target		= null;
		
		animateDragItemTo(mc_Source.dragItem, mc_Source.preDragX, mc_Source.preDragY);
	}
	
	private function animateToTarget( mc_Source:Source, mc_Target:Target ):Void
	{
		var n_TargetX:Number = (mc_Target._x + mc_Target.targetArea._x) - (mc_Source._x + mc_Source.dragArea._x);
		var n_TargetY:Number = (mc_Target._y + mc_Target.targetArea._y) - (mc_Source._y + mc_Source.dragArea._y);
		
		mc_Target.source.target = null;
		mc_Source.target.source	= null;
		mc_Source.target		= mc_Target;
		mc_Source.target.source	= mc_Source;
		
		animateDragItemTo(mc_Source.dragItem, n_TargetX, n_TargetY);
	}
	
	private function animateDragItemTo( mc_Item:MovieClip, n_X:Number, n_Y:Number ):Void
	{
		stopDragItemAnimation(mc_Item);
		mc_Item.onMouseMove = onDragMove;
		mc_Item.__twnX = new Tween(mc_Item, "_x", Strong.easeOut, mc_Item._x, n_X, .5, true);
		mc_Item.__twnY = new Tween(mc_Item, "_y", Strong.easeOut, mc_Item._y, n_Y, .5, true);
		mc_Item.__twnY.onMotionChanged	= function():Void { mc_Item.onMouseMove() };
		mc_Item.__twnY.onMotionFinished	= function():Void { delete mc_Item.onMouseMove };
	}
	
	private function getCurrentTarget( mc_Source:Source ):Target
	{
		for (var i:Number = 0; i < $arr_TargetItems.length; i ++)
		{
			var n_X:Number = $mc_Display._xmouse;
			var n_Y:Number = $mc_Display._ymouse;
			var n_L:Number = $arr_TargetItems[i]._x;
			var n_T:Number = $arr_TargetItems[i]._y;
			var n_R:Number = n_L + $arr_TargetItems[i]._width;
			var n_B:Number = n_T + $arr_TargetItems[i]._height;
			
			if ((n_X >= n_L) && (n_X <= n_R) && (n_Y >= n_T) && (n_Y <= n_B))
				return $arr_TargetItems[i];
		}
		
		return null;
	}
	
	public function grade():Number
	{
		var str_Response		:String	= response;
		var str_Correct			:String	= correctResponse;
		var n_Points			:Number	= super.grade();
		var xml_Feedback		:_XMLNode;

		$b_Correct	= str_Response == str_Correct;
		$b_Complete = $b_Correct || attemptsRemaining <= 0;

		if ($b_Complete)
		{
			enabled = false;
			
			for (var i:Number = 0; i < $arr_SourceItems.length; i ++)
				$arr_SourceItems[i].showGradeMark();
				
			if ($b_Correct)
			{
				n_Points += pointValue;
				xml_Feedback = $xml_FeedbackCorrect;
			}
			else
				xml_Feedback = $xml_FeedbackIncorrect;
		}
		else
			xml_Feedback = $xml_FeedbackInitialIncorrect;
		
		var mc_LastSource:MovieClip = $arr_SourceItems[$arr_SourceItems.length - 1];
		var mc_LastTarget:MovieClip = $arr_TargetItems[$arr_TargetItems.length - 1];
		
		showFeedback(xml_Feedback, Math.max(mc_LastSource._y + mc_LastSource.height, mc_LastTarget._y + mc_LastTarget.height));
		
		return n_Points;
	}

	public function selectCorrectAnswers():Void
	{
		for (var i:Number = 0; i < $arr_SourceItems.length; i ++)
		{
			var mc_Source:Source		= $arr_SourceItems[i];
			var n_TargetIndex:Number	= mc_Source.match;
			
			if ($arr_TargetKeys != null)
				n_TargetIndex = $arr_TargetKeys[mc_Source.match].newIndex;
			
			if ($arr_TargetItems[n_TargetIndex] != null)
			{
				animateToTarget(mc_Source, $arr_TargetItems[n_TargetIndex]);
				mc_Source.swapDepths($mc_Display.getNextHighestDepth());
			}
			else
				animateToStart(mc_Source);
		}
		
		$fn_Change();
	}
	
	public function selectIncorrectAnswers():Void
	{
		for (var i:Number = 0; i < $arr_SourceItems.length; i ++)
		{
			var mc_Source:Source		= $arr_SourceItems[i];
			var n_TargetIndex:Number	= mc_Source.match;
			
			if ($arr_TargetKeys != null)
				n_TargetIndex = $arr_TargetKeys[mc_Source.match].newIndex;
			
			n_TargetIndex ++;
			
			if (n_TargetIndex >= $arr_TargetItems.length)
				n_TargetIndex = 0;
			
			if (mc_Source.match != null)
			{
				animateToTarget(mc_Source, $arr_TargetItems[n_TargetIndex]);
				mc_Source.swapDepths($mc_Display.getNextHighestDepth());
			}
			else
				animateToStart(mc_Source);
		}
		
		$fn_Change();
	}
}