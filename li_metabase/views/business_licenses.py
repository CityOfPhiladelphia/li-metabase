from flask import Blueprint, render_template

from li_metabase.utils import Dashboard, get_dashboard_id_from_url, build_iframe_url


BUSINESS_LICENSES_DASHBOARDS = [
    Dashboard('Business Licenses Active Jobs', 'active-jobs', 33),
    Dashboard('Business Licenses Active Processes', 'active-processes', 45),
    Dashboard('Business Licenses Expiration Dates', 'expiration-dates', 47, {'date_filter': '2017-12-31~'}),
    Dashboard('Business Licenses Incomplete Processes', 'incomplete-processes', 50),
    Dashboard('Business Licenses Job Volumes By Submission Type', 'job-volumes-by-submission-type', 46, {'job_created_date_filter', '2017-12-31~'}),
    Dashboard('Business Licenses Overdue Inspections', 'overdue-inspections', 48, {'scheduled_inspection_date_filter': '2017-12-31~'}),
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
