package com.precognox.digiwhist.input.columbia.csv;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface Secop2ContratosRepository  extends JpaRepository<Secop2Contratos, String>{

    @Query("SELECT s FROM Secop2Contratos s WHERE s.proceso_de_compra = ?1")
    List<Secop2Contratos> getByProcesoDeCompra(String proceso_de_compra);
}
