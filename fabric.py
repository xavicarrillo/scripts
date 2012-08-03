from __future__ import with_statement
from fabric.api import *
import fabric.contrib
import paramiko
import socket
 
### How to run ###
#	fab multiplehosts deploy

env.user = 'xcarrillo'
env.password = 'mypass'
env.warn_only = True # To continue after errors

def ntpd_status():
    run('/sbin/service ntpd status')
    run('/sbin/chkconfig --list ntpd')
 
def multiplehosts():
    """Loads a group of hosts from a config file.
    hostsfile: name of the group file, one host per line
    """
    hostsfile = 'non-prod-linux-no-puppet.csv'
    base_dir = './'
    from os.path import join, abspath, expanduser
    filename = abspath(expanduser(join(base_dir, hostsfile)))
    try:
        fhosts = open(filename)
    except IOError:
        abort('file not found: %s' % filename)
 
    def has_data(line):
        """'line' is not commented out and not just whitespace."""
        return line.strip() and not line.startswith('#')
 
    env.hosts = [ line.strip() for line in fhosts
                        if has_data(line)]
 
def _is_host_up(host, port):
    # Set the timeout
    original_timeout = socket.getdefaulttimeout()
    new_timeout = 3
    socket.setdefaulttimeout(new_timeout)
    host_status = False
    try:
        transport = paramiko.Transport((host, port))
        host_status = True
    except:
        print('=== Warning ===  Host {host} on port {port} is down.'.format(
            host=host, port=port)
        )
    socket.setdefaulttimeout(original_timeout)
    return host_status

def host_type():
    run('uname -s')

def hello():
    print("Hello world!")

def change_password(user,password):
    crypted_password = crypt(password, 'salt')
    sudo('usermod --password %s %s' % (crypted_password, user), pty=False)

def update_history():
	sudo("wget http://inventory-1.mit.esportz.com/downloads/history.sh -O /etc/profile.d/history.sh")
	sudo("chmod +x /etc/profile.d/history.sh")

def deploy():
    if _is_host_up(env.host, int(env.port)) is True:
    	try:
			update_history()
			update_logrotate()
    	except:
        	print("=== Warning, couldn't execute the command ===")
