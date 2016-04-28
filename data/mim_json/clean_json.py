#!/usr/bin/python
import json
from sys import argv

def clean_key_name(js):
    if type(js) != dict:
        #print type(js)
        return js
    tmp = {}
    for k,v in js.items():
        if "{http://uniprot.org/uniprot}" in k:
            new_key_name = k.replace("{http://uniprot.org/uniprot}","")
            js.update(new_key_name=js.pop(k))
            tmp[new_key_name]=clean_key_name(v)
        elif v !='\n':
            tmp[k] = clean_key_name(v)
    return tmp

def main():
    file_name = argv[1]
    handle = open(file_name,'r')
    out_name = file_name+".cleaned"
    fout = open(out_name,'w')
    js = json.loads(handle.read())
    js = js["omim"]["entryList"][0]["entry"]
    #print js
    """
    for k,v in js.items():
        print k
        print v
    """
    js = json.dumps(js)
    fout.write(js)


if __name__=="__main__":
    main()
