package com.precognox.digiwhist.mapper.mexico;

import com.precognox.digiwhist.input.mexico.csv.company.CompanySIEM;
import com.precognox.digiwhist.input.mexico.csv.company.CompanySIEMRepository;
import com.precognox.digiwhist.output.ocds.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@Slf4j
public class CompanySiemMapper {
	@Autowired
	CompanySIEMRepository repo;
	
	public OCDSRecord map(OCDSRecord ocdsRoot) {
		
		for(OCDSAward award: ocdsRoot.getReleases().get(0).getAwards()) {
			for(OCDSOrganizationReference supplier : award.getSuppliers()) {
                List<CompanySIEM> companySIEMList = repo.getByName(supplier.getName());
                if (!companySIEMList.isEmpty() && companySIEMList.size()==1) {

                    CompanySIEM companySIEM = companySIEMList.get(0);
                    if (companySIEM != null) {
                        supplier.setAddress(new OCDSAddress());
                        supplier.getAddress().setRegion(companySIEM.getEstado());
                        supplier.getAddress().setStreet(companySIEM.getDomicilio());
                        supplier.getAddress().setLocality(companySIEM.getColonia());
                        supplier.getAddress().setPostcode(companySIEM.getCodigoPostal());

                        supplier.setContactPoint(new OCDSContactPoint());
                        supplier.getContactPoint().setPhone(companySIEM.getTelefono());
                        supplier.getContactPoint().setEmail(companySIEM.getCorreo());
                    }
                }
            }
		} 
		return ocdsRoot;
	}
}
