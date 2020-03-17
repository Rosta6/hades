# Tento program slouží k tvorbě tabulek pro AKIKO a následně ke generování knihoven pro ANDREU
# Je určen ke čtení souborů ze SERPENTU
# V první verzi bude mít definované proměnné přímo zde v hlavičce souboru, v pozdější verzi bude umět číst vstupní soubor či jinak načítat data

# Vytvořeno: Rostislav Kubín, ORF UJV Řež

# spuštění AKIKO: ../../../../haf/sw/andrea/bin/akiko --serial  --kinetics-data endfb6 --debug --dir data --no-features --development --skip-errors


# Blok s načtením všech knihoven
require_relative 'libs/loadFiles'
require_relative 'libs/createTables'

# Blok inicializace proměnných potřebných ke čtení dat se serpentu
path = "./rawdata"
detektoryPath = []          #pole s odkazy na soubory detektorů
dataDetektory = {}
dataRes = {}
nazevSlozky = "table_model3D"
nazevCasti = "a07A_bottom"
stav = "HOT-REF"

# musí být nutně srovnané za sebou tak jak jdou ve výstupním souboru!!
detektory = ["DET2", "DET1","DETmod_flux1", "DETmod_flux0","DETtot_flux1", "DETtot_flux0", "DETcurr_in1","DETcurr_in0","DETcurr_out1","DETcurr_out0", "DET10Bxs1", "DET10Bxs0",
             "DET135XExs1", "DET135XExs0", "DET149SMxs1", "DET149SMxs0","DET149PMxs1","DET149PMxs0","DET135Ixs1","DET135Ixs0","DET147NDxs1","DET147NDxs0","DET148NDxs1","DET148NDxs0",
             "DET147PMxs1","DET147PMxs0","DET148PMxs1","DET148PMxs0","DET11Bxs1","DET11Bxs0"]
# musí být nutně srovnané za sebou tak jak jdou ve výstupním souboru!!
veliciny = ["INF_KINF", "INF_TOT", "INF_ABS", "INF_FISS", "INF_NSF","INF_KAPPA","INF_DIFFCOEF","INF_I135_YIELD" ,"INF_XE135_YIELD" ,"INF_PM149_YIELD" ,"INF_SM149_YIELD", "INF_S0"]
# tady jsou hodnoty pro soubor GLOBAL -> musím zjistit kde je vzít ap ak je načtu do hototo pole
hodnotyGlobal = ["4.86932e+02","1.42959e+02","2.74384e+02","2.74384e+02","4.0452","7.14031e-03"]
# tady jsou hodnoty vyhoření v MWd/kgU?? 
vyhoreni = ["0.0"]

# převod stavu na číslo (podle toho o jaký odskok jde)
STAVY = {
    "HOT:MODM"  => "0",
    "HOT-REF" => "1",
    "HOT:MODP" => "2",
    "HOT-POW0" => "3"
}

stavNumber = STAVY[stav].to_i
stavDet = stavNumber + 1                # číslo pro název detektoru a výber správných hodnot

# Vlastní struktura programu
overSlozku(path)

# blok na čtení obsahu files
detPath = "#{path}/*det1b#{stavDet}*"                       # tady hledáme pouze file s detektorem, sem mohu přidat #{i}, kde i bude stupeň vyhoření!
detektoryPath = zjistiObsah(detPath)

for i in 0...detektoryPath.size
    dataDetektory = prectiDetektory(detektoryPath[i],detektory) 
end
dataRes = prectiResFile(veliciny,dataRes)  


# blok na tvorbu table pro AKIKO 
vytvorSlozky(nazevCasti,nazevSlozky,stav)
path = "#{nazevSlozky}/data/#{nazevCasti}/#{nazevCasti}.tables"
createGlobalTable(path,hodnotyGlobal)
createBasicTable(path,vyhoreni,stav,dataRes,stavNumber)
createMacroTable(path,vyhoreni,stav,dataRes,stavNumber)
createMicroTable(path,vyhoreni,stav,dataDetektory)
createNdTable(path,vyhoreni,stav)
createYieldsTable(path,vyhoreni,stav,dataRes,stavNumber)


puts "Process complete!"







