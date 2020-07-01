package utils;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;

public class DateChecker {

    /*
    Simple function to check both format and validity of the provided date (so if 'date' represents a real date - eg. 2020.13.45 not allowed).
     */
    public static boolean isDateInValidFormat(String date, String format) {
        try {
            DateFormat df = new SimpleDateFormat(format);
            df.setLenient(false);
            df.parse(date);
            return true;
        } catch (ParseException e) {
            //no need to handle, information about validity (true/false) will suffice
            return false;
        }
    }
}
