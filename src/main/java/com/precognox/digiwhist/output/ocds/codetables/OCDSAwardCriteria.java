package com.precognox.digiwhist.output.ocds.codetables;

import com.fasterxml.jackson.annotation.JsonValue;

/**
 * OCDS award criteria enumeration.
 *
 * @author Tomas Mrazek
 */
public enum OCDSAwardCriteria {
    /**
     * Price.
     */
    PRICE_ONLY,

    /**
     * Meat.
     */
    RATED_CRITERIA;

    @Override
    @JsonValue
    public String toString() {
        return OCDSEnumUtils.ocdsCodelistJsonValue(this);
    }

}
