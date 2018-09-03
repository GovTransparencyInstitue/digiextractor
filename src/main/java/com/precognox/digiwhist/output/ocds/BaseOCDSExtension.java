package com.precognox.digiwhist.output.ocds;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonInclude;

/**
 * Base class for OCDS extensions.
 *
 * @author Tomas Mrazek
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
public abstract class BaseOCDSExtension {

    protected String url;

    /**
     * @return extension URL
     */
    @JsonIgnore
    abstract String getUrl();
}
