# Tento soubor se stará o tvorbu textových souborů s daty a o tvorbu složek

# TO DO
#      - přejmenovat tento modul na nějaké zajímavější jméno :D

# vytvoří strukturu složek
def vytvorSlozky(nazevCasti,nazevSlozky,stav)
    Dir.mkdir("#{nazevSlozky}") unless File.exists?("#{nazevSlozky}")
    Dir.mkdir("#{nazevSlozky}/data") unless File.exists?("#{nazevSlozky}/data")
    Dir.mkdir("#{nazevSlozky}/data/#{nazevCasti}") unless File.exists?("#{nazevSlozky}/data/#{nazevCasti}")
    #do níže vytvořené složky je třeba před AKIKO nakopírovat info file z heliosu pro ten stav!
    Dir.mkdir("#{nazevSlozky}/data/#{nazevCasti}/#{nazevCasti}.tables") unless File.exists?("#{nazevSlozky}/data/#{nazevCasti}/#{nazevCasti}.tables")
    Dir.mkdir("#{nazevSlozky}/data/#{nazevCasti}/#{nazevCasti}.tables/#{stav}") unless File.exists?("#{nazevSlozky}/data/#{nazevCasti}/#{nazevCasti}.tables/#{stav}")
end

# tvoří tabulku GLOBAL 
def createGlobalTable(path,hodnoty)
    nazvy = ["area_system","area_fuel","area_moderator","area_moderator_roded","hm_mass","enrichment"]
    file = File.new("#{path}/global", "w")

    for i in 0...nazvy.size
        file.printf("%-29s%f\n",nazvy[i], hodnoty[i])
    end

    file.close
end

# tvoří tabulku BASIC   
def createBasicTable(path,vyhoreni,stav,dataRes,stavNumber)
    veliciny = ["burnup","kinf"]
    file = File.new("#{path}/#{stav}/basic", "w")

    for i in 0...veliciny.size
        file.printf("%-29s",veliciny[i])
    end

    file.printf("\n")
    for i in 0...vyhoreni.size
        file.printf("%-29f",vyhoreni[i]) # krok vyhoření
        file.printf("%-29f",dataRes["INF_KINF"][stavNumber][0]) 
    end

    file.close
end

# tvoří tabulku MACRO
def createMacroTable(path,vyhoreni,stav,dataRes,stavNumber)
    veliciny = ["burnup","sa^1","sa^2","sf^1","sf^2","nf^1","nf^2","kf^1","kf^2","d^1","d^2","chi^1","chi^2","ss^1^1","ss^1^2","ss^2^1","ss^2^2"]
    file = File.new("#{path}/#{stav}/macro", "w")

    for i in 0...veliciny.size
        file.printf("%-29s",veliciny[i])
    end
    
    file.printf("\n")
    for i in 0...vyhoreni.size
        file.printf("%-29f",vyhoreni[i]) # krok vyhoření
        file.printf("%-29f%-29f",dataRes["INF_ABS"][stavNumber][0],dataRes["INF_ABS"][stavNumber][2])
        file.printf("%-29f%-29f",dataRes["INF_FISS"][stavNumber][0],dataRes["INF_FISS"][stavNumber][2])
        file.printf("%-29f%-29f",dataRes["INF_NSF"][stavNumber][0],dataRes["INF_NSF"][stavNumber][2])
        file.printf("%-29e%-29e",dataRes["INF_KAPPA"][stavNumber][0],dataRes["INF_KAPPA"][stavNumber][2])
        file.printf("%-29f%-29f",dataRes["INF_DIFFCOEF"][stavNumber][0],dataRes["INF_DIFFCOEF"][stavNumber][2])
        file.printf("%-29f%-29f","1","0")
        file.printf("%-29f%-29f%-29f%-29f",dataRes["INF_S0"][stavNumber][0],dataRes["INF_S0"][stavNumber][2],dataRes["INF_S0"][stavNumber][4],dataRes["INF_S0"][stavNumber][6])
    end
    
    file.close
