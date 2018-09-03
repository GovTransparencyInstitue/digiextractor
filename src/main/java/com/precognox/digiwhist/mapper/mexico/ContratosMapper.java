package com.precognox.digiwhist.mapper.mexico;

import com.google.gson.*;
import com.precognox.digiwhist.input.mexico.csv.contract.Contract;
import com.precognox.digiwhist.input.mexico.csv.contract.ContractRepository;
import com.precognox.digiwhist.input.mexico.json.RawResult;
import com.precognox.digiwhist.input.mexico.json.RawResultRepository;
import com.precognox.digiwhist.output.ocds.*;
import com.precognox.digiwhist.output.ocds.codetables.OCDSAdditionalProcurementCategories;
import com.precognox.digiwhist.output.ocds.codetables.OCDSContractStatus;
import com.precognox.digiwhist.output.ocds.codetables.OCDSMainProcurementCategory;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.net.MalformedURLException;
import java.net.URL;
import java.time.format.DateTimeFormatter;
import java.util.*;

import static com.precognox.digiwhist.mapper.util.Util.parseDate;


@Component
@Slf4j
public class ContratosMapper {

    @Autowired
    private ContractRepository contractRepo;

    @Autowired
    private CompanyMapper companyMapper;

    @Autowired
    private StateInstitutionMapper stateInstitutionMapper;

    @Autowired
    private CompanySiemMapper companySiemMapper;
    
    @Autowired
    private RawResultRepository rawResultRepository;

    private static final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
 
    public Optional<JsonElement> mergeWithRaw(String id) {
        final Optional<RawResult> rawResult = rawResultRepository.findById(id);
        
        if (!rawResult.isPresent()) {
            return Optional.empty();
        }

        GsonBuilder builder = new GsonBuilder();
        Gson gson = builder.create();
        builder.setPrettyPrinting();
        JsonElement jsonElement = gson.fromJson(rawResult.get().getRaw_data(), JsonElement.class);

        Optional<OCDSRecordPackage> mapped = mapByID(id);
        JsonObject jo = jsonElement.getAsJsonObject();

        if (!mapped.isPresent()) {
            return Optional.of(jo);
        }

        //final JsonArray releaseList = jo.get("records").getAsJsonArray().get(0).getAsJsonObject().get("releases").getAsJsonArray();
        
        //if (releaseList.size()==1) {
            //mergeRelease(releaseList.get(0).getAsJsonObject(), mapped.get());
        //} else {
            //log.warn("the {} has more then one releases in the raw json, get compiledrelease as release", id);
            mergeRelease(jo.get("records").getAsJsonArray().get(0).getAsJsonObject().get("compiledRelease").getAsJsonObject(), mapped.get());
        //}
        
        return Optional.of(jo);
    }

    private void mergeRelease(final JsonObject onerelease, OCDSRecordPackage mapped) {
        GsonBuilder builder = new GsonBuilder();
        builder.setPrettyPrinting();

        Gson gson = builder.create();
        onerelease.remove("buyer");

        onerelease.add("buyer", gson.toJsonTree(mapped.getRecords().get(0).getReleases().get(0).getBuyer()));

        mergeTender(onerelease, mapped);
        mergeContracts(onerelease, mapped);
        mergeAwards(onerelease, mapped);

    }
    
