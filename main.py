import time
from MYSQlWrapper import MYSQlWrapper

def main_call(mysql_obj):
    try:
        mysql_obj.shipment_id()

    except Exception:
        print("Hit again after 120 seconds")
        time.sleep(120)
        del(mysql_obj)
        mysql_obj = MYSQlWrapper()
        main_call(mysql_obj)

    finally:
        print("Hit again after 3 seconds")
        time.sleep(3)
        del (mysql_obj)
        mysql_obj = MYSQlWrapper()
        main_call(mysql_obj)


if __name__ == '__main__':
    mysql = MYSQlWrapper()
    main_call(mysql)

