''' This script refreshes materialized views in GISLNIDBX through the use of the refresh_mvw stored procedure. '''

def refresh_mvw(mvw_list_filename, logger):
    import cx_Oracle
    from li_dbs import GISLNIDBX

    # Write the starting message
    logger.info('Starting Materialized View refresh. Filename of MVWs list: ' + mvw_list_filename)

    mvw_list = [line.rstrip('\n') for line in open(mvw_list_filename)]

    failed = []

    for mvw in mvw_list:
        try:
            print(mvw + ' refresh begun.')
            logger.info(mvw + ' refresh begun.')
            with GISLNIDBX.GISLNIDBX() as con:
                cursor = con.cursor()
                # Run the refresh_mvw stored procedure passing in the mvw_name
                cursor.callproc('refresh_mvw', [mvw])
                logger.info(mvw + ' refreshed successfully.')
                del cursor
        except cx_Oracle.DatabaseError as e:
            # Log it if it fails
            logger.error('Failed to refresh ' + mvw + '.', exc_info=True)
            # Add it to the failed list for a descriptive email
            failed.append(mvw)
        except:
            # Log it if it fails
            logger.error('Something went wrong while trying to refresh ' + mvw + '.', exc_info=True)
            # Add it to the failed list for a descriptive email
            failed.append(mvw)

    # Send an email if any refreshed failed.
    if len(failed) > 0:
        utils.send_email(failed)

if __name__ == '__main__':
    import utils
    import sys
    # Set up logging
    logger = utils.get_logger('log.txt')

    mvw_list_filename = sys.argv[1]
    refresh_mvw(mvw_list_filename, logger)
