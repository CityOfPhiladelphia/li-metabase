from flask import Blueprint, render_template

from li_metabase.utils import Dashboard, build_iframe_url_from_dashboard_url, DashboardNotFound
from li_metabase.auth import auth


BUSINESS_LICENSING_DASHBOARDS = [
    Dashboard('Business Licensing Active Jobs', 'active-jobs', 33),
    Dashboard('Business Licensing Active Processes', 'active-processes', 45),
    Dashboard('Expiring Business Licensing', 'expiring-licenses', 47),
    Dashboard('Business Licensing Incomplete Processes', 'incomplete-processes', 50),
    Dashboard('Business Licensing Jobs By Submission Mode', 'submission-mode', 83),
    Dashboard('Business Licensing Overdue Inspections', 'overdue-inspections', 48),
    Dashboard('Business Licensing Revenue', 'revenue', 37),
    Dashboard('Business Licensing SLA', 'sla', 51),
    Dashboard('Business Licensing Uninspected with Completed Completeness Checks', 'uninspected-with-completed-completeness-checks', 70),
    Dashboard('Business Licensing Issued', 'issued', 34),
	Dashboard('Business Licensing Dumpster Medallion Lookup', 'dumpster-medallions', 164),
]

bp = Blueprint('business_licensing', __name__)

@bp.route('/bl/<dashboard_url>')
@auth.login_required
def business_licensing(dashboard_url):
    global BUSINESS_LICENSING_DASHBOARDS

    iframe_url = build_iframe_url_from_dashboard_url(dashboard_url, BUSINESS_LICENSING_DASHBOARDS)

    return render_template('dashboard.html', iframe_url=iframe_url)

@bp.errorhandler(DashboardNotFound)
def handle_error(error):
    return render_template('error.html')