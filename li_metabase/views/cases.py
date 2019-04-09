from flask import Blueprint, render_template

from li_metabase.utils import Dashboard, build_iframe_url_from_dashboard_url, DashboardNotFound
from li_metabase.auth import auth


CASES_DASHBOARDS = [
    Dashboard('Resolved', 'resolved', 152)
]

bp = Blueprint('cases', __name__)

@bp.route('/cases-violations/cases/<dashboard_url>')
@auth.login_required
def cases_violations(dashboard_url):
    global CASES_DASHBOARDS

    iframe_url = build_iframe_url_from_dashboard_url(dashboard_url, CASES_DASHBOARDS)

    return render_template('dashboard.html', iframe_url=iframe_url)

@bp.errorhandler(DashboardNotFound)
def handle_error(error):
    return render_template('error.html')
