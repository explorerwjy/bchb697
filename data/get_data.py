#!/usr/bin/python
""" get protein data from Uniprot
    get gene data from HGNC
    get phenotype data from OMIM
    get Disease ontology data from DO
"""

import json
import urllib2
import re
from bs4 import BeautifulSoup
import urllib

def get_protein_list():
    files = ["skin_cancer_protein.tab","amyloidosis_proteins.tab"]
    protein_list = {}
    for file_ in files:
        hand = open(file_,'r')
        hand.readline()
        for l in hand:
            protein = l.split()[0]
            if protein not in protein_list:
                protein_list[protein] = 1
    protein_list = protein_list.keys()
    return protein_list

def get_protein():
    Uniprot_root = "http://www.uniprot.org/uniprot/"
    protein_list = get_protein_list()
    print protein_list
    for protein in protein_list:
        url = Uniprot_root + protein + ".xml"
        s = urllib2.urlopen(url)
        contents = s.read()
        myfile = open(protein+".xml", 'w')
        myfile.write(contents)
        myfile.close()
    return

def get_gene_list():
    gene_list = []
    handle = open("HGNC_ID.txt",'r')
    handle.readline()
    for l in handle:
        gene_id = l.split()[0]
        gene_list.append(gene_id)
    return gene_list

def get_gene():
    gene_list = get_gene_list()
    print gene_list
    HGNC_root = "http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id="
    for gene in gene_list:
        url = HGNC_root + gene
        html = urllib.urlopen(url).read()
        soup = BeautifulSoup(html,"html.parser")
        tmp = {}
        tmp["HGNC_id"] = gene
        for dl in soup.findAll('dl'):
            if dl['class'][0] == 'symbol_data':
                dds,dts = [],[]
                for dd in dl.findAll('dd'):
                    dds.append(dd.text.encode('utf-8').strip())
                for dt in dl.findAll('dt'):
                    dts.append(dt.text.encode('utf-8').strip())
            break
        flag = 0
        for i in xrange(0,len(dds)):
            if dts[i] == 'Approved symbol':
                tmp["Approved symbol"]=(";".join(dds[i].split(',')))
                flag = 1
                break
            if flag != 1:
                tmp["Approved symbol"] = "None"
        flag = 0
        for i in xrange(0,len(dds)):
            if dts[i] == 'Approved name':
                tmp["Approved name"]=(";".join(dds[i].split(',')))
                flag = 1
                break
            if flag != 1:
                tmp["Approved name"] = "None"
        flag = 0
        for i in xrange(0,len(dds)):
            if dts[i] == 'Synonyms':
                tmp["Synonyms"]=[i.strip().strip("\"") for i in (dds[i].split(','))]
                flag = 1
                break
            if flag != 1:
                tmp["Synonyms"] = "None"
        flag = 0
        for i in xrange(0,len(dds)):
            if dts[i] == 'Chromosomal location':
                tmp["Chromosomal location"]=(";".join(dds[i].split(',')))
                flag = 1
                break
            if flag != 1:
                tmp["Chromosomal location"] = "None"
        flag = 0
        for i in xrange(0,len(dds)):
            if dts[i] == 'Locus type':
                tmp["Locus type"]=(";".join(dds[i].split(',')))
                flag = 1
                break
            if flag != 1:
                tmp["Locus type"] = "None"
        flag = 0
        for i in xrange(0,len(dds)):
            if dts[i] == 'HCOP':
                tmp["HCOP"]=(";".join(dds[i].split(',')))
                flag = 1
                break
            if flag != 1:
                tmp["HCOP"] = "None"
        flag = 0
        with open(gene+".json",'w') as fout:
            fout.write(json.dumps(tmp))

def get_mim_list():
    handle = open("MIM_ID.txt",'r')
    mim_list = {}
    for l in handle:
        mim = l.split()[1]
        if mim not in mim_list:
            mim_list[mim] = 1
    mim_list = mim_list.keys()
    return mim_list

def get_mim():
    #example url like this:
    #http://api.omim.org/api/entry?mimNumber=616004&include=all&format=json
    ApiKey = "gMOJZFKsSlW4VrLPyjdDEg"#This key is temporary. Need a new key every time try to use OMIM API
    api_root = "http://api.omim.org/api/"
    format_ = "&format=json"
    url = ""
    mim_list = get_mim_list()
    print mim_list
    for mim in mim_list:
        entry = "entry?mimNumber="+mim+"&include=all"
        url = api_root+entry+format_+"&apiKey="+ApiKey
        print url
        s = urllib.urlopen(url)
        contents = s.read()
        myfile = open(mim+".json", 'w')
        myfile.write(contents)
        myfile.close()

def main():
    #get_protein()
    get_gene()
    #get_mim()
    #get_do()

if __name__ == "__main__":
    main()

