#!/usr/bin/python
import os.path
import json

def get_gene(gene_id):
    try:
        hand = open(gene_id+".json")
        gene = json.loads(hand.read())
        return gene
    except:
        print "Cant find gene",gene_id,"file under this dictionary."
        return None

def get_mim(mim_list):
    MIM = []
    for mim in mim_list:
        file_name = mim+".json.cleaned"
        try:
            hand = open(file_name,'r')
            mim = json.loads(hand.read())
            MIM.append(mim["phenotypeMapList"][0]["phenotypeMap"])
        except:
            print "mim file",file_name,"Not find"
            continue
    return MIM

def make_protein():
    protein = []
    for root,dirs,files in os.walk("./"):
        for my_file in files:
            if (my_file[0] in '1234567890') or (my_file[-8:] != ".cleaned"):
                continue
            print "Conctructing",my_file
            hand = open(my_file,'r')
            record = json.loads(hand.read())
            new_record = {}

            try:
                new_record["Uniprot_ID"] = record["accession"][0]["#text"]
            except:
                pass
            try:
                new_record["Uniprot_ID"] = record["accession"][0]["#text"]
            except:
                pass

            recommendedName = {}
            recommendedName["fullName"]=record["protein"]["recommendedName"]["fullName"]["#text"]
            try:
                recommendedName["shortName"]=[]
                for shortname in record["protein"]["recommendedName"]['shortName']:
                    recommendedName["shortName"].append(shortname["#text"])
            except:
                pass
            new_record["recommendedName"] = recommendedName
            alternativeName = []
            try:
                for altname in record["protein"]["alternativeName"]:
                    try:
                        alternativeName.append(altname["{http://uniprot.org/uniprot}fullName"]["#text"])
                    except:
                        pass
                    try:
                        alternativeName.append(altname["{http://uniprot.org/uniprot}fullName"]["#text"])
                    except:
                        pass
            except:
                pass

            new_record["alternativeName"] = alternativeName
            
            #new_record[""] = record
            new_record["name"]=record["name"]["#text"]
            
            sequence = {}
            sequence["length"] = record["sequence"]["@length"]
            sequence["mass"] = record["sequence"]["@mass"]
            sequence["seq"] = record["sequence"]["#text"]
            new_record["sequence"]=sequence
            
            MIM_list = []
            HGNC = ""
            for item in record["dbReference"]:
                if item["@type"] == "MIM":
                    MIM_list.append(item["@id"])
                if item["@type"] == "HGNC":
                    HGNC = item["@id"].split(":")[1]
            new_record["Gene"] = get_gene(HGNC)
            new_record["MIM_phenotype"] = get_mim(MIM_list)
            protein.append(json.dumps(new_record))
        with open("protein.json",'w') as fout:
            for item in protein:
                fout.write(item+"\n")
        


def main():
    make_protein()
    return

if __name__=="__main__":
    main()

