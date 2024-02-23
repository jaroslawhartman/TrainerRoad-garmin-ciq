import Toybox.Lang;
import Toybox.WatchUi;

//! Input handler for the main primate views
class TrainerRoadWorkoutDelegate extends WatchUi.BehaviorDelegate {
    private var _index as Number;
    private var _view as TrainerRoadWorkoutView;
    // private const NUM_PAGES = 3;

    //! Constructor
    //! @param index The current page index
    public function initialize(index as Number, view as TrainerRoadWorkoutView) {
        BehaviorDelegate.initialize();
        _index = index;
        _view = view;
    }

    //! Handle going to the next view
    //! @return true if handled, false otherwise
    public function onNextPage() as Boolean {
        _index++;
        _view.webReq(_index);
        return true;
    }

    //! Handle going to the previous view
    //! @return true if handled, false otherwise
    public function onPreviousPage() as Boolean {
        _index--;
        _view.webReq(_index);
        return true;
    }

    //! On select behavior show the detail view
    //! @return true if handled, false otherwise
    public function onSelect() as Boolean {
        if(_view.initial) {
            _view.initial = false;
            $.pushTrainerRoadWorkoutView();
        } else {
            if(! _view.description.equals("")) {
                // var view = new $.TrainerRoadDetailsView("xxx");
                // WatchUi.pushView(view, new $.TrainerRoadDetailsMenuDelegate(), WatchUi.SLIDE_RIGHT);
                $.pushTrainerRoadDetailsMenu("Workout", _view.description);
                return false;
            }
        }

        return true;
    }

    //! Handle going back
    //! @return true if handled, false otherwise
    public function onBack() as Boolean {
        if(! _view.initial) {
            _view.initial = true;
        }

        return false;
    }
}