    private void mergeAwards(final JsonObject onerelease, OCDSRecordPackage mapped) {
    	JsonElement awardsRoot = onerelease.get("awards");

    	if (awardsRoot == null) {
    	    return;
        }
        JsonArray awards = awardsRoot.getAsJsonArray();
    	
    	Map<String, OCDSAward> mappedAwards = new HashMap<>();
    	
    	for(OCDSAward mappedAward : mapped.getRecords().get(0).getReleases().get(0).getAwards()){
    		mappedAwards.put(mappedAward.getId(), mappedAward);
    	}
    	
    	for(int i = 0; i< awards.size(); i++) {
    		JsonObject award = awards.get(i).getAsJsonObject();
    		OCDSAward mappedAward = mappedAwards.get(award.get("id").getAsString());

    		if (mappedAward != null) {
                Gson gson = new GsonBuilder().create();

                award.getAsJsonArray("suppliers").get(0).getAsJsonObject().add("identifier", gson.toJsonTree(mappedAward.getSuppliers().get(0).getIdentifier()));
                award.getAsJsonArray("suppliers").get(0).getAsJsonObject().add("address", gson.toJsonTree(mappedAward.getSuppliers().get(0).getAddress()));
                award.getAsJsonArray("suppliers").get(0).getAsJsonObject().add("contactPoint", gson.toJsonTree(mappedAward.getSuppliers().get(0).getContactPoint()));
                award.getAsJsonArray("suppliers").get(0).getAsJsonObject().add("additionalIdentifiers", gson.toJsonTree(mappedAward.getSuppliers().get(0).getAdditionalIdentifiers()));
            }
    	}
    }
    
    private void mergeContracts(final JsonObject onerelease, OCDSRecordPackage mapped) {
        if (onerelease.get("contracts") == null) {
            // nothing to merge, no data in raw json
            return;
        }
        JsonArray contracts = onerelease.get("contracts").getAsJsonArray();

        Map<String, OCDSContract> mappedContracts = new HashMap<>();
        for(OCDSContract ocdsContract : mapped.getRecords().get(0).getReleases().get(0).getContracts()){
            mappedContracts.put(ocdsContract.getId(), ocdsContract);
        }

        int counter = 0;
        while (counter<contracts.size()) {
            JsonElement oneContract = contracts.get(counter++);
            JsonElement jsonContractId = oneContract.getAsJsonObject().get("id");
            if (jsonContractId != null && !jsonContractId.isJsonNull()) {
                final OCDSContract ocdsContract = mappedContracts.get(jsonContractId.getAsString());
                // there is a contract in the json
                // let's try to find this one in the mapped
                if (ocdsContract!=null) {
                    // found..
                    if (ocdsContract.getValue() != null) {
                        if (!setIfNotExists(oneContract.getAsJsonObject(), ocdsContract.getValue(), "value")) {
                            // value found, we have to merge it, one-by one
                            JsonObject contractValue = oneContract.getAsJsonObject().get("value").getAsJsonObject();
                            if (!contractValue.has("amount")) {
                                contractValue.add("amount", new JsonPrimitive(ocdsContract.getValue().getAmount()));
                            }
                            if (!contractValue.has("currency")) {
                                contractValue.add("currency", new JsonPrimitive(ocdsContract.getValue().getCurrency().toString()));
                            }
                        }
                    }
                } else {
                    log.debug("no contract with id: {} found in mapped", jsonContractId);
                }
            }

        }

    }
    
    private void mergeTender(final JsonObject onerelease, OCDSRecordPackage mapped) {
        JsonObject tender = onerelease.get("tender").getAsJsonObject();
        OCDSTender mTender = mapped.getRecords().get(0).getReleases().get(0).getTender();
        
        if ( (!tender.has("procurementMethod") || tender.get("procurementMethod").isJsonNull()) 
                && mTender.getProcurementMethod() != null) {
            tender.add("procurementMethod", new JsonPrimitive(mTender.getProcurementMethod().name().toLowerCase()));
        }
        
        if (mTender.getTenderPeriod()!=null) {
            if (tender.get("tenderPeriod")==null) {
                tender.add("tenderPeriod", new JsonObject());
            }
            //if (!setIfNotExists(tender, mTender.getTenderPeriod(), "tenderPeriod")) {
                // set was failed! merge requred
                JsonObject jTenderPeriod = tender.get("tenderPeriod").getAsJsonObject();
                setIfNotExists(jTenderPeriod,
                        (mTender.getTenderPeriod().getStartDate() != null ? mTender.getTenderPeriod().getStartDate().format(formatter) : null),
                        "startDate");

                setIfNotExists(jTenderPeriod,
                        (mTender.getTenderPeriod().getEndDate() != null ? mTender.getTenderPeriod().getEndDate().format(formatter) : null),
                        "endDate");
            //}
        }
        
        if (mTender.getMainProcurementCategory()!=null) {
            setIfNotExists(tender, mTender.getMainProcurementCategory().name().toLowerCase(), "mainProcurementCategory");
        }
    }
    
