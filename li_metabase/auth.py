from flask_httpauth import HTTPBasicAuth
from li_metabase.config import USERS


auth = HTTPBasicAuth()

@auth.get_password
def get_pw(username):
    if username in USERS:
        return USERS.get(username)
    return None