end

# tvoří tabulku MICRO
def createMicroTable(path,vyhoreni,stav,dataDetektory)
    veliciny = ["burnup","a_xe135^1","a_xe135^2 ","a_nd147^1","a_nd147^2","a_nd148^1","a_nd148^2","a_pm147^1","a_pm147^2","a_pm148^1","a_pm148^2","a_pm148m^1","a_pm148m^2","a_pm149^1","a_pm149^2","a_sm149^1","a_sm149^2","a_b10^1","a_b10^2","a_b11^1","a_b11^2"]
    file = File.new("#{path}/#{stav}/micro", "w")

    nula = 0

    for i in 0...veliciny.size
        file.printf("%-29s",veliciny[i])
    end
    
    file.printf("\n")
    for i in 0...vyhoreni.size
        file.printf("%-29f",vyhoreni[i]) # krok vyhoření
        file.printf("%-29f%-29f",dataDetektory["DET135XExs1"][0][0],dataDetektory["DET135XExs0"][0][0])
        file.printf("%-29f%-29f",dataDetektory["DET147NDxs1"][0][0],dataDetektory["DET147NDxs0"][0][0]) #nd147
        file.printf("%-29f%-29f",dataDetektory["DET148NDxs1"][0][0],dataDetektory["DET148NDxs0"][0][0]) #nd148 
        file.printf("%-29f%-29f",dataDetektory["DET147PMxs1"][0][0],dataDetektory["DET147PMxs0"][0][0]) #pm147
        file.printf("%-29f%-29f",dataDetektory["DET148PMxs1"][0][0],dataDetektory["DET148PMxs0"][0][0]) #pm148
        file.printf("%-29f%-29f",nula,nula) #pm148m
        file.printf("%-29f%-29f",dataDetektory["DET149PMxs1"][0][0],dataDetektory["DET149PMxs0"][0][0]) 
        file.printf("%-29f%-29f",dataDetektory["DET149SMxs1"][0][0],dataDetektory["DET149SMxs0"][0][0]) 
        file.printf("%-29f%-29f",dataDetektory["DET10Bxs1"][0][0],dataDetektory["DET10Bxs0"][0][0])
        file.printf("%-29f%-29f",dataDetektory["DET11Bxs1"][0][0],dataDetektory["DET11Bxs0"][0][0]) #n11
    end
    
    file.close
end

# vytvoří tabulku ND
def createNdTable(path,vyhoreni,stav)
    file = File.new("#{path}/#{stav}/nd", "w")

    file.puts("b10")
    for i in 0...vyhoreni.size
        file.puts("4.10460e-06")
    end

    file.close
end

# tvoří tabulku YIELDS
def createYieldsTable(path,vyhoreni,stav,dataRes,stavNumber)
    veliciny = ["yield_i135","yield_nd147","yield_nd148","yield_pm149","yield_xe135"]
    file = File.new("#{path}/#{stav}/yields", "w")

    for i in 0...veliciny.size
        file.printf("%-29s",veliciny[i])
    end
    
    file.printf("\n")
    for i in 0...vyhoreni.size
        zapis = (dataRes["INF_I135_YIELD"][stavNumber][0].to_f+dataRes["INF_I135_YIELD"][stavNumber][2].to_f)/2  # průměruji výtěžek těch dvou energetických grup
        file.printf("%-29f",zapis)
        file.printf("%-29f","0") #nd147
        file.printf("%-29f","0") #nd148
        zapis = (dataRes["INF_PM149_YIELD"][stavNumber][0].to_f+dataRes["INF_PM149_YIELD"][stavNumber][2].to_f)/2  # průměruji výtěžek těch dvou energetických grup
        file.printf("%-29f",zapis)
        zapis = (dataRes["INF_XE135_YIELD"][stavNumber][0].to_f+dataRes["INF_XE135_YIELD"][stavNumber][2].to_f)/2  # průměruji výtěžek těch dvou energetických grup
        file.printf("%-29f",zapis)
    end
    
    file.close
end