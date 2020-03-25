from subprocess import call
import sys


def call_rpa(shipment_id, file_name):
    python_path = sys.executable
    robotFile_variable = "-v shipment_id:" + shipment_id
    print(python_path, '-m', 'robot', robotFile_variable, file_name)
    call([python_path, '-m', 'robot', robotFile_variable, file_name])
