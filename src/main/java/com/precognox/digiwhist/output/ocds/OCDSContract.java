package com.precognox.digiwhist.output.ocds;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.precognox.digiwhist.output.ocds.codetables.OCDSContractStatus;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

/**
 * OCDS contract. This object doesn't cover full OCDS schema.
 * 
 * @see <a href="http://standard.open-contracting.org/1.1/en/schema/release/">OCDS Release Schema</a>
 */
@Getter
@Setter
@JsonInclude(JsonInclude.Include.NON_NULL)
public class OCDSContract extends BaseOCDSDocumentsReferrer<OCDSContract> {

    private String id;

    private String title;

    private String awardId;

    private LocalDateTime signed;

    private OCDSPeriod period;

    private OCDSValue value;

    private OCDSContractStatus status;
    
    private OCDSImplementation implementation;

    /**
     * @return award id
     */
    @JsonProperty("awardID")
    public final String getAwardId() {
        return awardId;
    }

    /**
     * @return date of signing
     */
    @JsonProperty("dateSigned")
    @JsonSerialize(using = OCDSLocalDateTimeSerializer.class)
    public final LocalDateTime getSigned() {
        return signed;
    }


}
