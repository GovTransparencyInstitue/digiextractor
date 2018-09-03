
package com.precognox.digiwhist.input.mexico.csv.contract;

import java.util.List;
import java.util.Set;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

/**
 *
 * @author precognox
 */
public interface ContractRepository extends JpaRepository<Contract, Long>{
    
    @Query("SELECT c FROM Contract c WHERE c.folioRupc = ?1")
    Set<Contract> getContractsByFolioRUPC(String folioRUPC);

    @Query("SELECT c FROM Contract c WHERE c.numeroProcedimiento = ?1")
    Set<Contract> getContractsByOCID(String id);

    @Query("SELECT c FROM Contract c WHERE c.codigoExpediente = ?1")
    List<Contract> getContractsByTenderId(String id);
}
