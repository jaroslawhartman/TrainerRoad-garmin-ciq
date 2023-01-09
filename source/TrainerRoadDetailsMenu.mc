
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

//! Create the Images custom menu
function pushTrainerRoadDetailsMenu(name as String, description as String) as Void {
    var customMenu = new $.TrainerRoadDetailsMenu(name, 450, Graphics.COLOR_BLACK);
    customMenu.addItem(new $.TrainerRoadDetailsMenuItem(:description, description));
    WatchUi.pushView(customMenu, new $.TrainerRoadDetailsMenuDelegate(), WatchUi.SLIDE_RIGHT);
}

//! This is the Images custom menu, which shows an
//! image and text for each item
class TrainerRoadDetailsMenu extends WatchUi.CustomMenu {
    private var _name as String;
    private var _icon as BitmapResource;
    private var _iconOffset as Number;

    //! Constructor
    //! @param itemHeight The pixel height of menu items rendered by this menu
    //! @param backgroundColor The color for the menu background
    public function initialize(name as String, itemHeight as Number, backgroundColor as ColorType) {
        _name = name;
        _icon = WatchUi.loadResource($.Rez.Drawables.LauncherIcon) as BitmapResource;
        _iconOffset = -1 - _icon.getWidth() / 2;
        CustomMenu.initialize(itemHeight, backgroundColor, {:titleItemHeight => 150});
    }

    //! Draw the menu title
    //! @param dc Device Context
    public function drawTitle(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_DK_GRAY);
        dc.setPenWidth(3);
        dc.drawLine(0, dc.getHeight() - 4, dc.getWidth(), dc.getHeight() - 4);
        dc.setPenWidth(1);
        // dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawBitmap(dc.getWidth() / 2+_iconOffset, 20, _icon);
        // dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_MEDIUM, _name, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }
}

//! This is the menu input delegate for the images custom menu
class TrainerRoadDetailsMenuDelegate extends WatchUi.Menu2InputDelegate {

    //! Constructor
    public function initialize() {
        Menu2InputDelegate.initialize();
    }

    //! Handle an item being selected
    //! @param item The selected menu item
    public function onSelect(item as MenuItem) as Void {
        WatchUi.requestUpdate();
    }

    //! Handle the back key being pressed
    public function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }
}

//! This is the custom item drawable.
//! It draws the item's bitmap and label.
class TrainerRoadDetailsMenuItem extends WatchUi.CustomMenuItem {
    private var _description as String?;


    //! Constructor
    //! @param id The identifier for this item
    //! @param label Text to display
    //! @param bitmap Color of the text
    public function initialize(id as Symbol, description as String) {
        CustomMenuItem.initialize(id, {});
        _description = description;
    }

    private function wrapText(dc as Dc, text as String) as Array<Graphics.FontDefinition or String> {
        var fonts = [
            // Graphics.FONT_LARGE,
            Graphics.FONT_MEDIUM,
            Graphics.FONT_SMALL,
            Graphics.FONT_TINY,
            // Graphics.FONT_XTINY
         ] as Array<Graphics.FontDefinition>;

        var result;

         // Iterate through the list of fonts
         // to check if fitTextToArea is not null
         // i.e. the text does not need to be truncated
        for(var i=0; i<fonts.size(); i++) {
            result = Graphics.fitTextToArea(_description, fonts[i], dc.getWidth()-15, dc.getHeight()-20, false);

            if(result != null) {
                return[fonts[i], result];
            }
        }
        result = Graphics.fitTextToArea(_description, Graphics.FONT_TINY, dc.getWidth()-15, dc.getHeight()-20, true);

        return[Graphics.FONT_TINY, result];
    }

    //! Draw the item's label and bitmap
    //! @param dc Device context
    public function draw(dc as Dc) as Void {
        // formattedDescription[0] - font
        // formattedDescription[1] - text
        var formattedDescription = wrapText(dc, _description);

        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2,
                    0,
                    formattedDescription[0],
                    formattedDescription[1],
                    Graphics.TEXT_JUSTIFY_CENTER);
    }
}
