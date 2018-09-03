package com.precognox.digiwhist.output.ocds;


import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.precognox.digiwhist.output.ocds.codetables.OCDSInitiationType;
import com.precognox.digiwhist.output.ocds.codetables.OCDSReleaseTag;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * OCDS release. This object doesn't cover full OCDS schema.
 * 
 * @see <a href="http://standard.open-contracting.org/1.1/en/schema/release/">OCDS Release Schema</a>
 */

@Getter
@Setter
@JsonInclude(JsonInclude.Include.NON_NULL)
public class OCDSRelease {

    private String ocid;

    private String id;

    private LocalDateTime date;

    private List<OCDSReleaseTag> tags = new ArrayList<>();

    private OCDSInitiationType initiationType;

    private String language;

    private OCDSOrganizationReference buyer;

    private List<OCDSOrganization> parties = new ArrayList<>();

    private OCDSTender tender;
    
    private List<OCDSAward> awards = new ArrayList<>();
    
    private List<OCDSContract> contracts = new ArrayList<>();

    private OCDSBid bids;

    private OCDSPlanning planning;


    /**
     * @return date
     */
    @JsonSerialize(using = OCDSLocalDateTimeSerializer.class)
    public final LocalDateTime getDate() {
        return date;
    }

    /**
     * @return list of tags
     */
    @JsonProperty("tag")
    public final List<OCDSReleaseTag> getTags() {
        return tags;
    }


}
