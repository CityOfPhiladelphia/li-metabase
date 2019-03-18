import sys
import datetime
import os

import petl as etl

from li_dbs import (
    ECLIPSE_PROD, LIDB, GISLNI, DataBridge, GISLICLD
)
from sql_queries import queries


class CursorProxy(object):
    '''Required to use petl with cx_Oracle https://petl.readthedocs.io/en/stable/io.html#databases'''
    def __init__(self, cursor):
        self._cursor = cursor
    def executemany(self, statement, parameters, **kwargs):
        parameters = list(parameters)
        return self._cursor.executemany(statement, parameters, **kwargs)
    def __getattr__(self, item):
        return getattr(self._cursor, item)

def get_cursor(conn):
    return CursorProxy(conn.cursor())

def get_logger():
    import logging
    
    logger = logging.getLogger(__name__)
    logger.setLevel(logging.INFO)

    # Create a file handler
    handler = logging.FileHandler('log.txt')
    handler.setLevel(logging.INFO)

    # Create a logging format
    formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
    handler.setFormatter(formatter)
    
    logger.addHandler(handler)

    return logger

def send_email(failed):
    from email.mime.text import MIMEText
    from phila_mail import server

    recipientslist = ['peter.dannemann@Phila.gov', 
                      'dani.interrante@phila.gov', 
                      'philip.ribbens@phila.gov',
                      'shannon.holm@phila.gov']
    sender = 'ligisteam@phila.gov'
    body = 'AUTOMATIC EMAIL: \n' + '\n\nThe following tables failed to update:\n\n' + ', \n'.join(failed)  
    msg = MIMEText(body)
    msg['To'] =  ', '.join(recipientslist)
    msg['From'] = sender
    msg['X-Priority'] = '2'
    msg['Subject'] = 'Dashboards ETL Failure'
       
    server.server.sendmail(sender, recipientslist, msg.as_string())
    server.server.quit()

def get_source_db(query):
    if query.source_db == 'ECLIPSE_PROD':
        return ECLIPSE_PROD.ECLIPSE_PROD
    elif query.source_db == 'LIDB':
        return LIDB.LIDB
    elif query.source_db == 'GISLNI':
        return GISLNI.GISLNI
    elif query.source_db == 'DataBridge':
        return DataBridge.DataBridge
    elif query.source_db == 'GISLICLD':
        return GISLICLD.GISLICLD

def get_extract_query(query):
    with open(query.extract_query_file) as sql:
        return sql.read()

def etl_(query):
    source_db = get_source_db(query)
    extract_query = get_extract_query(query)

    with source_db() as source:
        etl.fromdb(source, extract_query) \
           .topickle(f'temp/{query.target_table}.p')

    with GISLICLD.GISLICLD() as target:
        etl.frompickle(f'temp/{query.target_table}.p') \
           .todb(get_cursor(target), query.target_table.upper())

def etl_process(queries):
    logger = get_logger()
    logger.info('---------------------------------')
    logger.info('ETL process initialized: ' + str(datetime.datetime.now()))
    
    failed = []

    for query in queries:
        try:
            etl_(query)
            logger.info(f'{query.target_table} successfully updated.')
        except:
            logger.error(f'ETL Process into GISLICLD.{query.target_table} failed.', exc_info=True)
            failed.append(query.target_table)

    logger.info('ETL process ended: ' + str(datetime.datetime.now()))

    #if len(failed) > 0:
    #    send_email(failed)

def main():
    global queries
    etl_process(queries)

if __name__ == '__main__':
    main()