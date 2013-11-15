#!/usr/bin/python
# -*- coding: utf-8 -*-
#
# obrim un arxiu de texte. cada linea conte un nom d'arxiu
# obrim cada un d'ells i imprimim totes les variables php (paraules que comencin per $)

arxius="./arxius"
def main():
    FD = open(arxius, 'r')
    for arxiu in FD:
	arxiu = arxiu.replace("\n","")
	print "##########"
	print arxiu
	print "##########"
        FD2 = open(arxiu, 'r')
        for line in FD2:
            lineaArray = line.split()
            for element in lineaArray:
                if element.startswith("$"):
                    print element

     	FD2.close()
    FD.close()

if __name__ == "__main__":
    main()
