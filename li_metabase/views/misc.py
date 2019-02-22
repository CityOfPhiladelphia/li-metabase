from flask import Blueprint, render_template

from li_metabase.utils import Dashboard, build_iframe_url_from_dashboard_url, DashboardNotFound
from li_metabase.auth import auth


MISC_DASHBOARDS = [
    Dashboard('Individual Workloads', 'individual-workloads', 49),
    Dashboard('Expiring Licenses with Tax Issues', 'expiring-licenses-with-tax-issues', 72),
    Dashboard('Public Demos', 'public-demos', 76),
    Dashboard('Uninspected Service Requests', 'unispected-service-requests', 77),
]

bp = Blueprint('misc', __name__)

@bp.route('/misc/<dashboard_url>')
@auth.login_required
def misc(dashboard_url):
    global MISC_DASHBOARDS

    iframe_url = build_iframe_url_from_dashboard_url(dashboard_url, MISC_DASHBOARDS)

    return render_template('dashboard.html', iframe_url=iframe_url)

@bp.errorhandler(DashboardNotFound)
def handle_error(error):
    return render_template('error.html')
