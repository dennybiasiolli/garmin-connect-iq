using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Math as Math;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Calendar;
using Toybox.WatchUi as Ui;
using Toybox.Application as App;

class SwimBikeRunView extends Ui.WatchFace {
	var showSecond = true;
	var background_color = Gfx.COLOR_BLACK;

    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
        var clockTime = Sys.getClockTime();

        // Clear the screen
        dc.setColor(background_color, Gfx.COLOR_WHITE);
        dc.fillRectangle(0,0, dc.getWidth(), dc.getHeight());
        // Draw the gray rectangle
        //dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_DK_GRAY);
        //dc.fillPolygon([[0,0],[dc.getWidth(), 0],[dc.getWidth(), dc.getHeight()],[0,0]]);

        // Draw the hash marks
		dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
        drawHashMarks(dc);


        // Draw the logo
        dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth()/2, dc.getHeight()/6, Gfx.FONT_MEDIUM, "TRIATHLON", Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(dc.getWidth()/2, dc.getHeight()/4, Gfx.FONT_LARGE, "SwimBikeRun", Gfx.TEXT_JUSTIFY_CENTER);
        //dc.drawText(dc.getWidth()/2, dc.getHeight()/6, Gfx.FONT_LARGE, "IRONMAN", Gfx.TEXT_JUSTIFY_CENTER);
        //dc.drawText(dc.getWidth()/2, dc.getHeight()/7*2, Gfx.FONT_MEDIUM, "Swim Bike Run", Gfx.TEXT_JUSTIFY_CENTER);
        //dc.setColor(Gfx.COLOR_DK_BLUE, Gfx.COLOR_TRANSPARENT);
        //dc.drawText(dc.getWidth()/4, dc.getHeight()/7*2, Gfx.FONT_LARGE, "Swim", Gfx.TEXT_JUSTIFY_CENTER);
        //dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        //dc.drawText(dc.getWidth()/2 + 10, dc.getHeight()/7*2, Gfx.FONT_LARGE, "Bike", Gfx.TEXT_JUSTIFY_CENTER);
        //dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
        //dc.drawText(dc.getWidth()/4*3 + 10, dc.getHeight()/7*2, Gfx.FONT_LARGE, "Run", Gfx.TEXT_JUSTIFY_CENTER);


		drawHands(dc, clockTime.hour, clockTime.min, clockTime.sec, Gfx.COLOR_LT_GRAY, Gfx.COLOR_LT_GRAY, Gfx.COLOR_LT_GRAY);


		// Draw the battery icon
		drawBattery(dc, Gfx.COLOR_DK_GRAY);

