# digiextractor

a small rest service, which is capable of creating ocds standard json from imported data (database)

# some technical infos

The tool is written with spring-boot, to start is simple, just run bootRun gradle task. However it will require a database and data too. In this repository the data itself is not included.
The database can be started with the docker-compose file (docker-compose up -d) or in case you have a db running, configure it here: src/main/resources/application.yml

# important endpoints

## mexico endpoints
* */tender/{tenderid}* produces the tender infos in ocds json format, {tenderid) is the id of the tender we need info from
* */extra/{tenderid}* produces a json with extra informations, {tenderid) is the id of the tender we need info from

## columbia endpoints
* */columbia/tender/{tenderid}* produces the tender infos in ocds json format (however somewhat different as the mexican ones), {tenderid) is the id of the tender we need info from

# other tools

In helper_scripts directory you can find some bash scripts, which were used to generate the final result
* *mexico_ocds_downloader.sh*, downloads from our rest service the generated (and merged) data in ocds json format. The script requires an id list to run on
* *makeonebig.sh*, iterates over the downloaded files and copies into bigger files (unfortunatly the flatten-tool is not capable of processing really large files).
* *flattenall.sh*, iterates over the bigger json files created by previous step and run the flatten-tool with each file
* *mergeflattened.sh*, iterates over the flattened directories/files and merges them
