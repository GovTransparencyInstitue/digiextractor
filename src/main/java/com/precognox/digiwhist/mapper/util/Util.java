package com.precognox.digiwhist.mapper.util;

import lombok.extern.slf4j.Slf4j;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Slf4j
public class Util {

    private static final DateTimeFormatter formatter2 = DateTimeFormatter.ofPattern("M/dd/yyyy HH:mm");
    private static final DateTimeFormatter formatter4 = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    private static final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
    private static final DateTimeFormatter formatter3 = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");



    public static LocalDateTime parseDate(String text) {
        LocalDateTime result = null;
        DateTimeFormatter myFormatter = formatter;
        if (text!=null) {
            try {
                result = LocalDateTime.parse(text, formatter);
            } catch (java.time.format.DateTimeParseException ex) {
                Pattern p = Pattern.compile("\\d{4}-\\d{2}-\\d{2}");
                Pattern pgmt = Pattern.compile("\\d{4}-\\d{2}-\\d{2}.* GMT");
                Pattern p2 = Pattern.compile("\\d{1,2}\\/\\d{2}\\/\\d{4} \\d{2}[:]\\d{2}");
                Pattern p3 = Pattern.compile("\\d{2}\\/\\d{2}\\/\\d{4}");
                Matcher m = p.matcher(text);
                Matcher m2 = p2.matcher(text);
                Matcher m3 = p3.matcher(text);
                Matcher mgmt = pgmt.matcher(text);
                if (m.matches()) {
                    text = text + " 00:00";
                } else {
                    if (mgmt.matches()) {
                        text = text.replaceAll("GMT", "").trim();
                        myFormatter = formatter3;
                    } else {
                        if (m2.matches()) {
                            myFormatter = formatter2;
                        } else {
                            if (m3.matches()) {
                                text = text + " 00:00";
                                myFormatter = formatter4;
                            }
                        }
                    }
                }
                try {
                    result = LocalDateTime.parse(text, myFormatter);
                } catch (java.time.format.DateTimeParseException ex2) {
                    log.warn("the date parsing failed for {}", text);
                }
            }
        }
        return result;
    }
}
