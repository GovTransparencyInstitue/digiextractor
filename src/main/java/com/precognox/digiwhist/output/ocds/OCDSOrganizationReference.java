package com.precognox.digiwhist.output.ocds;


import com.fasterxml.jackson.annotation.JsonInclude;

/**
 * OCDS organization reference. This object doesn't cover full OCDS schema.
 * 
 * @see <a href="http://standard.open-contracting.org/1.1/en/schema/release/">OCDS Release Schema</a>
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
public class OCDSOrganizationReference extends BaseOCDSOrganization<OCDSOrganizationReference> {
}
