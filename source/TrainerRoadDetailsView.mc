import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class TrainerRoadDetailsView extends WatchUi.View {
    private var _descriptionLabel as Text?;
    private var _description as String;

    public function initialize(description as String) {
        _description = description as String;
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        // dc.clear();
        // dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_MEDIUM, _message, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        // dc.drawLine(dc.getWidth() / 2, 0, dc.getWidth() / 2, dc.getHeight());

        _descriptionLabel = View.findDrawableById("DescriptionLabel") as Text;
        _descriptionLabel.setText(_description);

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }
}
