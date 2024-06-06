#!/usr/bin/env python3

# Copyright 2021 Teros Technology!
#
# Ismael Perez Rojo ismaelprojo@gmail.com
# Carlos Alberto Ruiz Naranjo carlosruiznaranjo@gmail.com
# Alfredo Saez
#
# Colibri is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Colibri is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Colibri.  If not, see <https://www.gnu.org/licenses/>.

import yaml
import subprocess
import sys
from datetime import datetime


def git_clone(repository):
    cmd = 'git clone {}'.format(repository)
    cmd = [cmd]
    exec_command(cmd)


def execute_teroshdl(name, folder, output_type, vhdl_symbol, verilog_symbol):
    signal_extract = 'all'
    constants_extract = 'all'
    processes_extract = 'all'
    vhdl_symbol_cmd = f"--symbol_vhdl \"{vhdl_symbol}\""
    verilog_symbol_cmd = f"--symbol_verilog \"{verilog_symbol}\""

    output_path = f"./teroshdl_doc/{name}_doc"
    cmd = f"teroshdl-hdl-documenter --recursive -o {output_type} {vhdl_symbol_cmd} {verilog_symbol_cmd} --recursive --fsm -s {signal_extract} -c {constants_extract} -p {processes_extract} --dep --outpath {output_path} --input {folder}"
    exec_command(cmd)


def exec_command(cmd):
    p = subprocess.Popen(cmd, shell=True)
    p.wait()


def read_repositories(config_path):
    with open(config_path, 'r') as yaml_in:
        yaml_object = yaml.safe_load(yaml_in)
        return yaml_object


OUTPUT_TYPE = 'html'
if (len(sys.argv) > 1):
    OUTPUT_TYPE = sys.argv[1]

CONFIG_PATH = './config.yml'
now = datetime.now()
dt_string = now.strftime("%d/%m/%Y %H:%M:%S")
################################################################################
# HTML
################################################################################
if (OUTPUT_TYPE == 'html'):
    html_index = '<h1>Open Spectre Project:</h1>\n\n<ul>\n'
    html_index += f"Created: {dt_string}\n\n"
    repositories = read_repositories(CONFIG_PATH)
    for rep in repositories:
        name = rep
        repository = repositories[name]
        url = repository['url']
        folder = repository['folder']
        vhdl_symbol = repository['vhdl_symbol']
        verilog_symbol = repository['verilog_symbol']

        html_index += f"    <li>Project: <a href=\"{index.html\">{name}</a> (<a href=\"{url}\">go to Github project</a>) </li>\n"
        git_clone(url)
        execute_teroshdl(name, folder, OUTPUT_TYPE, vhdl_symbol, verilog_symbol)
    html_index += '</ul>\n'

    with open('teroshdl_doc/index.html', "w") as text_file:
        print(html_index, file=text_file)

################################################################################
# Markdown
################################################################################
if (OUTPUT_TYPE == 'markdown'):
    html_index = '# Open source projects:\n'
    html_index += f"Created: {dt_string}\n"
    repositories = read_repositories(CONFIG_PATH)
    for rep in repositories:
        name = rep
        repository = repositories[name]
        url = repository['url']
        folder = repository['folder']
        vhdl_symbol = repository['vhdl_symbol']
        verilog_symbol = repository['verilog_symbol']

        html_index += f"- Project: [{name} ](./gh_pages/README.md) ([go to Github project]({url}))\n"
        git_clone(url)
        execute_teroshdl(name, folder, OUTPUT_TYPE, vhdl_symbol, verilog_symbol)

    with open('teroshdl_doc/README.md', "w") as text_file:
        print(html_index, file=text_file)
