package com.precognox.digiwhist.output.ocds;


import com.fasterxml.jackson.annotation.JsonInclude;
import com.precognox.digiwhist.output.ocds.codetables.*;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

/**
 * OCDS tender. This object doesn't cover full OCDS schema.
 * 
 * @see <a href="http://standard.open-contracting.org/1.1/en/schema/release/">OCDS Release Schema</a>
 */
@Getter
@Setter
@JsonInclude(JsonInclude.Include.NON_NULL)
public class OCDSTender extends BaseOCDSDocumentsReferrer<OCDSTender> {

    private String id;

    private String title;

    private String description;

    private OCDSValue value;

    private OCDSValue minValue;
    
    private OCDSTenderStatus status;

    /**
     * tender/procedureType mapped to OCDS codelist.
     */
    private OCDSProcedureMethod procurementMethod;
    
    private String procurementMethodDetails;

    private String procurementMethodRationale;

    /**
     * tender/supplyType mapped to OCDS codelist.
     */
    private OCDSMainProcurementCategory mainProcurementCategory;

    /**
     * tender/additionalProcurementCategory mapped to OCDS
     */
    private List<String> additionalProcurementCategories;

    /**
     * tender/selectionMethod mapped to OCDS codelist.
     */
    private OCDSAwardCriteria awardCriteria;
    
    private String awardCriteriaDetails;

    /**
     * if tender/isElectronicAuction then "electronicAuction" codelist value.
     */
    private List<OCDSSubmissionMethod> submissionMethod;

    private String submissionMethodDetails;
    
    private String eligibilityCriteria;

    private OCDSPeriod tenderPeriod;

    private OCDSPeriod awardPeriod;

    private OCDSPeriod contractPeriod;

    private OCDSPeriod enquiryPeriod;

    private OCDSOrganizationReference procuringEntity;

    private Integer numberOfTenderers;

    private List<OCDSItem> items = new ArrayList<>();

    private List<OCDSLot> lots = new ArrayList<>();

    /**
     * Adds item. List is created if needed.
     *
     * @param item
     *      item to be added
     * @return this instance for chaining
     */
    public final OCDSTender addItem(final OCDSItem item) {
        if (item != null) {
            if (this.items == null) {
                this.items = new ArrayList<>();
            }

            this.items.add(item);
        }

        return this;
    }

    /**
     * Adds items. List is created if needed.
     *
     * @param newItems
     *      list of items to be added
     * @return this instance for chaining
     */
    public final OCDSTender addItems(final List<OCDSItem> newItems) {
        if (newItems != null) {
            if (this.items == null) {
                this.items = new ArrayList<>();
            }

            this.items.addAll(newItems);
        }

        return this;
    }
    
    public final OCDSTender addAdditionalProcurementCategory(final String newItem) {
        if (newItem != null) {
            if (this.additionalProcurementCategories == null) {
                this.additionalProcurementCategories = new ArrayList<>();
            }

            this.additionalProcurementCategories.add(newItem);
        }

        return this;
    }

    /**
     * Adds lot. List is created if needed.
     *
     * @param lot
     *      lot to be added
     * @return this instance for chaining
     */
    public final OCDSTender addLot(final OCDSLot lot) {
        if (lot != null) {
            if (this.lots == null) {
                this.lots = new ArrayList<>();
            }

            this.lots.add(lot);
        }

        return this;
    }


    /**
     * Adds submission method. List is created if needed.
     *
     * @param method
     *      method to be added
     * @return this instance for chaining
     */
    public final OCDSTender addSubmissionMethod(final OCDSSubmissionMethod method) {
        if (method != null) {
            if (this.submissionMethod == null) {
                this.submissionMethod = new ArrayList<>();
            }

            this.submissionMethod.add(method);
        }

        return this;
    }
}
