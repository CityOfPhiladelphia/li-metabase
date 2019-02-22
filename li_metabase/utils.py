from collections import namedtuple

import jwt
from flask import render_template

from li_metabase.config import METABASE_SECRET_KEY, METABASE_SITE_URL


# A convenient data structure for defining many dashboards
Dashboard = namedtuple('Dashboard', ['name', 'url', 'id'])

class DashboardNotFound(Exception):
    pass

def get_dashboard_id_from_url(dashboard_url, dashboards):
    """Search through a list of dashboards to find the dashboard with the given
    dashboard_url and return its id.

    Keyword arguments:
    dashboard_url -- The url of the dashboard.
    dashboards    -- A list of dashboards to search through.
    """
    for dashboard in dashboards:
        if dashboard.url == dashboard_url:
            return dashboard.id
    raise DashboardNotFound # If the dashboard wasn't found

def build_iframe_url(payload):
    """Build an iframe_url from a payload.
    
    Keyword arguments:
    payload -- A dictionary of the payload required to build a dashboard. Consists of the dashboard's id 
    and any filters to apply to the dashboard.
    """
    token = jwt.encode(payload, METABASE_SECRET_KEY, algorithm='HS256')
    iframe_url = METABASE_SITE_URL + '/embed/dashboard/' + token.decode('utf8') + '#bordered=true&titled=true'
    return iframe_url

def build_iframe_url_from_dashboard_url(dashboard_url, dashboards):
    """Build an iframe_url from a dashboard url.
    
    Keyword arguments:
    dashboard_url -- The url of the dashboard.
    dashboards    -- A list of dashboards to search through.
    """
    dashboard_id = get_dashboard_id_from_url(dashboard_url, dashboards)

    payload = {
        'resource': {'dashboard': dashboard_id},
        'params': {} # Throws an error if this is not included
    }

    iframe_url = build_iframe_url(payload)
    return iframe_url