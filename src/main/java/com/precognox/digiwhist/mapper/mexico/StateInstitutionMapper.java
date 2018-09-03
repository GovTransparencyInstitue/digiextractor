package com.precognox.digiwhist.mapper.mexico;

import com.precognox.digiwhist.input.mexico.csv.stateinstitution.StateInstitution;
import com.precognox.digiwhist.input.mexico.csv.stateinstitution.StateInstitutionRepository;
import com.precognox.digiwhist.output.ocds.OCDSAddress;
import com.precognox.digiwhist.output.ocds.OCDSRecord;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class StateInstitutionMapper {

    @Autowired
    private StateInstitutionRepository stateInstitutionRepo;
    
	public OCDSRecord map(OCDSRecord ocdsRoot) {
		
		StateInstitution  stateInstitution = stateInstitutionRepo.getStateInstitutionByClaveUc(ocdsRoot.getReleases().get(0).getBuyer().getId());
		
		if(stateInstitution == null) return ocdsRoot;
		
		ocdsRoot.getReleases().get(0).getBuyer().setName(stateInstitution.getNombreUc());
		ocdsRoot.getReleases().get(0).getBuyer().getContactPoint().setName(stateInstitution.getResponsable());
		
		ocdsRoot.getReleases().get(0).getBuyer().setAddress(new OCDSAddress());
		ocdsRoot.getReleases().get(0).getBuyer().getAddress().setRegion(stateInstitution.getEntidadFederativa());
		ocdsRoot.getReleases().get(0).getBuyer().getContactPoint().setPhone(stateInstitution.getTelefono());
				
		return ocdsRoot;
	}
	
	
}
