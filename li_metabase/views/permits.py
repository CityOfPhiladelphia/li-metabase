from flask import Blueprint, render_template

from li_metabase.utils import Dashboard, build_iframe_url_from_dashboard_url, DashboardNotFound
from li_metabase.auth import auth


PERMITS_DASHBOARDS = [
    Dashboard('Permit Volumes and Revenues', 'volume-and-revenues', 39)
]

bp = Blueprint('permits', __name__)

@bp.route('/permits/<dashboard_url>')
@auth.login_required
def permits(dashboard_url):
    global PERMITS_DASHBOARDS

    iframe_url = build_iframe_url_from_dashboard_url(dashboard_url, PERMITS_DASHBOARDS)

    return render_template('dashboard.html', iframe_url=iframe_url)

@bp.errorhandler(DashboardNotFound)
def handle_error(error):
    return render_template('error.html')
