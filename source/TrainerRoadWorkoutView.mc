import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

//! Create the Images custom menu
function pushTrainerRoadWorkoutView() as Void {
    WatchUi.pushView(getApp()._view, getApp()._delegate, WatchUi.SLIDE_RIGHT);
}

class TrainerRoadWorkoutView extends WatchUi.View {
    public var description as String = "";
    public var _workout = {};
    public var initial as Boolean = true;

    private var _webReq as TrainerRoadWorkoutWebReq?;
    private var _index as Number;
    private var _prevIndex as Number? = null;

    const FIELDS as Array<String> = [ "Name", "Now", "Activity", "Kj", "WorkoutDescription", "Duration", "TSS", "Progression", "Text", "ProgressionLevel", "Duration", "CompletedRide", "PicUrl", "Error" ];

    public function initialize(index as Number) {
        View.initialize();
        _index = index;
        _webReq = new $.TrainerRoadWorkoutWebReq(self.method(:onReceive));
    }

    public function webReq(index as Number) as Void {
        var icon = View.findDrawableById("icon") as Bitmap;

        if(index == _prevIndex) {
            return;
        }

        _index = index;
        _prevIndex = index;
        icon.setBitmap(Rez.Drawables.LoadingIcon);
        WatchUi.requestUpdate();
        _webReq.makeRequest(_index);
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));

        _workout = loadWorkout();
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        webReq(_index);
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        // dc.clear();
        // dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_MEDIUM, _message, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        // dc.drawLine(dc.getWidth() / 2, 0, dc.getWidth() / 2, dc.getHeight());

        renderDictionary(_workout);

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
        dc.drawLine(dc.getWidth()/2, dc.getHeight()*0.33, dc.getWidth()/2, dc.getHeight()*0.81);

        if(! initial) {
            dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLACK);
            dc.fillCircle(dc.getWidth()/2+9, dc.getWidth()-6, 2);
            dc.fillCircle(dc.getWidth()/2-1, dc.getWidth()-6, 2);
            dc.fillCircle(dc.getWidth()/2-10, dc.getWidth()-6, 2);
        }
    }

    // // Called when this View is removed from the screen. Save the
    // // state of this View here. This includes freeing resources from
    // // memory.
    // function onHide() as Void {
    //     saveWorkout(_workout);
    // }

    private function saveWorkout(workout as Dictionary) {
        Storage.setValue("Workout", workout);
    }

    private function loadWorkout() as Dictionary {
        var workout = Storage.getValue("Workout") as Dictionary;
        if(workout != null) {
            workout.remove("Error");
            return workout;
        } else {
            return _workout;
        }
    }

    private function secToHMS(val as Number) as String {
        var H = val / 3600;
        var M = val % 3600 / 60;
        var S = val % 60;

        // $1$ is $H
        // $2$ is $M
        // $3$ is $S

        // // if you want T: $H:$M:$S..
        // fmt = "T: $1$:$2$:$3$";

        // // if you want $S
        // fmt = "T: $3$";

        // if you want $H:$M
        var fmt = "$1$:$2$";

        var s = Lang.format(fmt, [ H, M.format("%02d"), S.format("%02d") ]);

        return(s);
    }

    private function stringReplace(str, oldString, newString)
    {
        var result = str;

        while (true)
        {
            var index = result.find(oldString);

            if (index != null)
            {
                var index2 = index+oldString.length();
                result = result.substring(0, index) + newString + result.substring(index2, result.length());
            }
            else
            {
                return result;
            }
        }

        return null;
    }

    // Remove HTML tags
    // Remove &nbsp;
    private function cleanupString(text as String) as String {
        var result = "";
        var remove = false;

        for(var i = 0; i<text.length(); i++) {
            var character = text.substring(i, i+1);
            if(character.equals("<")) {
                remove = true;
                continue;
            } else if (character.equals(">")) {
                remove = false;
                continue;
            }

            if(!remove) {
                result += character;
            }
        }

        result = stringReplace(result, "&nbsp;", "");
        result = stringReplace(result, "&amp;", "&");

        return result;
    }

    private function setLabel(key as String, value as String or Number or Null) as Void {
        if(value == null) {
            value ="...";
        } else {
            if(key.equals("WorkoutDescription")) {
                description = cleanupString(value);
                return;
            }

            if(key.equals("Duration")) {
                value = secToHMS(value);
            }

            if(key.equals("TSS")) {
                value = Lang.format("$1$", [value.format("%d")]);
            }

            if(key.equals("ProgressionLevel")) {
                value = Lang.format("$1$", [value.format("%.2f")]);
            }
        }

        var _label = View.findDrawableById(key + "Label") as Text;
        if(_label instanceof Text) {
            _label.setText(Lang.format("$1$", [value]));
        }
    }

    // cleanup - delete all labels
    private function renderDictionary(workout as Dictionary) as Void {
        var keys = workout.keys() as Array<String>;

        if(keys.indexOf("Cleanup") != -1) {
            for(var i=0; i<FIELDS.size(); i++) {
                setLabel(FIELDS[i], null);
            }
        }

        // Cleanup Error (if not present)
        if(keys.indexOf("Error") == -1) {
            setLabel("Error", "");
        }

        for (var i = 0; i < keys.size(); i++) {
            var key = keys[i];
            var value = workout[key];
            setLabel(key, value);
        }
    }

    private function extractWorkoutParameters(workout as Dictionary) as Void {
        var keys = workout.keys() as Array<String>;

        // Cleanup the error (will be re-populated if needed)
        _workout.remove("Error");

        for (var i = 0; i < keys.size(); i++) {
            if(FIELDS.indexOf(keys[i]) >= 0) {
                var key = keys[i];
                var value = workout[key];
                switch(value)
                {
                    case instanceof String:
                    case instanceof Number:
                    case instanceof Float:
                        _workout.put(key, value);
                        break;
                    case instanceof Dictionary:
                        extractWorkoutParameters(value);
                        break;
                }
            }
        }
    }

    //! Show the result or status of the web request
    //! @param args Data from the web request, or error message
    public function onReceive(args as Dictionary or String or Null) as Void {
        var icon = View.findDrawableById("icon") as Bitmap;
        icon.setBitmap(Rez.Drawables.LauncherIcon);

        if (args instanceof String) {
            System.println("onReceived -- String: " + args);
        } else if (args instanceof Dictionary) {
            System.println("onReceived -- Dictionary");
            extractWorkoutParameters(args);
        } else if (args instanceof Array) {
            System.println("onReceived -- Array");
            var workouts = args as Array<Dictionary>;
            if(workouts.size() == 1) {
                System.println("No workouts");
                _workout = {
                    "Name" => "No workout!",
                    "Error" => "",
                    "Cleanup" => "y",
                    "Now" => workouts[0].get("Now")
                };

                description = "";
            }
            else {
                for (var i = 0; i<workouts.size(); i++) {
                    extractWorkoutParameters(workouts[i]);
                }
            }
        }
        saveWorkout(_workout);
        WatchUi.requestUpdate();
    }

}
