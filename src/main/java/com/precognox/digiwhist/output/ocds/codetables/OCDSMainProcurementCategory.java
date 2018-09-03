package com.precognox.digiwhist.output.ocds.codetables;

import com.fasterxml.jackson.annotation.JsonValue;

/**
 * OCDS supply type enumeration.
 *
 * @author Tomas Mrazek
 */
public enum OCDSMainProcurementCategory {
    /**
     * Works.
     */
    WORKS,
    /**
     * Goods.
     */
    GOODS,
    /**
     * Services.
     */
    SERVICES;

    public static OCDSMainProcurementCategory convertFromMexico(String text) {
        if ("Obra Pública".equals(text)) {
            return WORKS;
        }

        if ("Adquisiciones".equals(text)) {
            return GOODS;
        }

        if ("Servicios".equals(text)) {
            return SERVICES;
        }

        return null;
    }


    @Override
    @JsonValue
    public String toString() {
        return OCDSEnumUtils.ocdsCodelistJsonValue(this);
    }
}
