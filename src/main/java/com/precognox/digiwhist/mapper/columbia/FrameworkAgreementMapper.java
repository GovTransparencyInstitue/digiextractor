package com.precognox.digiwhist.mapper.columbia;

import java.math.BigDecimal;

import org.springframework.stereotype.Component;

import com.precognox.digiwhist.input.columbia.csv.FrameworkAgreement;
import com.precognox.digiwhist.output.ocds.OCDSAward;
import com.precognox.digiwhist.output.ocds.OCDSContactPoint;
import com.precognox.digiwhist.output.ocds.OCDSOrganizationReference;
import com.precognox.digiwhist.output.ocds.OCDSRelease;
import com.precognox.digiwhist.output.ocds.OCDSReleasePackage;
import com.precognox.digiwhist.output.ocds.OCDSTender;
import com.precognox.digiwhist.output.ocds.OCDSValue;
import com.precognox.digiwhist.output.ocds.codetables.OCDSTenderStatus;

@Component
public class FrameworkAgreementMapper {

	public OCDSReleasePackage map(FrameworkAgreement frameworkAgreement, OCDSReleasePackage ocdsRoot){
		ocdsRoot.addRelease(new OCDSRelease());
		final OCDSRelease release = ocdsRoot.getReleases().get(0);
		release.setOcid(frameworkAgreement.getIdentificador_de_la_orden());
		
		
        release.setBuyer(new OCDSOrganizationReference());
        
        release.getBuyer().setName(frameworkAgreement.getEntidad());
        release.getBuyer().setContactPoint(new OCDSContactPoint());
        release.getBuyer().getContactPoint().setName(frameworkAgreement.getSolicitante());
        
        OCDSAward award = new OCDSAward();
        award.addSupplier(new OCDSOrganizationReference());
        award.getSuppliers().get(0).setName(frameworkAgreement.getProveedor());
        release.getAwards().add(award);
    	
        OCDSTender tender = new OCDSTender();
        release.setTender(tender);
        if("Cerrada".equals(frameworkAgreement.getEstado())) {
        	tender.setStatus(OCDSTenderStatus.complete);
        }else if("CerradaxError".equals(frameworkAgreement.getEstado())) {
        	tender.setStatus(OCDSTenderStatus.withdrawn);
        }else if("Emitida".equals(frameworkAgreement.getEstado())) {
        	tender.setStatus(OCDSTenderStatus.active);
        }
        
        tender.setDescription(frameworkAgreement.getItems());
        
        tender.setValue(new OCDSValue());
        tender.getValue().setAmount(new BigDecimal(frameworkAgreement.getTotal()));
        
		return ocdsRoot;
	}
	
}
