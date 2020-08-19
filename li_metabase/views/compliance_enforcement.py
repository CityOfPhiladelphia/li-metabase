from flask import Blueprint, render_template, redirect

from li_metabase.utils import Dashboard, build_iframe_url_from_dashboard_url, DashboardNotFound
from li_metabase.auth import auth


COMPLIANCE_ENFORCEMENT_DASHBOARDS = [
    Dashboard('Complaints', 'complaints', 192),
    Dashboard('Violations', 'violations', 185)
]

bp = Blueprint('violations', __name__)

@bp.route('/compliance-enforcement/<dashboard_url>')
@auth.login_required
def compliance_enforcement(dashboard_url):
    global COMPLIANCE_ENFORCEMENT_DASHBOARDS

    iframe_url = build_iframe_url_from_dashboard_url(dashboard_url, COMPLIANCE_ENFORCEMENT_DASHBOARDS)

    return render_template('dashboard.html', iframe_url=iframe_url)

@bp.errorhandler(DashboardNotFound)
def handle_error(error):
    return render_template('error.html')