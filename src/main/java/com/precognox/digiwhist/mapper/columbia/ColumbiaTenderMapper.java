package com.precognox.digiwhist.mapper.columbia;

import java.math.BigDecimal;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Currency;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.precognox.digiwhist.input.columbia.csv.FrameworkAgreement;
import com.precognox.digiwhist.input.columbia.csv.FrameworkAgreementRepository;
import com.precognox.digiwhist.input.columbia.csv.Secop2Contratos;
import com.precognox.digiwhist.input.columbia.csv.Secop2ContratosRepository;
import com.precognox.digiwhist.input.columbia.csv.SecopI;
import com.precognox.digiwhist.input.columbia.csv.SecopIRepository;
import com.precognox.digiwhist.mapper.util.Util;
import com.precognox.digiwhist.output.ocds.OCDSAward;
import com.precognox.digiwhist.output.ocds.OCDSBudget;
import com.precognox.digiwhist.output.ocds.OCDSContract;
import com.precognox.digiwhist.output.ocds.OCDSDocument;
import com.precognox.digiwhist.output.ocds.OCDSIdentifier;
import com.precognox.digiwhist.output.ocds.OCDSItem;
import com.precognox.digiwhist.output.ocds.OCDSItemClassification;
import com.precognox.digiwhist.output.ocds.OCDSOrganizationReference;
import com.precognox.digiwhist.output.ocds.OCDSPeriod;
import com.precognox.digiwhist.output.ocds.OCDSPlanning;
import com.precognox.digiwhist.output.ocds.OCDSRelease;
import com.precognox.digiwhist.output.ocds.OCDSReleasePackage;
import com.precognox.digiwhist.output.ocds.OCDSTender;
import com.precognox.digiwhist.output.ocds.OCDSValue;
import com.precognox.digiwhist.output.ocds.codetables.OCDSAdditionalProcurementCategories;
import com.precognox.digiwhist.output.ocds.codetables.OCDSMainProcurementCategory;

import lombok.extern.slf4j.Slf4j;

@Component
@Slf4j
public class ColumbiaTenderMapper {

    @Autowired
    private SecopIRepository secopIRepo;

    @Autowired
    private FrameworkAgreementRepository frameworkAgreementRepo;
    
    @Autowired
    private FrameworkAgreementMapper frameworkAgreementMapper;
    
    @Autowired
    private Secop2ContratosRepository secop2ContratosRepo;
    
    @Autowired
    private Secop2Mapper secop2ContratosMapper;
    
    public OCDSReleasePackage mapByID(String id) {
        OCDSReleasePackage ocdsRoot = new OCDSReleasePackage();

        List<SecopI> secopIList = secopIRepo.getByNumConstancia(id);

        if (secopIList != null && secopIList.size() > 0) {
            mapFirstSecopI(ocdsRoot, secopIList.get(0));
            
            for(int i = 1; i< secopIList.size(); i++) {
            	addMoreSecopI(ocdsRoot, secopIList.get(i));
            }
            return ocdsRoot;
        }
        	
        List<Secop2Contratos> secop2Contratos = secop2ContratosRepo.getByProcesoDeCompra(id);
        	
        if(secop2Contratos!=null&&secop2Contratos.size()>0) {
        	ocdsRoot = secop2ContratosMapper.map(secop2Contratos,ocdsRoot);
        	return ocdsRoot;
        }
        	
        FrameworkAgreement frameworkAgreement = frameworkAgreementRepo.getById(id);
    	
        if(frameworkAgreement!=null) {
        	ocdsRoot = frameworkAgreementMapper.map(frameworkAgreement,ocdsRoot);
        	return ocdsRoot;
        }
        
        return ocdsRoot;
        
    }

    private OCDSReleasePackage mapFirstSecopI(OCDSReleasePackage ocdsRoot, SecopI secopI) {

        ocdsRoot.addRelease(new OCDSRelease());
        mapBuyer(secopI, ocdsRoot);
        mapOCID(secopI, ocdsRoot);
        mapTender(secopI, ocdsRoot);
        mapContracts(secopI, ocdsRoot);
        mapAward(secopI, ocdsRoot);
        mapPlanning(secopI, ocdsRoot);
        
        return ocdsRoot;
    }
    
    private OCDSReleasePackage addMoreSecopI(OCDSReleasePackage ocdsRoot, SecopI secopI) {
    	mapContracts(secopI, ocdsRoot);
    	mapAward(secopI, ocdsRoot);
        return ocdsRoot;
    }

