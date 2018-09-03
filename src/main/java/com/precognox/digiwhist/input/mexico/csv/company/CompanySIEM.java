
package com.precognox.digiwhist.input.mexico.csv.company;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import lombok.Getter;
import lombok.Setter;

/**
 *
 * @author pferenczy
 */
@Entity
@Table(schema = "digiwhist_parse_raw", name = "company_siem")
@Getter
@Setter
public class CompanySIEM {
    
    private String razonSocialCleaned;
    private String estado;
    private String municipio;
    private String domicilio;
    private String colonia;
    private String codigoPostal;
    private String telefono;
    private String correo;
    private String giro;
    private String scian;
    private String rangoEmpleados;
    private String registradoPor;
            
    @Id
    private Long id; 
}
