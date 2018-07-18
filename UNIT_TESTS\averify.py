#c:\Python27 

import os, sys
import hashlib
import pickle
import configparser

settings = configparser.ConfigParser()
settings.read('config.ini')

# -------------------   remove lines with garbidge patterns ----------------------
with open('error.txt', 'a') as f1:
    for line in open('result.txt'):
        if 'PASSED' not in line and '-----------' not in line and '(0 rows affected)' not in line and 'Warning: Null' not in line and 'rows affected)' not in line and 'DBCC execution completed' not in line and 'Checking identity information:' not in line and 'Unit tests for' not in line:
            f1.write(line)

# -------------------   remove empty lines ----------------------
clean_lines = []
with open("error.txt", "r") as f:
    lines = f.readlines()
    clean_lines = [l.strip() for l in lines if l.strip()]

os.remove('error.txt')

with open("final.txt", "w") as f:
    f.writelines('\n'.join(clean_lines))

z = pickle.dumps(clean_lines)
checksum = hashlib.md5(z).hexdigest()

# -------------------   calc crc and do not match saved then send email with attach error file ----------------------
if settings.get('mail','crcstate') != checksum:
    print (checksum)
    os.system('python smtppart.py') 

