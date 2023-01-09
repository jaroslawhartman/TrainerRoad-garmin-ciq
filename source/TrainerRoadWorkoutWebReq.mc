import Toybox.Application;
import Toybox.Communications;
import Toybox.Lang;

import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;

class TrainerRoadWorkoutWebReq {
    private var _notify as Method(args as Dictionary or String or Null) as Void;
    private var _now as String?;

    //! Set up the callback to the view
    //! @param handler Callback method for when data is received
    public function initialize(handler as Method(args as Dictionary or String or Null) as Void) {
        _notify = handler;
    }

    //! Make the web request
    public function makeRequest(index as Number) as Void {
        var options = {
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON,
            :headers => {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED
            }
        };

        var today = Gregorian.info(Time.now().add(new Time.Duration(3600*24*index)), Time.FORMAT_SHORT);
        var dateString = Lang.format(
            "$1$-$2$-$3$",
            [
                today.month,
                today.day,
                today.year
            ]
        );

        today = Gregorian.info(Time.now().add(new Time.Duration(3600*24*index)), Time.FORMAT_MEDIUM);
        _now = Lang.format(
            "$1$ $2$/$3$",
            [
                today.day_of_week,
                today.day,
                today.month
            ]
        );

        var username = Properties.getValue("username_prop");
        System.println("https://www.trainerroad.com/app/api/calendar/activities/" + username + "?startDate=" + dateString + "&endDate=" + dateString);

        // dateString = "1-21-2023";
        Communications.makeWebRequest(
            // "https://jsonplaceholder.typicode.com/todos/115",
            "https://www.trainerroad.com/app/api/calendar/activities/" + username + "?startDate=" + dateString + "&endDate=" + dateString,
            {},
            options,
            method(:onReceive)
        );
    }

    //! Receive the data from the web request
    //! @param responseCode The server response code
    //! @param data Content from a successful request
    public function onReceive(responseCode as Number, data as Dictionary<String, Object?> or String or Null) as Void {
        (data as Array<Dictionary<String, Object?>>).add({"Now" => _now});
        if (responseCode == 200) {
            _notify.invoke(data);
        } else {
            var response = responseCode.toString();
            // Map 404 to "no user"
            // This happens when username is not set after
            // installation
            if(response.equals("404")) {
                response = "User not set";
            }
            System.println("Error " + response);
            _notify.invoke({"Error" => "Err: " + response});
        }
    }
}