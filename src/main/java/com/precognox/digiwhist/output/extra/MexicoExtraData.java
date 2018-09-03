package com.precognox.digiwhist.output.extra;

import java.util.List;

import com.precognox.digiwhist.input.mexico.csv.company.CompanyRUPC;
import com.precognox.digiwhist.input.mexico.csv.company.CompanySIEM;
import com.precognox.digiwhist.input.mexico.csv.contract.Contract;
import com.precognox.digiwhist.input.mexico.csv.stateinstitution.StateInstitution;

import lombok.Data;

@Data
public class MexicoExtraData {
	String id;
	List<Contract> contratos;
	List<CompanyRUPC> rupc;
	List<CompanySIEM> siem;
	StateInstitution uc;
}
