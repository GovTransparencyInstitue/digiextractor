/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.precognox.digiwhist.input.mexico.csv.contract;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 *
 * @author precognox
 */
@Entity
@Table(schema = "digiwhist_parse_raw")
@Getter
@Setter
public class Contract {
    
    @Id
    private Long id;

    private String gobierno;

    private String siglas;

    private String dependencia;

    private String claveuc;

    private String nombreDeLaUc;

    private String responsable;

    private String codigoExpediente;

    private String tituloExpediente;

    private String plantillaExpediente;

    private String numeroProcedimiento;

    private String expFFallo;

    private String procFPublicacion;

    private String fechaAperturaProposiciones;

    private String caracter;

    private String tipoContratacion;

    private String tipoProcedimiento;

    private String formaProcedimiento;

    private String codigoContrato;

    private String tituloContrato;

    private String fechaInicio;

    private String fechaFin;

    private String importeContrato;

    private String moneda;

    private String estatusContrato;

    private String archivado;

    private String convenioModificatorio;

    private String ramo;

    private String clavePrograma;

    private String aportacionFederal;

    private String fechaCelebracion;

    private String contratoMacro;

    private String identificadorCm;

    private String compraConsolidada;

    private String plurianual;

    private String claveCarteraShcp;

    private String estratificacionMuc;

    private String folioRupc;

    @Column(name = "proveendor_contratista")
    private String proveedorContratista;

    private String estratificacionMpc;

    private String siglasPais;

    private String estatusEmpresa;

    private String cuentaAdministradaPor;

    private String cExterno;

    @Column(name = "organizmo")
    private String organismo;

    private String anuncio;
}
