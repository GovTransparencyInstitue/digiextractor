/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.precognox.digiwhist.input.columbia.csv;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

/**
 *
 * @author precognox
 */
public interface FrameworkAgreementRepository extends JpaRepository<FrameworkAgreement, String>{
 
    @Query("SELECT s FROM FrameworkAgreement s WHERE s.identificador_de_la_orden = ?1")
    FrameworkAgreement getById(String identificador_de_la_orden);
}
