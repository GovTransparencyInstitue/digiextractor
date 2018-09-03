package com.precognox.digiwhist.input.mexico.json;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(schema = "digiwhist_parse_raw", name = "raw_json_with_tender_id")
@Getter
@Setter
public class RawResult {

    @Id
    @Column(name = "tender_id")
    private String id;
    private String raw_data;
}
