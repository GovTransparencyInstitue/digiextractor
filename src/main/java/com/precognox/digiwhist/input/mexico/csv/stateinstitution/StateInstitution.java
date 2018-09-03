/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.precognox.digiwhist.input.mexico.csv.stateinstitution;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import lombok.Getter;
import lombok.Setter;

/**
 *
 * @author precognox
 */
@Entity
@Table(schema = "digiwhist_parse_raw", name = "state_institution")
@Getter
@Setter
public class StateInstitution {

    @Id
    @Column(name = "id")
    private Long id;

    @Column(name = "ramo")
    private String ramo;

    @Column(name = "institucion")
    private String institucion;

    @Column(name = "siglas")
    private String siglas;

    @Column(name = "clave_uc")
    private String claveUc;

    @Column(name = "nombre_uc")
    private String nombreUc;

    @Column(name = "rfc_uc")
    private String rfcUc;

    @Column(name = "responsable")
    private String responsable;

    @Column(name = "entidad_federativa")
    private String entidadFederativa;

    @Column(name = "zona_horaria")
    private String zonaHoraria;

    @Column(name = "telefono")
    private String telefono;
}