    /**
     * set the value if not found in json and returns true on success, false if the element already present
     * @param to the jsonObject where the element can be found
     * @param from the object which has to be added
     * @param name the json property name
     * @return true if success false if not
     */
    private boolean setIfNotExists(JsonObject to, Object from, String name) {
        boolean result = false;
        GsonBuilder builder = new GsonBuilder();
        Gson gson = builder.create();
         if ( !to.has(name) || to.get(name).isJsonNull()) {
             JsonElement newElement = gson.toJsonTree(from);
             to.add(name, newElement);
             result = true;
        }
        return result;
    }
    
    
    public Optional<OCDSRecordPackage> mapByID(String id) {
        OCDSRecordPackage ocdsRoot = new OCDSRecordPackage();
        ocdsRoot.getRecords().add(new OCDSRecord());

        List<Contract> contracts = contractRepo.getContractsByTenderId(id);

        if(contracts==null || contracts.isEmpty()) return Optional.empty();

        OCDSRecord ocdsRecord = ocdsRoot.getRecords().get(0);
        for (Contract contract : contracts) {
            map(contract, ocdsRecord);
        }

        companyMapper.mapCompanies(ocdsRecord);
        stateInstitutionMapper.map(ocdsRecord);
        companySiemMapper.map(ocdsRecord);
        ocdsRecord.setCompiledRelease(ocdsRecord.getReleases().get(0));
        ocdsRecord.setOcid(ocdsRecord.getCompiledRelease().getOcid());
        return Optional.of(ocdsRoot);
    }

    private void map(Contract contract, OCDSRecord ocdsRoot) {

        // mapping
        OCDSAward award = new OCDSAward();
        OCDSOrganizationReference org = new OCDSOrganizationReference();
        org.setId(contract.getFolioRupc());
        org.setName(contract.getProveedorContratista());
        org.setIdentifier(new OCDSIdentifier());
        org.getIdentifier().setId(contract.getFolioRupc());
        award.getSuppliers().add(org);
        award.setId(contract.getCodigoContrato());
        
        if (ocdsRoot.getReleases().isEmpty()) {
            OCDSRelease release = new OCDSRelease();
            ocdsRoot.addRelease(release);
        }
        ocdsRoot.getReleases().get(0).getAwards().add(award);

        mapOCID(contract, ocdsRoot);
        if (ocdsRoot.getReleases().get(0).getBuyer() == null) {
            mapBuyer(contract, ocdsRoot);
        }

        mapTender(contract, ocdsRoot);

        mapContract(contract, ocdsRoot);
        mapPlanning(contract, ocdsRoot);

        //return ocdsRoot;
    }

    private void mapPlanning(Contract contract, OCDSRecord ocdsRoot) {
        OCDSRelease ocdsRelease = ocdsRoot.getReleases().get(0);

        if (ocdsRelease.getPlanning() == null) {
            OCDSPlanning planning = new OCDSPlanning();
            OCDSBudget budget = new OCDSBudget();

            budget.setDescription(contract.getOrganismo());
            budget.setProject(contract.getClavePrograma());
            if (contract.getAportacionFederal()!= null) {
                OCDSValue value = new OCDSValue();
                value.setAmount(new BigDecimal(contract.getAportacionFederal()));
                budget.setAmount(value);
            }
            planning.setBudget(budget);
            ocdsRelease.setPlanning(planning);
        }
    }

