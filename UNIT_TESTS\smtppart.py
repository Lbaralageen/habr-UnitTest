#c:\Python27 

#-- https://www.tutorialspoint.com/python/python_sending_email.htm
import smtplib
import base64
import configparser
from smtplib import SMTPException

settings = configparser.ConfigParser()
settings.read('config.ini')
filename = "result.txt"

# Read a file and encode it into base64 format
fo = open(filename, "rb")
filecontent = fo.read()
encodedcontent = base64.b64encode(filecontent)  # base64

sender = settings.get('mail','sender')
receivers = [settings.get('mail','receiver')]

marker = "AUNIQUEMARKER"

body = settings.get('mail','crcstate') + """
Do not replay!
"""
# Define the main headers.
part1 = """Broken TSQL unit test
To: To Person <auto.test@company.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary=%s
--%s
""" % (marker, marker)

# Define the message action
part2 = """Content-Type: text/plain charset=ISO-8859-1 
Content-transfer-encoding:QUOTED-PRINTABLE

%s
--%s
""" % (body,marker)

# Define the attachment section
TEXT = """Content-Type: multipart/mixed; name=\"%s\"
Content-Transfer-Encoding:base64
Content-Disposition: attachment; filename=%s

%s
--%s--
""" %(filename, filename, encodedcontent, marker)
message = 'Subject: ' + part1 + part2 + TEXT

#smtpObj = smtplib.SMTP(u'smtp.habr.com', int(smtpport))

try:
   smtpsrv = settings.get('mail','smtp')
   smtpport = settings.get('mail','smtpport')   
   smtpObj = smtplib.SMTP(smtpsrv, int(smtpport))
   smtpObj.sendmail(sender, receivers, message)         
   print ("Successfully sent email")
except SMTPException:
   print ("Error: unable to send email")
