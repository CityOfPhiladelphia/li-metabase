from flask import Blueprint, render_template

from li_metabase.utils import Dashboard, build_iframe_url_from_dashboard_url, DashboardNotFound
from li_metabase.auth import auth


BUSINESS_LICENSES_DASHBOARDS = [
    Dashboard('Business Licenses Active Jobs', 'active-jobs', 33),
    Dashboard('Business Licenses Active Processes', 'active-processes', 45),
    Dashboard('Expiring Business Licenses', 'expiring-licenses', 47),
    Dashboard('Business Licenses Incomplete Processes', 'incomplete-processes', 50),
    Dashboard('Business Licenses Jobs By Submission Mode', 'jobs-by-submission-mode', 83),
    Dashboard('Business Licenses Overdue Inspections', 'overdue-inspections', 48),
    Dashboard('Business Licenses Revenue', 'revenue', 37),
    Dashboard('Business Licenses SLA', 'sla', 51),
    Dashboard('Business Licenses Trends', 'trends', 80),
    Dashboard('Business Licenses Uninspected with Completed Completeness Checks', 'uninspected-with-completed-completeness-checks', 70),
    Dashboard('Business Licenses Issued', 'issued', 34),
]

bp = Blueprint('business_licenses', __name__)

@bp.route('/bl/<dashboard_url>')
@auth.login_required
def business_licenses(dashboard_url):
    global BUSINESS_LICENSES_DASHBOARDS

    iframe_url = build_iframe_url_from_dashboard_url(dashboard_url, BUSINESS_LICENSES_DASHBOARDS)

    return render_template('dashboard.html', iframe_url=iframe_url)

@bp.errorhandler(DashboardNotFound)
def handle_error(error):
    return render_template('error.html')