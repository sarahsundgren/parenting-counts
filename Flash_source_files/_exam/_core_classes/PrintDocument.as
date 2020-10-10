import mx.containers.*;

class PrintDocument extends PrintJob
{		
	public static var showPageNumbers:Boolean;
	public static var showPageDate:Boolean;
	public static var showPageURL:Boolean;

	public static var formatPageNumbers:TextFormat	= new TextFormat("_sans", 14, 0x000000, null, null, null, null, null, "right");
	public static var formatPageDate:TextFormat		= new TextFormat("_sans", 14, 0x000000, null, null, null, null, null, "left");
	public static var formatPageURL:TextFormat		= new TextFormat("_sans", 14, 0x000000, null, null, null, null, null, "left");
	
	private var n_PagePaddingLeft:Number	= 20;
	private var n_PagePaddingRight:Number	= 20;
	private var n_PagePaddingTop:Number		= 20;
	private var n_PagePaddingBtm:Number		= 20;
	
	public function get paddingTop():Number
	{
		return n_PagePaddingTop;
	}
	
	public function set paddingTop( n_Value:Number ):Void
	{
			// Only allow positive padding
		n_PagePaddingTop = n_Value > 0 ? n_Value : 0;
	}
	
	public function get paddingBottom():Number
	{
		return n_PagePaddingBtm;
	}
	
	public function set paddingBottom( n_Value:Number ):Void
	{
			// Only allow positive padding
		n_PagePaddingBtm = n_Value > 0 ? n_Value : 0;
	}
	
	public function printMovieClip( mc_Target:MovieClip ):Void
	{
		if (start())
			printMovieClipContent(mc_Target);
	}
	
	public function printScrollPane( pane_Target:ScrollPane ):Void
	{
		if (start())
		{
				// Hide the mask to ensure all content is printed
			pane_Target.content.setMask(null);
			printMovieClipContent(pane_Target.content);
			
				// Restore mask when printing is complete
			pane_Target.content.setMask(pane_Target.mask_mc);
		}
	}
	
	private function findVisualChildren( mc_Target:MovieClip, n_MaxHeight:Number, n_OffsetY:Number ):Array
	{
		var arr_VisualChildren:Array = new Array();
		
		if (n_OffsetY == null)
			n_OffsetY = 0;
		
		for (var str_Prop:String in mc_Target)
		{
			var obj_Prop:Object = mc_Target[str_Prop];
			
			if ((obj_Prop._visible) && (obj_Prop instanceof MovieClip || obj_Prop instanceof TextField))
			{
				if (obj_Prop._height < n_MaxHeight)
					arr_VisualChildren.push({child: obj_Prop, startY: obj_Prop._y, absoluteY: obj_Prop._y + n_OffsetY});
				else if (obj_Prop instanceof MovieClip)
				{
					arr_VisualChildren = arr_VisualChildren.concat(findVisualChildren(MovieClip(obj_Prop), n_MaxHeight, n_OffsetY + obj_Prop._y));
				}
			}
		}
		
		return arr_VisualChildren;
	}
	
