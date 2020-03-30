import mysql.connector
from mysql.connector import Error
from db_details import db_details
from call_robot import call_rpa
from filename_list import filename_list



class MYSQlWrapper:
    def db_connect(self):
        self.connection = mysql.connector.connect(host=db_details["host"],
                                             database=db_details["database"],
                                             user=db_details["user"],
                                             password=db_details["psswd"])
        if self.connection.is_connected():
            print("Connected to MySQL Server version ")
            self.cursor = self.connection.cursor()
        else:
            print("Could not connect")


    def shipment_id(self):
        self.db_connect()
        get_shipment_id_query="select * from track_ids order by shipment_id ASC"
        self.cursor.execute(get_shipment_id_query)
        track_ids = self.cursor.fetchall()
        for id in track_ids:
            if id[0][:3] in filename_list and len(id[0]) == 11:
                robot_filename = id[0][:3]+'.robot'
                call_rpa(id, robot_filename)
            else:
                continue
        print("All ids in track_ids table checked.") #\n Rerun after 10 mins")
        self.connection.close()
        #time.sleep(600)
        #self.shipment_id()


    def delete_entry(self, shipment_id):
        self.db_connect()
        delete_query= "delete from track_ids where shipment_id like '{0}'".format(shipment_id)
        self.cursor.execute(delete_query, shipment_id)
        print("Entry Deleted")
        self.connection.commit()


    def check_entry(self, shipment_id):
        self.db_connect()
        check_query = "select * from shipment_status where shipment_id like '{0}'".format(shipment_id)
        self.cursor.execute(check_query, shipment_id)
        check = self.cursor.fetchall()
        if len(check) > 0:
            return True
        else:
            return False


    def send_to_DB(self, shipment_id, current_status, current_remarks, status_string):
        self.db_connect()
        insert_query='''insert into shipment_status 
                        (shipment_id, current_status, current_remarks, track_history)
                        values ('{0}','{1}','{2}','{3}')'''. format(shipment_id, current_status, current_remarks, status_string)

        update_query='''update shipment_status 
                     set current_status='{0}', current_remarks= '{1}', track_history= '{2}' 
                     where shipment_id like '{3}' '''. format(current_status, current_remarks, status_string, shipment_id)

        status = current_status.lower()
        if 'delivered' in status or 'dlv' in status and 'documents delivered' not in status:
            self.delete_entry(shipment_id)
            if self.check_entry(shipment_id):
                self.cursor.execute(update_query)
            else:
                self.cursor.execute(insert_query)
        else:
            if self.check_entry(shipment_id):
                self.cursor.execute(update_query)
            else:
                self.cursor.execute(insert_query)
        self.connection.commit()
        self.connection.close()