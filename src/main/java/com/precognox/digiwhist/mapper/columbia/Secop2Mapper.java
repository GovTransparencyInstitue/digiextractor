package com.precognox.digiwhist.mapper.columbia;

import java.math.BigDecimal;
import java.util.List;

import org.springframework.stereotype.Component;

import com.precognox.digiwhist.input.columbia.csv.Secop2Contratos;
import com.precognox.digiwhist.mapper.util.Util;
import com.precognox.digiwhist.output.ocds.OCDSAward;
import com.precognox.digiwhist.output.ocds.OCDSContract;
import com.precognox.digiwhist.output.ocds.OCDSIdentifier;
import com.precognox.digiwhist.output.ocds.OCDSImplementation;
import com.precognox.digiwhist.output.ocds.OCDSItem;
import com.precognox.digiwhist.output.ocds.OCDSItemClassification;
import com.precognox.digiwhist.output.ocds.OCDSOrganizationReference;
import com.precognox.digiwhist.output.ocds.OCDSPeriod;
import com.precognox.digiwhist.output.ocds.OCDSRelease;
import com.precognox.digiwhist.output.ocds.OCDSReleasePackage;
import com.precognox.digiwhist.output.ocds.OCDSTender;
import com.precognox.digiwhist.output.ocds.OCDSTransaction;
import com.precognox.digiwhist.output.ocds.OCDSValue;
import com.precognox.digiwhist.output.ocds.codetables.OCDSContractStatus;
import com.precognox.digiwhist.output.ocds.codetables.OCDSMainProcurementCategory;

@Component
public class Secop2Mapper {
    
	public OCDSReleasePackage map(List<Secop2Contratos> secop2Contratos, OCDSReleasePackage ocdsRoot){
		ocdsRoot.addRelease(new OCDSRelease());
		final OCDSRelease release = ocdsRoot.getReleases().get(0);
		
		release.setOcid(secop2Contratos.get(0).getProceso_de_compra());
		
		release.setBuyer(new OCDSOrganizationReference());
		release.getBuyer().setName(secop2Contratos.get(0).getNombre_entidad());
		release.getBuyer().setIdentifier(new OCDSIdentifier());
		release.getBuyer().getIdentifier().setId(secop2Contratos.get(0).getNit_entidad());
		
		release.setTender(new OCDSTender());
		release.getTender().setDescription(secop2Contratos.get(0).getDescripcion_del_proceso());
		
		
        if("Obra".equals(secop2Contratos.get(0).getTipo_de_contrato())) {
        	release.getTender().setMainProcurementCategory(OCDSMainProcurementCategory.WORKS);
        }else if("Suministros".equals(secop2Contratos.get(0).getTipo_de_contrato())) {
        	release.getTender().setMainProcurementCategory(OCDSMainProcurementCategory.GOODS);
        }else if(secop2Contratos.get(0).getTipo_de_contrato().startsWith("Prestaci")) {
        	release.getTender().setMainProcurementCategory(OCDSMainProcurementCategory.SERVICES);        	
        } else {
        	release.getTender().addAdditionalProcurementCategory(secop2Contratos.get(0).getTipo_de_contrato());
        }
		
        release.getTender().addAdditionalProcurementCategory(secop2Contratos.get(0).getTipo_de_proceso());

		release.getTender().addItem(new OCDSItem());
		release.getTender().getItems().get(0).setClassification(new OCDSItemClassification());
		release.getTender().getItems().get(0).getClassification().setId(secop2Contratos.get(0).getCodigo_de_categoria_principal());
		
		//release.getTender().setStatus(status);

			
		
		
		for(Secop2Contratos secop2Contrat : secop2Contratos) {
			OCDSContract contract = new OCDSContract();
			contract.setPeriod(new OCDSPeriod());
			contract.getPeriod().setStartDate(Util.parseDate(secop2Contrat.getFecha_de_inicio_del_contrato()));
			contract.getPeriod().setEndDate(Util.parseDate(secop2Contrat.getFecha_de_fin_del_contrato()));
			contract.setAwardId(secop2Contrat.getReferencia_del_contrato());
			contract.setId(secop2Contrat.getReferencia_del_contrato());
			contract.setSigned(Util.parseDate(secop2Contrat.getFecha_de_firma()));
			
			
			if( "cedido".equals(secop2Contratos.get(0).getEstado_contrato()) ||
					"Prorrogado".equals(secop2Contratos.get(0).getEstado_contrato()) || 
					"Modificado".equals(secop2Contratos.get(0).getEstado_contrato()) ||
					"Firmado".equals(secop2Contratos.get(0).getEstado_contrato()) 	) {
				contract.setStatus(OCDSContractStatus.active);
			}else if("Suspendido".equals(secop2Contratos.get(0).getEstado_contrato()) ||
					"terminado".equals(secop2Contratos.get(0).getEstado_contrato()) ||
					"Cerrado".equals(secop2Contratos.get(0).getEstado_contrato())) {
				contract.setStatus(OCDSContractStatus.terminated);				
			}else if("Cancelado".equals(secop2Contratos.get(0).getEstado_contrato())) {
				contract.setStatus(OCDSContractStatus.cancelled);
			}else {
				contract.setStatus(OCDSContractStatus.pending);
			}
			
			if(secop2Contrat.getValor_del_contrato()!=null) {
				contract.setValue(new OCDSValue());			
				contract.getValue().setAmount(new BigDecimal(secop2Contrat.getValor_del_contrato()));
			}
			
			if(secop2Contrat.getValor_pagado()!=null) {
				contract.setImplementation(new OCDSImplementation());
				contract.getImplementation().addTransaction(new OCDSTransaction());
				contract.getImplementation().getTransactions().get(0).setValue(new OCDSValue());
				contract.getImplementation().getTransactions().get(0).getValue().setAmount(new BigDecimal(secop2Contrat.getValor_pagado()));
			}
			release.getContracts().add(contract);
			
			OCDSAward award = new OCDSAward();
			award.addSupplier(new OCDSOrganizationReference());
			award.getSuppliers().get(0).setName(secop2Contrat.getProveedor_adjudicado());
			award.setId(secop2Contrat.getReferencia_del_contrato());
			release.getAwards().add(award);
			
			
			
		}
        
		
		
		return ocdsRoot;
	}
	
}