        // Draw digital time
        //var timeString = Lang.format("$1$:$2$:$3$", [clockTime.hour.format("%2d"), clockTime.min.format("%2d"), clockTime.sec.format("%2d")]);
		var nMin = 1;//clockTime.min;
        var timeString = Lang.format("$1$:$2$", [clockTime.hour.format("%02d"), clockTime.min.format("%02d")]);
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth()/2, dc.getHeight()/5*3, Gfx.FONT_LARGE, timeString, Gfx.TEXT_JUSTIFY_CENTER);

        
        // Draw date
		drawDate(dc, Gfx.COLOR_WHITE);
    }

    //! The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    	showSecond = true;
    	//timer1.stop();
    }

    //! Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    	showSecond = false;
    	requestUpdate();
		//timer1.start(method(:callback1), 1000, true);
    }

    //! Draw the watch hand
    //! @param dc Device Context to Draw
    //! @param angle Angle to draw the watch hand
    //! @param length Length of the watch hand
    //! @param width Width of the watch hand
    function drawHand(dc, angle, length, width, overheadLine, drawCircleOnTop)
    {
        // Map out the coordinates of the watch hand
        var coords = [ 
        	[-(width/2), 0 + overheadLine],
        	[-(width/2), -length],
        	[width/2, -length],
        	[width/2, 0 + overheadLine]
    	];
        var result = new [4];
        var centerX = dc.getWidth() / 2;
        var centerY = dc.getHeight() / 2;
        var cos = Math.cos(angle);
        var sin = Math.sin(angle);

        // Transform the coordinates
        for (var i = 0; i < 4; i += 1)
        {
            var x = (coords[i][0] * cos) - (coords[i][1] * sin);
            var y = (coords[i][0] * sin) + (coords[i][1] * cos);
            result[i] = [ centerX + x, centerY + y];
            if(drawCircleOnTop)
            {
            	if(i == 0)
            	{
	            	var xCircle = ((coords[i][0]+(width/2)) * cos) - ((coords[i][1]) * sin);
	            	var yCircle = ((coords[i][0]+(width/2)) * sin) + ((coords[i][1]) * cos);
					dc.fillCircle(centerX + xCircle, centerY + yCircle, (width/2)-1);
            	}
            	else if(i == 1)
            	{
	            	var xCircle = ((coords[i][0]+(width/2)) * cos) - ((coords[i][1]) * sin);
	            	var yCircle = ((coords[i][0]+(width/2)) * sin) + ((coords[i][1]) * cos);
					dc.fillCircle(centerX + xCircle, centerY + yCircle, (width/2)-1);
            	}
            }
        }

        // Draw the polygon
        dc.fillPolygon(result);
        //dc.fillPolygon(result);
    }

	function drawHands(dc, clock_hour, clock_min, clock_sec, hour_color, min_color, sec_color)
	{
        var hour, min, sec;

		// Draw the hour. Convert it to minutes and
        // compute the angle.
        hour = ( ( ( clock_hour % 12 ) * 60 ) + clock_min );
        hour = hour / (12 * 60.0);
        hour = hour * Math.PI * 2;
        dc.setColor(hour_color, Gfx.COLOR_TRANSPARENT);
        drawHand(dc, hour, 70, 6, 15, true);

        // Draw the minute
        min = ( clock_min / 60.0) * Math.PI * 2;
        dc.setColor(min_color, Gfx.COLOR_TRANSPARENT);
        drawHand(dc, min, 100, 4, 15, true);

        // Draw the seconds
		if(showSecond){
			sec = ( clock_sec / 60.0) *  Math.PI * 2;
        	dc.setColor(sec_color, Gfx.COLOR_TRANSPARENT);
        	drawHand(dc, sec, 105, 2, 15, true);
        }

        // Draw the inner circle
        dc.setColor(Gfx.COLOR_LT_GRAY, background_color);
        dc.fillCircle(dc.getWidth()/2, dc.getHeight()/2, 6);
        dc.setColor(background_color,background_color);
        dc.drawCircle(dc.getWidth()/2, dc.getHeight()/2, 6);
	}

    //! Draw the hash mark symbols on the watch
    //! @param dc Device context
    function drawHashMarks(dc)
    {
        var width, height;
        width = dc.getWidth();
        height = dc.getHeight();

        // Draw the numbers
        dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
        dc.drawText((dc.getWidth()/2), 0, Gfx.FONT_MEDIUM, "12",Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(dc.getWidth(), dc.getHeight()/2, Gfx.FONT_MEDIUM, "3 ", Gfx.TEXT_JUSTIFY_RIGHT + Gfx.TEXT_JUSTIFY_VCENTER);
        dc.drawText(dc.getWidth()/2, dc.getHeight()-30, Gfx.FONT_MEDIUM, "6", Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(0, dc.getHeight()/2, Gfx.FONT_MEDIUM, " 9",Gfx.TEXT_JUSTIFY_LEFT + Gfx.TEXT_JUSTIFY_VCENTER);

		var hashMarks;
		for(var i = 0; i < 60; i += 1)
		{
			if(i != 0 && i != 15 && i != 30 && i != 45)
			{
				if(i % 5 == 0)
				{
					hashMarks = (i / 60.0) * Math.PI * 2;
	    			drawHand(dc, hashMarks, 110, 2, -100, false);
	    		}
	    		else
				{
					hashMarks = (i / 60.0) * Math.PI * 2;
	    			drawHand(dc, hashMarks, 110, 2, -107, false);
				}	    		
	    	}
		}
    }
    
    function drawBattery(dc, primaryColor)
    {
        var width, height;
        width = dc.getWidth();
        height = dc.getHeight();

    	var battery = Sys.getSystemStats().battery;
    	
    	var width_rect = 20;
    	var height_rect = 10;

    	var width_rect_small = 2;
    	var height_rect_small = 5;

    	var x = (dc.getWidth()/2) - (width_rect/2) - (width_rect_small/2);
    	var y = (dc.getHeight()/5*4) - (height_rect/2);

    	var x_small = x + width_rect;
    	var y_small = y + ((height_rect - height_rect_small) / 2);
    	
    	dc.setColor(primaryColor, Gfx.COLOR_TRANSPARENT);
        dc.drawRectangle(x, y, width_rect, height_rect);
        dc.setColor(background_color, Gfx.COLOR_TRANSPARENT);
        dc.drawLine(x_small-1, y_small+1, x_small-1, y_small + height_rect_small-1);

        dc.setColor(primaryColor, Gfx.COLOR_TRANSPARENT);
        dc.drawRectangle(x_small, y_small, width_rect_small, height_rect_small);
        dc.setColor(background_color, Gfx.COLOR_TRANSPARENT);
        dc.drawLine(x_small, y_small+1, x_small, y_small + height_rect_small-1);

        dc.setColor(primaryColor, Gfx.COLOR_TRANSPARENT);
        dc.fillRectangle(x, y, (width_rect*battery/100), height_rect);
        if(battery == 100.0)
        {
        	dc.fillRectangle(x_small, y_small, width_rect_small, height_rect_small);
        }

		//dc.setColor(background_color, Gfx.COLOR_TRANSPARENT);
    	//dc.drawText((dc.getWidth()/2), (dc.getHeight()/5), Gfx.FONT_TINY, Lang.format("$1$", [battery.format("%03d")]), Gfx.TEXT_JUSTIFY_CENTER + Gfx.TEXT_JUSTIFY_VCENTER);
    }

	function drawDate(dc, text_color)
	{
        var now = Time.now();
        var info = Calendar.info(now, Time.FORMAT_LONG);
        //var dateStr = Lang.format("$1$ $2$ $3$", [info.day_of_week, info.month, info.day]);
		var dateStr = Lang.format("$1$ $2$", [info.day_of_week, info.day.format("%02d")]);
        dc.setColor(text_color, Gfx.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 7 * 6, (dc.getHeight() / 2), Gfx.FONT_TINY, dateStr, Gfx.TEXT_JUSTIFY_VCENTER);
	}

    //function callback1()
    //{
    //    showSecond = true;
    //    requestUpdate();
    //}
}