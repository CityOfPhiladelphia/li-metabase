from flask import Blueprint, render_template

from li_metabase.utils import Dashboard, build_iframe_url_from_dashboard_url, DashboardNotFound
from li_metabase.auth import auth


CASE_INVESTIGATIONS_DASHBOARDS = [
    Dashboard('Completed', 'completed', 196),
    Dashboard('Outstanding', 'outstanding', 115)
]

bp = Blueprint('case_inspections', __name__)

@bp.route('/compliance-enforcement/case-investigations/<dashboard_url>')
@auth.login_required
def case_inspections(dashboard_url):
    global CASE_INVESTIGATIONS_DASHBOARDS

    iframe_url = build_iframe_url_from_dashboard_url(dashboard_url, CASE_INVESTIGATIONS_DASHBOARDS)

    return render_template('dashboard.html', iframe_url=iframe_url)

@bp.errorhandler(DashboardNotFound)
def handle_error(error):
    return render_template('error.html')