	private function printMovieClipContent( mc_Target:MovieClip ):Void
	{
			// Record original scaling
		var n_ScaleX:Number = mc_Target._xscale;
		var n_ScaleY:Number = mc_Target._yscale;
		
			// Scale to fit page
		mc_Target._width = pageWidth;
		mc_Target._yscale = mc_Target._xscale;
		
			// Track the new page dimensions adjusted to the scaling
		var n_ScaledPageWidth:Number = pageWidth / (mc_Target._xscale / 100);
		var n_ScaledPageHeight:Number = pageHeight / (mc_Target._yscale / 100);
		
			// Set up an array of visual children
		var arr_VisualChildren:Array = findVisualChildren(mc_Target, n_ScaledPageHeight - n_PagePaddingTop - n_PagePaddingBtm);
		var n_OffsetY:Number = n_PagePaddingTop;
		
			// Make sure they are in order top to bottom
		arr_VisualChildren.sortOn("absoluteY", Array.NUMERIC);
		
			// Move all the children to acount for line breaks
		for (var i:Number = 0; i < arr_VisualChildren.length; i ++)
		{
			var n_T:Number = arr_VisualChildren[i].absoluteY + n_OffsetY;
			var n_B:Number = n_T + arr_VisualChildren[i].child._height + n_PagePaddingBtm;
			
				// If the starting page is less than the ending page
				// Offset everything by the gap between the start of the child and the end of the starting page
			if (Math.floor(n_T / n_ScaledPageHeight) < Math.floor(n_B / n_ScaledPageHeight))
				n_OffsetY += n_PagePaddingTop + (Math.ceil(n_T / n_ScaledPageHeight) - (n_T / n_ScaledPageHeight)) * n_ScaledPageHeight;
			
			arr_VisualChildren[i].child._y += n_OffsetY;
		}
		
			// Loop through and print the movie clip in page sized sections
		var n_ScaledTotalHeight:Number = mc_Target._height / (mc_Target._yscale / 100);
		var n_TotalPages:Number	= Math.ceil(n_ScaledTotalHeight / n_ScaledPageHeight);
		var n_CurrentY:Number	= 0;
		var n_Page:Number		= 1;
		var arr_CleanUp:Array	= new Array();
		
		while (n_CurrentY < n_ScaledTotalHeight)
		{
			if (showPageNumbers)
			{
				var txt_PageNumber:TextField	= mc_Target.createTextField("txt_PageNumber" + n_CurrentY, mc_Target.getNextHighestDepth(), n_PagePaddingLeft, n_CurrentY, n_ScaledPageWidth - n_PagePaddingLeft - n_PagePaddingRight, 0);
				txt_PageNumber.multiline		= false;
				txt_PageNumber.wordWrap			= false;
				txt_PageNumber.autoSize			= formatPageNumbers.align;
				txt_PageNumber.text				= "Page " + n_Page + " of " + n_TotalPages;
				txt_PageNumber.setTextFormat(formatPageNumbers);
				arr_CleanUp.push(txt_PageNumber);
			}
			if (showPageDate)
			{
				var dte_Current:Date		= new Date();
				var txt_PageDate:TextField	= mc_Target.createTextField("txt_PageDate" + n_CurrentY, mc_Target.getNextHighestDepth(), n_PagePaddingLeft, n_CurrentY, n_ScaledPageWidth - n_PagePaddingLeft - n_PagePaddingRight, 0);
				txt_PageDate.multiline		= false;
				txt_PageDate.wordWrap		= false;
				txt_PageDate.autoSize		= formatPageDate.align;
				txt_PageDate.text			= (dte_Current.getMonth() + 1) + "/" + dte_Current.getDate() + "/" + dte_Current.getFullYear();
				txt_PageDate.setTextFormat(formatPageDate);
				arr_CleanUp.push(txt_PageDate);
			}
			if (showPageURL)
			{
				var txt_PageURL:TextField	= mc_Target.createTextField("txt_PageURL" + n_CurrentY, mc_Target.getNextHighestDepth(), n_PagePaddingLeft, n_CurrentY, n_ScaledPageWidth - n_PagePaddingLeft - n_PagePaddingRight, 0);
				txt_PageURL.multiline		= false;
				txt_PageURL.wordWrap		= false;
				txt_PageURL.autoSize		= formatPageURL.align;
				txt_PageURL.text			= unescape(_root._url);
				txt_PageURL.setTextFormat(formatPageURL);
				arr_CleanUp.push(txt_PageURL);
				
				txt_PageURL._y += n_ScaledPageHeight - txt_PageURL._height;
			}
			
			addPage(mc_Target, {xMin: 0, xMax: n_ScaledPageWidth, yMin: n_CurrentY, yMax: n_CurrentY += n_ScaledPageHeight});
			n_Page ++;
		}
		
		send();
		
			// Remove any TextFields that were added
		for (var i:Number = 0; i < arr_CleanUp.length; i ++)
			arr_CleanUp[i].removeTextField();
		
			// Reset the movieclips scaling and children positions
		for (var i:Number = 0; i < arr_VisualChildren.length; i ++)
			arr_VisualChildren[i].child._y = arr_VisualChildren[i].startY;
		
		mc_Target._xscale = n_ScaleX;
		mc_Target._yscale = n_ScaleY;
	}
}