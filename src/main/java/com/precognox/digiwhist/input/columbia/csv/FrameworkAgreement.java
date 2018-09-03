package com.precognox.digiwhist.input.columbia.csv;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import lombok.Getter;
import lombok.Setter;

@Entity
@Table(schema = "digiwhist_parse_raw", name = "co_secop3")
@Getter
@Setter
public class FrameworkAgreement {

    String ano;
    @Id
    String identificador_de_la_orden;
    String rama_de_la_entidad;
    String sector_de_la_entidad;
    String entidad;
    String solicitante;
    String fecha;
    String proveedor;
    String estado;
    String solicitud;
    String items;
    String total;
    String agregacion;
    String ciudad;
    String entidad_obigada;
    String espostconflicto ;

}
