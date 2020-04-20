def get_logger(log_file):
    import logging

    logger = logging.getLogger(__name__)
    logger.setLevel(logging.INFO)

    # Create a file handler
    handler = logging.FileHandler(log_file)
    handler.setLevel(logging.INFO)

    # Create a logging format
    formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
    handler.setFormatter(formatter)

    logger.addHandler(handler)

    return logger


def send_email(failed):
    from email.mime.text import MIMEText
    from phila_mail import server

    recipientslist = ['Philip.Ribbens@Phila.gov', 'Shannon.Holm@phila.gov', 'Dani.Interrante@phila.gov', 'Jessica.Bradley@phila.gov']
    sender = 'ligisteam@phila.gov'

    # Create email body
    body = 'AUTOMATIC EMAIL: \n' + '\n\nThe following MVWs on GISLNIDBX failed to update:\n\n' + ', \n'.join(failed)

    # Create email
    msg = MIMEText(body)
    msg['To'] =  ', '.join(recipientslist)
    msg['From'] = sender
    msg['X-Priority'] = '2'
    msg['Subject'] = 'Materialized Views Update Failure'

    # Send email
    server.server.sendmail(sender, recipientslist, msg.as_string())
    server.server.quit()