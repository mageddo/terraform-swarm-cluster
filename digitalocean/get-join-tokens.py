import sys
import json
import StringIO
from paramiko import SSHClient
from paramiko import RSAKey
from paramiko import AutoAddPolicy

args = json.load(sys.stdin)

client = SSHClient()
client.set_missing_host_key_policy(AutoAddPolicy())

f = open('/tmp/get-join-tokens.log', 'w')
f.write('args=');
f.write(str(args));
f.write('\n');

for host in args["hosts"].split(","):
	try:
		client.connect(host, username=args["user"], pkey = RSAKey.from_private_key(StringIO.StringIO(args["private_key"])), timeout = 15)
		stdin, stdf, stderr = client.exec_command('printf \'{"worker":"%s","manager":"%s"}\' `docker swarm join-token worker -q` `docker swarm join-token manager -q`')
		err, resp = stderr.readline(), stdf.readline()
		if err:
			print '{"worker": null,"manager": null}'
			f.write("error=" + err)
			sys.exit("error: " + err)
		else:
			print resp
			f.write("got it")
		break
	except:
		f.write("host=" + host + ", exception=" + str(sys.exc_info()[0]))
		pass

f.close()