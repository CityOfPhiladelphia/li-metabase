from flask import Blueprint, render_template

from li_metabase.utils import Dashboard, build_iframe_url_from_dashboard_url, DashboardNotFound
from li_metabase.auth import auth


PERMIT_INSPECTIONS_DASHBOARDS = [
    Dashboard('Outstanding', 'outstanding', 178)
]

bp = Blueprint('permit_inspections', __name__)

@bp.route('/permits/permit-inspections/<dashboard_url>')
@auth.login_required
def permit_inspections(dashboard_url):
    global PERMIT_INSPECTIONS_DASHBOARDS

    iframe_url = build_iframe_url_from_dashboard_url(dashboard_url, PERMIT_INSPECTIONS_DASHBOARDS)

    return render_template('dashboard.html', iframe_url=iframe_url)

@bp.errorhandler(DashboardNotFound)
def handle_error(error):
    return render_template('error.html')
