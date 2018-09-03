/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.precognox.digiwhist.input.mexico.csv.stateinstitution;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

/**
 *
 * @author precognox
 */
public interface StateInstitutionRepository extends JpaRepository<StateInstitution, Long>{
    
        @Query("SELECT s FROM StateInstitution s WHERE s.claveUc = ?1")
        StateInstitution getStateInstitutionByClaveUc(String claveUc);
}
