# Tento soubor obsahuje funkce pro čtení souborů ze SERPENTU
# TO DO
#      - přejmenovat tento modul na nějaké zajímavější jméno :D

def overSlozku(path)   #oveří existenci složky rawdata na zadané cestě, vrací true a false
    if(Dir.exist?(path))
        puts path                           #if true -> vypíše cestu ke složce se soubory
        return true
    else
        puts "Dir with data not found!"     #if false -> vypíše chybu a ukončí běh programu
        exit
    end
end

def zjistiObsah(path) #zjistí obsah složky a vrátí pole s odkazy na soubory které jsou zrovna hledané
    folderContent = []
    Dir[path].each  do |filename|
        folderContent << filename
    end
    if(folderContent.empty?)
        puts "No files in directory!"
        exit
    end
    folderContent
end


 # Přečte data z detektorů v příslušném souboru a vrací pole obsahující [hodnotu, chybu] a klíč je název detektoru
def prectiDetektory(file,detektory)
    nactena_data = {}                    # prázdné pole
    i = 0
    hodnota_cteni = 0                    # když najdu správný název, tak pak na dalším řádku jsou data
    File.open(file).each do |line|
        if(hodnota_cteni == 1)
            zapis = line.split(" ")
            zapis = "#{zapis[10]} #{zapis[11]}"         # data jsou poslední 2 hodnoty
            zapis = zapis.split(" ")
            nactena_data[detektory[i-1]] ||= []
            nactena_data[detektory[i-1]] << zapis
            hodnota_cteni = 0
        end
        data = line.split(" ")
        if(detektory[i] == data[0] && i <detektory.size)
            i += 1
            hodnota_cteni = 1
        end
    end
    nactena_data
end


# přečte res soubor a prací mi hash stavů odskoků -> zajímá mě teď nominální stav, což je 1 hodnota
def prectiResFile(veliciny,data_soubor)
    counter = 0
    File.open("rawdata/vver_burnup_res.m").each do |line|
        nacteno = line.split(" ")
        if(nacteno[0] == veliciny[counter] && counter != (veliciny.size-1) && counter != 0)
            data_soubor[nacteno[0]] ||= []
            tmp = "#{nacteno[6]} #{nacteno[7]} #{nacteno[8]} #{nacteno[9]}"
            zapis = tmp.split(" ")
            data_soubor[nacteno[0]] << zapis
            counter += 1
        elsif(nacteno[0] == veliciny[counter] && counter == (veliciny.size-1))
            data_soubor[nacteno[0]] ||= []
            tmp = "#{nacteno[6]} #{nacteno[7]} #{nacteno[8]} #{nacteno[9]} #{nacteno[10]} #{nacteno[11]} #{nacteno[12]} #{nacteno[13]}"
            zapis = tmp.split(" ")
            data_soubor[nacteno[0]] << zapis
            counter += 1
        elsif(nacteno[0] == veliciny[counter] && counter == 0)
            data_soubor[nacteno[0]] ||= []
            tmp = "#{nacteno[6]} #{nacteno[7]}"
            zapis = tmp.split(" ")
            data_soubor[nacteno[0]] << zapis
            counter += 1
        end
        if(counter > (veliciny.size-1))
            counter = 0
        end
    end
        data_soubor["INF_KAPPA"][1][0] = data_soubor["INF_KAPPA"][1][0].to_f*data_soubor["INF_FISS"][1][0].to_f*0.0000000000001602
        data_soubor["INF_KAPPA"][1][2] = (data_soubor["INF_KAPPA"][1][2].to_f*data_soubor["INF_FISS"][1][2].to_f*0.0000000000001602)
        data_soubor
end
    