package com.precognox.digiwhist.output.ocds.codetables;

public enum OCDSContractStatus {

    pending,
    active,
    cancelled,
    terminated;

    public static OCDSContractStatus convertFromMexico(String text) {
        if ("Activo".equalsIgnoreCase(text)) {
            return active;
        }

        if ("Terminado".equalsIgnoreCase(text) || "Expirado".equalsIgnoreCase(text)) {
            return terminated;
        }

        return null;
    }

  }