    private void mapContract(Contract contract, OCDSRecord ocdsRoot) {
        OCDSRelease ocdsRelease = ocdsRoot.getReleases().get(0);

        OCDSContract ocdsContract = new OCDSContract();
        ocdsContract.setId(contract.getCodigoContrato());
        ocdsContract.setTitle(contract.getTituloContrato());

        OCDSPeriod period = new OCDSPeriod();

        period.setStartDate(parseDate(contract.getFechaInicio()));

        period.setEndDate(parseDate(contract.getFechaFin()));

        ocdsContract.setPeriod(period);

        OCDSValue value = new OCDSValue();

        if (contract.getImporteContrato() != null) {
            value.setAmount(new BigDecimal(contract.getImporteContrato()));
        }
        if (contract.getMoneda() != null) {
            try {
                value.setCurrency(Currency.getInstance(contract.getMoneda()));
            } catch (IllegalArgumentException ex) {
                log.warn("contract {} has an illegal currency value: {}, will be ignored", ocdsContract.getId(), contract.getMoneda());
            }
        }
        ocdsContract.setValue(value);

        ocdsContract.setStatus(OCDSContractStatus.convertFromMexico(contract.getEstatusContrato()));
        ocdsContract.setSigned(parseDate(contract.getFechaCelebracion()));

        ocdsRelease.getContracts().add(ocdsContract);

    }

    private void mapTender(Contract contract, OCDSRecord ocdsRoot) {
        OCDSRelease ocdsRelease = ocdsRoot.getReleases().get(0);
        OCDSTender tender = new OCDSTender();        
        tender.setId(contract.getCodigoExpediente());
        tender.setTitle(contract.getTituloExpediente());
        //tender.setProcurementMethod(OCDSProcedureMethod.valueOf(contract.getPlantillaExpediente()));
        //tender.setMainProcurementCategory(OCDSProcurementCategory.valueOf(contract.getTipoContratacion()));
        OCDSPeriod tenderPeriod = new OCDSPeriod();

        tenderPeriod.setStartDate(parseDate(contract.getProcFPublicacion()));
        tenderPeriod.setEndDate(parseDate(contract.getFechaAperturaProposiciones()));
        tender.setTenderPeriod(tenderPeriod);

        tender.addAdditionalProcurementCategory(OCDSAdditionalProcurementCategories.convertFromMexico(contract.getTipoContratacion()));
        tender.setMainProcurementCategory(OCDSMainProcurementCategory.convertFromMexico(contract.getTipoContratacion()));

        OCDSDocument document = new OCDSDocument();
        try{
            URL url = new URL(contract.getAnuncio());
            document.setUrl(url);
        } catch (MalformedURLException ex ) {
            log.warn("was not able to parse the url: {}", contract.getAnuncio());
        }
        tender.getDocuments().add(document);
        tender.setTenderPeriod(tenderPeriod);
        ocdsRelease.setTender(tender);

    }

    private void mapBuyer(Contract contract, OCDSRecord ocdsRoot) {
        //buyer
        OCDSOrganizationReference buyer = new OCDSOrganizationReference();
        buyer.setId(contract.getClaveuc());
        buyer.setName(contract.getNombreDeLaUc());

        OCDSIdentifier identifier = new OCDSIdentifier();
        identifier.setId(contract.getClaveuc());
        buyer.setIdentifier(identifier);

        OCDSContactPoint contactPoint = new OCDSContactPoint();
        contactPoint.setName(contract.getResponsable());
        buyer.setContactPoint(contactPoint);

        ocdsRoot.getReleases().get(0).setBuyer(buyer);
    }

    private void mapOCID(Contract contract, OCDSRecord ocdsRoot) {
        String numeroProcedimiento = contract.getNumeroProcedimiento();
        if (numeroProcedimiento != null && !numeroProcedimiento.isEmpty()) {
            String ocid = ocdsRoot.getReleases().get(0).getOcid();
            if (ocid ==null || ocid.isEmpty()) {
                ocdsRoot.getReleases().get(0).setOcid(numeroProcedimiento);
            } else {
                log.debug("the ocid value is already set to: {},  we can't overwrite with: {}", ocid, numeroProcedimiento);
            }
        }
    }
}
