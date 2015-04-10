using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Math as Math;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Calendar;
using Toybox.WatchUi as Ui;
using Toybox.Application as App;

class AnalogDigitalView extends Ui.WatchFace {
	//var timer1;
	var showSecond = true;

    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    	//timer1 = new Timer.Timer();
    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
        var clockTime = Sys.getClockTime();
        var width, height;
        var screenWidth = dc.getWidth();
        var hour;
        var min;
        var sec;

        width = dc.getWidth();
        height = dc.getHeight();

        var now = Time.now();
        var info = Calendar.info(now, Time.FORMAT_LONG);

        //var dateStr = Lang.format("$1$ $2$ $3$", [info.day_of_week, info.month, info.day]);
		var dateStr = Lang.format("$1$ $2$", [info.day_of_week, info.day.format("%02d")]);

        // Clear the screen
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
        dc.fillRectangle(0,0,dc.getWidth(), dc.getHeight());
        // Draw the gray rectangle
        //dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_DK_GRAY);
        //dc.fillPolygon([[0,0],[dc.getWidth(), 0],[dc.getWidth(), dc.getHeight()],[0,0]]);

        // Draw the numbers
        dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
        dc.drawText((width/2), 0, Gfx.FONT_MEDIUM, "12",Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(width, height/2, Gfx.FONT_MEDIUM, "3", Gfx.TEXT_JUSTIFY_RIGHT + Gfx.TEXT_JUSTIFY_VCENTER);
        dc.drawText(width/2, height-30, Gfx.FONT_MEDIUM, "6", Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(0, height/2, Gfx.FONT_MEDIUM, "9",Gfx.TEXT_JUSTIFY_LEFT + Gfx.TEXT_JUSTIFY_VCENTER);

        // Draw the hash marks
		dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
        drawHashMarks(dc);

        // Draw the logo
        dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
        dc.drawText(width/2, height/4, Gfx.FONT_LARGE, "SwimBikeRun", Gfx.TEXT_JUSTIFY_CENTER);

		
		dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
        // Draw the hour. Convert it to minutes and
        // compute the angle.
        hour = ( ( ( clockTime.hour % 12 ) * 60 ) + clockTime.min );
        hour = hour / (12 * 60.0);
        hour = hour * Math.PI * 2;
        drawHand(dc, hour, 70, 5, 15);

        // Draw the minute
        min = ( clockTime.min / 60.0) * Math.PI * 2;
        drawHand(dc, min, 95, 4, 15);

        // Draw the seconds
		if(showSecond){
			dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
        	sec = ( clockTime.sec / 60.0) *  Math.PI * 2;
        	drawHand(dc, sec, 105, 2, 15);
        }

        // Draw the inner circle
        dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_BLACK);
        dc.fillCircle(width/2, height/2, 7);
        dc.setColor(Gfx.COLOR_BLACK,Gfx.COLOR_BLACK);
        dc.drawCircle(width/2, height/2, 7);


        // Draw digital time
        //var timeString = Lang.format("$1$:$2$:$3$", [clockTime.hour.format("%2d"), clockTime.min.format("%2d"), clockTime.sec.format("%2d")]);
		var nMin = 1;//clockTime.min;
        var timeString = Lang.format("$1$:$2$", [clockTime.hour.format("%02d"), clockTime.min.format("%02d")]);
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(width/2, height/5*3, Gfx.FONT_LARGE, timeString, Gfx.TEXT_JUSTIFY_CENTER);

        
        // Draw date
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(width / 6 * 5, (height / 2), Gfx.FONT_TINY, dateStr, Gfx.TEXT_JUSTIFY_VCENTER);
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
    function drawHand(dc, angle, length, width, overheadLine)
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
            result[i] = [ centerX+x, centerY+y];
        }

        // Draw the polygon
        dc.fillPolygon(result);
        //dc.fillPolygon(result);
    }

    //! Draw the hash mark symbols on the watch
    //! @param dc Device context
    function drawHashMarks(dc)
    {
		var hashMarks;
		for(var i = 0; i < 60; i += 5)
		{
			if(i != 0 && i != 15 && i != 30 && i != 45)
			{
				hashMarks = (i / 60.0) * Math.PI * 2;
	    		drawHand(dc, hashMarks, 110, 2, -100);
	    	}
		}
    }

    //function callback1()
    //{
    //    showSecond = true;
    //    requestUpdate();
    //}
}