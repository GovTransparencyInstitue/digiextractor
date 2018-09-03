package com.precognox.digiwhist.output.ocds.codetables;

import com.fasterxml.jackson.annotation.JsonValue;

import java.util.ArrayList;

/**
 * OCDS codelist for tender/additionalProcurementCategories
 *
 */
public enum OCDSAdditionalProcurementCategories {

    /**
     * Services related to work
     */
    SERVICES_RELATED_TO_WORK,

    /**
     * Leasing
     */
    LEASING;

    public static String convertFromMexico(String text) {
        if ("Servicios Relacionados con la".equals(text)) {
            return "SERVICES_RELATED_TO_WORK";
        }

        if ("Arrendamientos".equals(text)) {
            return "LEASING";
        }

        return null;
    }

    @Override
    @JsonValue
    public String toString() {
        return OCDSEnumUtils.ocdsCodelistJsonValue(this);
    }
}
