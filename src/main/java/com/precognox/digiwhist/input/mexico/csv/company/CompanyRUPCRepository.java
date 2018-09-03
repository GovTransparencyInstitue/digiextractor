package com.precognox.digiwhist.input.mexico.csv.company;

import java.util.Set;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;


/**
 *
 * @author precognox
 */
public interface CompanyRUPCRepository extends JpaRepository<CompanyRUPC, Long>{
    
    @Query("SELECT c FROM CompanyRUPC c WHERE c.folioRUPC = ?1")
    Set<CompanyRUPC> getCompaniesByFolioRUPC(String folioRUPC);
    
    @Query("SELECT c FROM CompanyRUPC c WHERE c.companyName like CONCAT('%',:company,'%')")
    Set<CompanyRUPC> getCompaniesByNameLike(@Param("company") String companyName);
}
