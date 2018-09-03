package com.precognox.digiwhist.output.ocds;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@NoArgsConstructor
@Getter
@Setter
@JsonInclude(JsonInclude.Include.NON_NULL)
public class OCDSRecord {

    private String ocid;
    private List<OCDSRelease> releases = new ArrayList<>();

    private OCDSRelease compiledRelease;

    public final OCDSRecord addRelease(final OCDSRelease release) {
        if (release != null) {
            if (this.releases == null) {
                this.releases = new ArrayList<>();
            }

            this.releases.add(release);
        }

        return this;
    }
}
