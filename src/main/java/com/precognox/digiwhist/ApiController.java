package com.precognox.digiwhist;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.JsonElement;
import com.precognox.digiwhist.input.mexico.csv.company.CompanyRUPCRepository;
import com.precognox.digiwhist.input.mexico.csv.contract.ContractRepository;
import com.precognox.digiwhist.input.mexico.csv.stateinstitution.StateInstitutionRepository;
import com.precognox.digiwhist.mapper.columbia.ColumbiaTenderMapper;
import com.precognox.digiwhist.mapper.mexico.ContratosMapper;
import com.precognox.digiwhist.output.extra.ExtraDataMapper;
import com.precognox.digiwhist.output.ocds.OCDSRecordPackage;
import com.precognox.digiwhist.output.ocds.OCDSReleasePackage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Optional;


@RestController
public class ApiController {

    @Autowired
    private CompanyRUPCRepository companyRepo;
    
    @Autowired
    private ContractRepository contractRepo;
    
    @Autowired
    private StateInstitutionRepository institutionRepo;

    @Autowired
    private ContratosMapper contratosMapper;
    
    @Autowired
    private ExtraDataMapper extraDataMapper;
    
    @Autowired
    private ColumbiaTenderMapper columbiaMapper;

    @GetMapping("/tender/{id}")
    public void getByID(@PathVariable("id") String id, HttpServletResponse response) throws IOException{
        Optional<JsonElement> mergeWithRaw = contratosMapper.mergeWithRaw(id);

        if (mergeWithRaw.isPresent()) {
            response.setStatus(200);
            response.getOutputStream().write(mergeWithRaw.get().toString().getBytes());
        } else {
            Optional<OCDSRecordPackage> mappedResult = contratosMapper.mapByID(id);
            if (mappedResult.isPresent()) {
                ObjectMapper om = new ObjectMapper();
                om.writeValue(response.getOutputStream(), mappedResult.get());
            } else {
                response.setStatus(400);
            }
        }

    }
    
    @GetMapping("/contratos/{id}")
    public void getContratosByID(@PathVariable("id") String id, HttpServletResponse response) throws JsonProcessingException, IOException{
                    Optional<OCDSRecordPackage> mappedResult = contratosMapper.mapByID(id);
            if (mappedResult.isPresent()) {
                ObjectMapper om = new ObjectMapper();
                om.writeValue(response.getOutputStream(), mappedResult.get());
            } else {
                response.setStatus(400);
            }        
    }
    
    @GetMapping("/extra/{id}")
    public void getExtraData(@PathVariable("id") String id,  HttpServletResponse response) throws IOException{
        ObjectMapper om = new ObjectMapper();
        om.writeValue(response.getOutputStream(), extraDataMapper.map(id));
        response.setStatus(200);
        response.flushBuffer();
    }
    
    @GetMapping("/rupc/count")
    public Object rupcCount() {
        return companyRepo.count();
    }

    @GetMapping("/contract/count")
    public Object contractCount() {
        return contractRepo.count();
    }
    
    @GetMapping("/institution/count")
    public Object getStateInstitutionCount() {
        return institutionRepo.count();
    }
    
    @GetMapping("/columbia/tender/{id}")
    public OCDSReleasePackage getColumbiaTenderByID(@PathVariable("id") String id){
        return columbiaMapper.mapByID(id);
    }
}