    private void mapTender(SecopI secopI, OCDSReleasePackage ocdsRoot) {
        OCDSRelease ocdsRelease = ocdsRoot.getReleases().get(0);
        OCDSTender tender = new OCDSTender();
        
        tender.setProcurementMethodDetails(secopI.getTipo_de_proceso());
        
        OCDSItem item = new OCDSItem();
        OCDSItemClassification classification = new OCDSItemClassification();
        classification.setId(secopI.getId_objeto_a_contratar());
        item.setClassification(classification);
        tender.getItems().add(item);
        tender.setDescription(secopI.getDetalle_del_objeto_a_contratar());

        // OCDSTenderStatus missing

        if("Obra".equals(secopI.getTipo_de_contrato())) {
        	tender.setMainProcurementCategory(OCDSMainProcurementCategory.WORKS);
        }else if("Suministro".equals(secopI.getTipo_de_contrato())) {
        	tender.setMainProcurementCategory(OCDSMainProcurementCategory.GOODS);
        }else if(secopI.getTipo_de_contrato().startsWith("Prestaci")) {
        	tender.setMainProcurementCategory(OCDSMainProcurementCategory.SERVICES);        	
        } else {
        	tender.addAdditionalProcurementCategory(secopI.getTipo_de_contrato());
        }
        
        
        
        OCDSValue value = new OCDSValue();
        value.setAmount(new BigDecimal(secopI.getCuantia_proceso()));
        tender.setValue(value);
        OCDSDocument document = new OCDSDocument();
        URL url;
        try {
            url = new URL(secopI.getRuta_proceso_en_secop_i());
            document.setUrl(url);
        } catch (MalformedURLException ex) {
            Logger.getLogger(ColumbiaTenderMapper.class.getName()).log(Level.SEVERE, null, ex);
        }
        tender.getDocuments().add(document);
        
        ocdsRelease.setTender(tender);
    }

    private void mapContracts(SecopI secopI, OCDSReleasePackage ocdsRoot) {
        OCDSRelease ocdsRelease = ocdsRoot.getReleases().get(0);
        OCDSContract contract = new OCDSContract();
        contract.setAwardId(secopI.getId_ajudicacion());
        contract.setId(secopI.getNumero_del_contrato());
        contract.setSigned(Util.parseDate(secopI.getFecha_de_firma_del_contrato()));

        OCDSPeriod period = new OCDSPeriod();
        period.setStartDate(Util.parseDate(secopI.getFecha_ini_ejec_contrato()));
        
        if(secopI.getPlazo_de_ejec_del_contrato()!= null) {
	        if("D".equals(secopI.getRango_de_ejec_del_contrato())) {
	        	period.setDurationInDays(Integer.valueOf(secopI.getPlazo_de_ejec_del_contrato()));
	        }else if("M".equals(secopI.getRango_de_ejec_del_contrato())){
	        	period.setDurationInDays(Integer.valueOf(secopI.getPlazo_de_ejec_del_contrato())*30);
	        }
        }        
        period.setEndDate(Util.parseDate(secopI.getFecha_fin_ejec_contrato()));
        
        contract.setPeriod(period);
        contract.setValue(new OCDSValue());
        contract.getValue().setAmount(new BigDecimal(secopI.getCuantia_contrato()));
        
        if(secopI.getMoneda()!=null){
	        if(secopI.getMoneda().contains("(COP)")) {
	        	contract.getValue().setCurrency(Currency.getInstance("COP"));
	        }else if(secopI.getMoneda().contains("(USD)")) {
	        	contract.getValue().setCurrency(Currency.getInstance("USD"));
	        }
        }
        ocdsRelease.getContracts().add(contract);
    }

    private void mapBuyer(SecopI secopI, OCDSReleasePackage ocdsRoot) {
        final OCDSRelease release = ocdsRoot.getReleases().get(0);
        release.setBuyer(new OCDSOrganizationReference());
        release.getBuyer().setId(secopI.getNit_de_la_entidad());
        release.getBuyer().setName(secopI.getNombre_de_la_entidad());
        release.getBuyer().setIdentifier(new OCDSIdentifier());
        release.getBuyer().getIdentifier().setId(secopI.getNit_de_la_entidad());
        release.getBuyer().addAdditionalIdentifier(new OCDSIdentifier());
        release.getBuyer().getAdditionalIdentifiers().get(0).setId(secopI.getCodigo_de_la_entidad());
    }

    private void mapOCID(SecopI secopI, OCDSReleasePackage ocdsRoot) {
        final OCDSRelease release = ocdsRoot.getReleases().get(0);

        final String ocid = release.getOcid();
        if (ocid == null || ocid.isEmpty()) {
            release.setOcid(secopI.getNumero_de_proceso());
        } else {
            log.debug("the ocid value is already set to: {},  we can't overwrite with: {}", ocid, secopI.getNumero_de_proceso());
        }
    }

    private OCDSReleasePackage mapAward(SecopI secopI, OCDSReleasePackage ocdsRoot) {
    	OCDSAward award = new OCDSAward();
    	ocdsRoot.getReleases().get(0).getAwards().add(award);
    	award.addSupplier(new OCDSOrganizationReference());    	
    	award.getSuppliers().get(0).setIdentifier(new OCDSIdentifier());
    	award.getSuppliers().get(0).getIdentifier().setId(secopI.getIdentificacion_del_contratista());
    	award.getSuppliers().get(0).getIdentifier().setScheme(secopI.getTipo_identifi_del_contratista());
    	award.getSuppliers().get(0).setName(secopI.getNom_raz_social_contratista());
    	award.setId(secopI.getId_ajudicacion());
    	
    	return ocdsRoot;    	
    }
    
    private OCDSReleasePackage mapPlanning(SecopI secopI, OCDSReleasePackage ocdsRoot) {
    	
    	ocdsRoot.getReleases().get(0).setPlanning(new OCDSPlanning());
    	ocdsRoot.getReleases().get(0).getPlanning().setBudget(new OCDSBudget());
    	ocdsRoot.getReleases().get(0).getPlanning().getBudget().setProjectID(secopI.getId_origen_de_los_recursos());
    	ocdsRoot.getReleases().get(0).getPlanning().getBudget().setProject(secopI.getOrigen_de_los_recursos());
    	
    	return ocdsRoot;    	
    }
}
