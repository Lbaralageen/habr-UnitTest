import os
import io
import sys
import pymssql
import codecs
import configparser

settings = configparser.ConfigParser()
settings.read('config.ini')

infilename=settings.get('app','script')
outfilename='scriptdb.sql'
originaldb=settings.get('app','origindb')
newdbdb=originaldb

# -------------------   get the name of last created database ----------------------
conn = pymssql.connect(server=settings.get('app','server'), database=r'master')
cursor = conn.cursor()
cursor.execute("SELECT LEFT(replace(CAST(newid() AS sysname), '-', ''), 8) AS name")
row = cursor.fetchone()
while row:
    newdbdb = row[0]
    row = cursor.fetchone()
    break
conn.close()

print newdbdb

# -------------------   replace template database name with last created ----------------------

infile = codecs.open(infilename,'r', encoding='utf-16')
outfile = codecs.open(outfilename, 'w', encoding='utf-16')
for line in infile:
    fixed_line = line.replace(originaldb,newdbdb)
    outfile.write(fixed_line)
infile.close()
outfile.close()

# -------------------   save dbname to ini file                          ----------------------

inifile = open('dbname.ini', 'w')
inifile.write('dbname=' + newdbdb)
inifile.close()
