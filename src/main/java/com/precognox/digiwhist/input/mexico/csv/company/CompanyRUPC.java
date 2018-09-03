package com.precognox.digiwhist.input.mexico.csv.company;


import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(schema = "digiwhist_parse_raw", name = "company_rupc")
@Getter
@Setter
public class CompanyRUPC {

    @Id
    private Long id;

    private String folioRUPC;

    private String rfc;

    private String companyName;

    private String countryCode;

    private String federalEntity;

    private String estratificacion;

    private String userType;

    private String sector;

    private String giro;

    private String contratos;

    private String fechaDeInscripcionAlRUPC;

    private String contratosEvaluadosADQ;

    private String gradoDeCumplimientoADQ;

    private String contratosEvaluadosOP;

    private String gradoDeCumplimientoOP;

    private String web; 
}
