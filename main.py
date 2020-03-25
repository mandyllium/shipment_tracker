import time
from MYSQlWrapper import MySql_Wrapper

def main_call(mysql_obj):
    #try:
    mysql_obj.shipment_id()

    #except Exception:
    print("Hit again after 120 seconds")
    time.sleep(120)
    main_call(mysql_obj)

if __name__ == '__main__':
    mysql = MySql_Wrapper()
    main_call(mysql)

