package com.precognox.digiwhist.output.ocds;

import com.fasterxml.jackson.annotation.JsonInclude;

import java.util.ArrayList;
import java.util.List;

/**
 * Base class for OCDS entities that refers to list of lots.
 *
 * @param <T>
 *      class of underlying object
 * @author Tomas Mrazek
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
public abstract class BaseOCDSLotsAndDocumentsReferrer<T> extends BaseOCDSDocumentsReferrer<T> {
    private List<String> relatedLots;
    
    /**
     * @return list of related lots
     */
    public final List<String> getRelatedLots() {
        return relatedLots;
    }

    /**
     * @param newRelatedLots
     *      list of related lots to be set
     * @return this instance for chaining
     */
    public final T setRelatedLots(final List<String> newRelatedLots) {
        this.relatedLots = newRelatedLots;
        return (T) this;
    }

    /**
     * Adds related lot. List is created if needed.
     *
     * @param relatedLot
     *      related lot to be added
     * @return this instance for chaining
     */
    public final T addRelatedLot(final String relatedLot) {
        if (relatedLot != null) {
            if (this.relatedLots == null) {
                this.relatedLots = new ArrayList<>();
            }

            this.relatedLots.add(relatedLot);
        }

        return (T) this;
    }
}
