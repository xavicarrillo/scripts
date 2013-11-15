#!/usr/bin/env python
#
__version__ = "0.2"

import smtplib, sys, MimeWriter, mimetypes, mimetools, base64
import os, StringIO
from optparse import OptionParser
from sys import stdin,exit

SERVER = 'localhost'
PORT = 25

def mail(sender='', to='', subject='', text='', attachments=None):
    message = StringIO.StringIO()
    writer = MimeWriter.MimeWriter(message)
    writer.addheader('To', to)
    writer.addheader('From', sender)
    writer.addheader('Subject', subject)
    writer.addheader('MIME-Version', '1.0')
    
    writer.startmultipartbody('mixed')
    
    # start with a text/plain part
    part = writer.nextpart()
    body = part.startbody('text/plain')
    part.flushheaders()
    body.write(text)

    # now add the attachments
    if attachments is not None:
        for a in attachments:
            filename = os.path.basename(a)
            ctype, encoding = mimetypes.guess_type(a)
            if ctype is None:
                ctype = 'application/octet-stream'
                encoding = 'base64'
            elif ctype == 'text/plain':
                encoding = 'quoted-printable'
            else:
                encoding = 'base64'
                
            part = writer.nextpart()
            part.addheader('Content-Transfer-Encoding', encoding)
            body = part.startbody("%s; name=%s" % (ctype, filename))
            mimetools.encode(open(a, 'rb'), body, encoding)

    # that's all falks
    writer.lastpart()

    # send the mail
    smtp = smtplib.SMTP(SERVER, PORT)
    smtp.set_debuglevel(1)
    smtp.sendmail(sender, to, message.getvalue())
    smtp.quit()


        
if __name__ == "__main__":
    
    usage = """%prog [options] \n Python tool to send e-mails. Intended to be used with nagios when no local smtp is available\nUse --help to view options"""
    
    parser = OptionParser(usage, version=__version__)
    
    parser.add_option("-m", "--message", action="store", dest="message", type="string", help="Body of the message. Default is Standard Input. If both are used, stdin will prevail")
    parser.add_option("-t", "--to", action="store", dest="to", type="string", help="list of destination addresses")
    parser.add_option("-f", "--from", action="store", dest="mailfrom", type="string", help="fake 'From:' header")
    parser.add_option("-r", "--replyto", action="store", dest="replyto", type="string", help="fake 'Reply-To:' header")
    parser.add_option("-s", "--subject", action="store", dest="subject", type="string", help="Subject for the email")
    parser.add_option("-a", "--attach", action="store", dest="attach", type="string", help="Attachment path")

    (options, args) = parser.parse_args()

    if not options.to:
        parser.error("'To:' address is mandatory")
    if not options.mailfrom:
        parser.error("'From:' is mandatory")
    if not options.replyto:
        options.replyto = options.mailfrom
    if options.attach:    
    	attach = [
		options.attach,
        	#"/home/xcarrillo/Desktop/evil-twin.png",
        	]
    
    	mail(sender=options.mailfrom, to=options.to,
         	subject=options.subject,
         	text=options.message,
         	attachments=attach)
    else:
	mail(sender=options.mailfrom, to=options.to,
                subject=options.subject,
                text=options.message)

