package com.precognox.digiwhist.mapper.mexico;

import com.precognox.digiwhist.input.mexico.csv.company.CompanyRUPC;
import com.precognox.digiwhist.input.mexico.csv.company.CompanyRUPCRepository;
import com.precognox.digiwhist.output.ocds.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.List;
import java.util.Set;

@Component
@Slf4j
public class CompanyMapper {

    @Autowired
    private CompanyRUPCRepository companyRepo;

    public OCDSRecord mapCompanies(OCDSRecord ocdsData) {

        mapAwards( ocdsData.getReleases().get(0).getAwards());

        return ocdsData;
    }

    private void mapAwards(List<OCDSAward> awardlist) {
        for (OCDSAward award : awardlist) {
            for (OCDSOrganizationReference organization : award.getSuppliers()) {
                Set<CompanyRUPC> companiesByFolioRUPC = companyRepo.getCompaniesByFolioRUPC(organization.getId());
                // normally we get only one, the rupc is unique in the db
                if (!companiesByFolioRUPC.isEmpty()) {
                    CompanyRUPC next = companiesByFolioRUPC.iterator().next();
                    organization = map(next, organization);
                } else {
                    // we have to try find it otherwise
                    // no idea yet
                }
            }
        }
    }

    private OCDSOrganizationReference map(CompanyRUPC company, OCDSOrganizationReference ocdsData) {
        OCDSIdentifier additionalOcdsIdentifier = new OCDSIdentifier();
        additionalOcdsIdentifier.setId(company.getRfc());
        ocdsData.getAdditionalIdentifiers().add(additionalOcdsIdentifier);

        OCDSAddress address = new OCDSAddress();
        address.setCountry(company.getCountryCode());
        address.setRegion(company.getFederalEntity());
        ocdsData.setAddress(address);
        if (ocdsData.getName() == null || ocdsData.getName().isEmpty()) {
            ocdsData.setName(company.getCompanyName());
        }

        OCDSContactPoint contactPoint = new OCDSContactPoint();
        String web = company.getWeb();
        if (web !=null && !web.isEmpty()) {
            // try to map the url to URL
            try {
                if (!web.startsWith("http")) {
                    web = "http://" + web;
                }
                URL url = new URL(web);

                contactPoint.setUrl(url);
            } catch (MalformedURLException e) {
                // the url seems to be wrong.. nothing big, we just ignore it
                log.warn("received some malformed url: {}, we ignore it", web);
            }
        }
        ocdsData.setContactPoint(contactPoint);
        return ocdsData;
    }
}
