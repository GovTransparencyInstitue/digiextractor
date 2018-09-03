package com.precognox.digiwhist.output.ocds;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import java.time.LocalDateTime;

/**
 * OCDS period. This object doesn't cover full OCDS schema.
 * 
 * @see <a href="http://standard.open-contracting.org/1.1/en/schema/release/">OCDS Release Schema</a>
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
public class OCDSPeriod {

    private LocalDateTime startDate;

    private LocalDateTime endDate;

    private LocalDateTime maxExtentDate;
    
    private Integer durationInDays;

    /**
     * @return start date
     */
    @JsonSerialize(using = OCDSLocalDateTimeSerializer.class)
    public final LocalDateTime getStartDate() {
        return startDate;
    }

    /**
     * @param startDate
     *      start date to be set
     * @return this instance for chaining
     */
    public final OCDSPeriod setStartDate(final LocalDateTime startDate) {
        this.startDate = startDate;
        return this;
    }

    /**
     * @return end date
     */
    @JsonSerialize(using = OCDSLocalDateTimeSerializer.class)
    public final LocalDateTime getEndDate() {
        return endDate;
    }

    /**
     * @param endDate
     *      end date to be set
     * @return this instance for chaining
     */
    public final OCDSPeriod setEndDate(final LocalDateTime endDate) {
        this.endDate = endDate;
        return this;
    }

    /**
     * @return max extent date
     */
    @JsonSerialize(using = OCDSLocalDateTimeSerializer.class)
    public final LocalDateTime getMaxExtentDate() {
        return maxExtentDate;
    }

    /**
     * @param maxExtentDate
     *      max extent date to be set
     * @return this instance for chaining
     */
    public final OCDSPeriod setMaxExtentDate(final LocalDateTime maxExtentDate) {
        this.maxExtentDate = maxExtentDate;
        return this;
    }

    /**
     * @return duration in days
     */
    public final Integer getDurationInDays() {
        return durationInDays;
    }

    /**
     * @param durationInDays
     *      number of days to be set
     * @return this instance for chaining
     */
    public final OCDSPeriod setDurationInDays(final Integer durationInDays) {
        this.durationInDays = durationInDays;
        return this;
    }
}
