package com.precognox.digiwhist.output.ocds;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@JsonInclude(JsonInclude.Include.NON_NULL)
public class OCDSPlanning {
    private OCDSBudget budget;
}
