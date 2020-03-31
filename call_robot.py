from subprocess import call, Popen
import sys
import os


def call_rpa(shipment_id, file_name):
    shipment_id=shipment_id[0]
    python_path = sys.executable
    robotFile_variable = "-v shipment_id:" + shipment_id
    print(python_path, '-m', 'robot', robotFile_variable, file_name)
    #command= python_path + '-m' + 'robot' + robotFile_variable + file_name
    #call([python_path, '-m', 'robot', robotFile_variable, file_name])
    p = Popen([python_path, '-m', 'robot', robotFile_variable, file_name], stdout=open(os.devnull, 'w'), stderr=open(os.devnull, 'w'))
    p.wait()
