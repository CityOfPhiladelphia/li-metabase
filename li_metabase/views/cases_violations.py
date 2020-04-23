from flask import Blueprint, render_template, redirect

from li_metabase.utils import Dashboard, build_iframe_url_from_dashboard_url, DashboardNotFound
from li_metabase.auth import auth


CASES_VIOLATIONS_DASHBOARDS = [
    Dashboard('Violations', 'violations', 185),
    Dashboard('Case Contacts', 'case-contacts', 174)
]

bp = Blueprint('violations', __name__)

@bp.route('/cases-violations/<dashboard_url>')
@auth.login_required
def cases_violations(dashboard_url):
    global CASES_VIOLATIONS_DASHBOARDS

    iframe_url = build_iframe_url_from_dashboard_url(dashboard_url, CASES_VIOLATIONS_DASHBOARDS)

    return render_template('dashboard.html', iframe_url=iframe_url)

@bp.errorhandler(DashboardNotFound)
def handle_error(error):
    return render_template('error.html')