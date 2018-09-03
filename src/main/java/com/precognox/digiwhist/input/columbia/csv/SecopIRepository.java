package com.precognox.digiwhist.input.columbia.csv;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface SecopIRepository  extends JpaRepository<SecopI, String>{

    @Query("SELECT s FROM SecopI s WHERE s.numero_de_constancia = ?1")
    List<SecopI> getByNumConstancia(String numero_de_constancia);
}
