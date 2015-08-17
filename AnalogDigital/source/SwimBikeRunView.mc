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
	var width_screen, height_screen;

	var hashMarksArray = new [60];

	var batt_width_rect = 20;
	var batt_height_rect = 10;
	var batt_width_rect_small = 2;
	var batt_height_rect_small = 5;
	var batt_x, batt_y, batt_x_small, batt_y_small;

    //! Load your resources here
    function onLayout(dc) {
    	//get screen dimensions
		width_screen = dc.getWidth();
		height_screen = dc.getHeight();

		//get hash marks position
		for(var i = 0; i < 60; i+=1)
		{
			hashMarksArray[i] = new [2];
			if(i != 0 && i != 15 && i != 30 && i != 45)
			{
				hashMarksArray[i][0] = (i / 60.0) * Math.PI * 2;
				if(i % 5 == 0)
				{
					hashMarksArray[i][1] = -100;
	    			//drawHand(dc, hashMarksArray[i][0], 110, 2, hashMarksArray[i][1], false);
	    		}
	    		else
				{
					hashMarksArray[i][1] = -108;
	    			//drawHand(dc, hashMarksArray[i][0], 110, 2, hashMarksArray[i][1], false);
				}
	    	}
		}

		//get battery icon position
		batt_x = (width_screen / 7 * 2) - (batt_width_rect/2) - (batt_width_rect_small/2);
		batt_y = (height_screen / 2) - (batt_height_rect/2);
		batt_x_small = batt_x + batt_width_rect;
		batt_y_small = batt_y + ((batt_height_rect - batt_height_rect_small) / 2);

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
        dc.fillRectangle(0,0, width_screen, height_screen);
        // Draw the gray rectangle
        //dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_DK_GRAY);
        //dc.fillPolygon([[0,0],[width_screen, 0],[width_screen, height_screen],[0,0]]);


        // Draw the hash marks
		dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
        drawHashMarks(dc);


		// Draw analog time
		drawHands(dc, clockTime.hour, clockTime.min, clockTime.sec, Gfx.COLOR_LT_GRAY, Gfx.COLOR_LT_GRAY, Gfx.COLOR_LT_GRAY);


        // Draw the logo
        dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
        dc.drawText(width_screen/2, height_screen/6, Gfx.FONT_SMALL, "Keep Calm and", Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(width_screen/2, height_screen/4, Gfx.FONT_LARGE, "TRIATHLON", Gfx.TEXT_JUSTIFY_CENTER);
        //dc.drawText(width_screen/2, height_screen/4, Gfx.FONT_LARGE, "SwimBikeRun", Gfx.TEXT_JUSTIFY_CENTER);
        //dc.drawText(width_screen/2, height_screen/6, Gfx.FONT_LARGE, "IRONMAN", Gfx.TEXT_JUSTIFY_CENTER);
        //dc.drawText(width_screen/2, height_screen/7*2, Gfx.FONT_MEDIUM, "Swim Bike Run", Gfx.TEXT_JUSTIFY_CENTER);
        //dc.setColor(Gfx.COLOR_DK_BLUE, Gfx.COLOR_TRANSPARENT);
        //dc.drawText(width_screen/4, height_screen/7*2, Gfx.FONT_LARGE, "Swim", Gfx.TEXT_JUSTIFY_CENTER);
        //dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        //dc.drawText(width_screen/2 + 10, height_screen/7*2, Gfx.FONT_LARGE, "Bike", Gfx.TEXT_JUSTIFY_CENTER);
        //dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
        //dc.drawText(width_screen/4*3 + 10, height_screen/7*2, Gfx.FONT_LARGE, "Run", Gfx.TEXT_JUSTIFY_CENTER);


		// Draw the battery icon
		drawBattery(dc, Gfx.COLOR_DK_GRAY, Gfx.COLOR_DK_RED, Gfx.COLOR_DK_GREEN);
		
        // Draw digital time
		drawDigitalTime(dc, Gfx.COLOR_WHITE, clockTime);

        // Draw date
		drawDate(dc, Gfx.COLOR_WHITE);
    }

    //! The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    	showSecond = true;
    }

    //! Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    	showSecond = false;
    	requestUpdate();
    }
    
    function drawDigitalTime(dc, text_color, clockTime)
    {
        //var timeString = Lang.format("$1$:$2$:$3$", [clockTime.hour.format("%2d"), clockTime.min.format("%2d"), clockTime.sec.format("%2d")]);
        var timeString = Lang.format("$1$:$2$", [clockTime.hour.format("%02d"), clockTime.min.format("%02d")]);
        dc.setColor(text_color, Gfx.COLOR_TRANSPARENT);
        dc.drawText(width_screen/2, height_screen/6*3, Gfx.FONT_NUMBER_HOT, timeString, Gfx.TEXT_JUSTIFY_CENTER);
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
        var centerX = width_screen / 2;
        var centerY = height_screen / 2;
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
        dc.fillCircle(width_screen/2, height_screen/2, 6);
        dc.setColor(background_color,background_color);
        dc.drawCircle(width_screen/2, height_screen/2, 6);
	}


    //! Draw the hash mark symbols on the watch
    //! @param dc Device context
    function drawHashMarks(dc)
    {
        // Draw the numbers
        dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
        dc.drawText((width_screen/2), 0, Gfx.FONT_MEDIUM, "12",Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(width_screen, height_screen/2, Gfx.FONT_MEDIUM, "3 ", Gfx.TEXT_JUSTIFY_RIGHT + Gfx.TEXT_JUSTIFY_VCENTER);
        dc.drawText(width_screen/2, height_screen-30, Gfx.FONT_MEDIUM, "6", Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(0, height_screen/2, Gfx.FONT_MEDIUM, " 9",Gfx.TEXT_JUSTIFY_LEFT + Gfx.TEXT_JUSTIFY_VCENTER);

		//for(var i = 0; i < 60; i += 1)
		for(var i = 0; i < 60; i += 5)
		{
			if(i != 0 && i != 15 && i != 30 && i != 45)
			{
				//if(i % 5 == 0)
				//{
	    			drawHand(dc, hashMarksArray[i][0], 110, 2, hashMarksArray[i][1], false);
	    		//}
	    		//else
				//{
	    		//	drawHand(dc, hashMarksArray[i][0], 110, 2, hashMarksArray[i][1], false);
				//}
	    	}
		}
    }
    
    function drawBattery(dc, primaryColor, lowBatteryColor, fullBatteryColor)
    {
    	var battery = Sys.getSystemStats().battery;
    	
    	if(battery < 15.0)
    	{
    		primaryColor = lowBatteryColor;
    	}
    	//else if(battery == 100.0)
    	//{
    	//	primaryColor = fullBatteryColor;
    	//}

    	dc.setColor(primaryColor, Gfx.COLOR_TRANSPARENT);
        dc.drawRectangle(batt_x, batt_y, batt_width_rect, batt_height_rect);
        dc.setColor(background_color, Gfx.COLOR_TRANSPARENT);
        dc.drawLine(batt_x_small-1, batt_y_small+1, batt_x_small-1, batt_y_small + batt_height_rect_small-1);

        dc.setColor(primaryColor, Gfx.COLOR_TRANSPARENT);
        dc.drawRectangle(batt_x_small, batt_y_small, batt_width_rect_small, batt_height_rect_small);
        dc.setColor(background_color, Gfx.COLOR_TRANSPARENT);
        dc.drawLine(batt_x_small, batt_y_small+1, batt_x_small, batt_y_small + batt_height_rect_small-1);

        dc.setColor(primaryColor, Gfx.COLOR_TRANSPARENT);
        dc.fillRectangle(batt_x, batt_y, (batt_width_rect * battery / 100), batt_height_rect);
        if(battery == 100.0)
        {
        	dc.fillRectangle(batt_x_small, batt_y_small, batt_width_rect_small, batt_height_rect_small);
        }
    }

	function drawDate(dc, text_color)
	{
        var now = Time.now();
        var info = Calendar.info(now, Time.FORMAT_LONG);
        //var dateStr = Lang.format("$1$ $2$ $3$", [info.day_of_week, info.month, info.day]);
		var dateStr = Lang.format("$1$ $2$", [info.day_of_week, info.day.format("%02d")]);
        dc.setColor(text_color, Gfx.COLOR_TRANSPARENT);
        dc.drawText(width_screen / 7 * 6, (height_screen / 2), Gfx.FONT_TINY, dateStr, Gfx.TEXT_JUSTIFY_VCENTER);
	}
}