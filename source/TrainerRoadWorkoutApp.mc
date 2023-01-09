import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class TrainerRoadWorkoutApp extends Application.AppBase {
    public var _view as TrainerRoadWorkoutView?;
    public var _delegate as TrainerRoadWorkoutDelegate?;

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        _view = new $.TrainerRoadWorkoutView(0);
        _delegate = new $.TrainerRoadWorkoutDelegate(0, _view);

        return [_view, _delegate] as Array<Views or InputDelegates>;
    }

    function onSettingsChanged() {
        // WatchUi.requestUpdate();
        _view.webReq(0);
    }
}

function getApp() as TrainerRoadWorkoutApp {
    return Application.getApp() as TrainerRoadWorkoutApp;
}