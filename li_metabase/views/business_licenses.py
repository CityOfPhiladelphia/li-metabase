from flask import Blueprint, render_template

from li_metabase.utils import Dashboard, get_dashboard_id_from_url, build_iframe_url


BUSINESS_LICENSES_DASHBOARDS = [
    Dashboard('Business Licenses Active Jobs', 'active-jobs', 33),
    Dashboard('Business Licenses Active Processes', 'active-processes', 45),
    Dashboard('Business Licenses Expiration Dates', 'expiration-dates', 47),
    Dashboard('Business Licenses Incomplete Processes', 'incomplete-processes', 50),
    Dashboard('Business Licenses Job Volumes By Submission Type', 'job-volumes-by-submission-type', 46),
    Dashboard('Business Licenses Overdue Inspections', 'overdue-inspections', 48),
    Dashboard('Business Licenses Revenue', 'revenue', 37),
    Dashboard('Business Licenses SLA', 'sla', 51),
    Dashboard('Business Licenses Submittal Types', 'submittal-types', 38),
    Dashboard('Business Licenses Uninspected with Completed Completeness Checks', 'uninspected-with-completed-completeness-checks', 70),
    Dashboard('Business Licenses Volumes', 'volumes', 34),
]

bp = Blueprint('business_licenses', __name__)

@bp.route('/bl/<dashboard_url>')
def business_licenses(dashboard_url):
    global BUSINESS_LICENSES_DASHBOARDS

    dashboard_id = get_dashboard_id_from_url(dashboard_url, BUSINESS_LICENSES_DASHBOARDS)

    payload = {
        'resource': {'dashboard': dashboard_id},
        'params': {}
    }

    iframe_url = build_iframe_url(payload)

    return render_template('dashboard.html', iframe_url=iframe_url)
