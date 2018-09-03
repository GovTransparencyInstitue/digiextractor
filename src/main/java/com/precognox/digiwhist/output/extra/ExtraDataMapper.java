package com.precognox.digiwhist.output.extra;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.precognox.digiwhist.input.mexico.csv.company.CompanyRUPC;
import com.precognox.digiwhist.input.mexico.csv.company.CompanyRUPCRepository;
import com.precognox.digiwhist.input.mexico.csv.company.CompanySIEM;
import com.precognox.digiwhist.input.mexico.csv.company.CompanySIEMRepository;
import com.precognox.digiwhist.input.mexico.csv.contract.Contract;
import com.precognox.digiwhist.input.mexico.csv.contract.ContractRepository;
import com.precognox.digiwhist.input.mexico.csv.stateinstitution.StateInstitutionRepository;

@Component
public class ExtraDataMapper {

    @Autowired
    private ContractRepository contractRepo;
    
    @Autowired
    private StateInstitutionRepository stateInstitutionRepo;
    
	@Autowired
	CompanySIEMRepository siemRepo;
	
    @Autowired
    private CompanyRUPCRepository rupcRepo;
    
    public MexicoExtraData map(String id) {
    	MexicoExtraData data = new MexicoExtraData();
    	
    	data.setId(id);
    	
    	data.setContratos(contractRepo.getContractsByTenderId(id));
    	
    	List<CompanySIEM> siemList = new ArrayList<>();
    	for(Contract contract : data.getContratos()) {
    		
    		 List<CompanySIEM> companySIEMList = siemRepo.getByName(contract.getProveedorContratista());
             if (!companySIEMList.isEmpty() && companySIEMList.size()==1) {
            	 siemList.addAll(companySIEMList);
             }
    	}
    	data.setSiem(siemList);
    	
    	List<CompanyRUPC> rupcList = new ArrayList<>();
    	for(Contract contract : data.getContratos()) {
   		 Set<CompanyRUPC> companyRUPCList = rupcRepo.getCompaniesByFolioRUPC(contract.getFolioRupc());
         if (!companyRUPCList.isEmpty() && companyRUPCList.size()==1) {
        	 rupcList.addAll(companyRUPCList);
         }
    	}
    	data.setRupc(rupcList);
    	
    	data.setUc(stateInstitutionRepo.getStateInstitutionByClaveUc(data.getContratos().get(0).getClaveuc()));
    	
    	return data;
    }
}
