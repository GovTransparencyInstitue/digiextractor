#!/bin/bash
for filename in d*; do
sed 1d $filename/flattened/rel_awa_suppliers.csv >> merge/rel_awa_suppliers.csv;
sed 1d $filename/flattened/rel_awards.csv >> merge/rel_awards.csv;
sed 1d $filename/flattened/rel_buy_additionalIdentifiers.csv >> merge/rel_buy_additionalIdentifiers.csv;
sed 1d $filename/flattened/rel_contracts.csv >> merge/rel_contracts.csv;
sed 1d $filename/flattened/rel_ten_documents.csv >> merge/rel_ten_documents.csv;
sed 1d $filename/flattened/rel_ten_items.csv >> merge/rel_ten_items.csv;
sed 1d $filename/flattened/releases.csv >> merge/releases.csv;
done
 
