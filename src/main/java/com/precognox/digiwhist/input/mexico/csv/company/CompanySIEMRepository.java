package com.precognox.digiwhist.input.mexico.csv.company;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;


/**
 *
 * @author precognox
 */
public interface CompanySIEMRepository extends JpaRepository<CompanySIEM, Long>{

    @Query("SELECT c FROM CompanySIEM c WHERE c.razonSocialCleaned = :company")
    List<CompanySIEM> getByName(@Param("company") String companyName);
}
