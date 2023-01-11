from flask import Flask
from flask import request
from jinja2 import Template, FileSystemLoader, Environment
import subprocess
import os

app = Flask(__name__)


@app.route('/version')
def version():
	return "0.1.0"


def get_arguments(request):
	""" Get arguments from the request.
	"""
	args, kwargs = [], {}
	if request.is_json:
		json = request.get_json()
		if isinstance(json, str) and len(json) > 0:
			args = [json]
		elif isinstance(json, list):
			args = json
		elif isinstance(json, dict):
			kwargs = json
			if 'args' in kwargs:
				args = kwargs.pop('args')
	elif len(request.form) > 0:
		if 'args' in request.form:
			args = request.form.getlist('args')
		else:
			kwargs = request.form.to_dict()
	elif len(request.args) > 0:
		if 'args' in request.args:
			args = request.args.getlist('args')
		else:
			kwargs = request.args.to_dict()
	return list(args), kwargs

# @app.route('/exec', methods=['GET', 'POST', 'OPTIONS'])
# def script():
# 	args, kwargs = get_arguments(request)

# 	file_loader = FileSystemLoader('templates')
# 	env = Environment(loader=file_loader)
# 	template = env.get_template('nest_adapter.py.template')
# 	output = template.render(NEST_DESKTOP_SCRIPT=kwargs['source'])
# 	with open("nest_adapter.py", "w") as f:
# 		f.write(output)
# 	return output


@app.route('/start_cosim')
def start_cosim():
	os.system('bash /home/vagrant/shared_data/cosim_launch_local_dev.sh')
	return "Success"


if __name__ == '__main__':
	app.run(host="0.0.0.0", port="52428")
